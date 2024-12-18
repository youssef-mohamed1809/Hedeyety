import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/CustomFAB.dart';
import 'package:hedeyety/CustomWidgets/MyGiftsCard.dart';
import 'package:hedeyety/Model/Gift.dart';

import '../CustomWidgets/BottomNavBar.dart';
import '../CustomWidgets/CustomAppBar.dart';


class GiftsPage extends StatelessWidget {
  GiftsPage({super.key});
  late List event_ids = [];
  Future getMyGifts() async{
      var gifts_and_eventIDs = await Gift.getLocalGifts(-1);
      event_ids = gifts_and_eventIDs[1];
      return gifts_and_eventIDs[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          button: IconButton(onPressed: (){}, icon: Icon(Icons.filter_alt))
      ),
      body: Container(
          margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
          child: FutureBuilder(future: getMyGifts(),
              builder: (BuildContext, snapshot){
                if(snapshot.hasData){
                  List data = snapshot.data;

                  if(data.isEmpty){
                    return Center(child: Text("No gifts created yet"),);
                  }else{
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext, index){
                          return MyGiftsCard(gift: data[index], event_id: (index < event_ids.length)?event_ids[index].toString():"",);
                    });
                  }

                }else if(snapshot.hasError){
                  print(snapshot.error);
                  return Center(child: Text("An erro has occurred"),);
                }else{
                  return Center(child: CircularProgressIndicator(),);
                }
              }
          )
      ),
      floatingActionButton: CustomFAB(),
      bottomNavigationBar: NavBar(current_page: 2)
    );
  }
}
