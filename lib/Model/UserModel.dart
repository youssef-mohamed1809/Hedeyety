import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'RTdb.dart';

class UserModel{

  static String? current_user;

  String uid;
  DateTime created_at;
  String email;
  String photo;
  String username;
  String name;

  UserModel({
    required this.uid,
    required this.created_at,
    required this.email,
    required this.photo,
    required this.username,
    required this.name
  });


  static get_id_by_username(username) async {
    var db = RealTimeDatabase.getInstance();
    var ref = db.ref();

    var event = await ref.child("/users").orderByChild("username").equalTo(username).once();

    final data = event.snapshot.value;

    print(data);

    if(data != null) {
      Map x = event.snapshot.value;
      // print(x.keys.first);
      return x.keys.first;
    }else{
      return -1;
    }
  }


  static Future<bool> add_friend(friend_username) async{

    var user_id = getCurrentUserUID();
    var friend_id =  await get_id_by_username(friend_username);

    if(friend_id == false){
      return false;
    }

    var res = await _add_a_friend(user_id, friend_id);
    if(!res){
      return res;
    }
    res = await _add_a_friend(friend_id, user_id);
    return res;

  }

  static Future<bool> _add_a_friend(user_id, friend_id) async {

    if (friend_id != -1){
      var db = RealTimeDatabase.getInstance();

      var ref = db.ref().child("users/$user_id/friends");

      try{
        var snapshot = await ref.get();

        if(snapshot.exists){
          Map friends = snapshot.value as Map;

          if(!friends.containsKey(friend_id)){
            friends[friend_id] = true;
            await ref.set(friends);
          }
        }else{
          Map friends = {
            friend_id: true
          };

          await ref.set(friends);

        }

        return true;
      }catch(e){
        // print(e);
        return false;
      }
    }
    return false;

  }

  static getCurrentUserUID() {
    if(current_user == null){
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
         current_user = user.uid;
      }else{
        return false;
      }
    }

    return current_user;
  }

  static getCurrentUserData() async {
    String uid = getCurrentUserUID();



    var db = RealTimeDatabase.getInstance();

    var ref = db.ref();

    // print("hi");
    final snapshot = await ref.child('users/$uid').get();
    // print("bye");

    if (snapshot.exists){
      Map data = snapshot.value as Map;
      // print(data);

      return UserModel(uid: uid, created_at: DateTime.parse(data['createdAt']), email: data['email'], photo: data['profilePicture'], username: data['username'], name: data['name']);

    }else{
      // print("ello");
    }
  }

  static add_to_db({uid, name, username, email}) async {
    var db = RealTimeDatabase.getInstance();

    var ref = db.ref("users/${uid}");

    await ref.set({
      "name": name,
      "username": username,
      "email": email,
      "profilePicture": "",
      "friends": {},
      "createdAt": (DateTime.now()).toString()
    });
  }


  static getNameByID(id) async{
    var db = RealTimeDatabase.getInstance();
    var ref = db.ref().child("users/$id/name");
    try{
      var snapshot = await ref.get();
      // print(snapshot.value);
      return snapshot.value;
    }catch(e){
      print(e);
    }
  }

  static Future<List> getMyFriendsIDs() async{
    var db = RealTimeDatabase.getInstance();
    var id = getCurrentUserUID();
    var ref = db.ref().child("users/$id/friends");
    try{
      var snapshot = await ref.get();
      var data = snapshot.value;
      // print(data.keys.toList());
      return data.keys.toList();
    }catch(e){
      print(e);
      return [];
    }
  }

}