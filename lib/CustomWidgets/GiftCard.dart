import 'package:flutter/material.dart';
import 'package:hedeyety/Model/Gift.dart';
import 'package:hedeyety/Pages/giftsDetailsPage.dart';


class GiftCard extends StatelessWidget {
  Gift gift;
  GiftCard({super.key, required this.gift});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => GiftDetailsPage()));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(gift!.name as String),
            //TextButton(onPressed: pledged?null:(){}, child: Text("Pledge")),
          ],
        ),
      ),
    );
  }
}
