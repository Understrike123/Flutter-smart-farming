class NotificationPref {
  final String? email;

  NotificationPref({this.email});

  factory NotificationPref.fromJson(Map<String, dynamic> json) {
    return NotificationPref(email: json['email']);
  }
}
