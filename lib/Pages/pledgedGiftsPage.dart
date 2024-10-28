import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/CustomAppBar.dart';
import 'package:hedeyety/CustomWidgets/PledgedGiftCard.dart';

class PledgedGiftsPage extends StatelessWidget {
  const PledgedGiftsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(button: null,),
      body: Column(
        children: [
          PledgedGiftCard(),
          PledgedGiftCard(),
          PledgedGiftCard(),
          PledgedGiftCard()
        ],
      ),
    );
  }
}
