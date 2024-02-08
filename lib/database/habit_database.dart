import 'package:flutter/material.dart';
import 'package:habit_tracking_demo/models/app_settings.dart';
import 'package:habit_tracking_demo/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  // Open Isar instance
  static Future<void> innitialize() async {
    final dir = await getApplicationCacheDirectory();
    isar = await Isar.open(
      [HabitSchema, AppSettingsSchema],
      directory: dir.path,
    );
  }

  // Save first date of app startup (for heatmap)
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();

    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunceDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // Get first date of app startup (for heatmap)
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunceDate;
  }

  // list of habits
  final List<Habit> currentHabits = [];

  // # Create habit
  Future<void> addHabit(String habitname) async {
    // create new habit
    final newHabit = Habit()..name = habitname;

    // save to database
    await isar.writeTxn(() => isar.habits.put(newHabit));

    // re-read from database
    readHabit();
  }

  // Read
  Future<void> readHabit() async {
    // fetch all habits from db
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    // give to current habits
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    // update ui
    notifyListeners();
  }

  // UPDATE - check habit on and off
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    // find the specific habit
    final habit = await isar.habits.get(id);

    // update completion stutas
    if (habit != null) {
      await isar.writeTxn(() async {
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          final today = DateTime.now();

          habit.completedDays.add(DateTime(
            today.year,
            today.month,
            today.day,
          ));
        } else {
          habit.completedDays.removeWhere(
            (date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day,
          );
        }
        // save the updated habits back to the db
        await isar.habits.put(habit);
      });
    }

    // re-read from db
    readHabit();
  }

  // UPDATE - edit habit name
  Future<void> updateHabitName(int id, String newName) async {
    final habit = await isar.habits.get(id);

    if (habit != null) {
      await isar.writeTxn(() async {
        habit.name = newName;
        await isar.habits.put(habit);
      });
    }
    readHabit();
  }

  // DELETE
  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });

    readHabit();
  }
}
