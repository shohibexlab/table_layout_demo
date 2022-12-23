import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_layout_demo/table/table_controller.dart';
import 'package:table_layout_demo/table/table_widget.dart';

class CanvasController extends GetxController {
  static CanvasController get to => Get.find();
  final TextEditingController heightTEC = TextEditingController();
  final TextEditingController widthTEC = TextEditingController();
  TableWidget? get getSelectedTable {
    TableWidget? t;
    for (final table in tables) {
      if (table.controller.getIsSelected) {
        t = table;
      }
    }
    return t;
  }

  set setSelectedTable(TableController value) {
    for (final table in tables) {
      if (table.controller.getIsSelected) {
        table.controller.setIsSelected = false;
      }
    }
    value.setIsSelected = true;
    update();
  }

  final RxList<TableWidget> _tables = <TableWidget>[].obs;
  List<TableWidget> get tables => _tables;

  void addTable(TableController ctr) {
    for (var element in tables) {
      element.controller.setIsSelected = false;
    }
    setSelectedTable = ctr;
    _tables.add(TableWidget(controller: ctr));
    selectTable(ctr);
  }

  void removeTable() {
    _tables.removeWhere((element) =>
        element.controller.value.key == getSelectedTable?.controller.value.key);
    update();
  }

  void selectTable(TableController ctr) {
    setSelectedTable = ctr;
    print('selectTable: ${getSelectedTable?.controller.toString()}');
    heightTEC.text = ctr.getSize.height.toString();
    widthTEC.text = ctr.getSize.width.toString();
    update(['canvas']);
  }

  @override
  void onReady() {
    super.onReady();
    heightTEC.addListener(() {
      if (heightTEC.text.endsWith(".0")) {
        heightTEC.text = heightTEC.text.substring(0, heightTEC.text.length - 2);
      }
      if (heightTEC.text.isEmpty) {
        heightTEC.text = "0";
      }
    });
    widthTEC.addListener(() {
      if (widthTEC.text.endsWith(".0")) {
        widthTEC.text = widthTEC.text.substring(0, widthTEC.text.length - 2);
      }
      if (widthTEC.text.isEmpty) {
        widthTEC.text = "0";
      }
    });
  }

  @override
  void onClose() {
    heightTEC.dispose();
    widthTEC.dispose();
    super.onClose();
  }
}
