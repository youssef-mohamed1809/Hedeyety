import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  String event_name = "";
  String date = "";
  EventCard({super.key, required this.event_name, required this.date});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
            alignment: Alignment.centerLeft
        ),
        onPressed: (){
          print("Events");
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Row(
                  children: [
                    Icon(Icons.calendar_month),
                    SizedBox(width: 10),
                    Text(event_name),
                  ],
                ),
                ElevatedButton(onPressed: (){}, child: Text("Edit"))
              ],
            ),
            Text("Event Date: $date")
          ],
        )
      )
    );
  }
}
