import 'package:jobi/core/constants/user_roles.dart';
import 'package:jobi/features/profile/domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.fullName,
    required super.city,
    required super.region,
    required super.latitude,
    required super.longitude,
    required super.about,
    required super.avatarUrl,
    required super.roles,
    required super.professions,
    required super.experience,
    required super.totalTasks,
    required super.successfulTasks,
    required super.cancellations,
    required super.rating,
    required super.availableNow,
    required super.readyToTravel,
    required super.firstJobDate,
    required super.workHistory,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      city: json['city'] as String? ?? '',
      region: json['region'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      about: json['about'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      roles: ((json['roles'] as List<dynamic>? ?? const <dynamic>[])
              .map((role) => RoleTypeX.fromString(role as String)))
          .toList(),
      professions: (json['professions'] as List<dynamic>? ?? const <dynamic>[])
          .map((profession) => profession as String)
          .toList(),
      experience: (json['experience'] as List<dynamic>? ?? const <dynamic>[])
          .map(
            (item) => ProfessionExperience(
              profession: (item as Map<String, dynamic>)['profession'] as String,
              months: item['months'] as int,
            ),
          )
          .toList(),
      totalTasks: json['totalTasks'] as int? ?? 0,
      successfulTasks: json['successfulTasks'] as int? ?? 0,
      cancellations: json['cancellations'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      availableNow: json['availableNow'] as bool? ?? false,
      readyToTravel: json['readyToTravel'] as bool? ?? false,
      firstJobDate: DateTime.tryParse(json['firstJobDate'] as String? ?? '') ??
          DateTime.now(),
      workHistory: (json['workHistory'] as List<dynamic>? ?? const <dynamic>[])
          .map(
            (item) => WorkHistoryEntry(
              id: (item as Map<String, dynamic>)['id'] as String,
              title: item['title'] as String,
              counterparty: item['counterparty'] as String,
              date: DateTime.parse(item['date'] as String),
              status: item['status'] as String,
              amount: (item['amount'] as num).toDouble(),
            ),
          )
          .toList(),
    );
  }

  factory UserProfileModel.fromEntity(UserProfile profile) {
    return UserProfileModel(
      id: profile.id,
      fullName: profile.fullName,
      city: profile.city,
      region: profile.region,
      latitude: profile.latitude,
      longitude: profile.longitude,
      about: profile.about,
      avatarUrl: profile.avatarUrl,
      roles: profile.roles,
      professions: profile.professions,
      experience: profile.experience,
      totalTasks: profile.totalTasks,
      successfulTasks: profile.successfulTasks,
      cancellations: profile.cancellations,
      rating: profile.rating,
      availableNow: profile.availableNow,
      readyToTravel: profile.readyToTravel,
      firstJobDate: profile.firstJobDate,
      workHistory: profile.workHistory,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'city': city,
        'region': region,
        'latitude': latitude,
        'longitude': longitude,
        'about': about,
        'avatarUrl': avatarUrl,
        'roles': roles.map((role) => role.apiValue).toList(),
        'professions': professions,
        'experience': experience
            .map(
              (item) => {
                'profession': item.profession,
                'months': item.months,
              },
            )
            .toList(),
        'totalTasks': totalTasks,
        'successfulTasks': successfulTasks,
        'cancellations': cancellations,
        'rating': rating,
        'availableNow': availableNow,
        'readyToTravel': readyToTravel,
        'firstJobDate': firstJobDate.toIso8601String(),
        'workHistory': workHistory
            .map(
              (item) => {
                'id': item.id,
                'title': item.title,
                'counterparty': item.counterparty,
                'date': item.date.toIso8601String(),
                'status': item.status,
                'amount': item.amount,
              },
            )
            .toList(),
      };
}
