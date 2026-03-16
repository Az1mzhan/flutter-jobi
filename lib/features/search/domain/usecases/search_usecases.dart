import 'package:jobi/features/search/domain/entities/search_entities.dart';
import 'package:jobi/features/search/domain/repositories/search_repository.dart';
import 'package:jobi/features/tasks/domain/entities/task.dart';

class SearchWorkers {
  const SearchWorkers(this.repository);

  final SearchRepository repository;

  Future<SearchPageResult<WorkerSummary>> call(SearchFilters filters) {
    return repository.searchWorkers(filters);
  }
}

class SearchTasks {
  const SearchTasks(this.repository);

  final SearchRepository repository;

  Future<SearchPageResult<TaskEntity>> call(SearchFilters filters) {
    return repository.searchTasks(filters);
  }
}
