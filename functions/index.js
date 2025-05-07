const functions = require('firebase-functions');
const admin = require('firebase-admin');
const moment = require('moment');

admin.initializeApp();

exports.scheduleReminders = functions.pubsub.schedule('every 1 minutes').onRun(async (context) => {
  try {
    const now = moment().utc();
    const usersSnapshot = await admin.firestore().collection('Users').get();

    for (const userDoc of usersSnapshot.docs) {
      const userId = userDoc.id;
      const fcmToken = userDoc.data().fcmToken;

      if (!fcmToken) {
        console.log(`No FCM token for user ${userId}`);
        continue;
      }

      const remindersSnapshot = await admin.firestore()
        .collection('Users')
        .doc(userId)
        .collection('reminders')
        .where('isActive', '==', true)
        .where('notificationSent', '==', false)
        .get();

      for (const reminderDoc of remindersSnapshot.docs) {
        const reminder = reminderDoc.data();
        const reminderDateTime = moment.utc(`${reminder.date} ${reminder.time}`, 'YYYY-MM-DD HH:mm');

        // Check if the reminder's date and time is within the next minute
        if (reminderDateTime.isBetween(now, now.clone().add(1, 'minute'))) {
          // Send FCM notification
          const message = {
            token: fcmToken,
            notification: {
              title: reminder.type,
              body: `Time to ${reminder.type}!`,
            },
            data: {
              reminderId: reminder.id,
              type: reminder.type,
            },
          };

          try {
            await admin.messaging().send(message);
            console.log(`Notification sent for reminder ${reminder.id} to user ${userId}`);

            // Handle frequency for rescheduling
            if (reminder.frequency === 'Once') {
              // Mark as sent for one-time reminders
              await reminderDoc.ref.update({ notificationSent: true });
            } else {
              // Reschedule recurring reminders
              let newDate = reminderDateTime.clone();
              switch (reminder.frequency) {
                case 'Everyday':
                  newDate = newDate.add(1, 'day');
                  break;
                case 'Weekdays':
                  newDate = newDate.add(1, 'day');
                  if (newDate.day() === 0) newDate.add(1, 'day'); // Skip Sunday
                  if (newDate.day() === 6) newDate.add(2, 'days'); // Skip Saturday
                  break;
                case 'Weekends':
                  newDate = newDate.add(1, 'day');
                  if (newDate.day() !== 0 && newDate.day() !== 6) {
                    newDate = newDate.day(6); // Next Saturday
                  }
                  break;
                case 'Mon, Wed, Fri':
                  newDate = newDate.add(1, 'day');
                  if (newDate.day() === 1) newDate.day(3); // Monday to Wednesday
                  else if (newDate.day() === 3) newDate.day(5); // Wednesday to Friday
                  else if (newDate.day() === 5) newDate.day(1).add(1, 'week'); // Friday to Monday
                  else newDate.day(1); // Default to Monday
                  break;
                case 'Tue, Thu':
                  newDate = newDate.add(1, 'day');
                  if (newDate.day() === 2) newDate.day(4); // Tuesday to Thursday
                  else if (newDate.day() === 4) newDate.day(2).add(1, 'week'); // Thursday to Tuesday
                  else newDate.day(2); // Default to Tuesday
                  break;
              }

              await reminderDoc.ref.update({
                date: newDate.format('YYYY-MM-DD'),
                notificationSent: false,
              });
              console.log(`Rescheduled reminder ${reminder.id} to ${newDate.format('YYYY-MM-DD')}`);
            }
          } catch (error) {
            console.error(`Failed to send notification for reminder ${reminder.id}:`, error);
          }
        }
      }
    }
  } catch (error) {
    console.error('Error in scheduleReminders:', error);
  }
});