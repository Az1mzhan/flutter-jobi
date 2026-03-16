import 'package:jobi/features/brigades/domain/entities/brigade.dart';

abstract class BrigadesRepository {
  Future<List<Brigade>> getBrigades();

  Future<Brigade> getBrigade(String id);

  Future<Brigade> createBrigade({
    required String name,
    required String description,
    required String leaderName,
  });

  Future<Brigade> addMember({
    required String brigadeId,
    required String fullName,
    required String role,
  });

  Future<Brigade> removeMember({
    required String brigadeId,
    required String memberId,
  });
}
