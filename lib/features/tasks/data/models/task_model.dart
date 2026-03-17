import 'package:jobi/features/tasks/domain/entities/task.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.professionId,
    required super.professionName,
    required super.description,
    required super.locationName,
    required super.latitude,
    required super.longitude,
    required super.cityId,
    required super.regionId,
    required super.cityName,
    required super.regionName,
    required super.price,
    required super.startTime,
    required super.durationHours,
    required super.urgent,
    required super.status,
    required super.employerName,
    required super.workerName,
    required super.createdAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String? ?? '',
      professionId: json['professionId'] as String? ?? '',
      professionName: json['professionName'] as String? ?? '',
      description: json['description'] as String? ?? '',
      locationName: json['locationName'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      cityId: json['cityId'] as String? ?? '',
      regionId: json['regionId'] as String? ?? '',
      cityName: json['cityName'] as String? ?? '',
      regionName: json['regionName'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      startTime: DateTime.tryParse(json['startTime'] as String? ?? '') ??
          DateTime.now(),
      durationHours: json['durationHours'] as int? ?? 1,
      urgent: json['urgent'] as bool? ?? false,
      status: TaskStatus.fromString(json['status'] as String? ?? 'Open'),
      employerName: json['employerName'] as String? ?? '',
      workerName: json['workerName'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      professionId: entity.professionId,
      professionName: entity.professionName,
      description: entity.description,
      locationName: entity.locationName,
      latitude: entity.latitude,
      longitude: entity.longitude,
      cityId: entity.cityId,
      regionId: entity.regionId,
      cityName: entity.cityName,
      regionName: entity.regionName,
      price: entity.price,
      startTime: entity.startTime,
      durationHours: entity.durationHours,
      urgent: entity.urgent,
      status: entity.status,
      employerName: entity.employerName,
      workerName: entity.workerName,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'professionId': professionId,
        'professionName': professionName,
        'description': description,
        'locationName': locationName,
        'latitude': latitude,
        'longitude': longitude,
        'cityId': cityId,
        'regionId': regionId,
        'cityName': cityName,
        'regionName': regionName,
        'price': price,
        'startTime': startTime.toIso8601String(),
        'durationHours': durationHours,
        'urgent': urgent,
        'status': status.apiValue,
        'employerName': employerName,
        'workerName': workerName,
        'createdAt': createdAt.toIso8601String(),
      };
}
