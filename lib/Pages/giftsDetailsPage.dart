import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/BottomNavBar.dart';
import 'package:hedeyety/Model/Gift.dart';

import '../CustomWidgets/CustomAppBar.dart';

class GiftDetailsPage extends StatefulWidget {
  Gift gift;

  GiftDetailsPage({super.key, required this.gift});

  @override
  State<GiftDetailsPage> createState() => _GiftDetailsPageState();
}

class _GiftDetailsPageState extends State<GiftDetailsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(button: null),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              CircleAvatar(
                radius: 70,
                backgroundImage: (widget.gift.imgURL != null &&
                        widget.gift.imgURL!.isNotEmpty)
                    ? NetworkImage(widget.gift.imgURL!)
                    : null,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.gift.name as String,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              Text("Price: ${widget.gift.price as String}"),
              SizedBox(height: 20),
              Text(widget.gift.description as String,
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 17)),
            ],
          ),
        ),
      ),
    );
  }
}
