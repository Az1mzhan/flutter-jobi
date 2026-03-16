import 'package:equatable/equatable.dart';
import 'package:jobi/core/constants/user_roles.dart';

class UserSession extends Equatable {
  const UserSession({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.roles,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  final String userId;
  final String fullName;
  final String email;
  final String phone;
  final List<RoleType> roles;
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  @override
  List<Object?> get props => [
        userId,
        fullName,
        email,
        phone,
        roles,
        accessToken,
        refreshToken,
        expiresAt,
      ];
}
