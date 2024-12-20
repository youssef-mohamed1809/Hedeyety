import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/CustomAppBar.dart';
import 'package:hedeyety/CustomWidgets/EventCard.dart';
import 'package:hedeyety/Model/Event.dart';
import 'package:hedeyety/Model/UserModel.dart';

class FriendDetailsPage extends StatelessWidget {
  String id;
  UserModel friend = UserModel();
  List<Event> upcoming_events = [];
  List<Event> past_events = [];

  FriendDetailsPage({super.key, required this.id});

  Future<bool> getFriendDetails() async {
    try {
      friend = await UserModel.getFriendDetails(id);
      List<Event> friend_events = await Event.getFriendsEvents(id);

      for (var event in friend_events) {
        if (event.date!.isAfter(DateTime.now())) {
          upcoming_events.add(event);
        } else {
          past_events.add(event);
        }
      }

      return true;
    } catch (e) {
      print("Error in getFriendDetails");
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(button: null),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Center(
            child: FutureBuilder(
                future: getFriendDetails(),
                builder: (BuildContext, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    print("Error in future builder");
                    print(snapshot.error);
                    return Text("An error has occurred");
                  } else {
                    bool? status = snapshot.data;
                    if (status!) {
                      return Column(
                        children: [
                          SizedBox(height: 40,),
                          CircleAvatar(radius: 70, backgroundImage: (friend.photo != null && friend.photo != null)?NetworkImage(friend.photo as String):null),
                          SizedBox(height: 20,),
                          Text(
                            "${friend.name}",
                            style: TextStyle(fontSize: 35),
                          ),

                          Text("@${friend.username}",style: TextStyle(fontSize: 15)),
                          Divider(),
                          Text(
                            "Upcoming Events",
                            textAlign: TextAlign.center,
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: upcoming_events.length,
                              itemBuilder: (context, index) {
                                return EventCard(event: upcoming_events[index], id: id);
                              }),
                          Divider(),
                          Text(
                            "Past Events",
                            textAlign: TextAlign.center,
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: past_events.length,
                              itemBuilder: (context, index) {
                                return EventCard(event: past_events[index], id: id);
                              }),
                        ],
                      );
                    }
                    return Text("An error occurred");
                  }
                })),
      ),
    );
  }
}
