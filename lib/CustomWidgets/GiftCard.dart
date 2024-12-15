import 'package:flutter/material.dart';
import 'package:hedeyety/Model/Gift.dart';
import 'package:hedeyety/Pages/giftsDetailsPage.dart';


class GiftCard extends StatelessWidget {
  Gift gift;
  String user_id;
  int event_id;
  GiftCard({super.key, required this.gift, required this.user_id, required this.event_id});

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
            TextButton(onPressed: (int.parse(gift.status!) > 0)?null:() async {
              //Pledge Gift
              await gift.pledgeGift(user_id, event_id);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gift pledged successfully")));
            }, child: Text("Pledge")),
          ],
        ),
      ),
    );
  }
}
