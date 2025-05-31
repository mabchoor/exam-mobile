import 'package:equatable/equatable.dart';
import '../../models/conversation.dart';
import '../../models/message.dart';

abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object?> get props => [];
}

class ConversationInitial extends ConversationState {
  const ConversationInitial();
}

class ConversationLoading extends ConversationState {
  const ConversationLoading();
}

class ConversationLoaded extends ConversationState {
  final List<Conversation> conversations;

  const ConversationLoaded(this.conversations);

  @override
  List<Object?> get props => [conversations];
}

class ConversationError extends ConversationState {
  final String message;

  const ConversationError(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageSending extends ConversationState {
  final String conversationId;
  final Message message;

  const MessageSending({
    required this.conversationId,
    required this.message,
  });

  @override
  List<Object?> get props => [conversationId, message];
}

class MessageSent extends ConversationState {
  final String conversationId;
  final Message message;

  const MessageSent({
    required this.conversationId,
    required this.message,
  });

  @override
  List<Object?> get props => [conversationId, message];
}

class MessageReceived extends ConversationState {
  final String conversationId;
  final Message message;

  const MessageReceived({
    required this.conversationId,
    required this.message,
  });

  @override
  List<Object?> get props => [conversationId, message];
} 