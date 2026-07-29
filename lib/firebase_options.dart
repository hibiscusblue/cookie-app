import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Firebase settings for the platforms currently configured for this project.
///
/// The Windows app uses the same Firebase project and API credentials as the
/// Android app. A separate Windows app registration can replace these values
/// later if platform-specific Firebase settings are needed.
abstract final class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Firebase is not configured for web. Run FlutterFire configure first.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.windows:
        return android;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return ios;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'Firebase is not configured for Linux. Run FlutterFire configure first.',
        );
      case TargetPlatform.fuchsia:
        throw UnsupportedError('Firebase is not supported on Fuchsia.');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC5xEpORsSFJAo7La5cZtub_AJwcbcON78',
    appId: '1:336761803850:android:556e67e973f217680b82b3',
    messagingSenderId: '336761803850',
    projectId: 'naim-cookies',
    storageBucket: 'naim-cookies.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyABK6WirmDkONBCaestEAXHzCz-tQfc_1c',
    appId: '1:336761803850:ios:2e059afb64ac87820b82b3',
    messagingSenderId: '336761803850',
    projectId: 'naim-cookies',
    storageBucket: 'naim-cookies.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );
}
