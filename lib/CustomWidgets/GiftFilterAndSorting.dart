import 'package:flutter/material.dart';

class GiftFilterandSorting extends StatefulWidget {
  List category_names;
  Set selectedCategories = {};

  List sortingOptions = ['Alphabetically'];
  String? selectedSortOption;

  GiftFilterandSorting({super.key, required this.category_names, required selectedCategories, required selectedSortOption}){
    if(selectedCategories != null){
      this.selectedCategories = selectedCategories;
    }
    this.selectedSortOption = selectedSortOption;
  }

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
          Expanded(
            child: Wrap(
              spacing: 15,
              children: widget.sortingOptions.map((option) {
                final isSelected = (option == widget.selectedSortOption);
                return ChoiceChip(
                  label: Text(option),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    setState(() {
                      widget.selectedSortOption = selected ? option : null;
                    });
                  },
                );
              }).toList(),
            ),
          ),
          Divider(),
          Text("Filter"),
          Expanded(
            child: Wrap(
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
                }).toList()),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      side: BorderSide(color: Colors.black, width: 1)),
                  onPressed: () {
                    widget.selectedSortOption = null;
                    widget.selectedCategories.clear();
                    setState(() {


                    });
                  },
                  child: Text("Reset")),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      side: BorderSide(color: Colors.black, width: 1)),
                  onPressed: () {
                    Navigator.pop(context,
                        [widget.selectedSortOption, widget.selectedCategories]);
                  },
                  child: Text("Apply"))
            ],
          )
        ],
      ),
    );
  }
}
