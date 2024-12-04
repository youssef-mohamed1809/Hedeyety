import 'package:flutter/material.dart';
import 'package:hedeyety/CurrentUser.dart';
import 'package:hedeyety/CustomWidgets/BottomNavBar.dart';
import 'package:hedeyety/CustomWidgets/CustomFAB.dart';
import 'package:hedeyety/CustomWidgets/FriendCard.dart';
import 'package:hedeyety/CustomWidgets/CustomAppBar.dart';
import 'package:hedeyety/FriendSearchDelegate.dart';
import 'package:hedeyety/Model/Event.dart';
import 'package:hedeyety/Model/UserModel.dart';

class HomePage extends StatelessWidget {
  UserModel? user;
  List friends = [];

  Future getFriendsAndEvents() async {
    user = await CurrentUser.getCurrentUser();
    friends = (await user?.getMyFriendsIDs())!;
    List<Map> friendsAndUpcomingEvents = [];
    for (String friend in friends) {
      int num_of_events = await Event.getNumberOfUpcomingEvents(friend);
      String name = await UserModel.getNameByID(friend);
      friendsAndUpcomingEvents
          .add({'name': name, 'upcoming_events': num_of_events, 'id': friend});
      myFriends.add(name);
    }
    return friendsAndUpcomingEvents;
  }

  HomePage({super.key});
  List<String> myFriends = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            button: IconButton(
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: FriendSearchDelegate(myFriends: myFriends));
                },
                icon: const Icon(Icons.search))),
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: FutureBuilder(
              future: getFriendsAndEvents(),
              builder: (BuildContext, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data;
                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext, index) {
                        return FriendCard(
                          name: data[index]['name'],
                          upcoming_events: data[index]['upcoming_events'],
                          id: data[index]['id'],
                        );
                      });
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Center(child: Text("An error has Occurred"));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ),
        floatingActionButton: CustomFAB(),
        bottomNavigationBar: NavBar(current_page: 0));
  }
}
