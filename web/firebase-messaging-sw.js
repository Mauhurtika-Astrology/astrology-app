importScripts(
  "https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js"
);
importScripts(
  "https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js"
);

firebase.initializeApp({
  apiKey: "AIzaSyA_PPxVS1Xj5QuxkGybsFTG7ZUuiU0usu8",
  authDomain: "mauhurtika-pre.firebaseapp.com",
  databaseURL: "https://mauhurtika-pre-default-rtdb.firebaseio.com",
  projectId: "mauhurtika-pre",
  storageBucket: "mauhurtika-pre.appspot.com",
  messagingSenderId: "948854405434",
  appId: "1:948854405434:web:3500a6c2233d018d513803",
  measurementId: "G-XY1LD81J6X",
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});
