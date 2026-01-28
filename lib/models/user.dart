class User {
  final int id;
  final String nama;
  final String role;

  User({required this.id, required this.nama, required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.parse(json['id'].toString()),
      nama: json['nama'],
      role: json['role'],
    );
  }
}
