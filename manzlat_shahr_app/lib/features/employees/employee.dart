class Employee {
  Employee({
    required this.username,
    required this.pin,
    required this.fullName,
    required this.createdAtMillis,
  });

  final String username;
  final String pin;
  final String fullName;
  final int createdAtMillis;

  Map<String, dynamic> toMap() => {
        'username': username,
        'pin': pin,
        'fullName': fullName,
        'createdAtMillis': createdAtMillis,
      };

  static Employee fromMap(Map<dynamic, dynamic> map) {
    return Employee(
      username: (map['username'] ?? '').toString(),
      pin: (map['pin'] ?? '').toString(),
      fullName: (map['fullName'] ?? '').toString(),
      createdAtMillis: (map['createdAtMillis'] as int?) ?? 0,
    );
  }
}

