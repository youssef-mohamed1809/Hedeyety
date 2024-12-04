import 'package:flutter/material.dart';
import 'package:hedeyety/Model/Event.dart';
import 'package:hedeyety/Pages/myEventDetailsPage.dart';

class EventCard extends StatelessWidget {
  Event event;
  EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: TextButton(
            style: TextButton.styleFrom(alignment: Alignment.centerLeft),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EventDetailsPage(event: event)));
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
                    ElevatedButton(onPressed: () {}, child: const Text("Edit"))
                  ],
                ),
                Text(
                    "Event Date: ${event.date?.day}/${event.date?.month}/${event.date?.year}")
              ],
            )));
  }
}
