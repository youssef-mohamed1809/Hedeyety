import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/BottomNavBar.dart';
import 'package:hedeyety/CustomWidgets/CustomFAB.dart';
import 'package:hedeyety/CustomWidgets/FriendCard.dart';
import 'package:hedeyety/CustomWidgets/CustomAppBar.dart';
import 'package:hedeyety/FriendSearchDelegate.dart';
import 'package:hedeyety/Model/Event.dart';
import 'package:hedeyety/Model/UserModel.dart';

class HomePage extends StatelessWidget {

  List friends = [];

  Future getFriendsAndEvents() async {
    friends = await UserModel.getMyFriendsIDs();
    // print(friends.runtimeType);
    List<Map> res = [];
    for(String friend in friends) {
      // print(friend);

      int num_of_events = await Event.getNumberOfUpcomingEvents(friend);
      print(num_of_events);
      String name = await UserModel.getNameByID(friend);
      res.add({
        'name': name,
        'upcoming_events': num_of_events
      });
    }
    print(res);
    return res;
  }


  HomePage({super.key});
  List<String> myFriends = ["Youssef", "Yehia", "Juliana", "Donia", "Omar", "Mariam", "Ahmed"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          button: IconButton(onPressed: (){
            showSearch(context: context, delegate: FriendSearchDelegate(myFriends: myFriends));
          }, icon: Icon(Icons.search))
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: FutureBuilder(
                  future: getFriendsAndEvents(),
                  builder: (BuildContext, snapshot){
                    if(snapshot.hasData){
                      var data = snapshot.data;
                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext, index){
                            return FriendCard(name: data[index]['name'], upcoming_events: data[index]['upcoming_events'],);
                          }
                      );
                    }else if(snapshot.hasError){
                      return Center(child: Text("An rror has Occurred"));
                    }else{
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            ),


        floatingActionButton: CustomFAB(),
        bottomNavigationBar: NavBar(current_page: 0)
    );
  }
}


// Column(
// children: [
// ElevatedButton(onPressed: (){
// Navigator.push(context, MaterialPageRoute(builder: (context) => PledgedGiftsPage()));
// }, child: Text("Pledged Gifts")),
// FriendCard(name: "Ahmed", upcoming_events: 3),
// FriendCard(name: "Seif", upcoming_events: 1),
// FriendCard(name: "Mariam", upcoming_events: 2),
// FriendCard(name: "Youssef", upcoming_events: 0),
// FriendCard(name: "Yehia", upcoming_events: 0),
// FriendCard(name: "Mohamed", upcoming_events: 2),
// FriendCard(name: "Mahmoud", upcoming_events: 0),
// ],
// ),