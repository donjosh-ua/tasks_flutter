import 'package:flutter/material.dart';
import 'package:test/client/widgets/date_field.dart';
import 'package:test/client/widgets/snack_bar.dart';
import 'package:test/client/widgets/text_area.dart';
import 'package:test/client/widgets/text_field.dart';
import 'package:test/server/database/task_repository.dart';
import 'package:test/shared/constants/colors.dart';
import 'package:test/shared/constants/config.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key, required this.task, required this.id});
  final Map<String, dynamic> task;
  final String id;
  @override
  // ignore: library_private_types_in_public_api
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task['title']);
    _descriptionController =
        TextEditingController(text: widget.task['description']);
    _dateController = TextEditingController(text: widget.task['date']);
  }

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
            color: appBarTextColor,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
            iconSize: smallIconSize,
            tooltip: 'Volver',
          ),
          toolbarHeight: appBarHeight,
          centerTitle: true,
          title: const Text(
            'Editar tarea',
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
                textField(context, "Título", _titleController),
                const SizedBox(height: 20.0),
                textArea(context, "Descripción", "", _descriptionController),
                const SizedBox(height: 20.0),
                DateField(controller: _dateController),
                const SizedBox(height: 40.0),
                colorButton(
                  "Guardar",
                  accentPurple,
                  () {
                    if (_titleController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar(
                          context, 'La tarea debe tener título', true));
                      return;
                    }
                    TaskRepository().updateTask(
                      widget.id,
                      {
                        'title': _titleController.text,
                        'description': _descriptionController.text,
                        'date': _dateController.text,
                        'state': widget.task['state'],
                      },
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        snackBar(context, 'Has editado una tarea', false));
                  },
                ),
                const SizedBox(height: 10.0),
                colorButton(
                  "Eliminar",
                  lightRed,
                  () {
                    TaskRepository().deleteTask(widget.id);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        snackBar(context, 'Se ha eliminado una tarea', true));
                  },
                ),
                const SizedBox(height: 40.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget colorButton(String text, Color color, Function onPressed) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - horizontalScreenPadding,
        height: buttonHeight,
        child: FloatingActionButton(
          onPressed: onPressed as void Function()?,
          backgroundColor: color,
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
