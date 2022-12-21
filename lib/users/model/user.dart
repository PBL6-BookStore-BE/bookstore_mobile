class User
{
  String email;
  String password;
  String username;

  User(
      this.username,
      this.email,
      this.password,
      );
  factory User.fromJson(Map<String, dynamic> json) => User(
    json["username"],
    json["email"],
    json["password"],
  );



  Map<String, dynamic> toJson() =>
      {
        'username': username,
        'email':email,
        'password':password

      };
}