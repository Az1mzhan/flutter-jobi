import 'package:jobi/core/constants/api_endpoints.dart';
import 'package:jobi/core/network/api_client.dart';
import 'package:jobi/features/profile/data/models/user_profile_model.dart';
import 'package:jobi/features/profile/domain/entities/user_profile.dart';

class ProfileRemoteDataSource {
  const ProfileRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<UserProfileModel> getMyProfile() async {
    final response = await _apiClient.get(ApiEndpoints.usersMe);
    return UserProfileModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserProfileModel> updateProfile(UserProfile profile) async {
    final response = await _apiClient.put(
      ApiEndpoints.profilesUpdate,
      data: UserProfileModel.fromEntity(profile).toJson(),
    );

    return UserProfileModel.fromJson(response.data as Map<String, dynamic>);
  }
}
