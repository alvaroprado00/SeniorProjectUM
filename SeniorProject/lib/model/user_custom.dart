/**
 * This class is only used for storing purposes in order to create a user
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