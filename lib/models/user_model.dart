class UserModel {
  final String id;
  final String nama;
  final String username;
  final String role;

  UserModel({
    required this.id,
    required this.nama,
    required this.username,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      nama: json['nama'],
      username: json['username'],
      role: json['role'],
    );
  }
}
