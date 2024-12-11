import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/CustomAppBar.dart';
import 'package:hedeyety/Model/UserModel.dart';


class FriendDetailsPage extends StatelessWidget {
  UserModel friend;
  FriendDetailsPage({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(button: null),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [

            ],
          ),
        ),
      ),
    );
  }
}
