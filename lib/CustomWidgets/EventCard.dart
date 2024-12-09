import 'package:flutter/material.dart';
import 'package:hedeyety/Model/Event.dart';
import 'package:hedeyety/Pages/myEventDetailsPage.dart';

class EventCard extends StatefulWidget {
  Event event;
  EventCard({super.key, required this.event});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: TextButton(
            style: TextButton.styleFrom(alignment: Alignment.centerLeft),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EventDetailsPage(event: widget.event)));
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
                        Text(widget.event.name as String),
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {}, child: const Text("Edit")),
                        const SizedBox(width: 10),
                        ElevatedButton(
                            onPressed: widget.event.published == 0
                                ? () async {
                                    await Event.publishEvent(widget.event);
                                    setState(() {
                                      widget.event.published = 1;
                                    });
                                  }
                                : null,
                            child: const Text("Publish"))
                      ],
                    )
                  ],
                ),
                Text(
                    "Event Date: ${widget.event.date?.day}/${widget.event.date?.month}/${widget.event.date?.year}")
              ],
            )));
  }
}
