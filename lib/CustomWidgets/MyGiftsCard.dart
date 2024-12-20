import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hedeyety/Model/Gift.dart';
import 'package:hedeyety/Model/UserModel.dart';
import 'package:hedeyety/Pages/giftEditingPage.dart';
import 'package:hedeyety/Pages/giftsDetailsPage.dart';

// Status Mapping
// pledged => 1, blue
// unpledged => 0, red
// bought => 2, green

class MyGiftsCard extends StatelessWidget {
  final Gift gift;
  final String event_id;
  late final DatabaseReference _databaseReference;

  MyGiftsCard({super.key, required this.gift, required this.event_id}) {
    _databaseReference = FirebaseDatabase.instance.ref(
        "/users/${UserModel.getCurrentUserUID()}/events/eventN${event_id}/gifts/giftN${gift.id}/status");
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _databaseReference.onValue,
        builder: (context, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: 95,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(100),
              ),
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            );
          }
          if (streamSnapshot.hasError) {
            return Container(
              width: 95,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Text(
                'Error',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          var streamData = streamSnapshot.data!.snapshot.value;
          String statusText;
          Color statusColor;
          if (streamData == "2") {
            statusText = "Bought";
            statusColor = Colors.green;
          } else if (streamData == "1") {
            statusText = "Pledged";
            statusColor = Colors.blue;
          } else {
            statusText = "Not Bought";
            statusColor = Colors.red;
          }

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                SizedBox(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => GiftDetailsPage(gift: gift)));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(gift.name as String, textAlign: TextAlign.start),
                        ),
                        Expanded(
                          child: Container(
                            width: 95,
                            height: 30,
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: Text(
                                statusText,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: (streamData == "1" || streamData == "2")?null:() async {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>EditGiftPage(gift: gift)));
                            },
                            child: const Text("Edit", textAlign: TextAlign.center),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
