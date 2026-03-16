import 'package:jobi/core/constants/app_constants.dart';
import 'package:jobi/core/errors/app_exception.dart';
import 'package:jobi/features/brigades/data/models/brigade_model.dart';
import 'package:jobi/features/brigades/domain/entities/brigade.dart';

class BrigadesMockDataSource {
  final List<BrigadeModel> _brigades = [
    const BrigadeModel(
      id: 'brigade_1',
      name: 'Fast Finish Crew',
      description: 'Interior finishing brigade for apartments and small offices.',
      leaderName: 'Aidana K.',
      rating: 4.8,
      activeTasks: 3,
      completedTasks: 54,
      members: [
        BrigadeMember(id: 'bm_1', fullName: 'Aidana K.', role: 'Leader'),
        BrigadeMember(id: 'bm_2', fullName: 'Dias R.', role: 'Painter'),
        BrigadeMember(id: 'bm_3', fullName: 'Nursultan A.', role: 'Loader'),
      ],
    ),
  ];

  Future<List<BrigadeModel>> getBrigades() async {
    await Future<void>.delayed(AppConstants.mockDelay);
    return List<BrigadeModel>.from(_brigades);
  }

  Future<BrigadeModel> getBrigade(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _brigades.firstWhere(
      (brigade) => brigade.id == id,
      orElse: () => throw const AppException('Brigade not found'),
    );
  }

  Future<BrigadeModel> createBrigade({
    required String name,
    required String description,
    required String leaderName,
  }) async {
    await Future<void>.delayed(AppConstants.mockDelay);
    final brigade = BrigadeModel(
      id: 'brigade_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      description: description,
      leaderName: leaderName,
      rating: 0,
      activeTasks: 0,
      completedTasks: 0,
      members: [
        BrigadeMember(
          id: 'member_${DateTime.now().millisecondsSinceEpoch}',
          fullName: leaderName,
          role: 'Leader',
        ),
      ],
    );
    _brigades.insert(0, brigade);
    return brigade;
  }

  Future<BrigadeModel> addMember({
    required String brigadeId,
    required String fullName,
    required String role,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final index = _brigades.indexWhere((brigade) => brigade.id == brigadeId);
    if (index == -1) throw const AppException('Brigade not found');
    final brigade = _brigades[index];
    final updated = brigade.copyWith(
      members: [
        ...brigade.members,
        BrigadeMember(
          id: 'member_${DateTime.now().millisecondsSinceEpoch}',
          fullName: fullName,
          role: role,
        ),
      ],
    );
    _brigades[index] = BrigadeModel(
      id: updated.id,
      name: updated.name,
      description: updated.description,
      leaderName: updated.leaderName,
      rating: updated.rating,
      activeTasks: updated.activeTasks,
      completedTasks: updated.completedTasks,
      members: updated.members,
    );
    return _brigades[index];
  }

  Future<BrigadeModel> removeMember({
    required String brigadeId,
    required String memberId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final index = _brigades.indexWhere((brigade) => brigade.id == brigadeId);
    if (index == -1) throw const AppException('Brigade not found');
    final brigade = _brigades[index];
    final updatedMembers =
        brigade.members.where((member) => member.id != memberId).toList();
    _brigades[index] = BrigadeModel(
      id: brigade.id,
      name: brigade.name,
      description: brigade.description,
      leaderName: brigade.leaderName,
      rating: brigade.rating,
      activeTasks: brigade.activeTasks,
      completedTasks: brigade.completedTasks,
      members: updatedMembers,
    );
    return _brigades[index];
  }
}
