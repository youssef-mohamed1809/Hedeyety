import 'package:flutter/material.dart';
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
                MyGiftsCard(status: 2, name: "Iphone 12", event: "Birhday"),
                MyGiftsCard(status: 0, name: "Mac Book", event: "Graduation Ceremony"),
                MyGiftsCard(status: 1, name: "Ipad 9"),
                MyGiftsCard(status: 0, name: "Apple Watch"),

              ],
            ),
          )
      ),
      bottomNavigationBar: NavBar(current_page: 2)
    );
  }
}
