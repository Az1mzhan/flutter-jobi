import 'package:jobi/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getMyProfile();

  Future<UserProfile> updateProfile(UserProfile profile);

  Future<UserProfile> setAvailability(bool value);

  Future<UserProfile> setTravelReady(bool value);
}
