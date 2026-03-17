import 'package:jobi/core/constants/user_roles.dart';
import 'package:jobi/features/auth/domain/entities/user_session.dart';

class RegisterRequestModel {
  const RegisterRequestModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.roles,
  });

  final String fullName;
  final String email;
  final String phone;
  final String password;
  final List<RoleType> roles;

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'password': password,
        'roles': roles.map((role) => role.apiValue).toList(),
      };
}

class UserSessionModel extends UserSession {
  const UserSessionModel({
    required super.userId,
    required super.fullName,
    required super.email,
    required super.phone,
    required super.roles,
    required super.accessToken,
    required super.refreshToken,
    required super.expiresAt,
  });

  factory UserSessionModel.fromJson(Map<String, dynamic> json) {
    return UserSessionModel(
      userId: json['userId'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      roles: ((json['roles'] as List<dynamic>? ?? const <dynamic>[])
              .map((role) => RoleType.fromString(role as String)))
          .toList(),
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      expiresAt: DateTime.tryParse(json['expiresAt'] as String? ?? '') ??
          DateTime.now().add(const Duration(days: 30)),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'roles': roles.map((role) => role.apiValue).toList(),
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'expiresAt': expiresAt.toIso8601String(),
      };
}
