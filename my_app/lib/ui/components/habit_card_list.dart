import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_app/data/database/providers/habits_for_date_provider.dart';
import 'package:my_app/ui/components/habit_card.dart';

class HabitCardList extends HookConsumerWidget {
  const HabitCardList({super.key, required this.selectedDate});

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsyncValue = ref.watch(habitsForDateProvider(selectedDate));
    return habitsAsyncValue.when(
      data:
          (habits) => Expanded(
            child: ListView.separated(
              itemCount: habits.isNotEmpty ? habits.length : 0,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                if (index < habits.length) {
                  final habitWithCompletion = habits[index];
                  return HabitCard(
                    title: habitWithCompletion.habit.title,
                    streak: habitWithCompletion.habit.streak,
                    progress: habitWithCompletion.isCompleted ? 1 : 0,
                    habitId: habitWithCompletion.habit.id,
                    isCompleted: habitWithCompletion.isCompleted,
                    date: selectedDate,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text(error.toString())),
    );
  }
}
