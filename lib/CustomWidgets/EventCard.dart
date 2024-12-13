import 'package:flutter/material.dart';
import 'package:hedeyety/Model/Event.dart';

class EventCard extends StatelessWidget {
  Event event;
  EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: TextButton(
            style: TextButton.styleFrom(alignment: Alignment.centerLeft),
            onPressed: () {print("hi");},
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
