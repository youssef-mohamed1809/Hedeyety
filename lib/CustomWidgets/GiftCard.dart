import 'package:flutter/material.dart';
import 'package:hedeyety/Pages/giftsDetailsPage.dart';


class GiftCard extends StatelessWidget {
  bool pledged = false;
  GiftCard({super.key, required this.pledged});

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
            Text("Gift Name"),
            TextButton(onPressed: pledged?null:(){}, child: Text("Pledge")),
          ],
        ),
      ),
    );
  }
}
