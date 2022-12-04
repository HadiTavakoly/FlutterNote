import 'package:flutter/material.dart';
import 'package:my_notes/screens/add_edite_note.dart';
import '../db/notes_database.dart';
import '../models/notes_model.dart';
import '../screens/search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constans.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Note?>? notes;
  bool isLoading = false;
  bool lang = false;
  bool listIcon = false;

  save() async {
    SharedPreferences listOrGrid = await SharedPreferences.getInstance();
    await listOrGrid.setBool('list', listIcon);
  }

  load() async {
    final listOrGrid = await SharedPreferences.getInstance();
    setState(() {
      listIcon = listOrGrid.getBool('list') ?? false;
    });
  }

  @override
  void initState() {
    load();
    refresh();
    super.initState();
  }

  Future refresh() async {
    setState(() => isLoading = true);
    NotesDatabase.instanc.readAllNotes().then((value) => notes = value);
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    NotesDatabase.instanc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor[100],
      appBar: AppBar(
        backgroundColor: backgroundColor[100],
        elevation: 0,
        title: Text(
          'HomeAppBarTitle'.tr(),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 25,
          color: Colors.black,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchPage(),
                      ),
                    );
                    refresh();
                  },
                  icon: const Icon(
                    Icons.search_rounded,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    setState(
                      () {
                        lang ? lang = false : lang = true;
                        context.setLocale(
                          lang
                              ? const Locale('fa', 'IR')
                              : const Locale('en', 'US'),
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.language_rounded,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    setState(
                      () {
                        listIcon ? listIcon = false : listIcon = true;
                        save();
                      },
                    );
                  },
                  icon: Icon(
                    listIcon
                        ? Icons.view_list_rounded
                        : Icons.grid_view_rounded,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: NotesDatabase.instanc.readAllNotes(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            } else if (isLoading) {
              return const CircularProgressIndicator();
            } else {
              if (notes!.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.my_library_books_outlined,
                      size: 100,
                      color: primaryColor[200],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'All your notes will appear here'.tr(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Click'.tr(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: backgroundColor,
                      ),
                    ),
                  ],
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: MasonryGridView.count(
                    crossAxisCount: listIcon ? 1 : 2,
                    itemCount: notes!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            title: Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              notes![index]!.title.toString(),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                notes![index]!.description.toString(),
                                maxLines: listIcon ? 2 : 4,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black45),
                              ),
                            ),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddEditeNote(
                                    notes: notes![index],
                                  ),
                                ),
                              );
                              refresh();
                            },
                            onLongPress: () {
                              setState(
                                () {
                                  showDialog(
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
                                                      notes![index]!.id!);

                                              navigator.pop();
                                              refresh();
                                            },
                                            child: Text(
                                              'Yes'.tr(),
                                              style: const TextStyle(
                                                  color: dialogActionColor),
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
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add new note',
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEditeNote(),
            ),
          );
          refresh();
        },
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(
                Radius.circular(100),
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor,
                  spreadRadius: 10,
                  blurRadius: 10,
                  offset: Offset(0, 1),
                )
              ]),
          child: const Icon(
            Icons.add,
            size: 35,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
