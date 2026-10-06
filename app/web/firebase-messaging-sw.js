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

// Support dynamic config passed via query params to prevent drift from DefaultFirebaseOptions.web
const searchParams = new URL(self.location.href).searchParams;

firebase.initializeApp({
  apiKey: searchParams.get('apiKey') || 'AIzaSyD6cmsWnEW2EI6j1UxQBfqN2Ms9zpXyxAU',
  authDomain: searchParams.get('authDomain') || 'luxe-knox-app.firebaseapp.com',
  projectId: searchParams.get('projectId') || 'luxe-knox-app',
  storageBucket: searchParams.get('storageBucket') || 'luxe-knox-app.firebasestorage.app',
  messagingSenderId: searchParams.get('messagingSenderId') || '27985362758',
  appId: searchParams.get('appId') || '1:27985362758:web:fca5ce8055ad07ac202f47',
  measurementId: searchParams.get('measurementId') || 'G-14J71YHPDY',
});

firebase.messaging().onBackgroundMessage(function (payload) {
  // Tray display uses the FCM notification payload from the API sender.
  // Keep this handler registered so the worker stays active for background pushes.
  console.log('[firebase-messaging-sw.js] background message', payload);
});
