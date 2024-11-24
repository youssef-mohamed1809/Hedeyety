import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hedeyety/RTdb.dart';

class UserModel{

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

    final data = event.snapshot.data;

    if(data != null) {
      Map x = event.snapshot.value;
      return x.keys.first;
    }else{
      return -1;
    }
  }

  Future<bool> add_friend(username) async {

    var friend_id = get_id_by_username(username);

    if (friend_id != -1){
      var db = RealTimeDatabase.getInstance();

      var ref = db.ref().child("users/$uid/friends");

      try{
        print("hi");
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
        print(e);
        return false;
      }
    }
    return false;

  }

  static getCurrentUserUID() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;  // Get the UID of the current user
      print("User UID: $uid");
      return uid;
    }
    print("No user is logged in.");
    return false;
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
      print("ello");
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



}