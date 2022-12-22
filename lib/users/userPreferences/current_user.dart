import 'package:books_app/users/userPreferences/user_preferences.dart';
import 'package:books_app/users/model/user.dart';
import 'package:get/get.dart';

class CurrentUser extends GetxController
{
  Rx<User> _currentUser = User('','','','').obs;

  User get user => _currentUser.value;

  getUserInfo() async
  {
    User? getUserInfoFromLocalStorage = await RememberUserPrefs.readUserInfo();
    _currentUser.value = getUserInfoFromLocalStorage!;
  }
}