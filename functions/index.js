const functions = require('firebase-functions');

const  admin=require('firebase-admin');
admin.initializeApp();
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.createUser = functions.firestore
    .document('{Tm}/Interactions/{emails}/{docID}')
    .onCreate((snap, context) => {
   
// console.log(snap.data());

return admin.messaging().sendToTopic(snap.data().To,{notification:{body:'Check your notification in the app for more informations',title:snap.data().Name+' is interested about your book',clickAction:'FLUTTER_NOTIFICATION_CLICK'}});


 

    });