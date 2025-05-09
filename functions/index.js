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
    serviceAccountEmail: SERVICE_ACCOUNT_EMAIL
  })
  .pubsub.schedule('every 1 minutes')
  .onRun(async (context) => {
    console.log('Entering scheduleReminders');
    const now = moment().utc();
    console.log(`Checking reminders at: ${now.format()} (UTC)`);

    try {
      console.log('Fetching users from Firestore');
      const usersSnapshot = await admin.firestore()
        .collection('Users')
        .get();
      console.log(`Found ${usersSnapshot.size} users`);

      const notificationPromises = [];
      const batch = admin.firestore().batch();

      for (const userDoc of usersSnapshot.docs) {
        const userId = userDoc.id;
        console.log(`Processing userDoc: ${userId}`);
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

     if (minutesUntil === 0 && secondsUntil >= 0 && secondsUntil <= 20) {
      console.log(`SENDING NOTIFICATION for reminder ${reminder.id}: ${reminder.type}`);

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
                .then((response) => {
                  console.log(`Successfully sent notification for ${reminder.id}: ${response}`);
                  const updates = {
                    notificationSent: true,
                    lastNotified: admin.firestore.FieldValue.serverTimestamp(),
                  };

                  console.log(`Updating Firestore for reminder ${reminder.id}, frequency: ${reminder.frequency}`);
                  if (reminder.frequency === 'Once') {
                    batch.update(reminderDoc.ref, updates);
                  } else {
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
                        nextDate.add(1, 'day');
                    }
                    batch.update(reminderDoc.ref, {
                      ...updates,
                      date: nextDate.format('YYYY-MM-DD'),
                      time: nextDate.format('HH:mm'),
                      notificationSent: false,
                    });
                  }
                })
                .catch((error) => {
                  console.error(`Error sending notification for ${reminder.id}: ${error.message}`);
                  batch.update(reminderDoc.ref, {
                    notificationError: error.message,
                    notificationErrorTimestamp: admin.firestore.FieldValue.serverTimestamp(),
                  });
                })
            );
          } else {
            console.log(`Reminder ${reminder.id} not due yet: ${minutesUntil} minutes until trigger`);
          }
        }
      }

      console.log(`Total notification promises: ${notificationPromises.length}`);
      if (notificationPromises.length > 0) {
        console.log('Committing batch updates');
        await batch.commit();
        console.log('Batch updates committed');
      }

      console.log('Waiting for all notification promises');
      await Promise.all(notificationPromises);
      console.log('All notifications processed');
      console.log('scheduleReminders completed successfully');
      return null;
    } catch (error) {
      console.error('Error in scheduleReminders:', error);
      return null;
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

exports.sendReminderNotification = functions
  .region('us-central1')
  .runWith({
    serviceAccountEmail: SERVICE_ACCOUNT_EMAIL
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
    serviceAccountEmail: SERVICE_ACCOUNT_EMAIL
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