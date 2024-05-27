import 'package:flutter/material.dart';
import 'package:test/shared/constants/colors.dart';
import 'package:test/shared/constants/config.dart';

class DateField extends StatefulWidget {
  final TextEditingController controller;
  const DateField({required this.controller, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DateFieldState createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.controller.text.isNotEmpty) {
      try {
        DateTime controllerDate = DateTime.parse(widget.controller.text);
        if (controllerDate != selectedDate) {
          selectedDate = controllerDate;
        }
      } catch (e) {
        // just do nothing if the date is not valid
      }
    }
    widget.controller.text = "${selectedDate.toLocal()}"
        .split(' ')[0]; // Initialize the controller with the current date
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer initial date to the current date
      firstDate: DateTime(2000), // Prior date user can select
      lastDate: DateTime(2025), // Further date user can select
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.controller.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(roundLabelRadius),
      onTap: () =>
          _selectDate(context), // Call Function that has showDatePicker()
      splashColor: accentPurple,
      child: Stack(
        children: <Widget>[
          Container(
            height: 70.0,
            width: MediaQuery.of(context).size.width - horizontalScreenPadding,
            decoration: BoxDecoration(
              color: lightPurple,
              borderRadius: BorderRadius.circular(roundLabelRadius),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "${selectedDate.toLocal()}".split(' ')[0],
                  style: const TextStyle(
                    color: darkGray,
                    fontSize: normalFontSize,
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            right: 30,
            top: 25,
            child: Center(
                child: Icon(Icons.calendar_today,
                    color: darkGray)), // Add this line
          ),
        ],
      ),
    );
  }
}
