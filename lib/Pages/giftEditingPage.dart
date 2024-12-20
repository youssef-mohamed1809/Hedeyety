import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/CustomAppBar.dart';
import 'package:hedeyety/Model/Event.dart';
import 'package:hedeyety/Model/Gift.dart';

class EditGiftPage extends StatefulWidget {
  Gift gift;
  EditGiftPage({super.key, required this.gift});

  @override
  State<EditGiftPage> createState() => _EditGiftPageState();
}

class _EditGiftPageState extends State<EditGiftPage> {
  GlobalKey<FormState> key = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    name_controller = TextEditingController(text: widget.gift.name);
    price_controller = TextEditingController(text: widget.gift.price);
    description_controller =
        TextEditingController(text: widget.gift.description);
  }

  late TextEditingController name_controller;
  late TextEditingController price_controller;
  late TextEditingController description_controller;

  String? selected_value;

  // Future getEventNames() async {
  //   var res = await Event.getUpcomingEventNames();
  //   events = res;
  //   var eventNames = [];
  //   res.forEach((event) {
  //     eventNames.add(event['name']);
  //   });
  //   return eventNames;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,

        appBar: CustomAppBar(button: IconButton(onPressed: () async {
          await widget.gift.deleteGift();
          Navigator.pop(context);
        }, icon: Icon(Icons.delete),)),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Text("Add a new Gift", style: TextStyle(fontSize: 30)),
              SizedBox(
                height: 40,
              ),
              Center(
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: name_controller,
                        decoration: InputDecoration(
                            hintText: "Name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: price_controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "Price",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: description_controller,
                        decoration: InputDecoration(
                            hintText: "Description",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            // print(event_id);
                            await widget.gift.editGift();
                            Navigator.pop(context);
                          },
                          child: Text("Add Gift"))
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
