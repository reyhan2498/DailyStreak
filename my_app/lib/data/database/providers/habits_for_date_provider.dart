import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_app/data/database/database.dart';
import 'package:my_app/data/database/providers/database_provider.dart';

final habitsForDateProvider =
    StreamProvider.family<List<HabitWithCompletion>, DateTime>((ref, date) {
      final database = ref.watch(databaseProvider);
      return database.watchHabitsForDate(date);
    });
