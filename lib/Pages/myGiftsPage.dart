import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/CustomFAB.dart';
import 'package:hedeyety/CustomWidgets/GiftFilterAndSorting.dart';
import 'package:hedeyety/CustomWidgets/MyGiftsCard.dart';
import 'package:hedeyety/Model/Gift.dart';

import '../CustomWidgets/BottomNavBar.dart';
import '../CustomWidgets/CustomAppBar.dart';


class GiftsPage extends StatefulWidget {
  GiftsPage({super.key});

  late List event_ids = [];

  late List categories = [];
List category_names = [];
  int? _category_filter_value;
  Set selectedCategories = {};

  @override
  State<GiftsPage> createState() => _GiftsPageState();
}

class _GiftsPageState extends State<GiftsPage> {


  Future getMyGifts() async{
      var gifts_and_eventIDs = await Gift.getLocalGifts(-1);
      widget.categories = await Gift.getGiftCategories();
      widget.category_names =
          widget.categories.map((category) => category['category'] as String).toList();
      widget.event_ids = gifts_and_eventIDs[1];
      return gifts_and_eventIDs[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          button: IconButton(onPressed: (){

            showModalBottomSheet(
                context: context,
                builder: (context){
                  return GiftFilterandSorting(category_names: widget.category_names);
                }
            );
            
          }, icon: Icon(Icons.filter_alt))
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
                          return MyGiftsCard(gift: data[index], event_id: (index < widget.event_ids.length)?widget.event_ids[index].toString():"",);
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
