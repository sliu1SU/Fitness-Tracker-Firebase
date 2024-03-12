/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// The Firebase Admin SDK to access Firestore.
const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");
const {messaging} = require("firebase-admin");

initializeApp();

exports.updateLeaderboard = onRequest(async (request, response) => {
  try {
    // Extract parameters from request
    const {id, newLastTimeUpdate} = request.body;
    const curTime = Number(newLastTimeUpdate) / 1000; // convert to sec
    // Access Firestore instance
    const firestore = getFirestore();

    // Reference to the document with the provided ID
    const dataRef = firestore.collection("leaderboard").doc(id);

    const data = await dataRef.get();
    // do point calculation
    const oldPoint = data.get("point");
    let pointEarn = 0;
    const oldLastTimeUpdate = data.get("lastTimeUpdate") / 1000; // convert to sec
    let newPoint = 0;

    if (oldLastTimeUpdate === 0) {
      // no previous record for this user, give it 1 point
      // Update the document with new values
      newPoint = 1;
    } else {
      const diff = curTime - oldLastTimeUpdate;
      // calculate the point earned
      if (diff < 10) {
        pointEarn = 1;
      } else if (10 <= diff && diff <= 20) {
        pointEarn = 5;
      } else {
        pointEarn = 10;
      }
      newPoint = oldPoint + pointEarn;
      logger.info(`curTime = ${curTime}, lastTimeUpdate = ${curTime}, 
      diff = ${diff}, point earned = ${pointEarn}, email = ${data.get("email")}`);
    }

    // update your document here
    await dataRef.update({
      point: newPoint,
      lastTimeUpdate: Number(newLastTimeUpdate),
    });

    // Log success message
    logger.info(`Document with ID ${id} updated successfully.`);

    // Send response
    response.status(200).json({message: `Document with ID ${id} updated successfully.`});
  } catch (error) {
    // Log error
    logger.error("Error updating document:", error);

    // Send error response
    response.status(500).json({error: "Internal server error"});
  }
});

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
