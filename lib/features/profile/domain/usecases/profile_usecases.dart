import 'package:jobi/features/profile/domain/entities/user_profile.dart';
import 'package:jobi/features/profile/domain/repositories/profile_repository.dart';

class GetMyProfile {
  const GetMyProfile(this.repository);

  final ProfileRepository repository;

  Future<UserProfile> call() => repository.getMyProfile();
}

class UpdateMyProfile {
  const UpdateMyProfile(this.repository);

  final ProfileRepository repository;

  Future<UserProfile> call(UserProfile profile) => repository.updateProfile(profile);
}
