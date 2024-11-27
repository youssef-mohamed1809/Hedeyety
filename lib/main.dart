import 'package:flutter/material.dart';
import 'package:hedeyety/Model/Authentication.dart';
import 'package:hedeyety/Model/Event.dart';
import 'package:hedeyety/Pages/loginPage.dart';
import 'package:hedeyety/Pages/myGiftsPage.dart';
import 'package:hedeyety/Pages/homePage.dart';
import 'package:hedeyety/Pages/myEventsPage.dart';
import 'package:hedeyety/Pages/myProfilePage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hedeyety/Pages/signupPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Event.getAllEvents();
  // await Event.createEvent("name", "date", "location", "description");
  runApp(const MyApp());
}





class MyApp extends StatefulWidget {
  const MyApp({super.key});


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedeyety',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => AuthWrapper(),
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/myevents': (context) => MyEvents(),
        '/mygifts': (context) => GiftsPage(),
        '/myprofile': (context) => MyProfilePage(),
      },
    );
  }
}


class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Scaffold(
                body: CircularProgressIndicator(),
              );
            }else if(snapshot.hasData){
              Future.microtask(() => Navigator.pushReplacementNamed(context, '/home'));
            }else{
              Future.microtask(() => Navigator.pushReplacementNamed(context, '/login'));
            }
            return SizedBox.shrink();
        }
    );
  }
}







