import 'package:equatable/equatable.dart';
import 'package:jobi/core/constants/user_roles.dart';

class ProfessionExperience extends Equatable {
  const ProfessionExperience({
    required this.profession,
    required this.months,
  });

  final String profession;
  final int months;

  @override
  List<Object?> get props => [profession, months];
}

class WorkHistoryEntry extends Equatable {
  const WorkHistoryEntry({
    required this.id,
    required this.title,
    required this.counterparty,
    required this.date,
    required this.status,
    required this.amount,
  });

  final String id;
  final String title;
  final String counterparty;
  final DateTime date;
  final String status;
  final double amount;

  @override
  List<Object?> get props => [id, title, counterparty, date, status, amount];
}

class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.fullName,
    required this.city,
    required this.region,
    required this.latitude,
    required this.longitude,
    required this.about,
    required this.avatarUrl,
    required this.roles,
    required this.professions,
    required this.experience,
    required this.totalTasks,
    required this.successfulTasks,
    required this.cancellations,
    required this.rating,
    required this.availableNow,
    required this.readyToTravel,
    required this.firstJobDate,
    required this.workHistory,
  });

  final String id;
  final String fullName;
  final String city;
  final String region;
  final double latitude;
  final double longitude;
  final String about;
  final String avatarUrl;
  final List<RoleType> roles;
  final List<String> professions;
  final List<ProfessionExperience> experience;
  final int totalTasks;
  final int successfulTasks;
  final int cancellations;
  final double rating;
  final bool availableNow;
  final bool readyToTravel;
  final DateTime firstJobDate;
  final List<WorkHistoryEntry> workHistory;

  int get experienceMonths =>
      experience.fold<int>(0, (sum, item) => sum + item.months);

  UserProfile copyWith({
    String? fullName,
    String? city,
    String? region,
    double? latitude,
    double? longitude,
    String? about,
    String? avatarUrl,
    List<RoleType>? roles,
    List<String>? professions,
    List<ProfessionExperience>? experience,
    int? totalTasks,
    int? successfulTasks,
    int? cancellations,
    double? rating,
    bool? availableNow,
    bool? readyToTravel,
    DateTime? firstJobDate,
    List<WorkHistoryEntry>? workHistory,
  }) {
    return UserProfile(
      id: id,
      fullName: fullName ?? this.fullName,
      city: city ?? this.city,
      region: region ?? this.region,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      about: about ?? this.about,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      roles: roles ?? this.roles,
      professions: professions ?? this.professions,
      experience: experience ?? this.experience,
      totalTasks: totalTasks ?? this.totalTasks,
      successfulTasks: successfulTasks ?? this.successfulTasks,
      cancellations: cancellations ?? this.cancellations,
      rating: rating ?? this.rating,
      availableNow: availableNow ?? this.availableNow,
      readyToTravel: readyToTravel ?? this.readyToTravel,
      firstJobDate: firstJobDate ?? this.firstJobDate,
      workHistory: workHistory ?? this.workHistory,
    );
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        city,
        region,
        latitude,
        longitude,
        about,
        avatarUrl,
        roles,
        professions,
        experience,
        totalTasks,
        successfulTasks,
        cancellations,
        rating,
        availableNow,
        readyToTravel,
        firstJobDate,
        workHistory,
      ];
}
