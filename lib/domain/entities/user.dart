// lib/domain/entities/user.dart

class User {
  final String id;
  final String email;

  User({required this.id, required this.email});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id && email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;

  @override
  String toString() {
    return 'User{id: $id, email: $email}';
  }
}
