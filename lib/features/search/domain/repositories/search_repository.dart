import 'package:jobi/features/search/domain/entities/search_entities.dart';
import 'package:jobi/features/tasks/domain/entities/task.dart';

abstract class SearchRepository {
  Future<SearchPageResult<WorkerSummary>> searchWorkers(SearchFilters filters);

  Future<SearchPageResult<TaskEntity>> searchTasks(SearchFilters filters);
}
