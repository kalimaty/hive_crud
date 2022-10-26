import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hive/hive.dart';
import 'package:hive_crud/model/notes.dart';
import 'package:hive_crud/repository/box_repository.dart';

import '../widgets/customSnackBar.dart';

class NotesController extends GetxController {
  final Box _observableBox = BoxRepository.getBox();
  Box get observable => _observableBox;
  int get notCount => _observableBox.length;
  createNot({required Note note}) {
    _observableBox.add(note);
    update();
  }

  updatetNot({required int index, required Note note}) {
    _observableBox.putAt(index, note);
    update();
  }

  deleteNot({required int index}) {
    _observableBox.deleteAt(index);
    CustomSnackBar.showSnackBar(
      context: Get.context,
      title: "delete",
      message: "deleted successfully",
      backgroundColor: Color.fromARGB(255, 8, 128, 226),
    );
    Future.delayed(Duration(milliseconds: 700), () {
      Get.back();
    });
    update();
  }

  String? validateNote(String value) {
    if (value.isEmpty) {
      return "Please enter some text";
    }
    return null;
  }
}
