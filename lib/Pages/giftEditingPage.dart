import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/CustomAppBar.dart';
import 'package:hedeyety/Model/Event.dart';
import 'package:hedeyety/Model/Gift.dart';
import 'package:hedeyety/Model/ImageHandler.dart';
import 'package:image_picker/image_picker.dart';

class EditGiftPage extends StatefulWidget {
  Gift gift;
  bool newImageSelected = false;
  String? localImgPath;
  EditGiftPage({super.key, required this.gift});

  @override
  State<EditGiftPage> createState() => _EditGiftPageState();
}

class _EditGiftPageState extends State<EditGiftPage> {
  GlobalKey<FormState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    name_controller = TextEditingController(text: widget.gift.name);
    price_controller = TextEditingController(text: widget.gift.price);
    description_controller = TextEditingController(text: widget.gift.description);
  }

  late TextEditingController name_controller;
  late TextEditingController price_controller;
  late TextEditingController description_controller;

  String? selected_value;

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
              Text("Edit Gift", style: TextStyle(fontSize: 30)),
              SizedBox(
                height: 40,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(radius: 70, backgroundImage: (widget.newImageSelected)?FileImage(File(widget.localImgPath as String)):(widget.gift.imgURL == null || widget.gift.imgURL == "")?null:NetworkImage(widget.gift.imgURL as String),),
                  Container(
                    width: 140, // Twice the radius (2 * 70)
                    height: 140, // Twice the radius (2 * 70)
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4), // Transparent black color
                      shape: BoxShape.circle,
                    ),
                  ),
                  IconButton(onPressed: () async {
                    print("SUIII");
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
                                  leading: Icon(Icons.camera_alt),
                                  onTap: () async {
                                    image = await picker.pickImage(
                                        source: ImageSource.camera);
                                    if(image != null){
                                      widget.newImageSelected = true;
                                      widget.localImgPath = image!.path;
                                    }
                                    Navigator.pop(context);

                                  },
                                ),
                                ListTile(
                                  title: Text("Gallery"),
                                  leading: Icon(Icons.photo),
                                  onTap: () async {
                                    image = await picker.pickImage(
                                        source: ImageSource.gallery);
                                    // print("EL PATHHHH:   ${image!.path}");
                                    if(image != null){
                                      widget.newImageSelected = true;
                                      widget.localImgPath = image!.path;
                                    }

                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          );
                        });
                    setState(() {

                    });

                  }, icon: Icon(
                    Icons.edit,
                    size: 40,
                    color: Colors.white,
                  ))
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: Form(
                  key: _key,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: name_controller,
                        decoration: InputDecoration(
                            hintText: "Name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30))),
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
                        controller: price_controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "Price",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30))),
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
                        controller: description_controller,
                        decoration: InputDecoration(
                            hintText: "Description",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30))),
                        validator: (description){
                          if(description!.isEmpty){
                            return "Description must not be empty";
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            if(_key.currentState!.validate()) {

                              if(widget.newImageSelected){
                                String? url_acctual =
                                await ImageHandler.uploadImage(
                                    widget.localImgPath as String);
                                widget.gift.imgURL = url_acctual;
                              }
                              await widget.gift.editGift();
                              Navigator.pop(context);
                            }
                          },
                          child: Text("Edit Gift"))
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
