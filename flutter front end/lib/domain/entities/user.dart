class User {
  final String id;
  final String name;
  final String username;
  final String depotName;
  final String token;
  final bool isSuperAdmin;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.depotName,
    required this.token,
    required this.isSuperAdmin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Cek apakah ada nested 'data' key, jika tidak, gunakan json root
    final data = json.containsKey('data') ? json['data'] : json;

    return User(
      // Berikan nilai default jika kunci tidak ada
      id: data['id'] ?? 'user-id-placeholder',
      name: data['name'] ?? 'User',
      username: data['email'] ?? '',
      depotName: data['depot_name'] ?? '',
      token: data['token'] ?? '', // Ambil token
      isSuperAdmin: data['is_super_admin'] == 1,
    );
  }
}
