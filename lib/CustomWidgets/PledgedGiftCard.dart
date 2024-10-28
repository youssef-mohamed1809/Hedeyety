import 'package:flutter/material.dart';

import '../Pages/giftsDetailsPage.dart';

class PledgedGiftCard extends StatelessWidget {
  const PledgedGiftCard({super.key});

  Widget build(BuildContext context) {
    return SizedBox(
      child: TextButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => GiftDetailsPage()));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Gift Name"),
            Row(
              children: [
                TextButton(onPressed: (){}, child: Text("Mark as Bought")),
                TextButton(onPressed: (){}, child: Text("Unpledge")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
