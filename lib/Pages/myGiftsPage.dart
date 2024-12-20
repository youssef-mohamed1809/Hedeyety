import 'package:flutter/material.dart';
import 'package:hedeyety/CustomWidgets/CustomFAB.dart';
import 'package:hedeyety/CustomWidgets/GiftFilterAndSorting.dart';
import 'package:hedeyety/CustomWidgets/MyGiftsCard.dart';
import 'package:hedeyety/Model/Gift.dart';

import '../CustomWidgets/BottomNavBar.dart';
import '../CustomWidgets/CustomAppBar.dart';

class GiftsPage extends StatefulWidget {
  GiftsPage({super.key});

  List? sorted_filtered_gifts;
  late List event_ids = [];

  late List categories = [];
  List category_names = [];

  Set selectedFilters = {};
  String? selectedSort;
  late List gifts;

  List? sorted_filtered_gifts_event_ids;

  @override
  State<GiftsPage> createState() => _GiftsPageState();
}

class _GiftsPageState extends State<GiftsPage> {
  Future getMyGifts() async {
    var gifts_and_eventIDs = await Gift.getLocalGifts(-1);
    widget.categories = await Gift.getGiftCategories();
    widget.category_names = widget.categories
        .map((category) => category['category'] as String)
        .toList();

    if(gifts_and_eventIDs.length == 2){
      widget.event_ids = gifts_and_eventIDs[1];
      widget.gifts = gifts_and_eventIDs[0];
      return gifts_and_eventIDs[0];
    }else{
      widget.event_ids = gifts_and_eventIDs[0];
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            button: IconButton(
                onPressed: () async {
                  final result = await showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return GiftFilterandSorting(
                            category_names: widget.category_names,
                            selectedCategories: widget.selectedFilters,
                            selectedSortOption: widget.selectedSort, );
                      });

                  widget.selectedSort = result[0];
                  widget.selectedFilters = result[1];
                  var filter_ids = [];
                  widget.selectedFilters.forEach((filter) {
                    for (var category in widget.categories) {
                      if (category['category'] == filter) {
                        filter_ids.add(category['id']);
                      }
                    }
                  });

                  if (filter_ids.isEmpty && widget.selectedSort == null) {
                    widget.sorted_filtered_gifts = null;
                    widget.sorted_filtered_gifts_event_ids = null;
                    setState(() {

                    });
                  } else {
                    List filtered_gifts =
                        Gift.filterGifts(widget.gifts, filter_ids);
                    List sorted_gifts =
                        Gift.sortGiftsAlphabetically(filtered_gifts);
                    widget.sorted_filtered_gifts = sorted_gifts;
                    widget.sorted_filtered_gifts_event_ids = null;
                    for (var gift in widget.sorted_filtered_gifts!) {
                      widget.sorted_filtered_gifts_event_ids
                          ?.add(await Gift.getEventID(gift));
                    }
                    setState(() {

                    });
                  }
                },
                icon: Icon(Icons.filter_alt))),
        body: Container(
            margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            child: FutureBuilder(
                future: getMyGifts(),
                builder: (BuildContext, snapshot) {
                  if (snapshot.hasData) {
                    List data = snapshot.data;
// print(data);
                    if (data.isEmpty) {
                      return Center(
                        child: Text("No gifts created yet"),
                      );
                    } else {
                      return ListView.builder(
                          itemCount: widget.sorted_filtered_gifts?.length??data.length,
                          itemBuilder: (BuildContext, index) {
                            return MyGiftsCard(
                              gift: widget.sorted_filtered_gifts?[index]??data[index],
                              event_id: (index < (widget.sorted_filtered_gifts_event_ids?.length??widget.event_ids.length))
                                  ? (widget.sorted_filtered_gifts_event_ids?[index].toString()??widget.event_ids[index].toString())
                                  : "",
                            );
                          });
                    }
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Center(
                      child: Text("An error has occurred"),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })),
        floatingActionButton: CustomFAB(),
        bottomNavigationBar: NavBar(current_page: 2));
  }
}
