import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/BottomNavBar.dart';
import 'package:hedeyety/CustomWidgets/CustomAppBar.dart';
import 'package:hedeyety/Pages/pledgedGiftsPage.dart';


class MyProfilePage extends StatelessWidget {
  bool hasImage = true;
  MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(button: null),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.person, size: 100,),
                  // SizedBox(width: 50),
                  Text("Youssef")
                ],
              ),
              TextButton(onPressed: (){}, child: Text("Edit Profile")),
              TextButton(onPressed: (){}, child: Text("Events")),
              TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => PledgedGiftsPage()));}, child: Text("Pledged Gifts"))
            ],
          )
        ),
      ),
      bottomNavigationBar: NavBar(current_page: 3,),
    );
  }
}