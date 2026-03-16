import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobi/core/errors/app_exception.dart';
import 'package:jobi/features/search/domain/entities/search_entities.dart';
import 'package:jobi/features/search/domain/repositories/search_repository.dart';
import 'package:jobi/features/tasks/domain/entities/task.dart';

enum SearchStatus { initial, loading, loaded, loadingMore, error }

class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.mode = SearchMode.workers,
    this.filters = const SearchFilters(),
    this.workers = const [],
    this.tasks = const [],
    this.hasMore = true,
    this.message,
  });

  final SearchStatus status;
  final SearchMode mode;
  final SearchFilters filters;
  final List<WorkerSummary> workers;
  final List<TaskEntity> tasks;
  final bool hasMore;
  final String? message;

  SearchState copyWith({
    SearchStatus? status,
    SearchMode? mode,
    SearchFilters? filters,
    List<WorkerSummary>? workers,
    List<TaskEntity>? tasks,
    bool? hasMore,
    String? message,
  }) {
    return SearchState(
      status: status ?? this.status,
      mode: mode ?? this.mode,
      filters: filters ?? this.filters,
      workers: workers ?? this.workers,
      tasks: tasks ?? this.tasks,
      hasMore: hasMore ?? this.hasMore,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, mode, filters, workers, tasks, hasMore, message];
}

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._repository) : super(const SearchState());

  final SearchRepository _repository;

  Future<void> load({bool reset = true}) async {
    final nextFilters = reset ? state.filters.copyWith(page: 1) : state.filters;
    emit(
      state.copyWith(
        status: reset ? SearchStatus.loading : SearchStatus.loadingMore,
        filters: nextFilters,
      ),
    );

    try {
      if (state.mode == SearchMode.workers) {
        final result = await _repository.searchWorkers(nextFilters);
        emit(
          state.copyWith(
            status: SearchStatus.loaded,
            filters: nextFilters,
            workers: reset ? result.items : [...state.workers, ...result.items],
            hasMore: result.hasMore,
          ),
        );
      } else {
        final result = await _repository.searchTasks(nextFilters);
        emit(
          state.copyWith(
            status: SearchStatus.loaded,
            filters: nextFilters,
            tasks: reset ? result.items : [...state.tasks, ...result.items],
            hasMore: result.hasMore,
          ),
        );
      }
    } on AppException catch (error) {
      emit(state.copyWith(status: SearchStatus.error, message: error.message));
    } catch (_) {
      emit(
        state.copyWith(
          status: SearchStatus.error,
          message: 'Unable to perform search right now.',
        ),
      );
    }
  }

  Future<void> switchMode(SearchMode mode) async {
    emit(
      state.copyWith(
        mode: mode,
        filters: state.filters.copyWith(page: 1),
        workers: const [],
        tasks: const [],
        hasMore: true,
      ),
    );
    await load();
  }

  Future<void> applyFilters(SearchFilters filters) async {
    emit(
      state.copyWith(
        filters: filters.copyWith(page: 1),
        workers: const [],
        tasks: const [],
        hasMore: true,
      ),
    );
    await load();
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.status == SearchStatus.loadingMore) return;
    final nextFilters = state.filters.copyWith(page: state.filters.page + 1);
    emit(
      state.copyWith(
        status: SearchStatus.loadingMore,
        filters: nextFilters,
      ),
    );

    try {
      if (state.mode == SearchMode.workers) {
        final result = await _repository.searchWorkers(nextFilters);
        emit(
          state.copyWith(
            status: SearchStatus.loaded,
            filters: nextFilters,
            workers: [...state.workers, ...result.items],
            hasMore: result.hasMore,
          ),
        );
      } else {
        final result = await _repository.searchTasks(nextFilters);
        emit(
          state.copyWith(
            status: SearchStatus.loaded,
            filters: nextFilters,
            tasks: [...state.tasks, ...result.items],
            hasMore: result.hasMore,
          ),
        );
      }
    } catch (_) {
      emit(
        state.copyWith(
          status: SearchStatus.error,
          message: 'Unable to load more results.',
        ),
      );
    }
  }
}
