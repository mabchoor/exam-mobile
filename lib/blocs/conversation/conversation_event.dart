import 'package:equatable/equatable.dart';
import '../../models/message.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object?> get props => [];
}

class LoadConversations extends ConversationEvent {}

class CreateNewConversation extends ConversationEvent {
  final String currentUserId;
  final String otherUserId;

  const CreateNewConversation({
    required this.currentUserId,
    required this.otherUserId,
  });

  @override
  List<Object?> get props => [currentUserId, otherUserId];
}

class SendMessage extends ConversationEvent {
  final String conversationId;
  final String senderId;
  final String content;

  const SendMessage({
    required this.conversationId,
    required this.senderId,
    required this.content,
  });

  @override
  List<Object?> get props => [conversationId, senderId, content];
}

class ReceiveMessage extends ConversationEvent {
  final String conversationId;
  final String senderId;
  final String content;

  const ReceiveMessage({
    required this.conversationId,
    required this.senderId,
    required this.content,
  });

  @override
  List<Object?> get props => [conversationId, senderId, content];
}

class AddConversation extends ConversationEvent {
  final String contactId;

  const AddConversation(this.contactId);

  @override
  List<Object?> get props => [contactId];
}

class MarkConversationAsRead extends ConversationEvent {
  final String conversationId;

  const MarkConversationAsRead(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
} 