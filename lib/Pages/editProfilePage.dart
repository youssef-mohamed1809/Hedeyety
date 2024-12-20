import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/CustomAppBar.dart';
import 'package:hedeyety/Model/ImageHandler.dart';
import 'package:hedeyety/Model/UserModel.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  UserModel user;
  bool newImageSelected = false;
  String? localImgPath = null;
  EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController name_controller = TextEditingController(text: widget.user.name);
  late TextEditingController username_controller = TextEditingController(text: widget.user.username);

  GlobalKey<FormState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(button: null),
      body: Center(
        child: Padding(
            padding: EdgeInsets.all(30),
          child: Column(
            children: [
              const Text("Edit your Profile", style: TextStyle(fontSize: 30),),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(radius: 70, backgroundImage: (widget.newImageSelected)?FileImage(File(widget.localImgPath as String)):(widget.user.photo == null || widget.user.photo == "")?null:NetworkImage(widget.user.photo as String),),
                  Container(
                    width: 140, // Twice the radius (2 * 70)
                    height: 140, // Twice the radius (2 * 70)
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4), // Transparent black color
                      shape: BoxShape.circle,
                    ),
                  ),
                  IconButton(onPressed: () async {
                    print("SUIII");
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
                                if(image != null){
                                  widget.newImageSelected = true;
                                  widget.localImgPath = image!.path;
                                }
                                Navigator.pop(context);

                              },
                            ),
                            ListTile(
                              title: Text("Gallery"),
                              leading: Icon(Icons.photo),
                              onTap: () async {
                                image = await picker.pickImage(
                                    source: ImageSource.gallery);
                                // print("EL PATHHHH:   ${image!.path}");
                                if(image != null){
                                  widget.newImageSelected = true;
                                  widget.localImgPath = image!.path;
                                }

                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      );
                    });
                    setState(() {

                    });

                  }, icon: Icon(
                      Icons.edit,
                      size: 40,
                    color: Colors.white,
                  ))
                ],
              ),
              SizedBox(height: 20,),
              Form(
                key: _key,
                child: Column(
                  children: [
                    TextFormField(
                        controller: name_controller,
                        decoration: InputDecoration(
                          hintText: "Name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30))
                        ),
                      validator: (name){

                      },
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: username_controller,
                      decoration: InputDecoration(
                        hintText: "Username",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30))
                      ),
                      validator: (username){

                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: () async {
                if (_key.currentState!.validate()){
                  bool username_exists = await UserModel.usernameExists(username_controller.text);
                  if(!username_exists){
                    if(widget.newImageSelected){
                      String? url_acctual =
                      await ImageHandler.uploadImage(
                          widget.localImgPath as String);
                      widget.user.photo = url_acctual;
                    }
                    widget.user.username = username_controller.text;
                    widget.user.name = name_controller.text;
                    widget.user.updateUserProfile();
                    Navigator.pop(context);
                  }
                }
              }, child: Text("Update Profile"))

            ],
          ),
        ),
      ),
    );
  }
}
