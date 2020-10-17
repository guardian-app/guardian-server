const express = require('express');
const router = express.Router();
const { selectChildById } = require('../services/children');
const { selectGeofenceById } = require('../services/geofence');
const { Expo } = require("expo-server-sdk");
const expo = new Expo();


pushTokens = {};

const handlePushTokens = async (user_id, body) => {
    let notifications = []; console.log(body)
    const pushToken = pushTokens[user_id];
    const child_id = body.child_id;
    const geofence_id = body.geofence_id;
    const special_word = body.special_word;

    if (!Expo.isExpoPushToken(pushToken)) {
        console.error(`Push token ${pushToken} is not a valid Expo push token!`);
    };

    const [children] = await selectChildById(child_id);
    const child = children[0];

    const [geofences] = await selectGeofenceById(geofence_id);
    const geofence = geofences[0];

    notifications.push({
        to: pushToken,
        sound: "default",
        title: "Guardian",
        body: `Your child ${child.first_name, child.last_name} has ${special_word} region ${geofence.name}`
    });

    let chunks = expo.chunkPushNotifications(notifications);

    (async () => {
        for (let chunk of chunks) {
            try {
                let receipts = await expo.sendPushNotificationsAsync(chunk);
                console.log(receipts);
            } catch (error) {
                console.error(error);
            }
        }
    })();
};

const saveToken = (user_id, token) => {
    pushTokens[user_id] = token;
};

router.post("/token/:user_id", async (req, res) => {
    const { user_id } = req.params;
    const { token } = req.body;

    await saveToken(user_id, token.data);

    console.log(`Received push notification token for user ${user_id}, ${token.data}`);
    res.send(`Success`);
});

router.post("/message/:user_id", async (req, res) => {
    const { user_id } = req.params;

    await handlePushTokens(user_id, req.body);

    console.log(`Received message for user ${user_id}`);
    res.send(`Success`);
});

module.exports = router;