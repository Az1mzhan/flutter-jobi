import 'package:jobi/features/search/domain/entities/search_entities.dart';

class WorkerSummaryModel extends WorkerSummary {
  const WorkerSummaryModel({
    required super.id,
    required super.fullName,
    required super.profession,
    required super.city,
    required super.region,
    required super.distanceKm,
    required super.rating,
    required super.availableNow,
    required super.readyToTravel,
    required super.completedTasks,
  });

  factory WorkerSummaryModel.fromJson(Map<String, dynamic> json) {
    return WorkerSummaryModel(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      profession: json['profession'] as String? ?? '',
      city: json['city'] as String? ?? '',
      region: json['region'] as String? ?? '',
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      availableNow: json['availableNow'] as bool? ?? false,
      readyToTravel: json['readyToTravel'] as bool? ?? false,
      completedTasks: json['completedTasks'] as int? ?? 0,
    );
  }
}
