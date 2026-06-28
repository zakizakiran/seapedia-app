import 'user_model.dart';

class AuthResponseModel {
  final UserModel? user;
  final bool? requiresRoleSelection;
  final String? accessToken;
  final String? refreshToken;
  final String? activeRole;
  final List<String>? roles;

  AuthResponseModel({
    this.user,
    this.requiresRoleSelection,
    this.accessToken,
    this.refreshToken,
    this.activeRole,
    this.roles,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      requiresRoleSelection: json['requiresRoleSelection'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      activeRole: json['activeRole'],
      roles: json['roles'] != null ? List<String>.from(json['roles']) : null,
    );
  }
}
