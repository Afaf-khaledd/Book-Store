class UserModel {
  final String uid;
  final String email;
  final String username;
  final String phone;
  final String address;
  final String birthday;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.phone,
    required this.address,
    required this.birthday,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'phone': phone,
      'address': address,
      'birthday': birthday,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      username: map['username'],
      phone: map['phone'],
      address: map['address'],
      birthday: map['birthday'],
    );
  }
  UserModel copyWith({
    String? uid,
    String? email,
    String? username,
    String? phone,
    String? address,
    String? birthday,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      birthday: birthday ?? this.birthday,
    );
  }
}