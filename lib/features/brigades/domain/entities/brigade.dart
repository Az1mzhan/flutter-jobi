import 'package:equatable/equatable.dart';

class BrigadeMember extends Equatable {
  const BrigadeMember({
    required this.id,
    required this.fullName,
    required this.role,
  });

  final String id;
  final String fullName;
  final String role;

  @override
  List<Object?> get props => [id, fullName, role];
}

class Brigade extends Equatable {
  const Brigade({
    required this.id,
    required this.name,
    required this.description,
    required this.leaderName,
    required this.rating,
    required this.activeTasks,
    required this.completedTasks,
    required this.members,
  });

  final String id;
  final String name;
  final String description;
  final String leaderName;
  final double rating;
  final int activeTasks;
  final int completedTasks;
  final List<BrigadeMember> members;

  int get memberCount => members.length;

  Brigade copyWith({
    String? name,
    String? description,
    String? leaderName,
    double? rating,
    int? activeTasks,
    int? completedTasks,
    List<BrigadeMember>? members,
  }) {
    return Brigade(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      leaderName: leaderName ?? this.leaderName,
      rating: rating ?? this.rating,
      activeTasks: activeTasks ?? this.activeTasks,
      completedTasks: completedTasks ?? this.completedTasks,
      members: members ?? this.members,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        leaderName,
        rating,
        activeTasks,
        completedTasks,
        members,
      ];
}
