import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/BottomNavBar.dart';

import '../CustomWidgets/CustomAppBar.dart';

class GiftDetailsPage extends StatelessWidget {
  String gift_name = "";
  String gift_description = "";
  GiftDetailsPage({super.key, required this.gift_name, required this.gift_description});

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
                  Text(gift_name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                  SizedBox(height: 20),
                  Text(gift_description, style: TextStyle(fontStyle: FontStyle.italic, fontSize: 17))
                ],
              ),
        ),
      ),
    );
  }
}
