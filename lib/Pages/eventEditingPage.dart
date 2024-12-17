import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/CustomAppBar.dart';
import 'package:hedeyety/Model/Event.dart';

class EditEventPage extends StatefulWidget {
  Event event;
  EditEventPage({super.key, required this.event});

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name_controller = TextEditingController(text: widget.event.name);
    location_controller = TextEditingController(text: widget.event.location);
    description_controller = TextEditingController(text: widget.event.description);
    event_date = widget.event.date;
    button_text =  "Event Date: ${event_date?.day}/${event_date?.month}/${event_date?.year}";
  }

  GlobalKey<FormState> key = GlobalKey();

  late TextEditingController name_controller;
  late TextEditingController location_controller;
  late TextEditingController description_controller;
  DateTime? event_date;

  var button_text = "Choose Event Date";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(button: IconButton(onPressed: (){

        widget.event.deleteEvent();
        Navigator.pop(context);
      }, icon: Icon(Icons.delete))),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const Text("Edit Event", style: TextStyle(fontSize: 30),),
              const SizedBox(height: 40,),
              Form(
                key: key,
                child: Column(
                  children: [
                    TextFormField(
                      controller: name_controller,
                      decoration: InputDecoration(
                          hintText: "name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30))),
                    ),
                    const SizedBox(height: 20,),
                    TextFormField(
                        controller: location_controller,
                        decoration: InputDecoration(
                            hintText: "location",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)))),
                    const SizedBox(height: 20,),
                    TextFormField(
                      controller: description_controller,
                      decoration: InputDecoration(
                          hintText: "description",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30))),
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(onPressed: () async {
                        event_date = await showDatePicker(context: context, initialDate: DateTime.now(),firstDate: DateTime.now(), lastDate: DateTime(3000));
                        if(event_date != null){
                          setState(() {
                            button_text =  "Event Date: ${event_date?.day}/${event_date?.month}/${event_date?.year}";
                          });
                        }else{
                          setState(() {
                            button_text = "Choose Event Date";
                          });
                        }
                      }, child: Text(button_text,)),
                    ),
                    const SizedBox(height: 40,),
                    ElevatedButton(onPressed: () async {
                      if(key.currentState!.validate() && event_date != null){
                          widget.event.name = name_controller.text;
                          widget.event.location = location_controller.text;
                          widget.event.description = description_controller.text;
                          widget.event.date = event_date;
                          await widget.event.updateEvent();
                          setState(() {
                          Navigator.pop(context);
                        });
                      }
                    }, child: const Text("Update Event"))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
