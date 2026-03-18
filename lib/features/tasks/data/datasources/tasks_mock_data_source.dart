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
            professionName: 'Маляр',
            description: 'Нужны два маляра для срочной покраски квартиры.',
            locationName: 'пр. Абылай хана, 14',
            latitude: 43.238949,
            longitude: 76.889709,
            cityId: 'almaty',
            regionId: 'almaty_region',
            cityName: 'Алматы',
            regionName: 'Алматинская область',
            price: 90000,
            startTime: DateTime.now().add(const Duration(hours: 4)),
            durationHours: 8,
            urgent: true,
            status: TaskStatus.open,
            employerName: 'Хан Строй',
            workerName: null,
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          TaskModel(
            id: 'task_2',
            professionId: 'loader',
            professionName: 'Грузчик',
            description: 'Нужна команда для разгрузки склада в утреннюю смену.',
            locationName: 'ул. Сейфуллина, 72',
            latitude: 43.2501,
            longitude: 76.9154,
            cityId: 'almaty',
            regionId: 'almaty_region',
            cityName: 'Алматы',
            regionName: 'Алматинская область',
            price: 45000,
            startTime: DateTime.now().add(const Duration(days: 1)),
            durationHours: 6,
            urgent: false,
            status: TaskStatus.assigned,
            employerName: 'Логистический хаб',
            workerName: 'Диас К.',
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
          TaskModel(
            id: 'task_3',
            professionId: 'electrician',
            professionName: 'Электрик',
            description: 'Замена офисного освещения и диагностика сети.',
            locationName: 'ул. Сатпаева, 11',
            latitude: 43.231,
            longitude: 76.937,
            cityId: 'almaty',
            regionId: 'almaty_region',
            cityName: 'Алматы',
            regionName: 'Алматинская область',
            price: 120000,
            startTime: DateTime.now().subtract(const Duration(hours: 5)),
            durationHours: 10,
            urgent: false,
            status: TaskStatus.inProgress,
            employerName: 'Офис Сквер',
            workerName: 'Нурсултан А.',
            createdAt: DateTime.now().subtract(const Duration(days: 2)),
          ),
          TaskModel(
            id: 'task_4',
            professionId: 'tiler',
            professionName: 'Плиточник',
            description: 'Ремонт плитки в ванной в жилом помещении.',
            locationName: 'пр. Туран, 88',
            latitude: 51.1282,
            longitude: 71.4304,
            cityId: 'astana',
            regionId: 'akmola_region',
            cityName: 'Астана',
            regionName: 'Акмолинская область',
            price: 70000,
            startTime: DateTime.now().subtract(const Duration(days: 3)),
            durationHours: 5,
            urgent: false,
            status: TaskStatus.completed,
            employerName: 'Частный работодатель',
            workerName: 'Жанибек Т.',
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
      orElse: () => throw const AppException('Задача не найдена'),
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
    if (index == -1) throw const AppException('Задача не найдена');

    final updated = TaskModel.fromEntity(
      _tasks[index].copyWith(
        status: status,
        workerName: status == TaskStatus.assigned ? 'Текущий пользователь' : _tasks[index].workerName,
      ),
    );
    _tasks[index] = updated;
    return updated;
  }
}
