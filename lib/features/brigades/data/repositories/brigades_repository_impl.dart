import 'package:jobi/core/constants/app_constants.dart';
import 'package:jobi/features/brigades/data/datasources/brigades_mock_data_source.dart';
import 'package:jobi/features/brigades/data/datasources/brigades_remote_data_source.dart';
import 'package:jobi/features/brigades/domain/entities/brigade.dart';
import 'package:jobi/features/brigades/domain/repositories/brigades_repository.dart';

class BrigadesRepositoryImpl implements BrigadesRepository {
  const BrigadesRepositoryImpl({
    required this.remoteDataSource,
    required this.mockDataSource,
  });

  final BrigadesRemoteDataSource remoteDataSource;
  final BrigadesMockDataSource mockDataSource;

  @override
  Future<List<Brigade>> getBrigades() {
    return AppConstants.useMockData
        ? mockDataSource.getBrigades()
        : remoteDataSource.getBrigades();
  }

  @override
  Future<Brigade> getBrigade(String id) {
    return AppConstants.useMockData
        ? mockDataSource.getBrigade(id)
        : remoteDataSource.getBrigade(id);
  }

  @override
  Future<Brigade> createBrigade({
    required String name,
    required String description,
    required String leaderName,
  }) {
    return mockDataSource.createBrigade(
      name: name,
      description: description,
      leaderName: leaderName,
    );
  }

  @override
  Future<Brigade> addMember({
    required String brigadeId,
    required String fullName,
    required String role,
  }) {
    return mockDataSource.addMember(
      brigadeId: brigadeId,
      fullName: fullName,
      role: role,
    );
  }

  @override
  Future<Brigade> removeMember({
    required String brigadeId,
    required String memberId,
  }) {
    return mockDataSource.removeMember(brigadeId: brigadeId, memberId: memberId);
  }
}
