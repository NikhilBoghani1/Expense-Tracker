class User {
  int? id;
  String email;
  String password;

  User({this.id, required this.email, required this.password});


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
    };
  }

  // Extract a User object from a Map.
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
    );
  }
}
