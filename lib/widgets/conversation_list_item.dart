import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/conversation.dart';
import '../models/user.dart';
import '../repositories/conversation_repository.dart';
import '../theme/app_theme.dart';
import '../utils/avatar_utils.dart';

class ConversationListItem extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const ConversationListItem({
    Key? key,
    required this.conversation,
    required this.onTap,
  }) : super(key: key);

  String _getLastMessage() {
    if (conversation.messages.isEmpty) {
      return 'No messages yet';
    }
    return conversation.messages.last.content;
  }

  String _formatTimestamp(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  User _getOtherUser(BuildContext context) {
    final repository = Provider.of<ConversationRepository>(context, listen: false);
    try {
      return repository.allUsers.firstWhere(
        (user) => user.id == conversation.otherUserId,
      );
    } catch (e) {
      // Return a default user if the other user is not found
      return const User(
        id: 'unknown',
        username: 'Unknown User',
        email: 'unknown@example.com',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final otherUser = _getOtherUser(context);
    final lastMessage = conversation.messages.isNotEmpty ? conversation.messages.last : null;
    final isUnread = conversation.unreadCount > 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: isUnread ? 2 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isUnread
            ? BorderSide(color: AppTheme.primaryColor.withOpacity(0.5), width: 1)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AvatarUtils.getRandomColor(otherUser.id),
                    child: ClipOval(
                      child: Image.network(
                        AvatarUtils.getRandomAvatarUrl(otherUser.id),
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Text(
                            AvatarUtils.getInitials(otherUser.username),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  if (isUnread)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text(
                          conversation.unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          otherUser.username,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                            color: isUnread ? Colors.black : Colors.black87,
                          ),
                        ),
                        Text(
                          _formatTimestamp(conversation.lastMessageTime),
                          style: TextStyle(
                            fontSize: 12,
                            color: isUnread ? AppTheme.primaryColor : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _getLastMessage(),
                            style: TextStyle(
                              fontSize: 14,
                              color: isUnread ? Colors.black87 : Colors.grey[600],
                              fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (lastMessage != null && lastMessage.isRead)
                          const Icon(
                            Icons.done_all,
                            size: 16,
                            color: Colors.blue,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 