import 'package:flutter/material.dart';
import 'package:hedeyety/Pages/myGiftsPage.dart';
import 'package:hedeyety/Pages/homePage.dart';
import 'package:hedeyety/Pages/myEventsPage.dart';
import 'package:hedeyety/Pages/myProfilePage.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() {
  testFire();
  runApp(const MyApp());
}

Future<void> testFire() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final ref = FirebaseDatabase.instance.ref();
  final userId = 1;
  final snapshot = await ref.child('users/username').get();
  if (snapshot.exists) {
    print(snapshot.value);
  } else {
    print('No data available.');
  }
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






