import 'package:flutter/material.dart';


class FriendSearchDelegate extends SearchDelegate<String>{

  List<String> myFriends;
  FriendSearchDelegate({required this.myFriends});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
      return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop()
      );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<String> searchResults = myFriends
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(searchResults[index]),
          onTap: () {
            // Handle the selected search result.
            close(context, searchResults[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> suggestionList = query.isEmpty
        ? []
        : myFriends
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index]),
          onTap: () {
            query = suggestionList[index];
            // Show the search results based on the selected suggestion.
          },
        );
      },
    );
  }

}