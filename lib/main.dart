//bala
//ssss
import 'package:flutter/material.dart';
import 'package:flutter_application_1/player.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() {
  AwesomeNotifications().initialize(
    "resource://drawable/ic_launcher",
  // set the icon to null if you want to use the default app icon
  //'resource://drawable/ic_launcher',
  [
    NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        importance: NotificationImportance.Max,
        playSound: false,
        onlyAlertOnce: true,
        enableVibration: false,
        channelDescription: 'Notification channel for basic tests',
        ledColor: Color.fromARGB(255, 79, 1, 42,)),
  ],
  // Channel groups are only visual and are not required
  channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group',
        channelGroupName: 'Basic group')
  ],
  debug: true
);
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'audioPlayer',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const MyHomePage(),
    );
  }
}

