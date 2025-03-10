import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_app/data/database/database.dart';
import 'package:my_app/data/database/providers/database_provider.dart';

class CreateHabitPage extends HookConsumerWidget {
  const CreateHabitPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final isDaily = useState(true);
    final hasReminder = useState(false);
    final reminderTime = useState<TimeOfDay?>(
      const TimeOfDay(hour: 10, minute: 0),
    );

    Future<void> onPressed() async {
      final title = titleController.text;
      final description = descriptionController.text;
      if (title.isEmpty) {
        return;
      }

      final habit = HabitsCompanion.insert(
        title: title,
        description: Value(description),
        isDaily: Value(isDaily.value),
        createdAt: Value(DateTime.now()),
        reminderTime: Value(reminderTime.value?.format(context)),
      );

      await ref.read(databaseProvider).createHabit(habit);
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Create Habit')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Habit Title'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Habit Description'),
            ),
            const SizedBox(height: 16),
            const Text('Goal'),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Daily'),
                Switch(
                  value: isDaily.value,
                  onChanged: (value) => isDaily.value = value,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Reminder'),
            const SizedBox(height: 16),
            SwitchListTile(
              value: hasReminder.value,
              onChanged: (value) {
                hasReminder.value = value;
                if (value) {
                  showTimePicker(
                    context: context,
                    initialTime:
                        reminderTime.value ??
                        const TimeOfDay(hour: 10, minute: 0),
                  ).then((time) {
                    if (time != null) {
                      reminderTime.value = time;
                    }
                  });
                }
              },
              title: const Text('Has Reminder'),
              subtitle:
                  hasReminder.value
                      ? Text(
                        reminderTime.value?.toString() ?? 'No time selected',
                      )
                      : null,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                child: const Text('Create Habit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
