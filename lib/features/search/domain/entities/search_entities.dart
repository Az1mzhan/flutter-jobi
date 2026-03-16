import 'package:equatable/equatable.dart';

enum SearchMode { workers, tasks }

class SearchFilters extends Equatable {
  const SearchFilters({
    this.radiusKm = 10,
    this.city = 'Almaty',
    this.region = '',
    this.district = '',
    this.profession = '',
    this.availableOnly = false,
    this.nationwide = false,
    this.page = 1,
    this.pageSize = 10,
  });

  final double radiusKm;
  final String city;
  final String region;
  final String district;
  final String profession;
  final bool availableOnly;
  final bool nationwide;
  final int page;
  final int pageSize;

  SearchFilters copyWith({
    double? radiusKm,
    String? city,
    String? region,
    String? district,
    String? profession,
    bool? availableOnly,
    bool? nationwide,
    int? page,
    int? pageSize,
  }) {
    return SearchFilters(
      radiusKm: radiusKm ?? this.radiusKm,
      city: city ?? this.city,
      region: region ?? this.region,
      district: district ?? this.district,
      profession: profession ?? this.profession,
      availableOnly: availableOnly ?? this.availableOnly,
      nationwide: nationwide ?? this.nationwide,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  @override
  List<Object?> get props => [
        radiusKm,
        city,
        region,
        district,
        profession,
        availableOnly,
        nationwide,
        page,
        pageSize,
      ];
}

class WorkerSummary extends Equatable {
  const WorkerSummary({
    required this.id,
    required this.fullName,
    required this.profession,
    required this.city,
    required this.region,
    required this.distanceKm,
    required this.rating,
    required this.availableNow,
    required this.readyToTravel,
    required this.completedTasks,
  });

  final String id;
  final String fullName;
  final String profession;
  final String city;
  final String region;
  final double distanceKm;
  final double rating;
  final bool availableNow;
  final bool readyToTravel;
  final int completedTasks;

  @override
  List<Object?> get props => [
        id,
        fullName,
        profession,
        city,
        region,
        distanceKm,
        rating,
        availableNow,
        readyToTravel,
        completedTasks,
      ];
}

class SearchPageResult<T> extends Equatable {
  const SearchPageResult({
    required this.items,
    required this.hasMore,
  });

  final List<T> items;
  final bool hasMore;

  @override
  List<Object?> get props => [items, hasMore];
}
