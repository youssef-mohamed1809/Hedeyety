import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hedeyety/CurrentUser.dart';

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
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Add Friend"),
                      content: TextField(
                        controller: friend_username,
                        decoration: const InputDecoration(hintText: "username"),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            var user =
                                await CurrentUser.getCurrentUser();
                            var friend_added = await user.add_friend(friend_username.text);
                            print("FRIEND ADDED: $friend_added");
                            Navigator.pop(context);
                            if (friend_added == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Friend Added Successfuly")));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Friend not found")));
                            }
                          },
                          child: const Text("Add Friend"),
                        )
                      ],
                    );
                  });
            }),
        SpeedDialChild(
            child: const Icon(Icons.event),
            onTap: () {
              Navigator.pushNamed(context, '/create_event');
              setState(() {});
            }),
        SpeedDialChild(
            child: const Icon(Icons.cake),
            onTap: () {
              Navigator.pushNamed(context, '/create_gift');
            })
      ],
    );
  }
}
