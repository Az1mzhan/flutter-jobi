import 'package:jobi/features/brigades/domain/entities/brigade.dart';

class BrigadeModel extends Brigade {
  const BrigadeModel({
    required super.id,
    required super.name,
    required super.description,
    required super.leaderName,
    required super.rating,
    required super.activeTasks,
    required super.completedTasks,
    required super.members,
  });

  factory BrigadeModel.fromJson(Map<String, dynamic> json) {
    return BrigadeModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      leaderName: json['leaderName'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      activeTasks: json['activeTasks'] as int? ?? 0,
      completedTasks: json['completedTasks'] as int? ?? 0,
      members: (json['members'] as List<dynamic>? ?? const <dynamic>[])
          .map(
            (item) => BrigadeMember(
              id: (item as Map<String, dynamic>)['id'] as String,
              fullName: item['fullName'] as String,
              role: item['role'] as String,
            ),
          )
          .toList(),
    );
  }
}
