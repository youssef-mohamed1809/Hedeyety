import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/CustomFAB.dart';
import 'package:hedeyety/CustomWidgets/MyGiftsCard.dart';
import 'package:hedeyety/Model/Gift.dart';

import '../CustomWidgets/BottomNavBar.dart';
import '../CustomWidgets/CustomAppBar.dart';


class GiftsPage extends StatelessWidget {
  const GiftsPage({super.key});

  Future getMyGifts() async{
      var gifts = await Gift.getLocalGifts(-1);
      print(gifts);
      return gifts;
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
                          return MyGiftsCard(gift: data[index]);
                    });
                  }

                }else if(snapshot.hasError){
                  return Center(child: Text("An error has occurred"),);
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
