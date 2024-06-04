// import 'dart:math';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Future<void> handleBackgroundMessage(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   PushNotificationService().showNotification(
//     message.notification!.title!,
//     message.notification!.body!,
//   );
// }

// class PushNotificationService {
//   final firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   PushNotificationService() {
//     initLocalNotifications();
//     firebaseInit();
//   }

//   void initLocalNotifications() async {
//     var androidInitialization =
//         const AndroidInitializationSettings("@mipmap/ic_launcher");
//     var iosInitialization = const DarwinInitializationSettings();

//     var initializationSettings = InitializationSettings(
//       android: androidInitialization,
//       iOS: iosInitialization,
//     );
//     await _localNotificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> initNotifications() async {
//     try {
//       var response = await firebaseMessaging.requestPermission(
//         alert: true,
//         sound: true,
//       );
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       prefs.setString(
//         "notification prefs",
//         response.authorizationStatus.toString(),
//       );
//       String? fCMToken = await firebaseMessaging.getToken();
//       if (fCMToken != null) {
//         prefs.setString("fCMToken", fCMToken);
//       }
//     } catch (e) {
//       print("Error initializing notifications: $e");
//     }
//   }

//   Future<void> showNotification(String title, String body) async {
//     AndroidNotificationChannel androidNotificationChannel =
//         AndroidNotificationChannel(
//       Random.secure().nextInt(10000).toString(),
//       "Maid Simpl",
//       importance: Importance.max,
//     );
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       androidNotificationChannel.id,
//       androidNotificationChannel.name,
//       channelDescription: "Maid Simpl Channel for Push Notification",
//       importance: Importance.high,
//       priority: Priority.high,
//       ticker: "Ticker",
//     );

//     DarwinNotificationDetails iosNotificationDetails =
//         const DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );

//     NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//       iOS: iosNotificationDetails,
//     );
//     await _localNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       notificationDetails,
//     );
//   }

//   void firebaseInit() {
//     FirebaseMessaging.onMessage.listen((message) {
//       showNotification(
//         message.notification!.title!,
//         message.notification!.body!,
//       );
//     });
//   }
// }






import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:venue_x/model.dart/notificationmodel.dart';
import 'package:http/http.dart' as http;

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  PushNotificationService().showNotification(
    message.notification!.title!,
    message.notification!.body!,
  );
}

class PushNotificationService {
  final firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  PushNotificationService() {
    initLocalNotifications();
    // firebaseInit();
  }

  void initLocalNotifications() async {
    var androidInitialization =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitialization = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: androidInitialization,
      iOS: iosInitialization,
    );
    await _localNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> initNotifications() async {
    try {
   
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
        prefs.setString("fCMToken", fCMToken);
      }
    } catch (e) {
      print("Error initializing notifications: $e");
    }
  }







Future<List<Noti>> getNotifications() async {
    // Fetch notifications from wherever they are stored (e.g., local storage, database, etc.)
    // For demonstration purpose, returning a hardcoded list of notifications
    return [
      Noti(title: "Booking Confirmed", message: "Your booking has been confirmed.", date: DateTime.now().subtract(Duration(minutes: 5))),
      Noti(title: "New Message", message: "You have a new message from the venue owner.", date: DateTime.now().subtract(Duration(hours: 1))),
      Noti(title: "Reminder", message: "Your event is tomorrow.", date: DateTime.now().subtract(Duration(days: 1))),
    ];
  }









  Future<void> showNotification(String title, String body) async {
    AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
      Random.secure().nextInt(10000).toString(),
      "Maid Simpl",
      importance: Importance.max,
    );
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      androidNotificationChannel.id,
      androidNotificationChannel.name,
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
    int id = Random.secure().nextInt(10000); // Generate unique ID
    await _localNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );

  
  }

 Future<String?> generateDeviceRegistrationToken() async {
    try {
      String? deviceToken = await firebaseMessaging.getToken();
      return deviceToken;
    } catch (e) {
      print("Error retrieving device token: $e");
      return null;
    }
  }

Future<void> sendNotification(String userDeviceToken, String title, String body) async {
  const String serverKey = 'YOUR_FIREBASE_SERVER_KEY';
  const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

  final Map<String, dynamic> notification = {
    'title': title,
    'body': body,
  };

  final Map<String, dynamic> data = {
    'notification': notification,
    'to': userDeviceToken,
  };

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=$serverKey',
  };

  try {
    final response = await http.post(
      Uri.parse(fcmUrl),
      headers: headers,
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error sending notification: $e');
  }
}
  Future<void> updateDeviceTokenInFirestore(String deviceToken) async {
    try {
      await FirebaseFirestore.instance.collection("users").add({
        "UserDeviceToken": deviceToken,
      });
      print('Device token updated in Firestore');
    } catch (e) {
      print('Error updating device token in Firestore: $e');
    }
  }
}




  
  Future generateDeviceRegistrationToken() async {
   String? deviceToken = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance.collection("users").doc().update({
"UserDeviceToken": deviceToken
    });
  }

  // void firebaseInit() {
  //   FirebaseMessaging.onMessage.listen((message) {
  //     showNotification(
  //       message.notification!.title!,
  //       message.notification!.body!,
  //     );
  //   });
  // }

