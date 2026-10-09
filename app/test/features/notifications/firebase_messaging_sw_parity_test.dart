import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/firebase_options.dart';

void main() {
  test(
    'firebase-messaging-sw.js matches DefaultFirebaseOptions.web config',
    () {
      final swFile = File('web/firebase-messaging-sw.js');
      expect(
        swFile.existsSync(),
        isTrue,
        reason: 'web/firebase-messaging-sw.js must exist',
      );

      final content = swFile.readAsStringSync();
      final web = DefaultFirebaseOptions.web;

      expect(
        content,
        contains(web.apiKey),
        reason: 'apiKey matches DefaultFirebaseOptions.web',
      );
      expect(
        content,
        contains(web.appId),
        reason: 'appId matches DefaultFirebaseOptions.web',
      );
      expect(
        content,
        contains(web.projectId),
        reason: 'projectId matches DefaultFirebaseOptions.web',
      );
      expect(
        content,
        contains(web.messagingSenderId),
        reason: 'messagingSenderId matches DefaultFirebaseOptions.web',
      );
      if (web.authDomain != null) {
        expect(
          content,
          contains(web.authDomain!),
          reason: 'authDomain matches DefaultFirebaseOptions.web',
        );
      }
      if (web.storageBucket != null) {
        expect(
          content,
          contains(web.storageBucket!),
          reason: 'storageBucket matches DefaultFirebaseOptions.web',
        );
      }
      if (web.measurementId != null) {
        expect(
          content,
          contains(web.measurementId!),
          reason: 'measurementId matches DefaultFirebaseOptions.web',
        );
      }
    },
  );
}
