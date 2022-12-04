import 'package:flutter/material.dart';
import '../db/notes_database.dart';
import '../models/notes_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'add_edite_note.dart';
import '../constans.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? keyword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: backgroundColor[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent.withOpacity(0),
        elevation: 0,
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Colors.amber,
            ),
            fillColor: backgroundColor[300],
            filled: true,
            hintText: 'search'.tr(),
            hintStyle: const TextStyle(
              color: Colors.black38,
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  40,
                ),
                borderSide: BorderSide.none),
          ),
          onChanged: (value) {
            keyword = value;

            setState(
              () {
                NotesDatabase.instanc.searchInNotes(keyword);
              },
            );
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FutureBuilder(
                  future: NotesDatabase.instanc.searchInNotes(keyword),
                  builder: (context, snapshot) {
                    List<Note>? notes = snapshot.data;
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    return notes!.isEmpty
                        ? Center(
                            child: Text(
                              'Nothing found'.tr(),
                            ),
                          )
                        : ListView.builder(
                            itemCount: notes.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ListTile(
                                    title: Text(
                                      notes[index].title.toString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        notes[index].description.toString(),
                                        maxLines: 5,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddEditeNote(
                                            notes: notes[index],
                                          ),
                                        ),
                                      );
                                      setState(
                                        () {
                                          NotesDatabase.instanc
                                              .searchInNotes(keyword);
                                        },
                                      );
                                    },
                                    onLongPress: () async {
                                      await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Notic'.tr()),
                                            content: Text(
                                              'question'.tr(),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () async {
                                                  final navigator =
                                                      Navigator.of(context);
                                                  await NotesDatabase.instanc
                                                      .deleteNote(
                                                          notes[index].id!);

                                                  navigator.pop();
                                                },
                                                child: Text(
                                                  'Yes'.tr(),
                                                  style: const TextStyle(
                                                    color: dialogActionColor,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'No,Cancel'.tr(),
                                                  style: const TextStyle(
                                                    color: dialogActionColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      setState(
                                        () {
                                          NotesDatabase.instanc
                                              .searchInNotes(keyword);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
