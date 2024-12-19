import 'package:flutter/material.dart';

class GiftFilterandSorting extends StatefulWidget {
  List category_names;
  Set selectedCategories = {};

  List sortingOptions = ['Alphabetically'];
  String? selectedSortOption;

  GiftFilterandSorting({super.key, required this.category_names});

  @override
  State<GiftFilterandSorting> createState() => _GiftFilterandSortingState();
}

class _GiftFilterandSortingState extends State<GiftFilterandSorting> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
          Text("Sort"),
          Wrap(
            spacing: 15,
            children: [
                // widget.sortingOptions.map((option){
                //   final isSelected =
                // }).toList()
            ],
          ),
          Divider(),
          Text("Filter"),
          Wrap(
              spacing: 8,
              children: widget.category_names.map((category) {
                final isSelected = widget.selectedCategories.contains(category);
                return FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    selectedColor: Colors.red,
                    backgroundColor: Colors.blue,
                    onSelected: (bool selected) {
                      print("hi");
                      if (selected) {
                        widget.selectedCategories.add(category);
                      } else {
                        widget.selectedCategories.remove(category);
                      }
                      print(widget.selectedCategories);
                      setState(() {});
                    });
              }).toList()
          ),


        ],
      ),
    );
  }
}
