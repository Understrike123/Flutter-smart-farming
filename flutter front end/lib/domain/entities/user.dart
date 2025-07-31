class User {
  final String id;
  final String name;
  final String email;
  final String token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Cek apakah ada nested 'data' key, jika tidak, gunakan json root
    final data = json.containsKey('data') ? json['data'] : json;

    return User(
      // Berikan nilai default jika kunci tidak ada
      id: data['id'] ?? 'user-id-placeholder',
      name: data['name'] ?? 'User',
      email: data['email'] ?? '',
      token: data['token'] ?? '', // Ambil token
    );
  }
}
