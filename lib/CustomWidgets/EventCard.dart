import 'package:flutter/material.dart';
import 'package:hedeyety/Model/Event.dart';
import 'package:hedeyety/Pages/friendEventDetailsPage.dart';

class EventCard extends StatelessWidget {
  Event event;
  String id;
  EventCard({super.key, required this.event, required this.id});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: TextButton(
            style: TextButton.styleFrom(alignment: Alignment.centerLeft),
            onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FriendsEventDetailsPage(event: event, id: id,)));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_month),
                        const SizedBox(width: 10),
                        Text(event.name as String),
                      ],
                    ),
                  ],
                ),
                Text(
                    "Event Date: ${event.date?.day}/${event.date?.month}/${event.date?.year}")
              ],
            )));
  }
}
