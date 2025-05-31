import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/conversation.dart';
import '../../models/message.dart';
import '../../repositories/conversation_repository.dart';
import 'conversation_event.dart';
import 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final ConversationRepository _repository;

  ConversationBloc(this._repository) : super(const ConversationInitial()) {
    on<LoadConversations>(_onLoadConversations);
    on<CreateNewConversation>(_onCreateNewConversation);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
  }

  Future<void> _onLoadConversations(
    LoadConversations event,
    Emitter<ConversationState> emit,
  ) async {
    emit(const ConversationLoading());
    try {
      await emit.forEach<List<Conversation>>(
        _repository.conversationsStream,
        onData: (conversations) => ConversationLoaded(conversations),
        onError: (_, __) => const ConversationError('Erreur de chargement'),
      );
    } catch (e) {
      emit(ConversationError(e.toString()));
    }
  }

  Future<void> _onCreateNewConversation(
    CreateNewConversation event,
    Emitter<ConversationState> emit,
  ) async {
    try {
      await _repository.createConversation(
        event.currentUserId,
        event.otherUserId,
      );
    } catch (e) {
      emit(ConversationError(e.toString()));
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ConversationState> emit,
  ) async {
    try {
      await _repository.sendMessage(
        event.conversationId,
        event.senderId,
        event.content,
      );
    } catch (e) {
      emit(ConversationError(e.toString()));
    }
  }

  void _onReceiveMessage(
    ReceiveMessage event,
    Emitter<ConversationState> emit,
  ) {
    // Les mises à jour sont gérées par le stream
  }
} 