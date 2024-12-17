import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/CustomAppBar.dart';
import 'package:hedeyety/Model/Event.dart';
import 'package:hedeyety/Model/Gift.dart';

class CreateGiftPage extends StatefulWidget {
  CreateGiftPage({super.key});

  @override
  State<CreateGiftPage> createState() => _CreateGiftPageState();
}

class _CreateGiftPageState extends State<CreateGiftPage> {
  GlobalKey<FormState> key = GlobalKey();

  List events = [];

  TextEditingController name_controller = TextEditingController();
  TextEditingController price_controller = TextEditingController();
  TextEditingController description_controller = TextEditingController();

  String? selected_value;

  Future getEventNames() async {
    var res = await Event.getUpcomingEventNames();
    events = res;
    var eventNames = [];
    res.forEach((event) {
      eventNames.add(event['name']);
    });
    // print(eventNames);

    return eventNames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(button: null),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Text("Add a new Gift", style: TextStyle(fontSize: 30)),
              SizedBox(height: 40, ),
              FutureBuilder(
                  future: getEventNames(),
                  builder: (BuildContext, snapshot) {
                    if (snapshot.hasData) {
                      List data = snapshot.data;
                      if (selected_value == null && data.isNotEmpty) {
                        selected_value = data[0];
                      }
                      if (!data.isEmpty) {
                        return Center(
                          child: Form(
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: name_controller,
                                  decoration: InputDecoration(hintText: "Name", border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30))),
                                ),
                                const SizedBox(height: 20,),
                                TextFormField(
                                  controller: price_controller,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(hintText: "Price",border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30))),
                                ),
                                const SizedBox(height: 20,),
                                TextFormField(
                                  controller: description_controller,
                                  decoration:
                                      InputDecoration(hintText: "Description", border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30))),
                                ),
                                const SizedBox(height: 20,),
                                DropdownButton(
                                  hint: Text("Select an Event"),
                                  value: selected_value,
                                  items: data.map((name) {
                                    return DropdownMenuItem(
                                      child: Text(name),
                                      value: name,
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selected_value = value as String?;
                                    });
                                    // print(selected_value);
                                  },
                                ),
                                const SizedBox(height: 20,),
                                ElevatedButton(
                                    onPressed: () {
                                      var event_id = -1;


                                      for (int i = 0; i < events.length; i++) {
                                        if (events[i]['name'] == selected_value) {
                                          event_id = events[i]['id'];
                                        }
                                      }
                                      // print(event_id);
                                      Gift.createGift(
                                          -1,
                                          name_controller.text,
                                          description_controller.text,
                                          "",
                                          price_controller.text,
                                          event_id);

                                      Navigator.pop(context);

                                    },
                                    child: Text("Add Gift"))
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Text("Create an Event first");
                      }
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return Center(child: Text("An Error has Occured"));
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            ],
          ),
        ));
  }
}
