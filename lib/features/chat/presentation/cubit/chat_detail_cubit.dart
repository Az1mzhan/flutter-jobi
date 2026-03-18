import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobi/features/chat/domain/entities/chat_entities.dart';
import 'package:jobi/features/chat/domain/repositories/chat_repository.dart';

enum ChatDetailStatus { initial, loading, loaded, sending, error }

class ChatDetailState extends Equatable {
  const ChatDetailState({
    this.status = ChatDetailStatus.initial,
    this.threadId,
    this.messages = const [],
    this.isConnected = false,
    this.message,
  });

  final ChatDetailStatus status;
  final String? threadId;
  final List<ChatMessage> messages;
  final bool isConnected;
  final String? message;

  ChatDetailState copyWith({
    ChatDetailStatus? status,
    String? threadId,
    List<ChatMessage>? messages,
    bool? isConnected,
    String? message,
  }) {
    return ChatDetailState(
      status: status ?? this.status,
      threadId: threadId ?? this.threadId,
      messages: messages ?? this.messages,
      isConnected: isConnected ?? this.isConnected,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, threadId, messages, isConnected, message];
}

class ChatDetailCubit extends Cubit<ChatDetailState> {
  ChatDetailCubit(this._repository) : super(const ChatDetailState());

  final ChatRepository _repository;
  StreamSubscription<ChatMessage>? _subscription;

  Future<void> openThread(String threadId) async {
    await _subscription?.cancel();
    emit(
      ChatDetailState(
        status: ChatDetailStatus.loading,
        threadId: threadId,
      ),
    );
    try {
      final history = await _repository.getMessages(threadId);
      await _repository.connect(threadId);
      _subscription = _repository.incomingMessages(threadId).listen((message) {
        emit(
          state.copyWith(
            status: ChatDetailStatus.loaded,
            messages: [...state.messages, message],
            isConnected: true,
          ),
        );
      });

      emit(
        state.copyWith(
          status: ChatDetailStatus.loaded,
          messages: history,
          isConnected: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ChatDetailStatus.error,
          message: 'Не удалось открыть этот диалог.',
        ),
      );
    }
  }

  Future<void> sendText(String text) async {
    final threadId = state.threadId;
    if (threadId == null || text.trim().isEmpty) return;

    emit(state.copyWith(status: ChatDetailStatus.sending));
    try {
      final message = await _repository.sendText(threadId: threadId, text: text.trim());
      emit(
        state.copyWith(
          status: ChatDetailStatus.loaded,
          messages: [...state.messages, message],
          isConnected: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ChatDetailStatus.error,
          message: 'Не удалось отправить сообщение.',
        ),
      );
    }
  }

  Future<void> sendImagePlaceholder() async {
    final threadId = state.threadId;
    if (threadId == null) return;

    emit(state.copyWith(status: ChatDetailStatus.sending));
    try {
      final message = await _repository.sendImagePlaceholder(threadId: threadId);
      emit(
        state.copyWith(
          status: ChatDetailStatus.loaded,
          messages: [...state.messages, message],
          isConnected: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ChatDetailStatus.error,
          message: 'Не удалось отправить изображение.',
        ),
      );
    }
  }

  Future<void> closeThread() async {
    final threadId = state.threadId;
    await _subscription?.cancel();
    _subscription = null;
    if (threadId != null) {
      await _repository.disconnect(threadId);
    }
    emit(const ChatDetailState());
  }

  @override
  Future<void> close() async {
    await closeThread();
    return super.close();
  }
}
