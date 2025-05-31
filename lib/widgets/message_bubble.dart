import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/message.dart';
import '../theme/app_theme.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool showTimestamp;

  const MessageBubble({
    Key? key,
    required this.message,
    this.showTimestamp = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment:
            message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (showTimestamp) ...[
            _buildTimestamp(),
            const SizedBox(height: 4),
          ],
          Row(
            mainAxisAlignment:
                message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!message.isMe) ...[
                _buildAvatar(),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: message.isMe
                      ? AppTheme.sentMessageDecoration
                      : AppTheme.receivedMessageDecoration,
                  child: Text(
                    message.content,
                    style: AppTheme.bodyStyle,
                  ),
                ),
              ),
              if (message.isMe) ...[
                const SizedBox(width: 8),
                _buildAvatar(),
              ],
            ],
          ),
          const SizedBox(height: 4),
          _buildStatus(),
        ],
      ),
    );
  }

  Widget _buildTimestamp() {
    return Text(
      DateFormat('HH:mm').format(message.timestamp),
      style: AppTheme.captionStyle,
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 16,
      backgroundColor: message.isMe ? AppTheme.primaryColor : AppTheme.accentColor,
      child: Text(
        message.isMe ? 'Me' : 'C',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildStatus() {
    if (!message.isMe) return const SizedBox.shrink();

    IconData icon;
    Color color;

    switch (message.status) {
      case MessageStatus.sending:
        icon = Icons.access_time;
        color = AppTheme.secondaryTextColor;
        break;
      case MessageStatus.sent:
        icon = Icons.check;
        color = AppTheme.secondaryTextColor;
        break;
      case MessageStatus.delivered:
        icon = Icons.done_all;
        color = AppTheme.secondaryTextColor;
        break;
      case MessageStatus.read:
        icon = Icons.done_all;
        color = AppTheme.primaryColor;
        break;
      case MessageStatus.error:
        icon = Icons.error_outline;
        color = AppTheme.errorColor;
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
        ),
      ],
    );
  }
} 