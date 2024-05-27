
import 'package:flutter/material.dart';
import 'package:venue_x/model.dart/notificationmodel.dart';

class NotificationScreen extends StatelessWidget {
  final List<Noti> noti = [
    Noti(title: "Booking Confirmed", message: "Your booking has been confirmed.", date: DateTime.now().subtract(Duration(minutes: 5))),
    Noti(title: "New Message", message: "You have a new message from the venue owner.", date: DateTime.now().subtract(Duration(hours: 1))),
    Noti(title: "Reminder", message: "Your event is tomorrow.", date: DateTime.now().subtract(Duration(days: 1))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: noti.length,
        itemBuilder: (context, index) {
          final notification = noti[index];
          return ListTile(
            title: Text(notification.title),
            subtitle: Text(notification.message),
            trailing: Text(
              '${notification.date.hour}:${notification.date.minute}',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          );
        },
      ),
    );
  }
}
