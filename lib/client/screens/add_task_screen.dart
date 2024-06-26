import 'package:flutter/material.dart';
import 'package:test/client/widgets/date_field.dart';
import 'package:test/client/widgets/snack_bar.dart';
import 'package:test/client/widgets/text_area.dart';
import 'package:test/client/widgets/text_field.dart';
import 'package:test/server/database/task_repository.dart';
import 'package:test/shared/constants/colors.dart';
import 'package:test/shared/constants/config.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key, required this.userID});
  final String userID;

  @override
  // ignore: library_private_types_in_public_api
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: appBarTextColor,
            onPressed: () {
              Navigator.pop(context);
            },
            iconSize: smallIconSize,
            tooltip: 'Volver',
          ),
          toolbarHeight: appBarHeight,
          centerTitle: true,
          title: const Text(
            'Nueva tarea',
            style: TextStyle(
              fontSize: appBarFontSize,
              color: appBarTextColor,
            ),
          ),
          shape: const Border(
            bottom: BorderSide(
              color: appBarLineColor,
              width: 2.0,
            ),
          ),
        ),
        body: SizedBox(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40.0),
                textField(
                  context,
                  "Título",
                  _titleController,
                ),
                const SizedBox(height: 20.0),
                textArea(context, "Descripción", "Bases no se estudia",
                    _descriptionController),
                const SizedBox(height: 20.0),
                DateField(controller: _dateController),
                const SizedBox(height: 60.0),
                colorButton("Agregar"),
                const SizedBox(height: 40.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget colorButton(String text) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - horizontalScreenPadding,
        height: buttonHeight,
        child: FloatingActionButton(
          onPressed: () {
            if (_titleController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                  snackBar(context, 'La tarea debe tener título', true));
              return;
            }
            TaskRepository().addTask({
              'title': _titleController.text,
              'description': _descriptionController.text,
              'date': _dateController.text,
              'state': false,
              'userID': widget.userID,
            });
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
                snackBar(context, 'Has creado una nueva tarea!', false));
          },
          backgroundColor: accentPurple,
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: buttonFontSize,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
