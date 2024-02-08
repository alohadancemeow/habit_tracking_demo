bool isHabitCompletedTOday(List<DateTime> completedDay) {
  final today = DateTime.now();

  return completedDay.any((date) =>
      date.year == today.year &&
      date.month == today.month &&
      date.day == today.day);
}
