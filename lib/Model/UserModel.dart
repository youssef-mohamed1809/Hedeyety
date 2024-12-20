import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'RTdb.dart';

class UserModel {
  String? uid;
  DateTime? created_at;
  String? email;
  String? photo;
  String? username;
  String? name;


  UserModel({this.uid, this.created_at, this.email, this.photo, this.username, this.name});

  static usernameExists(username) async {
    var db = RealTimeDatabase.getInstance();
    var ref = await db.ref();

    DatabaseEvent event = await ref
        .child('users')  // The 'users' node in your database
        .orderByChild('username')  // Query on 'username' field inside each userID
        .equalTo(username)  // Check if any username matches the input
        .once();

    return event.snapshot.value != null;
  }

  static Future<UserModel?> getCurrentUserData() async {
    String uid = getCurrentUserUID();
    // print(uid);
    var db = RealTimeDatabase.getInstance();
    var ref = db.ref();
    final snapshot = await ref.child('users/$uid').get();

    if (snapshot.exists) {
      Map data = snapshot.value as Map;
      UserModel user = UserModel();
      user.uid = uid;
      user.created_at = DateTime.parse(data['createdAt']);
      user.email = data['email'];
      user.photo = data['profilePicture'];
      user.username = data['username'];
      user.name = data['name'];

      return user;
    } else {
      print("Error in getCurrentUserData function");
      print(snapshot.error);
      return null;
    }
  }
  static get_id_by_username(username) async {
    var db = RealTimeDatabase.getInstance();
    var ref = db.ref();

    var event = await ref
        .child("/users")
        .orderByChild("username")
        .equalTo(username)
        .once();

    final data = event.snapshot.value;

    if (data != null) {
      Map x = event.snapshot.value;
      return x.keys.first;
    } else {
      return -1;
    }
  }
  static getCurrentUserUID() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return user.uid;
    } else {
      return false;
    }
  }
  static add_new_user_to_db({uid, name, username, email}) async {
    var db = RealTimeDatabase.getInstance();

    var ref = db.ref("users/${uid}");
    var date = DateTime.now();
    try{
      await ref.set({
        "name": name,
        "username": username,
        "email": email,
        "profilePicture": "",
        "friends": {},
        "createdAt": "${date.year}-${date.month}-${date.day}",
        "pledgedGiftsNum": "0"
      });
    }catch(e){
      print("An error occurred while adding to RTDB");
      print(e);
    }
  }
  static getNameByID(id) async {
    var db = RealTimeDatabase.getInstance();
    var ref = db.ref().child("users/$id/name");
    try {
      var snapshot = await ref.get();
      return snapshot.value;
    } catch (e) {
      print("An error occured in getNameByID");
      print(e);
    }
  }

  static getFriendDetails(id) async {
    var db = RealTimeDatabase.getInstance();

    var ref = db.ref().child("users/$id");
    try {
      var snapshot = await ref.get();
      Map friend = snapshot.value as Map;
      // print(friend['name']);
      var myUser = UserModel(
          uid: id,
          created_at: null,
          email: friend['email'],
          photo: null,
          username: friend['username'],
          name: friend['name']
      );

      // print(myUser);
      return myUser;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> add_friend(friend_username) async {
    var friend_id = await get_id_by_username(friend_username);

    if (friend_id == false) {
      print("Friend ID not found");
      return false;
    }

    var status = await _add_a_friend(uid, friend_id);
    // print("status1: $status");
    if (!status) {
      return status;
    }
    status = await _add_a_friend(friend_id, uid);
    // print("Status2: $status");
    return status;
  }
  Future<bool> _add_a_friend(user_id, friend_id) async {
    if (friend_id != -1) {
      var db = RealTimeDatabase.getInstance();

      var ref = db.ref().child("users/$user_id/friends");

      try {
        var snapshot = await ref.get();
        if (snapshot.exists) {
          Map friends = snapshot.value as Map;

          if (!friends.containsKey(friend_id)) {
            friends[friend_id] = true;
            await ref.set(friends);
          }
        } else {
          Map friends = {friend_id: true};

          await ref.set(friends);
        }

        return true;
      } catch (e) {
        print(e);
        return false;
      }
    }
    return false;
  }

  Future<List?> getMyFriendsIDs() async {
    var db = RealTimeDatabase.getInstance();
    var ref = db.ref().child("users/$uid/friends");
    try {
      var snapshot = await ref.get();
      var data = snapshot.value;
      if(data == null){
        return [];
      }
      return data.keys.toList();
    } catch (e) {
      print("An error occurred in getMyFriendsIDs");
      print(e);
      return [];
    }
  }

  // static updateProfilePIcture(imgPath) async {
  //   var userID = await UserModel.getCurrentUserUID();
  //   var db = RealTimeDatabase.getInstance();
  //   var ref = db.ref().child("/users/$userID/");
  //   ref.update({
  //     'profilePicture': imgPath
  //   });
  // }

  updateUserProfile(){
    // var userID = await UserModel.getCurrentUserUID();
    var db = RealTimeDatabase.getInstance();
    var ref = db.ref().child("/users/$uid/");
    ref.update({
      "name": name,
      "username": username,
      "profilePicture": photo
    });
  }

}
