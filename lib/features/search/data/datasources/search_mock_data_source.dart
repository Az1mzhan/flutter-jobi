import 'package:jobi/core/constants/app_constants.dart';
import 'package:jobi/features/search/data/models/search_models.dart';
import 'package:jobi/features/search/domain/entities/search_entities.dart';
import 'package:jobi/features/tasks/data/datasources/tasks_mock_data_source.dart';
import 'package:jobi/features/tasks/domain/entities/task.dart';

class SearchMockDataSource {
  SearchMockDataSource({required TasksMockDataSource tasksMockDataSource})
      : _tasksMockDataSource = tasksMockDataSource,
        _workers = const [
          WorkerSummaryModel(
            id: 'worker_1',
            fullName: 'Айдана К.',
            profession: 'Маляр',
            city: 'Алматы',
            region: 'Алматинская область',
            distanceKm: 1.4,
            rating: 4.8,
            availableNow: true,
            readyToTravel: true,
            completedTasks: 88,
          ),
          WorkerSummaryModel(
            id: 'worker_2',
            fullName: 'Диас Р.',
            profession: 'Грузчик',
            city: 'Алматы',
            region: 'Алматинская область',
            distanceKm: 4.6,
            rating: 4.5,
            availableNow: true,
            readyToTravel: false,
            completedTasks: 57,
          ),
          WorkerSummaryModel(
            id: 'worker_3',
            fullName: 'Жанар Т.',
            profession: 'Электрик',
            city: 'Астана',
            region: 'Акмолинская область',
            distanceKm: 12,
            rating: 4.9,
            availableNow: false,
            readyToTravel: true,
            completedTasks: 132,
          ),
          WorkerSummaryModel(
            id: 'worker_4',
            fullName: 'Максат П.',
            profession: 'Сантехник',
            city: 'Шымкент',
            region: 'Туркестанская область',
            distanceKm: 7.2,
            rating: 4.3,
            availableNow: true,
            readyToTravel: true,
            completedTasks: 39,
          ),
          WorkerSummaryModel(
            id: 'worker_5',
            fullName: 'Бригада Н.',
            profession: 'Бригадир',
            city: 'Алматы',
            region: 'Алматинская область',
            distanceKm: 3.1,
            rating: 4.7,
            availableNow: true,
            readyToTravel: true,
            completedTasks: 204,
          ),
        ];

  final TasksMockDataSource _tasksMockDataSource;
  final List<WorkerSummaryModel> _workers;

  Future<SearchPageResult<WorkerSummary>> searchWorkers(SearchFilters filters) async {
    await Future<void>.delayed(AppConstants.mockDelay);

    final filtered = _workers.where(
      (worker) =>
          (filters.nationwide || filters.city.isEmpty || worker.city == filters.city) &&
          (filters.nationwide ||
              filters.region.isEmpty ||
              worker.region == filters.region) &&
          (filters.profession.isEmpty ||
              worker.profession.toLowerCase().contains(filters.profession.toLowerCase())) &&
          (!filters.availableOnly || worker.availableNow) &&
          (filters.nationwide || worker.distanceKm <= filters.radiusKm),
    );

    final items = _paginate(filtered.toList(), filters.page, filters.pageSize);
    return SearchPageResult<WorkerSummary>(
      items: items,
      hasMore: filtered.length > filters.page * filters.pageSize,
    );
  }

  Future<SearchPageResult<TaskEntity>> searchTasks(SearchFilters filters) async {
    await Future<void>.delayed(AppConstants.mockDelay);

    final base = _tasksMockDataSource.allTasks.where((task) {
      return task.status == TaskStatus.open &&
          (filters.nationwide || filters.city.isEmpty || task.cityName == filters.city) &&
          (filters.nationwide ||
              filters.region.isEmpty ||
              task.regionName == filters.region) &&
          (filters.profession.isEmpty ||
              task.professionName.toLowerCase().contains(filters.profession.toLowerCase()));
    }).toList();

    final items = _paginate(base, filters.page, filters.pageSize);
    return SearchPageResult<TaskEntity>(
      items: items,
      hasMore: base.length > filters.page * filters.pageSize,
    );
  }

  List<T> _paginate<T>(List<T> source, int page, int pageSize) {
    final start = (page - 1) * pageSize;
    final end = start + pageSize > source.length ? source.length : start + pageSize;
    if (start >= source.length) return <T>[];
    return source.sublist(start, end);
  }
}
