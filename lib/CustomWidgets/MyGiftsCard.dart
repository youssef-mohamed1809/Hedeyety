import 'package:flutter/material.dart';
import 'package:hedeyety/Pages/giftsDetailsPage.dart';

//pledged => 1, blue
//unpledged =>0,  red
//bought => 2, green

class MyGiftsCard extends StatelessWidget {
  int status = 0;
  String name = "";
  String event = "";
  String description = "";

  MyGiftsCard({super.key, required this.status, required this.name, this.event = "", this.description = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),  // Add some padding for better spacing
      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.grey, width: 2), // Define border color and width
      //   borderRadius: BorderRadius.circular(10), // Rounded corners for the border
      // ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => GiftDetailsPage(gift_name: name, gift_description: description)));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(name, textAlign: TextAlign.start), // Centering the text
                  ),
                  Expanded(
                    child: Container(
                      width: 95,
                      height: 30,
                      decoration: BoxDecoration(
                        color: (status == 2) ? Colors.green
                            : (status == 1) ? Colors.blue
                            : Colors.red,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Text(
                          (status == 2)
                              ? "Bought"
                              : (status == 1)
                              ? "Pledged"
                              : "Not Bought",
                          style: TextStyle(color: Colors.white), // Added color to the text
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: (status>=1)?null:() {},
                      child: Text("Edit", textAlign: TextAlign.center), // Centering the button
                    ),
                  ),
                ],
              ),
            ),
          ),
          (event!="")?ElevatedButton(onPressed: (){}, child: Text(event))
              :Text("No Event Assigned", style: TextStyle(fontStyle: FontStyle.italic),)
        ],
      ),
    );
  }
}
