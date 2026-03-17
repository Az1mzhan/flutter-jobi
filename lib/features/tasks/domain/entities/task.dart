import 'package:equatable/equatable.dart';

enum TaskStatus {
  open,
  assigned,
  inProgress,
  completed,
  cancelled,
  rejected;

  String get apiValue => switch (this) {
        TaskStatus.open => 'Open',
        TaskStatus.assigned => 'Assigned',
        TaskStatus.inProgress => 'InProgress',
        TaskStatus.completed => 'Completed',
        TaskStatus.cancelled => 'Cancelled',
        TaskStatus.rejected => 'Rejected',
      };

  String get label => switch (this) {
        TaskStatus.open => 'Open',
        TaskStatus.assigned => 'Assigned',
        TaskStatus.inProgress => 'In progress',
        TaskStatus.completed => 'Completed',
        TaskStatus.cancelled => 'Cancelled',
        TaskStatus.rejected => 'Rejected',
      };

  static TaskStatus fromString(String value) {
    return TaskStatus.values.firstWhere(
      (status) => status.apiValue == value,
      orElse: () => TaskStatus.open,
    );
  }
}

class TaskEntity extends Equatable {
  const TaskEntity({
    required this.id,
    required this.professionId,
    required this.professionName,
    required this.description,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.cityId,
    required this.regionId,
    required this.cityName,
    required this.regionName,
    required this.price,
    required this.startTime,
    required this.durationHours,
    required this.urgent,
    required this.status,
    required this.employerName,
    required this.workerName,
    required this.createdAt,
  });

  final String id;
  final String professionId;
  final String professionName;
  final String description;
  final String locationName;
  final double latitude;
  final double longitude;
  final String cityId;
  final String regionId;
  final String cityName;
  final String regionName;
  final double price;
  final DateTime startTime;
  final int durationHours;
  final bool urgent;
  final TaskStatus status;
  final String employerName;
  final String? workerName;
  final DateTime createdAt;

  TaskEntity copyWith({
    String? id,
    String? professionId,
    String? professionName,
    String? description,
    String? locationName,
    double? latitude,
    double? longitude,
    String? cityId,
    String? regionId,
    String? cityName,
    String? regionName,
    double? price,
    DateTime? startTime,
    int? durationHours,
    bool? urgent,
    TaskStatus? status,
    String? employerName,
    String? workerName,
    DateTime? createdAt,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      professionId: professionId ?? this.professionId,
      professionName: professionName ?? this.professionName,
      description: description ?? this.description,
      locationName: locationName ?? this.locationName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      cityId: cityId ?? this.cityId,
      regionId: regionId ?? this.regionId,
      cityName: cityName ?? this.cityName,
      regionName: regionName ?? this.regionName,
      price: price ?? this.price,
      startTime: startTime ?? this.startTime,
      durationHours: durationHours ?? this.durationHours,
      urgent: urgent ?? this.urgent,
      status: status ?? this.status,
      employerName: employerName ?? this.employerName,
      workerName: workerName ?? this.workerName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        professionId,
        professionName,
        description,
        locationName,
        latitude,
        longitude,
        cityId,
        regionId,
        cityName,
        regionName,
        price,
        startTime,
        durationHours,
        urgent,
        status,
        employerName,
        workerName,
        createdAt,
      ];
}
