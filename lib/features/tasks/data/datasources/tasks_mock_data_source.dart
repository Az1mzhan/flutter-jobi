import 'package:jobi/core/constants/app_constants.dart';
import 'package:jobi/core/errors/app_exception.dart';
import 'package:jobi/features/tasks/data/models/task_model.dart';
import 'package:jobi/features/tasks/domain/entities/task.dart';

class TasksMockDataSource {
  TasksMockDataSource()
      : _tasks = [
          TaskModel(
            id: 'task_1',
            professionId: 'painter',
            professionName: 'Painter',
            description: 'Need two painters for urgent apartment repainting.',
            locationName: 'Abylai Khan Avenue 14',
            latitude: 43.238949,
            longitude: 76.889709,
            cityId: 'almaty',
            regionId: 'almaty_region',
            cityName: 'Almaty',
            regionName: 'Almaty Region',
            price: 90000,
            startTime: DateTime.now().add(const Duration(hours: 4)),
            durationHours: 8,
            urgent: true,
            status: TaskStatus.open,
            employerName: 'Khan Stroy LLP',
            workerName: null,
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          TaskModel(
            id: 'task_2',
            professionId: 'loader',
            professionName: 'Loader',
            description: 'Warehouse unloading team needed for morning shift.',
            locationName: 'Seifullin Street 72',
            latitude: 43.2501,
            longitude: 76.9154,
            cityId: 'almaty',
            regionId: 'almaty_region',
            cityName: 'Almaty',
            regionName: 'Almaty Region',
            price: 45000,
            startTime: DateTime.now().add(const Duration(days: 1)),
            durationHours: 6,
            urgent: false,
            status: TaskStatus.assigned,
            employerName: 'Logistics Hub',
            workerName: 'Dias K.',
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
          TaskModel(
            id: 'task_3',
            professionId: 'electrician',
            professionName: 'Electrician',
            description: 'Office lighting replacement and diagnostics.',
            locationName: 'Satpayev Street 11',
            latitude: 43.231,
            longitude: 76.937,
            cityId: 'almaty',
            regionId: 'almaty_region',
            cityName: 'Almaty',
            regionName: 'Almaty Region',
            price: 120000,
            startTime: DateTime.now().subtract(const Duration(hours: 5)),
            durationHours: 10,
            urgent: false,
            status: TaskStatus.inProgress,
            employerName: 'Office Square',
            workerName: 'Nursultan A.',
            createdAt: DateTime.now().subtract(const Duration(days: 2)),
          ),
          TaskModel(
            id: 'task_4',
            professionId: 'tiler',
            professionName: 'Tiler',
            description: 'Bathroom tile repair in residential unit.',
            locationName: 'Turan Avenue 88',
            latitude: 51.1282,
            longitude: 71.4304,
            cityId: 'astana',
            regionId: 'akmola_region',
            cityName: 'Astana',
            regionName: 'Akmola Region',
            price: 70000,
            startTime: DateTime.now().subtract(const Duration(days: 3)),
            durationHours: 5,
            urgent: false,
            status: TaskStatus.completed,
            employerName: 'Private employer',
            workerName: 'Zhanibek T.',
            createdAt: DateTime.now().subtract(const Duration(days: 5)),
          ),
        ];

  final List<TaskModel> _tasks;

  List<TaskModel> get allTasks => List<TaskModel>.unmodifiable(_tasks);

  Future<List<TaskModel>> getTasks({TaskStatus? status}) async {
    await Future<void>.delayed(AppConstants.mockDelay);
    if (status == null) return List<TaskModel>.from(_tasks);
    return _tasks.where((task) => task.status == status).toList();
  }

  Future<TaskModel> getTaskById(String taskId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _tasks.firstWhere(
      (task) => task.id == taskId,
      orElse: () => throw const AppException('Task not found'),
    );
  }

  Future<TaskModel> createTask(TaskEntity task) async {
    await Future<void>.delayed(AppConstants.mockDelay);
    final model = TaskModel.fromEntity(
      task.copyWith(
        id: 'task_${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
        status: TaskStatus.open,
      ),
    );
    _tasks.insert(0, model);
    return model;
  }

  Future<TaskModel> updateTaskStatus({
    required String taskId,
    required TaskStatus status,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index == -1) throw const AppException('Task not found');

    final updated = TaskModel.fromEntity(
      _tasks[index].copyWith(
        status: status,
        workerName: status == TaskStatus.assigned ? 'Current User' : _tasks[index].workerName,
      ),
    );
    _tasks[index] = updated;
    return updated;
  }
}
