import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  PushNotificationService().showNotification(message);
}

class PushNotificationService {
  final firebaseMessaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initLocalNotifications(RemoteMessage message) async {
    var androidInitializing =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitializing = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: androidInitializing,
      iOS: iosInitializing,
    );
    await _localNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> initNotifications() async {
    var response = await firebaseMessaging.requestPermission(
      alert: true,
      sound: true,
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
      "notification prefs",
      response.authorizationStatus.toString(),
    );
    String? fCMToken = await firebaseMessaging.getToken();
    if (fCMToken != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("fCMToken", fCMToken);
      // saveToken(fCMToken);
      //FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    }
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
      Random.secure().nextInt(10000).toString(),
      "Maid Simpl",
      importance: Importance.max,
    );
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      androidNotificationChannel.id.toString(),
      androidNotificationChannel.name.toString(),
      channelDescription: "Maid Simpl Channel for Push Notification",
      importance: Importance.high,
      priority: Priority.high,
      ticker: "Ticker",
    );

    DarwinNotificationDetails iosNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
    Future.delayed(
      Duration.zero,
      () {
        _localNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails,
        );
      },
    );
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen(
      (message) {
        initLocalNotifications(message);
        showNotification(message);
      },
    );
  }

  // Future<void> saveToken(String token) async => await FirebaseFirestore.instance
  //     .collection('cleaners')
  //     .doc(FirebaseAuth.instance.currentUser!.uid)
  //     .collection("notification")
  //     .doc(FirebaseAuth.instance.currentUser!.uid)
  //     .set({'token': token}, SetOptions(merge: true));

  // Future<String> getReceiverToken(String? receiverId) async {
  //   final getToken = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(receiverId)
  //       .collection("notification")
  //       .doc(receiverId)
  //       .get();

  //   final receiverToken = await getToken.data()!['token'];
  //   return receiverToken;
  // }

  void firebaseNotification() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.data.isNotEmpty) {}
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await showNotification(message);
    });
  }

  // Future<dynamic> sendNotification({
  //   required String body,
  //   required String title,
  //   required String email,
  // }) async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? token = prefs.getString('token');

  //     var response = await Dio().post(
  //       dotenv.env['BASE_URL']! + ApiEndPoints.sendNotificationByEmail,
  //       data: {
  //         "title": title,
  //         "message": body,
  //         "email": email,
  //       },
  //       options: Options(
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Token': token,
  //         },
  //       ),
  //     );
  //     if (response.statusCode! >= 200 && response.statusCode! <= 300) {
  //       return response.data;
  //     }
  //   } on DioException catch (e) {
  //     var error = e.response?.data;
  //     return error;
  //   }
  // }
}
