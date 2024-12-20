import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/CustomAppBar.dart';
import 'package:hedeyety/CustomWidgets/GiftCard.dart';
import 'package:hedeyety/Model/Event.dart';
import 'package:hedeyety/Model/Gift.dart';

class FriendsEventDetailsPage extends StatelessWidget {
  Event event;
  String id;
  FriendsEventDetailsPage({super.key, required this.event, required this.id});

  Future getGifts() async {
    var gifts = await Gift.getFriendGifts(id, event.id);
    return gifts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(button: null),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Column(
            children: [
              Text(
                "${event.name}",
                style: const TextStyle(fontSize: 30),
              ),
              Text(
                "${event.location}",
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Text(
                "${event.date?.day}/${event.date?.month}/${event.date?.year}",
                style:
                    const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "${event.description}",
                style: const TextStyle(fontSize: 15),
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              const Text("Requested Gifts"),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder(
                  future: getGifts(),
                  builder: (BuildContext, snapshot) {
                    if (snapshot.hasData) {
                      List data = snapshot.data;
                      if (data.isEmpty) {
                        return const Center(
                          child: Text("No gifts added yet"),
                        );
                      } else {
                        return Expanded(
                          child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (BuildContext, index) {
                                return GiftCard(
                                  gift: data[index],
                                  user_id: id,
                                  event_id: event.id as int,
                                );
                              }),
                        );
                      }
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return const Center(
                        child: Text("An Error has occurred"),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),

            ],
          ),
        ),
      ),
    );
  }
}


