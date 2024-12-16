import 'package:flutter/material.dart';
import 'package:hedeyety/Model/Gift.dart';
import 'package:hedeyety/Pages/giftsDetailsPage.dart';


class GiftCard extends StatefulWidget {
  Gift gift;
  String user_id;
  int event_id;
  GiftCard({super.key, required this.gift, required this.user_id, required this.event_id});

  @override
  State<GiftCard> createState() => _GiftCardState();
}

class _GiftCardState extends State<GiftCard> {
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
            Text(widget.gift!.name as String),
            TextButton(onPressed: (int.parse(widget.gift.status!) > 0)?null:() async {
              //Pledge Gift
              var res = await widget.gift.pledgeGift(widget.user_id, widget.event_id);
              if(res == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Gift pledged successfully")));
                setState(() {

                });
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("An error occurred")));
              }
            }, child: Text("Pledge")),
          ],
        ),
      ),
    );
  }
}
