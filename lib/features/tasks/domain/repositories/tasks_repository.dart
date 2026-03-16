import 'package:jobi/features/tasks/domain/entities/task.dart';

abstract class TasksRepository {
  Future<List<TaskEntity>> getTasks({TaskStatus? status});

  Future<TaskEntity> getTaskById(String taskId);

  Future<TaskEntity> createTask(TaskEntity task);

  Future<TaskEntity> updateTaskStatus({
    required String taskId,
    required TaskStatus status,
  });
}
