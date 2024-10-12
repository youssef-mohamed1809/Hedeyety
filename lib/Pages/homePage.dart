import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/BottomNavBar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(child: Image.asset("Assets/Images/hedeyety_logo.png"), width: 50, height: 50),
              Text("Hedeyety")
            ],
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Text("Hi"),
                Text("Hi")
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {  },
            child: Icon(Icons.add)
        ),
        bottomNavigationBar: NavBar(current_page: 0)
    );
  }
}


