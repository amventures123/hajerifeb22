import 'package:flutter/material.dart';

class NotificationInbox extends StatefulWidget {
  const NotificationInbox({ Key key }) : super(key: key);

  @override
  _NotificationInboxState createState() => _NotificationInboxState();
}

class _NotificationInboxState extends State<NotificationInbox> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(),
        ),
      )
    );
  }
}