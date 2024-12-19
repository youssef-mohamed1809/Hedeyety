import 'package:flutter/material.dart';
import 'package:hedeyety/Model/Gift.dart';
import 'package:hedeyety/Model/PledgedGift.dart';

import '../Pages/giftsDetailsPage.dart';

class PledgedGiftCard extends StatelessWidget {
  PledgedGift gift;
  PledgedGiftCard({super.key, required this.gift});

  Widget build(BuildContext context) {
    return SizedBox(
      child: TextButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => GiftDetailsPage(gift: gift as Gift)));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${gift.name}"),
            Row(
              children: [
                TextButton(onPressed: (gift.status == "1")?(){
                  // Change status to bought
                  gift.updateStatus("2");
                }:null, child: Text("Mark as Bought")),

                TextButton(onPressed: (gift.status == "1")?(){
                  // Unpledge
                  gift.updateStatus("0");
                }:null, child: Text("Unpledge")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
