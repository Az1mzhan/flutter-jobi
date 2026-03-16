import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobi/features/brigades/domain/entities/brigade.dart';
import 'package:jobi/features/brigades/domain/repositories/brigades_repository.dart';

enum BrigadesStatus { initial, loading, loaded, saving, error }

class BrigadesState extends Equatable {
  const BrigadesState({
    this.status = BrigadesStatus.initial,
    this.brigades = const [],
    this.selectedBrigade,
    this.message,
  });

  final BrigadesStatus status;
  final List<Brigade> brigades;
  final Brigade? selectedBrigade;
  final String? message;

  BrigadesState copyWith({
    BrigadesStatus? status,
    List<Brigade>? brigades,
    Brigade? selectedBrigade,
    String? message,
  }) {
    return BrigadesState(
      status: status ?? this.status,
      brigades: brigades ?? this.brigades,
      selectedBrigade: selectedBrigade ?? this.selectedBrigade,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, brigades, selectedBrigade, message];
}

class BrigadesCubit extends Cubit<BrigadesState> {
  BrigadesCubit(this._repository) : super(const BrigadesState());

  final BrigadesRepository _repository;

  Future<void> loadBrigades() async {
    emit(state.copyWith(status: BrigadesStatus.loading));
    try {
      final brigades = await _repository.getBrigades();
      emit(BrigadesState(status: BrigadesStatus.loaded, brigades: brigades));
    } catch (_) {
      emit(
        state.copyWith(
          status: BrigadesStatus.error,
          message: 'Unable to load brigades.',
        ),
      );
    }
  }

  Future<void> openBrigade(String brigadeId) async {
    emit(state.copyWith(status: BrigadesStatus.loading));
    try {
      final brigade = await _repository.getBrigade(brigadeId);
      emit(
        state.copyWith(
          status: BrigadesStatus.loaded,
          selectedBrigade: brigade,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: BrigadesStatus.error,
          message: 'Unable to load brigade details.',
        ),
      );
    }
  }

  Future<Brigade?> createBrigade({
    required String name,
    required String description,
    required String leaderName,
  }) async {
    emit(state.copyWith(status: BrigadesStatus.saving));
    try {
      final brigade = await _repository.createBrigade(
        name: name,
        description: description,
        leaderName: leaderName,
      );
      emit(
        state.copyWith(
          status: BrigadesStatus.loaded,
          brigades: [brigade, ...state.brigades],
          selectedBrigade: brigade,
        ),
      );
      return brigade;
    } catch (_) {
      emit(
        state.copyWith(
          status: BrigadesStatus.error,
          message: 'Unable to create brigade.',
        ),
      );
      return null;
    }
  }

  Future<void> addMember({
    required String brigadeId,
    required String fullName,
    required String role,
  }) async {
    emit(state.copyWith(status: BrigadesStatus.saving));
    try {
      final updated = await _repository.addMember(
        brigadeId: brigadeId,
        fullName: fullName,
        role: role,
      );
      _mergeUpdatedBrigade(updated);
    } catch (_) {
      emit(
        state.copyWith(
          status: BrigadesStatus.error,
          message: 'Unable to add member.',
        ),
      );
    }
  }

  Future<void> removeMember({
    required String brigadeId,
    required String memberId,
  }) async {
    emit(state.copyWith(status: BrigadesStatus.saving));
    try {
      final updated = await _repository.removeMember(
        brigadeId: brigadeId,
        memberId: memberId,
      );
      _mergeUpdatedBrigade(updated);
    } catch (_) {
      emit(
        state.copyWith(
          status: BrigadesStatus.error,
          message: 'Unable to remove member.',
        ),
      );
    }
  }

  void _mergeUpdatedBrigade(Brigade updated) {
    final brigades = state.brigades
        .map((brigade) => brigade.id == updated.id ? updated : brigade)
        .toList(growable: false);
    emit(
      state.copyWith(
        status: BrigadesStatus.loaded,
        brigades: brigades,
        selectedBrigade: updated,
      ),
    );
  }
}
