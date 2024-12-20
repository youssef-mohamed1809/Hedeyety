import 'package:flutter/material.dart';
import 'package:hedeyety/Pages/friendDetailsPage.dart';


class FriendSearchDelegate extends SearchDelegate<String>{

  List<String> myFriends;
  List<String> myFriendIDs;
  FriendSearchDelegate({required this.myFriends, required this.myFriendIDs});

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

            int i = myFriends.indexOf(searchResults[index]);
            Navigator.push(context, MaterialPageRoute(builder: (context) => FriendDetailsPage(id: myFriendIDs[i])));

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
            int i = myFriends.indexOf(suggestionList[index]);
            Navigator.push(context, MaterialPageRoute(builder: (context) => FriendDetailsPage(id: myFriendIDs[i])));
            // Show the search results based on the selected suggestion.
          },
        );
      },
    );
  }

}