

import 'package:flutter/material.dart';
import 'package:venue_x/data/pushNotificationServices.dart';
import 'package:venue_x/model.dart/notificationmodel.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _acceptBookingRequest(String requestId) {
  // Implement accept logic here
  PushNotificationService().showNotification(
    "Booking Confirmed",
    "Your booking has been confirmed.",
  );
}
 void _rejectBookingRequest(String requestId) {
    // Implement reject logic here
      PushNotificationService().showNotification(
    "Booking Rejected",
    "Your booking has been rejected try again."
      );
  }
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: FutureBuilder<List<Noti>>(
        future: PushNotificationService().getNotifications(), // Fetch notifications from PushNotificationService
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Noti> notifications = snapshot.data!;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Card(
                  child: ListTile(
                    title: Text(notification.title),
                    subtitle: Text(notification.message),
                    trailing: Text(
                      '${notification.date.hour}:${notification.date.minute}',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                );
                
              },
            );
          }
        },
      ),
    );
  }
}