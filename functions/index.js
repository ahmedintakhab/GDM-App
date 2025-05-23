const functions = require('firebase-functions/v1');
const admin = require('firebase-admin');
const moment = require('moment-timezone');

admin.initializeApp();

const SERVICE_ACCOUNT_EMAIL = 'custom-compute-618746563893@gdm-app-85a42.iam.gserviceaccount.com';

exports.scheduleReminders = functions
  .region('us-central1')
  .runWith({
    memory: '256MB',
    timeoutSeconds: 120,
    serviceAccountEmail: SERVICE_ACCOUNT_EMAIL,
  })
  .pubsub.schedule('every 1 minutes')
  .onRun(async (context) => {
    console.log('Entering scheduleReminders at:', new Date().toISOString());
    const now = moment().utc();
    console.log(`Checking reminders at: ${now.format()} (UTC)`);

    try {
      console.log('Fetching users from Firestore');
      const usersSnapshot = await admin.firestore().collection('Users').get();
      console.log(`Found ${usersSnapshot.size} users`);

      const notificationPromises = [];

      for (const userDoc of usersSnapshot.docs) {
        const userId = userDoc.id;
        console.log(`Processing userDoc: ${userId}`);
        try {
          const userData = userDoc.data();
          console.log(`User data: ${JSON.stringify(userData)}`);
          const fcmToken = userData.fcmToken;
          let timezone = userData.timezone || 'UTC';

          if (!moment.tz.zone(timezone)) {
            console.warn(`Invalid timezone ${timezone} for user ${userId}, defaulting to UTC`);
            timezone = 'UTC';
          }

          if (!fcmToken || typeof fcmToken !== 'string' || fcmToken.trim() === '') {
            console.log(`Skipping user ${userId}: No valid FCM token`);
            continue;
          }

          console.log(`Processing user ${userId} with timezone ${timezone} and FCM token ${fcmToken}`);

          const nowInUserTz = moment().tz(timezone);
          console.log(`Current time in user timezone (${timezone}): ${nowInUserTz.format()}`);

          // Fetch pregnancy info
          console.log(`Fetching Personal Information for user ${userId}`);
          const personalInfoSnapshot = await admin.firestore()
            .collection('Users')
            .doc(userId)
            .collection('Personal Information')
            .limit(1)
            .get();

          if (personalInfoSnapshot.docs.length > 0) {
            try {
              const personalInfo = personalInfoSnapshot.docs[0].data();
              const lmp = personalInfo['lmp'];
              const gdmTestDone = personalInfo['gdmTestDone'] || false;

              if (lmp && !gdmTestDone) {
                const lmpDate = moment(lmp, 'YYYY-MM-DD');
                if (!lmpDate.isValid()) {
                  console.warn(`Invalid LMP ${lmp} for user ${userId}, skipping GDM reminders`);
                  continue;
                }
                const weeksPregnant = nowInUserTz.diff(lmpDate, 'weeks');
                console.log(`User ${userId} is ${weeksPregnant} weeks pregnant`);

                if (weeksPregnant >= 24 && weeksPregnant <= 28) {
                  const gdmReminderSnapshot = await admin.firestore()
                    .collection('Users')
                    .doc(userId)
                    .collection('gdmReminders')
                    .where('isActive', '==', true)
                    .where('snoozeUntil', '<=', now.toDate())
                    .limit(1)
                    .get();

                  if (gdmReminderSnapshot.empty) {
                    const gdmReminderId = `gdm_${nowInUserTz.format('YYYYMMDDHHmm')}`;
                    await admin.firestore()
                      .collection('Users')
                      .doc(userId)
                      .collection('gdmReminders')
                      .doc(gdmReminderId)
                      .set({
                        id: gdmReminderId,
                        type: 'GDM Test Reminder',
                        createdAt: admin.firestore.FieldValue.serverTimestamp(),
                        isActive: true,
                        notificationSent: false,
                        snoozeUntil: now.toDate(),
                      });

                    console.log(`Created GDM reminder ${gdmReminderId} for user ${userId}`);
                  }

                  const activeGdmReminders = await admin.firestore()
                    .collection('Users')
                    .doc(userId)
                    .collection('gdmReminders')
                    .where('isActive', '==', true)
                    .where('notificationSent', '==', false)
                    .get();

                  for (const reminderDoc of activeGdmReminders.docs) {
                    try {
                      const reminder = reminderDoc.data();
                      console.log(`Processing GDM reminder: ${JSON.stringify(reminder)}`);

                      await reminderDoc.ref.update({
                        notificationSent: true,
                        lastNotified: admin.firestore.FieldValue.serverTimestamp(),
                      });

                      const message = {
                        token: fcmToken,
                        notification: {
                          title: 'GDM Test Reminder',
                          body: 'Reminder to go and test for diabetes at the hospital (between 24 to 28 weeks)?',
                        },
                        android: {
                          priority: 'high',
                          notification: {
                            channelId: 'reminder_channel',
                            sound: 'default',
                            priority: 'high',
                            visibility: 'public',
                            tag: reminder.id,
                          },
                        },
                        apns: {
                          payload: {
                            aps: {
                              sound: 'default',
                              badge: 1,
                            },
                          },
                        },
                        data: {
                          reminderType: 'GDM Test',
                          reminderId: reminder.id,
                        },
                      };

                      console.log(`Preparing to send GDM FCM message for reminder ${reminder.id}`);
                      notificationPromises.push(
                        retryFcmSend(message, 2)
                          .then(async (response) => {
                            console.log(`Successfully sent GDM notification for ${reminder.id}: ${response}`);
                            const notificationData = {
                              reminderId: reminder.id,
                              title: message.notification.title,
                              body: message.notification.body,
                              sentAt: admin.firestore.FieldValue.serverTimestamp(),
                              status: 'sent',
                              fcmToken: fcmToken,
                            };
                            await admin.firestore()
                              .collection('Users')
                              .doc(userId)
                              .collection('Display reminders')
                              .add(notificationData);
                            console.log(`GDM notification data saved for reminder ${reminder.id}`);
                          })
                          .catch(async (error) => {
                            console.error(`Error sending GDM notification for ${reminder.id}: ${error.message}`);
                            await reminderDoc.ref.update({
                              notificationError: error.message,
                              notificationErrorTimestamp: admin.firestore.FieldValue.serverTimestamp(),
                            });
                          })
                      );
                    } catch (error) {
                      console.error(`Error processing GDM reminder ${reminderDoc.id} for user ${userId}: ${error.message}`);
                    }
                  }
                }
              }
            } catch (error) {
              console.error(`Error processing Personal Information for user ${userId}: ${error.message}`);
            }
          }

          console.log(`Fetching reminders for user ${userId}`);
          const reminderSnapshot = await admin.firestore()
            .collection('Users')
            .doc(userId)
            .collection('reminders')
            .where('isActive', '==', true)
            .where('notificationSent', '==', false)
            .get();
          console.log(`User ${userId} has ${reminderSnapshot.size} active reminders`);

          for (const reminderDoc of reminderSnapshot.docs) {
            try {
              const reminder = reminderDoc.data();
              console.log(`Processing reminder: ${JSON.stringify(reminder)}`);

              if (!reminder.date || !reminder.time || !reminder.type || !reminder.id) {
                console.warn(`Invalid reminder ${reminder.id} for user ${userId}: Missing required fields`);
                continue;
              }

              console.log(`Parsing reminder time for ${reminder.id}`);
              const reminderTime = moment.tz(
                `${reminder.date} ${reminder.time}`,
                'YYYY-MM-DD HH:mm',
                timezone
              );

              if (!reminderTime.isValid()) {
                console.warn(`Invalid reminder time for ${reminder.id}: ${reminder.date} ${reminder.time}`);
                continue;
              }

              const minutesUntil = reminderTime.diff(nowInUserTz, 'minutes');
              console.log(`Reminder ${reminder.id}: ${reminderTime.format()} (${timezone}), Minutes until: ${minutesUntil}`);

              if (minutesUntil === -1) {
                console.log(`SENDING NOTIFICATION for reminder ${reminder.id}: ${reminder.type}`);

                await reminderDoc.ref.update({
                  notificationSent: true,
                  lastNotified: admin.firestore.FieldValue.serverTimestamp(),
                });

                const message = {
                  token: fcmToken,
                  notification: {
                    title: reminder.type,
                    body: `Time to ${reminder.type}!`,
                  },
                  android: {
                    priority: 'high',
                    notification: {
                      channelId: 'reminder_channel',
                      sound: 'default',
                      priority: 'high',
                      visibility: 'public',
                      tag: reminder.id,
                    },
                  },
                  apns: {
                    payload: {
                      aps: {
                        sound: 'default',
                        badge: 1,
                      },
                    },
                  },
                  data: {
                    reminderType: reminder.type,
                    reminderTime: reminder.time,
                    reminderId: reminder.id,
                  },
                };

                console.log(`Preparing to send FCM message for reminder ${reminder.id}`);
                notificationPromises.push(
                  retryFcmSend(message, 2)
                    .then(async (response) => {
                      console.log(`Successfully sent notification for ${reminder.id}: ${response}`);
                      const notificationData = {
                        reminderId: reminder.id,
                        title: message.notification.title,
                        body: message.notification.body,
                        sentAt: admin.firestore.FieldValue.serverTimestamp(),
                        status: 'sent',
                        fcmToken: fcmToken,
                      };
                      console.log(`Saving notification data for reminder ${reminder.id} to Display reminders`);
                      await admin.firestore()
                        .collection('Users')
                        .doc(userId)
                        .collection('Display reminders')
                        .add(notificationData);
                      console.log(`Notification data saved for reminder ${reminder.id}`);

                      if (reminder.frequency !== 'Once') {
                        let nextDate = reminderTime.clone();
                        switch (reminder.frequency) {
                          case 'Everyday':
                            nextDate.add(1, 'day');
                            break;
                          case 'Weekdays':
                            do {
                              nextDate.add(1, 'day');
                            } while ([0, 6].includes(nextDate.day()));
                            break;
                          default:
                            const days = reminder.frequency.split(', ').map(day => {
                              const dayMap = { 'Sun': 0, 'Mon': 1, 'Tue': 2, 'Wed': 3, 'Thu': 4, 'Fri': 5, 'Sat': 6 };
                              return dayMap[day];
                            });
                            do {
                              nextDate.add(1, 'day');
                            } while (!days.includes(nextDate.day()));
                            break;
                        }
                        await reminderDoc.ref.update({
                          date: nextDate.format('YYYY-MM-DD'),
                          time: nextDate.format('HH:mm'),
                          notificationSent: false,
                        });
                      }
                    })
                    .catch(async (error) => {
                      console.error(`Error sending notification for ${reminder.id}: ${error.message}`);
                      await reminderDoc.ref.update({
                        notificationError: error.message,
                        notificationErrorTimestamp: admin.firestore.FieldValue.serverTimestamp(),
                      });
                    })
                );
              } else {
                console.log(`Reminder ${reminder.id} not due yet: ${minutesUntil} minutes until trigger`);
              }
            } catch (error) {
              console.error(`Error processing reminder ${reminderDoc.id} for user ${userId}: ${error.message}`);
            }
          }
        } catch (error) {
          console.error(`Error processing user ${userId}: ${error.message}`);
        }
      }

      console.log(`Total notification promises: ${notificationPromises.length}`);
      console.log('Waiting for all notification promises');
      try {
        await Promise.all(notificationPromises);
        console.log('All notifications processed');
      } catch (error) {
        console.error('Error resolving notification promises:', error.message);
      }
      console.log('scheduleReminders completed successfully');
      return null;
    } catch (error) {
      console.error('Fatal error in scheduleReminders:', error.stack);
      throw error;
    }
  });

