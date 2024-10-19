import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/BottomNavBar.dart';
import 'package:hedeyety/CustomWidgets/CustomAppBar.dart';
import 'package:hedeyety/CustomWidgets/EventCard.dart';

class MyEvents extends StatelessWidget {
  const MyEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          button: IconButton(onPressed: (){}, icon: Icon(Icons.filter_alt))
      ),
      body: Container(
          margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                EventCard(event_name: "Birthday", date: "18/9/2024",),
                EventCard(event_name: "Graduation Ceremony", date: "30/9/2025"),
              ],
            ),
          )
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {  },
          child: const Icon(Icons.add)
      ),
      bottomNavigationBar: NavBar(current_page: 1)
    );
  }
}
