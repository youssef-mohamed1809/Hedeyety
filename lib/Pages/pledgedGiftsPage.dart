import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/CustomAppBar.dart';
import 'package:hedeyety/CustomWidgets/PledgedGiftCard.dart';
import 'package:hedeyety/Model/PledgedGift.dart';

class PledgedGiftsPage extends StatelessWidget {
  const PledgedGiftsPage({super.key});

  Future getPledgedGifts() async {
    var data = await PledgedGift.getPledgedGifts();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(button: null,),
      body:FutureBuilder(
          future: getPledgedGifts(),
          builder: (BuildContext, snapshot){
            if(snapshot.hasData){
              List gifts = snapshot.data;
              if(gifts.isEmpty){
                return Center(child: Text("You haven't pledged gifts yet"));
              }else{
                return ListView.builder(
                    itemCount: gifts.length,
                    itemBuilder: (BuildContext, index){
                        return PledgedGiftCard(gift: gifts[index]);
                });
              }
            }else if(snapshot.hasError){
              return Center(child: Text("An error has occured"));
            }else{
              return Center(child: CircularProgressIndicator());
            }
          })
    );
  }
}
