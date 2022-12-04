import 'package:flutter/material.dart';
import '../db/notes_database.dart';
import '../models/notes_model.dart';
import 'package:easy_localization/easy_localization.dart';
import '../constans.dart';

class AddEditeNote extends StatefulWidget {
  final Note? notes;
  const AddEditeNote({super.key, this.notes});

  @override
  State<AddEditeNote> createState() => _AddEditeNoteState();
}

class _AddEditeNoteState extends State<AddEditeNote> {
  late String title;
  late String description;

  bool saveVisible = false;

  @override
  void initState() {
    title = widget.notes?.title ?? '';
    description = widget.notes?.description ?? '';
    super.initState();
  }

  void save() async {
    final navigator = Navigator.of(context);

    if (widget.notes?.title == null) {
      final note = Note(
        title: title,
        description: description,
      );
      await NotesDatabase.instanc.creatNote(note);
      navigator.pop();
    } else {
      final note = Note(
        id: widget.notes!.id,
        title: title,
        description: description,
      );
      await NotesDatabase.instanc.updateNote(note);
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor[100],
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: backgroundColor[100],
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        foregroundColor: Colors.black,
        title: widget.notes?.title == null
            ? Text(
                'AddAppBarTitle'.tr(),
              )
            : Text('EditeAppBarTitle'.tr()),
        titleTextStyle: const TextStyle(
          fontSize: 25,
          color: Colors.black,
        ),
        actions: [
          Visibility(
            visible: saveVisible,
            child: IconButton(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
              ),
              onPressed: () {
                save();
              },
              icon: Icon(
                Icons.check_outlined,
                color: primaryColor[800],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                initialValue: title,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title'.tr(),
                  hintStyle: const TextStyle(
                    fontSize: 30,
                    color: backgroundColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onChanged: (String title) {
                  setState(
                    () {
                      if (title == '' && description == '') {
                        saveVisible = false;
                      } else {
                        saveVisible = true;
                      }
                      this.title = title;
                    },
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                initialValue: description,
                style: const TextStyle(
                  fontSize: 22,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Description'.tr(),
                  hintStyle: const TextStyle(
                    fontSize: 20,
                    color: backgroundColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                maxLines: null,
                minLines: null,
                onChanged: (String description) {
                  setState(
                    () {
                      if (description == '' && title == '') {
                        saveVisible = false;
                      } else {
                        saveVisible = true;
                      }
                      this.description = description;
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
