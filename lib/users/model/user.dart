class User
{
  String email;
  String password;
  String username;
  String token;
  String id;

  User(
      this.username,
      this.email,
      this.password,
      this.token,
      this.id
      );
  factory User.fromJson(Map<String, dynamic> json) => User(
    json["username"],
    json["email"],
    json["password"],
    json["token"],
    json["id"]
  );



  Map<String, dynamic> toJson() =>
      {
        'username': username,
        'email':email,
        'password':password,
        'token':token,
        'id': id,
      };
}