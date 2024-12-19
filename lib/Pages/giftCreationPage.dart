import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/CustomAppBar.dart';
import 'package:hedeyety/Model/Event.dart';
import 'package:hedeyety/Model/Gift.dart';
import 'package:hedeyety/Model/ImageHandler.dart';
import 'package:image_picker/image_picker.dart';

class CreateGiftPage extends StatefulWidget {
  CreateGiftPage({super.key});

  String? selected_value;
  String? selected_category;
  String? selected_category_id;
  String? image_path;

  @override
  State<CreateGiftPage> createState() => _CreateGiftPageState();
}

class _CreateGiftPageState extends State<CreateGiftPage> {
  GlobalKey<FormState> key = GlobalKey();

  List events = [];
  var categories = [];
  List category_names = [];

  TextEditingController name_controller = TextEditingController();
  TextEditingController price_controller = TextEditingController();
  TextEditingController description_controller = TextEditingController();



  Future getEventNames() async {
    categories = await Gift.getGiftCategories();
    category_names =
        categories.map((category) => category['category'] as String).toList();

    print(categories);
    print("---");
    print(category_names);

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
              SizedBox(
                height: 40,
              ),
              FutureBuilder(
                  future: getEventNames(),
                  builder: (BuildContext, snapshot) {
                    if (snapshot.hasData) {
                      List data = snapshot.data;
                      if (widget.selected_value == null && data.isNotEmpty) {
                        widget.selected_value = data[0];
                      }
                      if (!data.isEmpty) {
                        return Center(
                          child: Form(
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: name_controller,
                                  decoration: InputDecoration(
                                      hintText: "Name",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
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
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: description_controller,
                                  decoration: InputDecoration(
                                      hintText: "Description",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                ),
                                DropdownButton(
                                    hint: Text("Choose a category"),
                                    value: widget.selected_category,
                                    items: category_names.map((name) {
                                      return DropdownMenuItem(
                                        child: Text(name),
                                        value: name,
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        int id = 0;
                                        for(var category in categories){
                                          if(category['category'] == value){
                                            id = category['id'];
                                          }
                                        }
                                        widget.selected_category = value as String;
                                        widget.selected_category_id = id.toString();

                                      });
                                    }),
                                const SizedBox(
                                  height: 20,
                                ),
                                DropdownButton(
                                  hint: Text("Select an Event"),
                                  value: widget.selected_value,
                                  items: data.map((name) {
                                    return DropdownMenuItem(
                                      child: Text(name),
                                      value: name,
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      widget.selected_value = value as String?;
                                    });
                                    // print(selected_value);
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      final picker = ImagePicker();
                                      final image = await picker.pickImage(source: ImageSource.gallery);
                                      if(image != null){
                                        print(image.path);
                                        widget.image_path = image.path;
                                      }
                                    }, child: Text("Choose an Image")),
                                const SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      var event_id = -1;
                                      for (int i = 0; i < events.length; i++) {
                                        if (events[i]['name'] ==
                                            widget.selected_value) {
                                          event_id = events[i]['id'];
                                        }
                                      }

                                      String? url_acctual = await ImageHandler.uploadImage(widget.image_path as String);

                                      // print(event_id);
                                      Gift.createGift(
                                          -1,
                                          name_controller.text,
                                          description_controller.text,
                                          widget.selected_category_id,
                                          price_controller.text,
                                          event_id,
                                        imgURL: url_acctual
                                      );

                                      Navigator.pop(context);
                                    },
                                    child: Text("Add Gift")),

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
