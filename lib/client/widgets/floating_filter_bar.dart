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
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          overlayColor: WidgetStateProperty.all<Color>(darkPurple),
          backgroundColor: WidgetStateProperty.all<Color>(accentPurple)),
      segments: const <ButtonSegment<FilterBy>>[
        ButtonSegment<FilterBy>(
          value: FilterBy.all,
          label: Text(
            'Todas',
          ),
        ),
        ButtonSegment<FilterBy>(
          value: FilterBy.pending,
          label: Text(
            'Pendientes',
          ),
        ),
        ButtonSegment<FilterBy>(
          value: FilterBy.completed,
          label: Text(
            'Completadas',
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
