import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/CustomAppBar.dart';
import 'package:hedeyety/CustomWidgets/GiftCard.dart';
import 'package:hedeyety/Model/Event.dart';
import 'package:hedeyety/Model/Gift.dart';

class EventDetailsPage extends StatelessWidget {
  Event event;
  EventDetailsPage({super.key, required this.event});

  Future getGifts() async {

    List res = await Gift.getLocalGifts(event.id);
    print(res);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(button: null),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Column(
            children: [
              CircleAvatar(radius: 60,),
              SizedBox(height: 20,),
              Text("${event.name}", style: TextStyle(fontSize: 30),),
              Text("${event.location}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
              Text("${event.date?.day}/${event.date?.month}/${event.date?.year}", style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),),
              SizedBox(height: 20,),
              Text("${event.description}", style: TextStyle(fontSize: 15),),
              Divider(),
              SizedBox(height: 10,),
              Text("Requested Gifts"),
              SizedBox(height: 10,),
              FutureBuilder(
                    future: getGifts(),
                    builder: (BuildContext, snapshot){
                      if(snapshot.hasData){
                        List data = snapshot.data;
                        if(data.isEmpty){
                          return Center(child: Text("No gifts added yet"),);
                        }else{
                        return Expanded(

                          child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (BuildContext, index) {
                                  return Center(child: Column(
                                    children: [
                                      SizedBox(height: 10,),
                                      Text("• " + data[index].name),
                                    ],
                                  ));
                          }),
                        );}
                      }else if(snapshot.hasError){
                        print(snapshot.error);
                        return Center(child: Text("An Error has occured"),);
                      }else{
                        return Center(child: CircularProgressIndicator());
                      }
                    }),

              // ElevatedButton(onPressed:(){Navigator.pushNamed(context, '/create_gift')}, child: Text("Add Gift"))

            ],
          ),
        ),
      ),
    );
  }
}


// Column(
// children: [
// GiftCard(pledged: false,),
// GiftCard(pledged: true,),
// GiftCard(pledged: false,),
// GiftCard(pledged: true,)
// ],
// ),