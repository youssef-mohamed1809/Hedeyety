import 'package:flutter/material.dart';
import 'package:hedeyety/Model/Gift.dart';
import 'package:hedeyety/Pages/giftEditingPage.dart';
import 'package:hedeyety/Pages/giftsDetailsPage.dart';

//pledged => 1, blue
//unpledged =>0,  red
//bought => 2, green

class MyGiftsCard extends StatelessWidget {
  Gift gift;

  // bool showEventName;

  MyGiftsCard({super.key, required this.gift});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),  // Add some padding for better spacing
      child: Column(
        children: [
          SizedBox(
            child: TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => GiftDetailsPage()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(gift.name as String, textAlign: TextAlign.start), // Centering the text
                  ),
                  Expanded(
                    child: Container(
                      width: 95,
                      height: 30,
                      decoration: BoxDecoration(
                        color: (gift.status == "2") ? Colors.green
                            : (gift.status == "1") ? Colors.blue
                            : Colors.red,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Text(
                          (gift.status == "2")
                              ? "Bought"
                              : (gift.status == "1")
                              ? "Pledged"
                              : "Not Bought",
                          style: const TextStyle(color: Colors.white), // Added color to the text
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: (gift.status == "1" || gift.status == "2")?null:() async {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>EditGiftPage(gift: gift)));
                      },
                      child: const Text("Edit", textAlign: TextAlign.center), // Centering the button
                    ),
                  ),
                ],
              ),
            ),
          ),
          // (showEventName)?((event!="")?ElevatedButton(onPressed: (){}, child: Text(event))
          //     :const Text("No Event Assigned", style: TextStyle(fontStyle: FontStyle.italic),)):const SizedBox()
        ],
      ),
    );
  }
}
