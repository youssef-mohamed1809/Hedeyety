import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/CustomFAB.dart';
import 'package:hedeyety/Model/Authentication.dart';
import 'package:hedeyety/CustomWidgets/BottomNavBar.dart';
import 'package:hedeyety/CustomWidgets/CustomAppBar.dart';
import 'package:hedeyety/Pages/pledgedGiftsPage.dart';
import 'package:hedeyety/Model/UserModel.dart';


class MyProfilePage extends StatelessWidget {
  bool hasImage = true;
  MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(button: null),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Center(child: UserDetails()),
      ),
      bottomNavigationBar: NavBar(current_page: 3,),
      floatingActionButton: CustomFAB(),
    );
  }
}



class UserDetails extends StatefulWidget {
  UserDetails({super.key});

  UserModel? user;



  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  Future<UserModel> loadUserData() async {

    // await UserModel.get_id_by_username();
    return await UserModel.getCurrentUserData();

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadUserData(),
        builder: (BuildContext, snapshot){
          if(snapshot.hasData){
            UserModel data = snapshot.data as UserModel;
            
            return Column(
              children: [
                CircleAvatar(radius: 70),
                SizedBox(height: 30),
                Text(data.name),
                Divider(),
                TextButton(onPressed: (){}, child: Text("Edit Profile")),
                TextButton(onPressed: (){}, child: Text("Events")),
                TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => PledgedGiftsPage()));}, child: Text("Pledged Gifts")),
                TextButton(onPressed: () async {
                  await Authentication.logout();
                  Navigator.pushReplacementNamed(context, '/');
                }, child: Text("Log out"))
              ],
            );
          }else if(snapshot.hasError){
            print(snapshot.error);
            return Center(child: Text("An Error has Occurred"));
          }else{
            return CircularProgressIndicator();
          }
        });
  }
}




