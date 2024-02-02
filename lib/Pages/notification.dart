import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Notifications extends StatefulWidget {
  
  Notifications({super.key});
    static const route = '/notification-screen'; 

  @override
  State<Notifications> createState() => _NotificationsState();
  
}

class _NotificationsState extends State<Notifications> {

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(body: Center(child: Text('notification page content'),),);
    
  }
}