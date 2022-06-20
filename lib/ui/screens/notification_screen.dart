import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  static const String pageRoute = '/NotificationsScreen';
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text('Notificatios'),
        ),
      ),
    );
  }
}