async function retryFcmSend(message, retries) {
  console.log('Entering retryFcmSend');
  for (let attempt = 1; attempt <= retries; attempt++) {
    console.log(`Attempt ${attempt} to send FCM message`);
    try {
      const response = await admin.messaging().send(message);
      console.log(`FCM send successful: ${response}`);
      return response;
    } catch (error) {
      console.warn(`FCM send attempt ${attempt} failed: ${error.message}`);
      if (attempt === retries) {
        console.error('All FCM send attempts failed:', error);
        throw error;
      }
      await new Promise(resolve => setTimeout(resolve, 1000));
    }
  }
}

// Other functions unchanged
exports.handleGdmReminderResponse = functions
  .region('us-central1')
  .runWith({
    serviceAccountEmail: SERVICE_ACCOUNT_EMAIL,
  })
  .https.onCall(async (data, context) => {
    console.log('Entering handleGdmReminderResponse');
    if (!context.auth) {
      console.error('Authentication failed: User must be authenticated');
      throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
    }

    try {
      const userId = context.auth.uid;
      const { reminderId, action, snoozeDuration } = data;

      if (!reminderId || !action) {
        throw new functions.https.HttpsError('invalid-argument', 'Missing reminderId or action');
      }

      const gdmReminderRef = admin.firestore()
        .collection('Users')
        .doc(userId)
        .collection('gdmReminders')
        .doc(reminderId);

      const gdmReminderDoc = await gdmReminderRef.get();
      if (!gdmReminderDoc.exists) {
        throw new functions.https.HttpsError('not-found', 'GDM reminder not found');
      }

      if (action === 'done') {
        await admin.firestore()
          .collection('Users')
          .doc(userId)
          .collection('Personal Information')
          .doc('default_doc')
          .set({ gdmTestDone: true }, { merge: true });

        await admin.firestore()
          .collection('Users')
          .doc(userId)
          .collection('gdmReminders')
          .where('isActive', '==', true)
          .get()
          .then(snapshot => {
            const batch = admin.firestore().batch();
            snapshot.forEach(doc => batch.update(doc.ref, { isActive: false }));
            return batch.commit();
          });

        console.log(`GDM test marked as done for user ${userId}`);
        return { success: true, message: 'GDM test marked as done' };
      } else if (action === 'snooze') {
        if (!snoozeDuration || !['3days', '1week'].includes(snoozeDuration)) {
          throw new functions.https.HttpsError('invalid-argument', 'Invalid snooze duration');
        }

        const snoozeUntil = moment().utc()
          .add(snoozeDuration === '3days' ? 3 : 7, 'days')
          .toDate();

        await gdmReminderRef.update({
          snoozeUntil,
          notificationSent: false,
        });

        console.log(`GDM reminder ${reminderId} snoozed for ${snoozeDuration} for user ${userId}`);
        return { success: true, message: `Reminder snoozed for ${snoozeDuration}` };
      } else {
        throw new functions.https.HttpsError('invalid-argument', 'Invalid action');
      }
    } catch (error) {
      console.error('Error handling GDM reminder response:', error);
      throw new functions.https.HttpsError('internal', `Failed to handle GDM reminder: ${error.message}`);
    }
  });

