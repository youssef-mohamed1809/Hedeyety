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

  String image_message = "Choose an Image";

  @override
  State<CreateGiftPage> createState() => _CreateGiftPageState();
}

class _CreateGiftPageState extends State<CreateGiftPage> {
  GlobalKey<FormState> _key = GlobalKey();

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



    var res = await Event.getUpcomingEventNames();
    events = res;
    var eventNames = [];
    res.forEach((event) {
      eventNames.add(event['name']);
    });

    return eventNames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(button: null),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Text("Add a New Gift", style: TextStyle(fontSize: 30)),
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
                            key: _key,
                            child: Column(
                              children: [
                                TextFormField(
                                  key: Key("GiftNameField"),
                                  controller: name_controller,
                                  decoration: InputDecoration(
                                      hintText: "Name",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                  validator: (name){
                                    if(name!.isEmpty){
                                      return "Name must not be empty";
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  key: Key("GiftPriceField"),
                                  controller: price_controller,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      hintText: "Price",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                  validator: (price){
                                    if(price!.isEmpty){
                                      return "Price must not be empty";
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  key: Key("GiftDescriptionField"),
                                  controller: description_controller,
                                  decoration: InputDecoration(
                                      hintText: "Description",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                  validator: (description){
                                    if(description!.isEmpty){
                                      return "Description must not be empty";
                                    }
                                  },
                                ),
                                DropdownButton(
                                  key: Key("GiftCategoryDropDownButton"),
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
                                        for (var category in categories) {
                                          if (category['category'] == value) {
                                            id = category['id'];
                                          }
                                        }
                                        widget.selected_category =
                                            value as String;
                                        widget.selected_category_id =
                                            id.toString();
                                      });
                                    }),
                                const SizedBox(
                                  height: 20,
                                ),
                                DropdownButton(
                                  key: Key("GiftEventDropDownButton"),
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
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      final picker = ImagePicker();

                                      XFile? image;
                                      await showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return SafeArea(
                                              child: Wrap(
                                                children: [
                                                  ListTile(
                                                    title: Text("Camera"),
                                                    leading:
                                                        Icon(Icons.camera_alt),
                                                    onTap: () async {
                                                      image = await picker
                                                          .pickImage(
                                                              source:
                                                                  ImageSource
                                                                      .camera);
                                                      widget.image_path = image!.path;
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: Text("Gallery"),
                                                    leading: Icon(Icons.photo),
                                                    onTap: () async {
                                                      image = await picker
                                                          .pickImage(
                                                              source:
                                                                  ImageSource
                                                                      .gallery);
                                                      widget.image_path = image!.path;
                                                      Navigator.pop(context);
                                                      },

                                                  )
                                                ],
                                              ),
                                            );
                                          });

                                      if (image != null) {
                                        widget.image_message = "Image Selected";

                                      } else {
                                        widget.image_message =
                                            "Select an Image";
                                        widget.image_path = null;
                                      }
                                      setState(() {

                                      });
                                    },

                                    child: Text(widget.image_message)),
                                const SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                    key: Key("CreateGiftButton"),
                                    onPressed: () async {
                                      if(_key.currentState!.validate()){
                                        var event_id = -1;
                                        for (int i = 0; i < events.length; i++) {
                                          if (events[i]['name'] ==
                                              widget.selected_value) {
                                            event_id = events[i]['id'];
                                          }
                                        }
                                        String? url_acctual;
                                        if(widget.image_path != null){
                                          url_acctual =
                                          await ImageHandler.uploadImage(
                                              widget.image_path as String);
                                        }

                                        Gift.createGift(
                                            -1,
                                            name_controller.text,
                                            description_controller.text,
                                            widget.selected_category_id,
                                            price_controller.text,
                                            event_id,
                                            imgURL: url_acctual??"");

                                        Navigator.pop(context);
                                      }

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
