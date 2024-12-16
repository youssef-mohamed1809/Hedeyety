import 'package:hedeyety/Model/UserModel.dart';

class CurrentUser{
  static UserModel? user;


  static getCurrentUser() async {
    user ??= await UserModel.getCurrentUserData() as UserModel?;
    return user;
  }

}