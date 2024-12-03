import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/CustomAppBar.dart';
import 'package:hedeyety/Model/Event.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {

  GlobalKey<FormState> key = GlobalKey();

  TextEditingController name_controller = TextEditingController();
  TextEditingController location_controller = TextEditingController();
  TextEditingController description_controller = TextEditingController();
  DateTime? event_date;

  var button_text = "Choose Event Date";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(button: null),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Text("Create a New Event"),
              SizedBox(height: 40,),
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
                    SizedBox(height: 20,),
                    TextFormField(
                        controller: location_controller,
                        decoration: InputDecoration(
                            hintText: "location",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)))),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: description_controller,
                      decoration: InputDecoration(
                          hintText: "description",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30))),
                    ),
                    SizedBox(height: 20,),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(onPressed: () async {
                        event_date = await showDatePicker(context: context, initialDate: DateTime.now(),firstDate: DateTime.now(), lastDate: DateTime(3000)) as DateTime?;
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
                    SizedBox(height: 40,),
                    ElevatedButton(onPressed: (){
                      if(key.currentState!.validate() && event_date != null){
                        Event.createEvent(name_controller.text, "${event_date?.year}-${event_date?.month}-${event_date?.day}", location_controller.text, description_controller.text);
                        setState(() {
                          Navigator.pop(context);
                        });
                      }
                    }, child: Text("Create Event"))
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
