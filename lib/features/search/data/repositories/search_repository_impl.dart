import 'package:jobi/core/constants/app_constants.dart';
import 'package:jobi/features/search/data/datasources/search_mock_data_source.dart';
import 'package:jobi/features/search/data/datasources/search_remote_data_source.dart';
import 'package:jobi/features/search/domain/entities/search_entities.dart';
import 'package:jobi/features/search/domain/repositories/search_repository.dart';
import 'package:jobi/features/tasks/domain/entities/task.dart';

class SearchRepositoryImpl implements SearchRepository {
  const SearchRepositoryImpl({
    required this.remoteDataSource,
    required this.mockDataSource,
  });

  final SearchRemoteDataSource remoteDataSource;
  final SearchMockDataSource mockDataSource;

  @override
  Future<SearchPageResult<WorkerSummary>> searchWorkers(SearchFilters filters) {
    return AppConstants.useMockData
        ? mockDataSource.searchWorkers(filters)
        : remoteDataSource.searchWorkers(filters);
  }

  @override
  Future<SearchPageResult<TaskEntity>> searchTasks(SearchFilters filters) {
    return AppConstants.useMockData
        ? mockDataSource.searchTasks(filters)
        : remoteDataSource.searchTasks(filters);
  }
}
