import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/CustomFAB.dart';
import 'package:hedeyety/CustomWidgets/MyGiftsCard.dart';

import '../CustomWidgets/BottomNavBar.dart';
import '../CustomWidgets/CustomAppBar.dart';


class GiftsPage extends StatelessWidget {
  const GiftsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          button: IconButton(onPressed: (){}, icon: Icon(Icons.filter_alt))
      ),
      body: Container(
          margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                MyGiftsCard(status: 2, name: "Iphone 12", event: "Birhday", description: "I want a blue Iphone 12 Pro Max with 128 GB of Storage", showEventName: true,),
                MyGiftsCard(status: 0, name: "Elden Ring", event: "Graduation Ceremony", showEventName: true,),
                MyGiftsCard(status: 1, name: "Piano", showEventName: true,),
                MyGiftsCard(status: 0, name: "Great Dane Dog (Blue)", showEventName: true,),
              ],
            ),
          )
      ),
      floatingActionButton: CustomFAB(),
      bottomNavigationBar: NavBar(current_page: 2)
    );
  }
}
