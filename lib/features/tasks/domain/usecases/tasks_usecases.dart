import 'package:jobi/features/tasks/domain/entities/task.dart';
import 'package:jobi/features/tasks/domain/repositories/tasks_repository.dart';

class GetTasks {
  const GetTasks(this.repository);

  final TasksRepository repository;

  Future<List<TaskEntity>> call({TaskStatus? status}) {
    return repository.getTasks(status: status);
  }
}

class CreateTask {
  const CreateTask(this.repository);

  final TasksRepository repository;

  Future<TaskEntity> call(TaskEntity task) => repository.createTask(task);
}
