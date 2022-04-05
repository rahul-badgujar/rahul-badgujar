import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

///
/// Just add this code in your Flutter App in a file.
/// Configure it according to the way you want to handle notifications. \
/// Just make sure to initialize FCM when your app starts using \
/// `  await FcmManager.init();`
///
class FcmManager {
  /// Initiazes FCM
  static Future<void> init() async {
    // Request permission on iOS Device
    if (Platform.isIOS) {
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      // TODO: Here handle the permission status in the app
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('User granted provisional permission');
      } else {
        print('User declined or has not accepted permission');
      }
    }

    // You can access the FCM Token for the device like this.
    final fcmToken = await FcmManager.getToken();
    printLog('FCM TOKEN: $fcmToken');
    // It is better to save FCM token in the code for later use.
    App.fcmToken = fcmToken;

    // Now we will be configuring different callbacks to handle notifications in different cases
    await _configureFCM();
  }

  /// Returns 'FCM Token' for the device
  static Future<String?> getToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    return fcmToken;
  }

  /// Configure FCM and add handlers for notification service
  static Future<void> _configureFCM() async {
    // To handle foreground notifications, providing a callback
    FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);
    // To handle background notification, providing a callback
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // To handle when app opens from notification tray, providing callback
    FirebaseMessaging.onMessageOpenedApp
        .listen(handleWhenOpenedFromTermination);
  }

  /// Handler to handle foreground notifications
  static Future<void> _firebaseMessagingForegroundHandler(
      RemoteMessage event) async {
    printLog(
        'FCM-MANAGER/_firebaseMessagingForegroundHandler: ' + event.toString());
    final notification = event.notification;
    final data = event.data;
    if (notification != null) {
      // TODO: Now you have access to the data of notification. Do whatever you want to do with this.
    }
  }

  /// Define a top-level named handler which background/terminated messages will call.
  ///
  /// To verify things are working, check out the native platform logs.
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage event) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
  }

  /// handler when app opens from termination status
  /// ! being called when app is opened by clicking notification from tray when app is in background
  static Future<void> handleWhenOpenedFromTermination(
      RemoteMessage event) async {
    final notification = event.notification;
    final data = event.data;
    if (notification != null) {
      // TODO: Now you have access to the data of notification. Do whatever you want to do with this.
    }
  }
}
