import 'package:jobi/core/constants/app_constants.dart';
import 'package:jobi/features/profile/data/datasources/profile_mock_data_source.dart';
import 'package:jobi/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:jobi/features/profile/domain/entities/user_profile.dart';
import 'package:jobi/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.mockDataSource,
  });

  final ProfileRemoteDataSource remoteDataSource;
  final ProfileMockDataSource mockDataSource;

  @override
  Future<UserProfile> getMyProfile() {
    return AppConstants.useMockData
        ? mockDataSource.getMyProfile()
        : remoteDataSource.getMyProfile();
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) {
    return AppConstants.useMockData
        ? mockDataSource.updateProfile(profile)
        : remoteDataSource.updateProfile(profile);
  }

  @override
  Future<UserProfile> setAvailability(bool value) async {
    final profile = await getMyProfile();
    return updateProfile(profile.copyWith(availableNow: value));
  }

  @override
  Future<UserProfile> setTravelReady(bool value) async {
    final profile = await getMyProfile();
    return updateProfile(profile.copyWith(readyToTravel: value));
  }
}
