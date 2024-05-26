import 'package:flutter/material.dart';
import 'package:test/shared/constants/colors.dart';
import 'package:test/shared/constants/config.dart';

class TaskCard extends StatelessWidget {
  const TaskCard(
      {super.key,
      required this.onDelete,
      required this.title,
      required this.state,
      required this.description,
      required this.date});
  final String title;
  final bool state;
  final String date;
  final String description;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - smallHorizontalScreenPadding,
      height: cardHeight,
      child: Card(
        elevation: cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        color: lightPurple,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: darkPurple,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      date, // Display the date
                      style: const TextStyle(fontSize: 16, color: darkGray),
                    ),
                    Text(
                      state
                          ? 'Completada'
                          : 'Pendiente', // Display the state of the task
                      style: TextStyle(
                          fontSize: 16, color: state ? lightGreen : lightRed),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onDelete as void Function()?,
                iconSize: 30,
                tooltip: 'Eliminar tarea',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
