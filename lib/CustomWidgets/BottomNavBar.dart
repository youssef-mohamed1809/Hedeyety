import 'package:flutter/material.dart';


class NavBar extends StatelessWidget {
  int current_page = 0;
  NavBar({super.key, required this.current_page});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF6200EE),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(.60),
      selectedFontSize: 14,
      unselectedFontSize: 14,
      currentIndex: current_page,
      onTap: (value) {
        // Respond to item press.
        print(value);
      },
      items: [
        BottomNavigationBarItem(
          label: 'Home',
          icon: IconButton(icon: Icon(Icons.home), onPressed: (){
            Navigator.pushReplacementNamed(context, "/");
          },),
        ),
        BottomNavigationBarItem(
          label: 'My Events',
          icon: IconButton(icon: Icon(Icons.calendar_month), onPressed: (){
            Navigator.pushReplacementNamed(context, "/myevents");
          },),
        ),
        BottomNavigationBarItem(
          label: ' Pledged Gifts',
          icon: Icon(Icons.card_giftcard),
        ),
        BottomNavigationBarItem(
          label: 'Profile',
          icon: Icon(Icons.person),
        ),
      ],
    );
  }
}