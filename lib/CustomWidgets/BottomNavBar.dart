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
        if(value == 0){
          Navigator.pushReplacementNamed(context, "/");
        }else if(value == 1){
          Navigator.pushReplacementNamed(context, "/myevents");
        }else if(value == 2){
          Navigator.pushReplacementNamed(context, '/mygifts');
        }else if(value == 3){
          Navigator.pushReplacementNamed(context, '/myprofile');
        }
      },
      items: [
        BottomNavigationBarItem(
          label: 'Home',
          icon: IconButton(icon: Icon(Icons.home), onPressed: (){Navigator.pushReplacementNamed(context, "/home");},),),
        BottomNavigationBarItem(
          key: Key("MyEventsPageNavBarButton"),
          label: 'My Events',
          icon: IconButton(icon: Icon(Icons.calendar_month), onPressed: (){Navigator.pushReplacementNamed(context, "/myevents");},),
        ),
        BottomNavigationBarItem(
          label: 'Wishlist',
          icon: IconButton(icon: Icon(Icons.card_giftcard), onPressed: (){Navigator.pushReplacementNamed(context, '/mygifts');}),),
        BottomNavigationBarItem(
          key: Key("ProfileNavBarButton"),
          label: 'Profile',
          icon: IconButton(icon: Icon(Icons.person), onPressed: (){Navigator.pushReplacementNamed(context, '/myprofile');},),
        ),

      ],
    );
  }
}