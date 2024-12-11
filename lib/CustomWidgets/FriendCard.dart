import 'package:flutter/material.dart';
import 'package:hedeyety/Model/UserModel.dart';

class FriendCard extends StatelessWidget {
  String name = "";
  int upcoming_events = 0;
  String id;
  FriendCard(
      {super.key,
      required this.name,
      required this.upcoming_events,
      required this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        child: TextButton(
          style: TextButton.styleFrom(alignment: Alignment.centerLeft),
          onPressed: () async {
            print(name);
            print(id);
            await UserModel.getFriendDetails(id);

          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person),
                  Text(
                    name,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              upcoming_events == 0
                  ? const Text("No upcoming events")
                  : Text("Upcoming Events: $upcoming_events"),
            ],
          ),
        ),
      ),
    );
  }
}
