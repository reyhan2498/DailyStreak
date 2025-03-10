import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_app/data/database/providers/database_provider.dart';

class HabitCard extends HookConsumerWidget {
  const HabitCard({
    super.key,
    required this.title,
    required this.streak,
    required this.progress,
    required this.habitId,
    required this.isCompleted,
    required this.date,
  });

  final String title;
  final int streak;
  final double progress;
  final int habitId;
  final bool isCompleted;
  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    Future<void> onComplete() async {
      await ref.read(databaseProvider).completeHabit(habitId, date);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Habit Completed'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    // Debug prints to check the values
    print('isCompleted: $isCompleted');
    print('colorScheme.primaryContainer: ${colorScheme.primaryContainer}');
    print('colorScheme.surface: ${colorScheme.surface}');

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isCompleted
                ? colorScheme.primaryContainer.withOpacity(0.8)
                : colorScheme.surface.withOpacity(0.1),
            isCompleted
                ? colorScheme.primaryContainer.withOpacity(0.6)
                : colorScheme.surface.withOpacity(0.05),
          ],
        ),
        boxShadow: [BoxShadow(color: colorScheme.shadow, blurRadius: 16)],
      ),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (streak > 0) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text('$streak days'),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient:
                      isCompleted
                          ? LinearGradient(
                            colors: [
                              colorScheme.primary,
                              colorScheme.secondary,
                            ],
                          )
                          : null,
                  color:
                      isCompleted ? colorScheme.surfaceContainerHighest : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onComplete,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        isCompleted
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color:
                            isCompleted
                                ? colorScheme.onPrimary
                                : colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
