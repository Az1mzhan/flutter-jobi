import 'package:jobi/core/constants/api_endpoints.dart';
import 'package:jobi/core/network/api_client.dart';
import 'package:jobi/features/tasks/data/models/task_model.dart';
import 'package:jobi/features/tasks/domain/entities/task.dart';

class TasksRemoteDataSource {
  const TasksRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<TaskModel>> getTasks({TaskStatus? status}) async {
    final response = await _apiClient.get(
      ApiEndpoints.tasks,
      queryParameters: {
        if (status != null) 'status': status.apiValue,
      },
    );

    return (response.data as List<dynamic>)
        .map((item) => TaskModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<TaskModel> getTaskById(String taskId) async {
    final response = await _apiClient.get('${ApiEndpoints.tasks}/$taskId');
    return TaskModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<TaskModel> createTask(TaskEntity task) async {
    final response = await _apiClient.post(
      ApiEndpoints.tasks,
      data: TaskModel.fromEntity(task).toJson(),
    );
    return TaskModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<TaskModel> updateTaskStatus({
    required String taskId,
    required TaskStatus status,
  }) async {
    final response = await _apiClient.put(
      '${ApiEndpoints.tasks}/$taskId',
      data: {'status': status.apiValue},
    );
    return TaskModel.fromJson(response.data as Map<String, dynamic>);
  }
}
