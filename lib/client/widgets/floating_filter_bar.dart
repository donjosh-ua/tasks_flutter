import 'package:flutter/material.dart';
import 'package:test/shared/constants/colors.dart';

enum FilterBy { all, pending, completed }

class FloatingFilterBar extends StatefulWidget {
  const FloatingFilterBar({super.key, required this.onFilterChanged});
  final Function(String) onFilterChanged;

  @override
  State<FloatingFilterBar> createState() => _FloatingFilterBarState();
}

class _FloatingFilterBarState extends State<FloatingFilterBar> {
  Set<FilterBy> selection = <FilterBy>{FilterBy.all};

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<FilterBy>(
      style: ButtonStyle(
          visualDensity: const VisualDensity(horizontal: -4.0, vertical: -4.0),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          overlayColor: WidgetStateProperty.all<Color>(darkPurple),
          backgroundColor: WidgetStateProperty.all<Color>(accentPurple)),
      segments: const <ButtonSegment<FilterBy>>[
        ButtonSegment<FilterBy>(
          value: FilterBy.all,
          label: Text(
            'Todo',
            style: TextStyle(fontSize: 12.0),
          ),
        ),
        ButtonSegment<FilterBy>(
          value: FilterBy.pending,
          label: Text(
            'Pendiente',
            style: TextStyle(fontSize: 12.0),
          ),
        ),
        ButtonSegment<FilterBy>(
          value: FilterBy.completed,
          label: Text(
            'Hecho',
            style: TextStyle(fontSize: 12.0),
          ),
        ),
      ],
      selected: selection,
      onSelectionChanged: (Set<FilterBy> newSelection) {
        setState(() {
          selection = newSelection;
        });
        widget.onFilterChanged(selection.first.name);
      },
    );
  }
}
