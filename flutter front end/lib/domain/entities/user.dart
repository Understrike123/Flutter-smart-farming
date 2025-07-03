class User {
  final String id;
  final String name;
  final String email;
  final String token; // Untuk otentikasi dengan API nanti

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
  });
}
