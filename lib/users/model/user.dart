class User
{
  String user_email;
  String user_password;
  String user_username;

  User(
      this.user_email,
      this.user_password,
      this.user_username
      );
  factory User.fromJson(Map<String, dynamic> json) => User(
    json["user_username"],
    json["user_email"],
    json["user_password"],
  );



  Map<String, dynamic> toJson() =>
      {
        'user_email':user_email,
        'user_password':user_password,
        'user_username': user_username

      };
}