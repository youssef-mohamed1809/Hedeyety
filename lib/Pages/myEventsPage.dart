import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/BottomNavBar.dart';
import 'package:hedeyety/CustomWidgets/CustomAppBar.dart';
import 'package:hedeyety/CustomWidgets/CustomFAB.dart';
import 'package:hedeyety/CustomWidgets/MyEventCard.dart';
import 'package:hedeyety/Model/Event.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  Future getEvents() async {
    var events = await Event.getAllMyEvents();
    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            button: IconButton(onPressed: () {
            }, icon: Icon(Icons.filter_alt))),
        body: Container(
            margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
            child: FutureBuilder(
                future: getEvents(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List data = snapshot.data;

                    if (data.isEmpty) {
                      return Center(child: Text("You have no events yet."));
                    } else {
                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext, index) {
                            return MyEventCard(event: data[index]);
                          });
                    }
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Center(
                      child: Text("An error has occured"),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })),
        floatingActionButton: CustomFAB(),
        bottomNavigationBar: NavBar(current_page: 1));
  }
}
