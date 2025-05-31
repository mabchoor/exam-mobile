import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/conversation/conversation_bloc.dart';
import '../blocs/conversation/conversation_event.dart';
import '../models/user.dart';
import '../repositories/conversation_repository.dart';
import '../theme/app_theme.dart';

class AddConversationScreen extends StatelessWidget {
  const AddConversationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repository = context.read<ConversationRepository>();
    final currentUser = (context.read<AuthBloc>().state as AuthAuthenticated).user;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('New Conversation'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: repository.allUsers.length,
        itemBuilder: (context, index) {
          final user = repository.allUsers[index];
          // Don't show current user in the list
          if (user.id == currentUser.id) return const SizedBox.shrink();

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.primaryColor,
                child: Text(
                  user.username[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                user.username,
                style: AppTheme.subheadingStyle,
              ),
              subtitle: Text(
                user.email,
                style: AppTheme.captionStyle,
              ),
              onTap: () {
                final currentUser = (context.read<AuthBloc>().state as AuthAuthenticated).user;
                context.read<ConversationBloc>().add(
                  CreateNewConversation(
                    currentUserId: currentUser.id,
                    otherUserId: user.id,
                  ),
                );
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }
} 