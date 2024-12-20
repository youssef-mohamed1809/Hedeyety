import 'package:flutter/material.dart';
import 'package:hedeyety/CurrentUser.dart';
import 'package:hedeyety/CustomWidgets/CustomFAB.dart';
import 'package:hedeyety/Model/Authentication.dart';
import 'package:hedeyety/CustomWidgets/BottomNavBar.dart';
import 'package:hedeyety/CustomWidgets/CustomAppBar.dart';
import 'package:hedeyety/Model/ImageHandler.dart';
import 'package:hedeyety/Pages/pledgedGiftsPage.dart';
import 'package:hedeyety/Model/UserModel.dart';
import 'package:image_picker/image_picker.dart';

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
    // await UserModel.get_id_by_username();
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
                (data.photo == null || data.photo == "")
                    ? CircleAvatar(
                        radius: 70,
                        child: IconButton(
                            onPressed: () async {
                              // upload photo
                              final picker = ImagePicker();

                              XFile? image;
                              await showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return SafeArea(
                                      child: Wrap(
                                        children: [
                                          ListTile(
                                            title: Text("Camera"),
                                            leading: Icon(Icons.camera_alt),
                                            onTap: () async {
                                              image = await picker.pickImage(
                                                  source: ImageSource.camera);
                                              widget.imgURL = image!.path;
                                            },
                                          ),
                                          ListTile(
                                            title: Text("Gallery"),
                                            leading: Icon(Icons.photo),
                                            onTap: () async {
                                              image = await picker.pickImage(
                                                  source: ImageSource.gallery);
                                              // print("EL PATHHHH:   ${image!.path}");
                                              widget.imgURL = image!.path;
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  });

                              if (image != null) {
                                String? url_acctual =
                                    await ImageHandler.uploadImage(
                                        widget.imgURL as String);
                                UserModel.updateProfilePIcture(
                                    url_acctual as String);
                                CurrentUser.user = null;
                              }
                            },
                            icon: Icon(Icons.camera_alt_outlined)),
                      )
                    : CircleAvatar(radius: 70, child: Image.network(data!.photo as String),),
                SizedBox(height: 30),
                Text(data.name as String),
                Divider(),
                TextButton(onPressed: () {}, child: Text("Edit Profile")),
                TextButton(onPressed: () {}, child: Text("Events")),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PledgedGiftsPage()));
                    },
                    child: Text("Pledged Gifts")),
                TextButton(
                    onPressed: () async {
                      await Authentication.logout();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text("Log out"))
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
