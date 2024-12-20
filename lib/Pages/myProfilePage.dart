import 'package:flutter/material.dart';
import 'package:hedeyety/CurrentUser.dart';
import 'package:hedeyety/CustomWidgets/CustomFAB.dart';
import 'package:hedeyety/Model/Authentication.dart';
import 'package:hedeyety/CustomWidgets/BottomNavBar.dart';
import 'package:hedeyety/CustomWidgets/CustomAppBar.dart';
import 'package:hedeyety/Model/ImageHandler.dart';
import 'package:hedeyety/Pages/editProfilePage.dart';
import 'package:hedeyety/Pages/pledgedGiftsPage.dart';
import 'package:hedeyety/Model/UserModel.dart';
import 'package:image_picker/image_picker.dart';

class MyProfilePage extends StatelessWidget {
  // bool hasImage = true;
  MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(button: null),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Center(child: UserDetails()),
      ),
      bottomNavigationBar: NavBar(
        current_page: 3,
      ),
      floatingActionButton: CustomFAB(),
    );
  }
}

class UserDetails extends StatefulWidget {
  UserDetails({super.key});

  UserModel? user;
  String? imgURL;

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  Future loadUserData() async {
    return await CurrentUser.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadUserData(),
        builder: (BuildContext, snapshot) {
          if (snapshot.hasData) {
            UserModel data = snapshot.data as UserModel;

            return Column(
              children: [
                Stack(children: [CircleAvatar(radius: 70, backgroundImage: (data.photo == null || data.photo == "")?null:NetworkImage(data.photo as String),)]),
                SizedBox(height: 30),
                Text(data.name as String, style: TextStyle(fontSize: 30),),
                Text("@${data.username as String}", style: TextStyle(fontSize: 20),),
                Divider(),
                SizedBox(height: 25,),
                ElevatedButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage(user: data)));
                }, child: Text("Edit Profile", style: TextStyle(fontSize: 25))),
                SizedBox(height: 50,),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PledgedGiftsPage()));
                    },
                    child: Text("Pledged Gifts", style: TextStyle(fontSize: 25),)),
                SizedBox(height: 50,),
                ElevatedButton(
                    onPressed: () async {
                      await Authentication.logout();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text("Log out", style: TextStyle(fontSize: 25)))
              ],
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text("An Error has Occurred"));
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
