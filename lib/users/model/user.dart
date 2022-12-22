class User
{
  String email;
  String password;
  String username;
  String token;

  User(
      this.username,
      this.email,
      this.password,
      this.token
      );
  factory User.fromJson(Map<String, dynamic> json) => User(
    json["username"],
    json["email"],
    json["password"],
    json["token"]
  );



  Map<String, dynamic> toJson() =>
      {
        'username': username,
        'email':email,
        'password':password,
        'token':token,

      };
}