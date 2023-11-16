// lib/models/contact.dart
class Contact {
  String name;
  String phoneNumber;

  Contact({ required this.name, required this.phoneNumber});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }
}
