import 'dart:ui';

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? phone;
  String? gender;
  Image? profileDP;
  DateTime? dateOfBirth;
  bool? emailChecked;
  bool? phoneChecked;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.phone,
      this.gender,
      this.profileDP,
      this.dateOfBirth,
      this.emailChecked,
      this.phoneChecked});

  factory User.fromJson(Map<String, dynamic> item) {
    return User(
        id: int.parse(item['userID']),
        firstName: item['firstName'],
        lastName: item['lastName'],
        email: item['email'],
        password: item['password'],
        phone: item['phone'],
        gender: item['gender'],
        profileDP: item['profileDP'],
        dateOfBirth: item['dateOfBirth'],
        emailChecked: item['emailChecked'],
        phoneChecked: item['phoneChecked']);
  }
}
