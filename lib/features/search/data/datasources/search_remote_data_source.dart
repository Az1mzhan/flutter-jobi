import 'package:jobi/core/constants/api_endpoints.dart';
import 'package:jobi/core/network/api_client.dart';
import 'package:jobi/features/search/data/models/search_models.dart';
import 'package:jobi/features/search/domain/entities/search_entities.dart';
import 'package:jobi/features/tasks/data/models/task_model.dart';
import 'package:jobi/features/tasks/domain/entities/task.dart';

class SearchRemoteDataSource {
  const SearchRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<SearchPageResult<WorkerSummary>> searchWorkers(SearchFilters filters) async {
    final response = await _apiClient.get(
      ApiEndpoints.searchWorkers,
      queryParameters: {
        'radiusKm': filters.radiusKm,
        'city': filters.city,
        'region': filters.region,
        'district': filters.district,
        'profession': filters.profession,
        'availableOnly': filters.availableOnly,
        'nationwide': filters.nationwide,
        'page': filters.page,
        'pageSize': filters.pageSize,
      },
    );

    final payload = response.data as Map<String, dynamic>;
    final items = (payload['items'] as List<dynamic>)
        .map((item) => WorkerSummaryModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return SearchPageResult<WorkerSummary>(
      items: items,
      hasMore: payload['hasMore'] as bool? ?? false,
    );
  }

  Future<SearchPageResult<TaskEntity>> searchTasks(SearchFilters filters) async {
    final response = await _apiClient.get(
      ApiEndpoints.searchTasks,
      queryParameters: {
        'radiusKm': filters.radiusKm,
        'city': filters.city,
        'region': filters.region,
        'district': filters.district,
        'profession': filters.profession,
        'page': filters.page,
        'pageSize': filters.pageSize,
      },
    );

    final payload = response.data as Map<String, dynamic>;
    final items = (payload['items'] as List<dynamic>)
        .map((item) => TaskModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return SearchPageResult<TaskEntity>(
      items: items,
      hasMore: payload['hasMore'] as bool? ?? false,
    );
  }
}
