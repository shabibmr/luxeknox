/* LuxeKnox web FCM service worker.
 * Config must match DefaultFirebaseOptions.web in lib/firebase_options.dart
 * (project luxe-knox-app). JS SDK version matches firebase_core_web.
 */
importScripts(
  'https://www.gstatic.com/firebasejs/12.19.0/firebase-app-compat.js',
);
importScripts(
  'https://www.gstatic.com/firebasejs/12.19.0/firebase-messaging-compat.js',
);

firebase.initializeApp({
  apiKey: 'AIzaSyD6cmsWnEW2EI6j1UxQBfqN2Ms9zpXyxAU',
  authDomain: 'luxe-knox-app.firebaseapp.com',
  projectId: 'luxe-knox-app',
  storageBucket: 'luxe-knox-app.firebasestorage.app',
  messagingSenderId: '27985362758',
  appId: '1:27985362758:web:fca5ce8055ad07ac202f47',
  measurementId: 'G-14J71YHPDY',
});

firebase.messaging().onBackgroundMessage(function (payload) {
  // Tray display uses the FCM notification payload from the API sender.
  // Keep this handler registered so the worker stays active for background pushes.
  console.log('[firebase-messaging-sw.js] background message', payload);
});
