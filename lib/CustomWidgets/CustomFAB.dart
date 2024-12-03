import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hedeyety/Model/Authentication.dart';
import 'package:hedeyety/Model/UserModel.dart';

class CustomFAB extends StatefulWidget {
  const CustomFAB({super.key});

  @override
  State<CustomFAB> createState() => _CustomFABState();
}

class _CustomFABState extends State<CustomFAB> {

  TextEditingController friend_username = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      children: [
        SpeedDialChild(
          child: Icon(Icons.person_add),
          onTap: (){
              showDialog(context: context, builder: (BuildContext context){
                  return AlertDialog(
                    title: Text("Add Friend"),
                    content: TextField(
                      controller: friend_username,
                      decoration: InputDecoration(
                        hintText: "username"
                      ),
                    ),
                    actions: [
                      TextButton(onPressed: () async{
                        var friend_added = await UserModel.add_friend(friend_username.text);
                        Navigator.pop(context);
                        if(friend_added == true){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Friend Added Successfuly"))
                          );
                        }else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Friend not found"))
                          );
                        }
                      }, child: Text("Add Friend"),)
                    ],
                  );
              });
          }
        ),
        SpeedDialChild(
          child: Icon(Icons.event),
          onTap: (){
            Navigator.pushNamed(context, '/create_event');
            setState(() {

            });
          }
        ),
        SpeedDialChild(
            child: Icon(Icons.cake),
            onTap: (){
              Navigator.pushNamed(context, '/create_gift');
            }
        )
      ],
    );
  }
}


