importScripts("https://www.gstatic.com/firebasejs/8.1.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.1.1/firebase-messaging.js");

// Initialize Firebase
firebase.initializeApp({
                           apiKey: "AIzaSyA8JBJ0jslecLFwYbdpO80nIdbQY9AWhBc",
                           authDomain: "bonjourcard.firebaseapp.com",
                           databaseURL: "https://bonjourcard.firebaseio.com",
                           projectId: "bonjourcard",
                           storageBucket: "bonjourcard.appspot.com",
                           messagingSenderId: "70543702123",
                           appId: "1:70543702123:web:a8bb6ef3b4e5dbb2ead92e"
                       });

const messaging = firebase.messaging();
//messaging.usePublicVapidKey('BMqzxMdlMBgQFYCO2cBQ8deKO_LOtBwegGpaM3SnVSNV0RwThWhxDaPSxeNDn_IU0MmIHweGeWIESymee5ddFjY');
//messaging.getToken().then((currentToken) => {
//    console.log(currentToken)
//})
//messaging.setBackgroundMessageHandler(function (payload) {
//    const promiseChain = clients
//        .matchAll({
//            type: "window",
//            includeUncontrolled: true
//        })
//        .then(windowClients => {
//            for (let i = 0; i < windowClients.length; i++) {
//                const windowClient = windowClients[i];
//                windowClient.postMessage(payload);
//            }
//        })
//        .then(() => {
//            return registration.showNotification("New Message");
//        });
//    return promiseChain;
//});
//
//messaging.getToken().then((currentToken) => {
//    console.log(currentToken)
//})

//self.addEventListener('notificationclick', function (event) {
//    console.log('notification received: ', event)
//});

//importScripts('https://www.gstatic.com/firebasejs/6.2.0/firebase-app.js');
//importScripts('https://www.gstatic.com/firebasejs/6.2.0/firebase-messaging.js');
//
//// Initialize the Firebase app in the service worker by passing in the
//// messagingSenderId.
//firebase.initializeApp({
//    'messagingSenderId': '70543702123'
//});
//
//// Retrieve an instance of Firebase Messaging so that it can handle background
//// messages.
//const messaging = firebase.messaging();
////const messaging = firebase.messaging();
//
//
//messaging.setBackgroundMessageHandler(function (payload) {
//console.log("Payload ");
//console.log(payload);
//    const promiseChain = clients
//        .matchAll({
//            type: "window",
//            includeUncontrolled: true
//        })
//        .then(windowClients => {
//            for (let i = 0; i < windowClients.length; i++) {
//                const windowClient = windowClients[i];
//                windowClient.postMessage(payload);
//            }
//        })
//        .then(() => {
//            return registration.showNotification("New Message");
//        });
//    return promiseChain;
//});
