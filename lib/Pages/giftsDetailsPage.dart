import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/BottomNavBar.dart';

import '../CustomWidgets/CustomAppBar.dart';

class GiftDetailsPage extends StatelessWidget {
  GiftDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(button: null),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          width: double.infinity,
          child:
              Column(
                children: [
                  CircleAvatar(radius: 70,),
                  SizedBox(height: 20,),
                  Text("Great Dane", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                  SizedBox(height: 20),
                  Text("I want a Great Dane puppy", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 17))
                ],
              ),
        ),
      ),
    );
  }
}
