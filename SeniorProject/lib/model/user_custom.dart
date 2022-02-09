/**
 * This class is to manage our users with all their info relevant
 * Not the password since it shouldnt be stored
 */
class UserCustom{

  String email;
  String username;


  UserCustom(this.email, this.username,);

  factory UserCustom.fromJson(Map<String, dynamic> json){
    return UserCustom(
       json['userName'],
       json['email'],
    );
  }

}