import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/BottomNavBar.dart';
import 'package:hedeyety/CustomWidgets/CustomFAB.dart';
import 'package:hedeyety/CustomWidgets/FriendCard.dart';
import 'package:hedeyety/CustomWidgets/CustomAppBar.dart';
import 'package:hedeyety/FriendSearchDelegate.dart';
import 'package:hedeyety/Pages/pledgedGiftsPage.dart';

import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  List<String> myFriends = ["Youssef", "Yehia", "Juliana", "Donia", "Omar", "Mariam", "Ahmed"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          button: IconButton(onPressed: (){
            showSearch(context: context, delegate: FriendSearchDelegate(myFriends: myFriends));
          }, icon: Icon(Icons.search))
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                ElevatedButton(onPressed: (){



                  Navigator.push(context, MaterialPageRoute(builder: (context) => PledgedGiftsPage()));
                }, child: Text("Pledged Gifts")),
                FriendCard(name: "Ahmed", upcoming_events: 3),
                FriendCard(name: "Seif", upcoming_events: 1),
                FriendCard(name: "Mariam", upcoming_events: 2),
                FriendCard(name: "Youssef", upcoming_events: 0),
                FriendCard(name: "Yehia", upcoming_events: 0),
                FriendCard(name: "Mohamed", upcoming_events: 2),
                FriendCard(name: "Mahmoud", upcoming_events: 0),
              ],
            ),
          ),
        ),
        floatingActionButton: CustomFAB(),
        bottomNavigationBar: NavBar(current_page: 0)
    );
  }
}


