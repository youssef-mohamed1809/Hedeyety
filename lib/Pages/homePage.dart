import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/BottomNavBar.dart';
import 'package:hedeyety/CustomWidgets/FriendCard.dart';
import 'package:hedeyety/CustomWidgets/CustomAppBar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          button: IconButton(onPressed: (){}, icon: Icon(Icons.search))
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                FriendCard(name: "Youssef", upcoming_events: 0),
                FriendCard(name: "Juliana", upcoming_events: 3),
                FriendCard(name: "Seif", upcoming_events: 1),
                FriendCard(name: "Omar", upcoming_events: 2),
                FriendCard(name: "Donia", upcoming_events: 0),
                FriendCard(name: "Yehia", upcoming_events: 1),
                FriendCard(name: "Mohamed", upcoming_events: 2),
                FriendCard(name: "Mahmoud", upcoming_events: 0),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {  },
            child: const Icon(Icons.add)
        ),
        bottomNavigationBar: NavBar(current_page: 0)
    );
  }
}


