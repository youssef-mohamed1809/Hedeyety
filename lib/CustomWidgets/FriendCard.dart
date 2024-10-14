import 'package:flutter/material.dart';


class FriendCard extends StatelessWidget {
  String name = "";
  int upcoming_events = 0;
  FriendCard({super.key, required this.name, required this.upcoming_events});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          alignment: Alignment.centerLeft
        ),
        onPressed: (){
          print(name);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontSize: 20),),
            upcoming_events == 0
                ? const Text("No upcoming events")
                : Text("Upcoming Events: $upcoming_events"),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
