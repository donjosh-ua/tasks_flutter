import 'dart:ffi';

class Task {
  final Short id;
  final String title;
  final String description;
  final DateTime date;
  final bool state;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.state,
  });
}
