import 'dart:async';
import '../models/conversation.dart';
import '../models/message.dart';
import '../models/user.dart';
import 'user_repository.dart';

class ConversationRepository {
  final UserRepository _userRepository;
  final Map<String, List<Conversation>> _conversations = {};
  final _conversationController = StreamController<List<Conversation>>.broadcast();

  Stream<List<Conversation>> get conversationsStream => _conversationController.stream;

  List<User> get allUsers => _userRepository.getUsers();

  ConversationRepository(this._userRepository) {
    initializeMockData();
  }

  void initializeMockData() {
    // Initialize empty conversations for each user
    for (var user in allUsers) {
      _conversations[user.id] = [];
    }
  }

  List<Conversation> getConversations(String userId) {
    return _conversations[userId] ?? [];
  }

  Future<Conversation> createConversation(String currentUserId, String otherUserId) async {
    // Check if conversation already exists for current user
    final existingConversation = _conversations[currentUserId]?.firstWhere(
      (conv) => conv.otherUserId == otherUserId,
      orElse: () => Conversation(
        id: '',
        currentUserId: currentUserId,
        otherUserId: otherUserId,
        messages: [],
        lastMessageTime: DateTime.now(),
      ),
    );

    if (existingConversation?.id.isNotEmpty ?? false) {
      return existingConversation!;
    }

    // Create new conversation
    final newConversation = Conversation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      currentUserId: currentUserId,
      otherUserId: otherUserId,
      messages: [],
      lastMessageTime: DateTime.now(),
    );

    // Create reverse conversation for the other user
    final reverseConversation = Conversation(
      id: newConversation.id,
      currentUserId: otherUserId,
      otherUserId: currentUserId,
      messages: [],
      lastMessageTime: newConversation.lastMessageTime,
    );

    // Add conversations to both users while preserving existing ones
    _conversations[currentUserId] = [
      ...(_conversations[currentUserId] ?? []),
      newConversation,
    ];
    _conversations[otherUserId] = [
      ...(_conversations[otherUserId] ?? []),
      reverseConversation,
    ];

    // Notify both users about the new conversation
    _notifyConversationUpdate(currentUserId);
    _notifyConversationUpdate(otherUserId);

    return newConversation;
  }

  Future<Message> sendMessage(String conversationId, String senderId, String content) async {
    final conversation = _findConversation(conversationId);
    if (conversation == null) {
      throw Exception('Conversation not found');
    }

    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: conversationId,
      senderId: senderId,
      content: content,
      timestamp: DateTime.now(),
      isRead: false,
    );

    // Update conversation for both users
    final updatedConversation = conversation.copyWith(
      messages: [...conversation.messages, message],
      lastMessageTime: message.timestamp,
    );

    // Create reverse conversation update
    final reverseConversation = Conversation(
      id: updatedConversation.id,
      currentUserId: updatedConversation.otherUserId,
      otherUserId: updatedConversation.currentUserId,
      messages: updatedConversation.messages,
      lastMessageTime: updatedConversation.lastMessageTime,
      unreadCount: updatedConversation.unreadCount + 1,
    );

    // Update conversations while preserving others
    _updateConversation(updatedConversation);
    _updateConversation(reverseConversation);

    _notifyConversationUpdate(conversation.currentUserId);
    _notifyConversationUpdate(conversation.otherUserId);

    return message;
  }

  void _updateConversation(Conversation updatedConversation) {
    final currentUserId = updatedConversation.currentUserId;
    final otherUserId = updatedConversation.otherUserId;

    // Update current user's conversations
    if (_conversations.containsKey(currentUserId)) {
      _conversations[currentUserId] = _conversations[currentUserId]!.map((conv) {
        return conv.id == updatedConversation.id ? updatedConversation : conv;
      }).toList();
    }

    // Update other user's conversations
    if (_conversations.containsKey(otherUserId)) {
      _conversations[otherUserId] = _conversations[otherUserId]!.map((conv) {
        return conv.id == updatedConversation.id ? updatedConversation : conv;
      }).toList();
    }
  }

  Conversation? _findConversation(String conversationId) {
    for (var userConversations in _conversations.values) {
      final conversation = userConversations.firstWhere(
        (conv) => conv.id == conversationId,
        orElse: () => Conversation(
          id: '',
          currentUserId: '',
          otherUserId: '',
          messages: [],
          lastMessageTime: DateTime.now(),
        ),
      );
      if (conversation.id.isNotEmpty) return conversation;
    }
    return null;
  }

  void _notifyConversationUpdate(String userId) {
    final conversations = _conversations[userId] ?? [];
    _conversationController.add(conversations);
  }

  void dispose() {
    _conversationController.close();
  }
} 