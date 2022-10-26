import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hive_crud/controller/notes_controller.dart';
import 'package:hive_crud/model/notes.dart';

import '../widgets/customSnackBar.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final controller = Get.put(NotesController());
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade100,
      appBar: AppBar(
        title: Text('Crud with Hive'),
      ),
      body: GetBuilder<NotesController>(
          builder: (cont) => ListView.builder(
              itemCount: cont.notCount,
              itemBuilder: (context, index) {
                if (cont.notCount > 0) {
                  Note? note = cont.observable.getAt(index);
                  return Card(
                    // color: Color.fromARGB(255, 47, 193, 11),
                    child: Container(
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.redAccent[100],
                          border: Border.all(width: 5, color: Colors.black)),
                      child: ListTile(
                        title: Text(
                          note?.title ?? "N/A",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        subtitle: Text(
                          note?.note ?? "Blank",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        leading: IconButton(
                            onPressed: () =>
                                addEditNote(index: index, note: note),
                            icon: const Icon(Icons.edit)),
                        trailing: IconButton(
                            onPressed: () => cont.deleteNot(index: index),
                            icon: const Icon(Icons.delete)),
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text("List is Empty"),
                  );
                }
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addEditNote(),
        child: const Icon(Icons.add),
      ),
    );
  }

  addEditNote({
    int? index,
    Note? note,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          //
          if (note != null) {
            titleController.text = note.title.toString();
            noteController.text = note.note.toString();
          } else {
            titleController.clear();
            noteController.clear();
          }

          return GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            child: Material(
              color: Colors.yellow.shade100,
              child: Form(
                // autovalidateMode: AutovalidateMode.onUserInteraction,
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    margin: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 7, color: Colors.redAccent.shade200),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      color: Colors.lightBlueAccent[100],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: ListView(
                        children: [
                          TextFormField(
                            // autofocus: true,
                            // enableInteractiveSelection: false,
                            decoration: InputDecoration(
                              fillColor: Colors.amber,
                              hintText: "Title",
                            ),
                            controller: titleController,
                            validator: (value) {
                              return controller.validateNote(value!);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            // autofocus: true,

                            decoration:
                                const InputDecoration(hintText: "Notes"),
                            controller: noteController,
                            maxLines: 5,
                            validator: (value) {
                              return controller.validateNote(value!);
                            },
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey),
                              onPressed: () {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus &&
                                    currentFocus.focusedChild != null) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                }

                                bool? isValidated =
                                    formKey.currentState?.validate();
                                if (isValidated == true) {
                                  String titleText = titleController.text;
                                  String noteText = noteController.text;
                                  if (index != null) {
                                    controller.updatetNot(
                                        index: index,
                                        note: Note(
                                          title:
                                              titleText, // titleController.text
                                          note: noteText, //noteController.text
                                        ));

                                    Future.delayed(Duration(milliseconds: 800),
                                        () {
                                      CustomSnackBar.showSnackBar(
                                          context: Get.context,
                                          title: "update",
                                          message: "updated successfully  ",
                                          backgroundColor: Colors.green);
                                    });
                                    Future.delayed(Duration(seconds: 4), () {
                                      // Navigator.pop(context);

                                      Get.back(
                                          // result: 'sucsses',
                                          // closeOverlays: true,
                                          );
                                    });
                                  } else {
                                    controller.createNot(
                                        note: Note(
                                            title: titleText, note: noteText));
                                    Future.delayed(Duration(milliseconds: 800),
                                        () {
                                      CustomSnackBar.showSnackBar(
                                          context: Get.context,
                                          title: "add",
                                          message: "adedd  successfully ",
                                          backgroundColor: Colors.green);
                                    });

                                    Future.delayed(Duration(seconds: 3), () {
                                      // Navigator.pop(context);

                                      Get.back();
                                    });
                                  }
                                } else {
                                  Future.delayed(Duration(seconds: 2), () {
                                    // Navigator.pop(context);
                                    // فى حالة الضغط على الزر قبل ملا الحقول النصية
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //     const SnackBar(
                                    //         shape: RoundedRectangleBorder(),
                                    //
                                    //      content: Text("Enter valid values")));
                                    Get.back();
                                    CustomSnackBar.showSnackBar(
                                        context: Get.context,
                                        title: "please",
                                        message: "Enter some text",
                                        backgroundColor: Colors.red);
                                  });
                                }
                              },
                              child: const Text("Submit"))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
