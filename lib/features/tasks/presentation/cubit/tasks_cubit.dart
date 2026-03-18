import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobi/core/errors/app_exception.dart';
import 'package:jobi/features/tasks/domain/entities/task.dart';
import 'package:jobi/features/tasks/domain/repositories/tasks_repository.dart';

enum TasksStatus { initial, loading, loaded, saving, error }

const _taskStateSentinel = Object();

class TasksState extends Equatable {
  const TasksState({
    this.status = TasksStatus.initial,
    this.tasks = const [],
    this.selectedTask,
    this.filter,
    this.message,
  });

  final TasksStatus status;
  final List<TaskEntity> tasks;
  final TaskEntity? selectedTask;
  final TaskStatus? filter;
  final String? message;

  TasksState copyWith({
    TasksStatus? status,
    List<TaskEntity>? tasks,
    Object? selectedTask = _taskStateSentinel,
    Object? filter = _taskStateSentinel,
    String? message,
    bool clearSelectedTask = false,
  }) {
    return TasksState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      selectedTask: clearSelectedTask
          ? null
          : (selectedTask == _taskStateSentinel
              ? this.selectedTask
              : selectedTask as TaskEntity?),
      filter: filter == _taskStateSentinel ? this.filter : filter as TaskStatus?,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, tasks, selectedTask, filter, message];
}

class TasksCubit extends Cubit<TasksState> {
  TasksCubit(this._repository) : super(const TasksState());

  final TasksRepository _repository;

  Future<void> loadTasks({
    TaskStatus? filter,
    bool clearFilter = false,
  }) async {
    final nextFilter = clearFilter ? null : (filter ?? state.filter);
    emit(
      state.copyWith(
        status: TasksStatus.loading,
        filter: nextFilter,
      ),
    );
    try {
      final tasks = await _repository.getTasks(status: nextFilter);
      emit(
        state.copyWith(
          status: TasksStatus.loaded,
          tasks: tasks,
          filter: nextFilter,
        ),
      );
    } on AppException catch (error) {
      emit(state.copyWith(status: TasksStatus.error, message: error.message));
    } catch (_) {
      emit(
        state.copyWith(
          status: TasksStatus.error,
          message: 'Сейчас не удается загрузить задачи.',
        ),
      );
    }
  }

  Future<void> openTask(String taskId) async {
    emit(state.copyWith(status: TasksStatus.loading, clearSelectedTask: true));
    try {
      final task = await _repository.getTaskById(taskId);
      emit(state.copyWith(status: TasksStatus.loaded, selectedTask: task));
    } catch (_) {
      emit(
        state.copyWith(
          status: TasksStatus.error,
          message: 'Не удалось загрузить детали задачи.',
        ),
      );
    }
  }

  Future<TaskEntity?> createTask(TaskEntity task) async {
    emit(state.copyWith(status: TasksStatus.saving));
    try {
      final created = await _repository.createTask(task);
      final updatedTasks = [created, ...state.tasks];
      emit(
        state.copyWith(
          status: TasksStatus.loaded,
          tasks: updatedTasks,
          selectedTask: created,
        ),
      );
      return created;
    } on AppException catch (error) {
      emit(state.copyWith(status: TasksStatus.error, message: error.message));
      return null;
    } catch (_) {
      emit(
        state.copyWith(
          status: TasksStatus.error,
          message: 'Не удалось создать задачу.',
        ),
      );
      return null;
    }
  }

  Future<void> changeStatus({
    required String taskId,
    required TaskStatus status,
  }) async {
    emit(state.copyWith(status: TasksStatus.saving));
    try {
      final updated = await _repository.updateTaskStatus(taskId: taskId, status: status);
      final nextTasks = state.tasks
          .map((task) => task.id == taskId ? updated : task)
          .toList(growable: false);
      emit(
        state.copyWith(
          status: TasksStatus.loaded,
          tasks: nextTasks,
          selectedTask: updated,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: TasksStatus.error,
          message: 'Не удалось обновить статус задачи.',
        ),
      );
    }
  }
}
