import 'package:jobi/core/constants/app_constants.dart';
import 'package:jobi/features/tasks/data/datasources/tasks_mock_data_source.dart';
import 'package:jobi/features/tasks/data/datasources/tasks_remote_data_source.dart';
import 'package:jobi/features/tasks/domain/entities/task.dart';
import 'package:jobi/features/tasks/domain/repositories/tasks_repository.dart';

class TasksRepositoryImpl implements TasksRepository {
  const TasksRepositoryImpl({
    required this.remoteDataSource,
    required this.mockDataSource,
  });

  final TasksRemoteDataSource remoteDataSource;
  final TasksMockDataSource mockDataSource;

  @override
  Future<List<TaskEntity>> getTasks({TaskStatus? status}) {
    return AppConstants.useMockData
        ? mockDataSource.getTasks(status: status)
        : remoteDataSource.getTasks(status: status);
  }

  @override
  Future<TaskEntity> getTaskById(String taskId) {
    return AppConstants.useMockData
        ? mockDataSource.getTaskById(taskId)
        : remoteDataSource.getTaskById(taskId);
  }

  @override
  Future<TaskEntity> createTask(TaskEntity task) {
    return AppConstants.useMockData
        ? mockDataSource.createTask(task)
        : remoteDataSource.createTask(task);
  }

  @override
  Future<TaskEntity> updateTaskStatus({
    required String taskId,
    required TaskStatus status,
  }) {
    return AppConstants.useMockData
        ? mockDataSource.updateTaskStatus(taskId: taskId, status: status)
        : remoteDataSource.updateTaskStatus(taskId: taskId, status: status);
  }
}
