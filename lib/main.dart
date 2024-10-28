import 'package:flutter/material.dart';
import 'package:hedeyety/Pages/myGiftsPage.dart';
import 'package:hedeyety/Pages/homePage.dart';
import 'package:hedeyety/Pages/myEventsPage.dart';
import 'package:hedeyety/Pages/myProfilePage.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedeyety',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/myevents': (context) => MyEvents(),
        '/mygifts': (context) => GiftsPage(),
        '/myprofile': (context) => MyProfilePage(),
      },
    );
  }
}