exports.sendReminderNotification = functions
  .region('us-central1')
  .runWith({
    serviceAccountEmail: SERVICE_ACCOUNT_EMAIL,
  })
  .https.onCall(async (data, context) => {
    console.log('Entering sendReminderNotification');
    if (!context.auth) {
      console.error('Authentication failed: User must be authenticated');
      throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
    }

    try {
      const userId = context.auth.uid;
      console.log(`Processing request for user: ${userId}`);

      console.log(`Fetching user document for ${userId}`);
      const userDoc = await admin.firestore().collection('Users').doc(userId).get();

      if (!userDoc.exists) {
        console.error(`User not found: ${userId}`);
        throw new functions.https.HttpsError('not-found', 'User not found');
      }

      const userData = userDoc.data();
      console.log(`User data: ${JSON.stringify(userData)}`);
      const fcmToken = userData.fcmToken;

      if (!fcmToken) {
        console.error(`No FCM token for user ${userId}`);
        throw new functions.https.HttpsError('failed-precondition', 'User has no FCM token');
      }

      console.log(`Preparing FCM message for user ${userId} with token ${fcmToken}`);
      const message = {
        token: fcmToken,
        notification: {
          title: 'Test Notification',
          body: 'This is a test notification from the server',
        },
        android: {
          priority: 'high',
          notification: {
            channelId: 'reminder_channel',
            sound: 'default',
          },
        },
        apns: {
          payload: {
            aps: {
              sound: 'default',
            },
          },
        },
      };

      console.log('Sending test FCM message');
      const response = await admin.messaging().send(message);
      console.log('Test notification sent successfully:', response);

      const notificationData = {
        reminderId: 'test-notification',
        title: message.notification.title,
        body: message.notification.body,
        sentAt: admin.firestore.FieldValue.serverTimestamp(),
        status: 'sent',
        fcmToken: fcmToken,
      };
      await admin.firestore()
        .collection('Users')
        .doc(userId)
        .collection('Display reminders')
        .add(notificationData);
      console.log('Test notification data saved to Display reminders');

      console.log('sendReminderNotification completed successfully');
      return { success: true, messageId: response };
    } catch (error) {
      console.error('Error sending test notification:', error);
      throw new functions.https.HttpsError('internal', `Failed to send notification: ${error.message}`);
    }
  });

exports.updateFcmToken = functions
  .region('us-central1')
  .runWith({
    serviceAccountEmail: SERVICE_ACCOUNT_EMAIL,
  })
  .firestore
  .document('Users/{userId}')
  .onUpdate(async (change, context) => {
    console.log('Entering updateFcmToken');
    const newData = change.after.data();
    const oldData = change.before.data();

    if (newData.fcmToken !== oldData.fcmToken) {
      console.log(`FCM token updated for user ${context.params.userId}: ${newData.fcmToken}`);
    } else {
      console.log(`No FCM token change for user ${context.params.userId}`);
    }
    console.log('updateFcmToken completed');
    return null;
  });