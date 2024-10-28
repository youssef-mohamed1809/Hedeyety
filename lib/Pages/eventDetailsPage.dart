import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/CustomAppBar.dart';
import 'package:hedeyety/CustomWidgets/GiftCard.dart';

class EventDetailsPage extends StatelessWidget {
  late int event_id;
  EventDetailsPage({super.key, required this.event_id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(button: null),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Column(
            children: [
              CircleAvatar(radius: 60,),
              SizedBox(height: 20,),
              Text("Event Name", style: TextStyle(fontSize: 30),),
              Text("Event Location", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
              Text("Event Date", style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),),
              SizedBox(height: 20,),
              Text("Event description", style: TextStyle(fontSize: 15),),
              Divider(),
              SizedBox(height: 10,),
              Text("Requested Gifts"),
              SingleChildScrollView(
                child: Column(
                  children: [
                    GiftCard(pledged: false,),
                    GiftCard(pledged: true,),
                    GiftCard(pledged: false,),
                    GiftCard(pledged: true,)
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
