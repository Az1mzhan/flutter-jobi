import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobi/features/chat/domain/entities/chat_entities.dart';
import 'package:jobi/features/chat/domain/repositories/chat_repository.dart';

enum ChatListStatus { initial, loading, loaded, error }

class ChatListState extends Equatable {
  const ChatListState({
    this.status = ChatListStatus.initial,
    this.threads = const [],
    this.message,
  });

  final ChatListStatus status;
  final List<ChatThread> threads;
  final String? message;

  ChatListState copyWith({
    ChatListStatus? status,
    List<ChatThread>? threads,
    String? message,
  }) {
    return ChatListState(
      status: status ?? this.status,
      threads: threads ?? this.threads,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, threads, message];
}

class ChatListCubit extends Cubit<ChatListState> {
  ChatListCubit(this._repository) : super(const ChatListState());

  final ChatRepository _repository;

  Future<void> loadThreads() async {
    emit(state.copyWith(status: ChatListStatus.loading));
    try {
      final threads = await _repository.getThreads();
      emit(ChatListState(status: ChatListStatus.loaded, threads: threads));
    } catch (_) {
      emit(
        state.copyWith(
          status: ChatListStatus.error,
          message: 'Unable to load chats right now.',
        ),
      );
    }
  }
}
