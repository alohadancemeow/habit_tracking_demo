import 'package:flutter/material.dart';

class MyHabitTile extends StatelessWidget {
  final String text;
  final bool isCompleted;
  final void Function(bool?)? onChnaged;

  const MyHabitTile({
    super.key,
    required this.text,
    required this.isCompleted,
    required this.onChnaged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isCompleted
            ? Colors.green
            : Theme.of(context).colorScheme.secondary,
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: ListTile(
        title: Text(text),
        leading: Checkbox(
          activeColor: Colors.green,
          value: isCompleted,
          onChanged: onChnaged,
        ),
      ),
    );
  }
}
