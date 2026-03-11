importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
 apiKey: "AIzaSyAQaGVCKQ6W7rOm0UlrFjV4pRCcgNJoQzU",
  authDomain: "liwas-793a1.firebaseapp.com",
  databaseURL: "https://liwas-793a1-default-rtdb.firebaseio.com",
  projectId: "liwas-793a1",
  storageBucket: "liwas-793a1.firebasestorage.app",
  messagingSenderId: "578255787212",
  appId: "1:578255787212:web:95dbe497017a4039bf9e69"
});

const messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            const title = payload.notification.title;
            const options = {
                body: payload.notification.score
              };
            return registration.showNotification(title, options);
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});