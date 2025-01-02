const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.generateCustomToken = functions.https.onCall(async (data, context) => {
  const { email, idUser } = data;  // Expecting both email and idUser in the request

  if (!email || !idUser) {
    throw new functions.https.HttpsError('invalid-argument', 'Email and idUser are required');
  }

  try {
    // Assuming you have the email and idUser as fields in your Person collection
    const personDoc = await admin.firestore().collection('Person').doc(idUser).get();
    
    if (!personDoc.exists) {
      throw new functions.https.HttpsError('not-found', 'User not found');
    }

    // Generate a custom token using the idUser (since you use idUser)
    const customToken = await admin.auth().createCustomToken(idUser);

    return { token: customToken };
  } catch (error) {
    console.error('Error generating custom token:', error);
    throw new functions.https.HttpsError('internal', 'Error generating custom token');
  }
});
