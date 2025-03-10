import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data/database/providers/daily_summary_provider.dart';
import 'package:my_app/ui/components/daily_summary_card.dart';
import 'package:my_app/ui/components/habit_card_list.dart';
import 'package:my_app/ui/pages/create_habit_page.dart';
import 'components/timeline_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = useState(DateTime.now());
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daily Streak',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TimelineView(
                selectedDate: selectedDate.value,
                onSelectedDateChanged: (date) => selectedDate.value = date,
              ),
              const SizedBox(height: 16),
              ref
                  .watch(dailySummaryProvider(selectedDate.value))
                  .when(
                    data: (data) {
                      return DailySummaryCard(
                        completedTasks: data.$1,
                        totalTasks: data.$2,
                        date: DateFormat(
                          'dd-MM-yyyy',
                        ).format(selectedDate.value),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (error, stack) => Text(error.toString()),
                  ),
              const SizedBox(height: 16),
              const Text('Habits'),
              const SizedBox(height: 16),
              HabitCardList(selectedDate: selectedDate.value),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.2),
              blurRadius: 16,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap:
                () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreateHabitPage(),
                  ),
                ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: const Text('Create Habit'),
            ),
          ),
        ),
      ),
    );
  }
}
