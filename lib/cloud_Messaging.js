const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotification = functions.https.onRequest(async (req, res) => {
  const { title, body, userDeviceToken } = req.body;

  // Check if the request body contains the required parameters
  if (!title || !body || !userDeviceToken) {
    return res.status(400).send('Missing parameters');
  }

  // Notification payload
  const message = {
    notification: {
      title: title,
      body: body,
    },
    token: userDeviceToken,
  };

  try {
    // Send the notification
    await admin.messaging().send(message);
    return res.status(200).send('Notification sent successfully');
  } catch (error) {
    console.error('Error sending notification:', error);
    return res.status(500).send('Error sending notification');
  }
});
