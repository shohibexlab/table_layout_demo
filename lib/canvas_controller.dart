import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_layout_demo/constants.dart';
import 'package:table_layout_demo/table/table_controller.dart';
import 'package:table_layout_demo/table/table_widget.dart';
import 'package:table_layout_demo/utils.dart';

import 'logger.dart';

export './logger.dart';

class CanvasController extends GetxController {
  static CanvasController get to => Get.find();
  final TextEditingController heightTEC = TextEditingController();
  final TextEditingController widthTEC = TextEditingController();

  bool get isTableTouchingCanvasLeft {
    return getSelectedTable?.controller.isTouchingCanvasLeft ?? false;
  }

  void moveTableToCanvasRightCorner() {}

  Offset get getLeftTopCorner {
    return GlobalKeyConstants.canvasGridKey.getPosition ?? Offset.zero;
  }

  Offset get getRightTopCorner {
    return Offset(
      getLeftTopCorner.dx +
          GridSettingsConstants.defaultGridCellSize.width *
              GridSettingsConstants.defaultGridCells.dx,
      getLeftTopCorner.dy,
    );
  }

  Offset get geLeftBottomCorner {
    return Offset(
      getLeftTopCorner.dx,
      getLeftTopCorner.dy +
          GridSettingsConstants.defaultGridCellSize.height *
              GridSettingsConstants.defaultGridCells.dy,
    );
  }

  Offset get getRightBottomCorner {
    return Offset(
      getLeftTopCorner.dx +
          GridSettingsConstants.defaultGridCellSize.width *
              GridSettingsConstants.defaultGridCells.dx,
      getLeftTopCorner.dy +
          GridSettingsConstants.defaultGridCellSize.height *
              GridSettingsConstants.defaultGridCells.dy,
    );
  }

  TableWidget? get getSelectedTable {
    TableWidget? t;
    for (final table in tables) {
      if (table.controller.getIsSelected) {
        t = table;
      }
    }
    return t;
  }

  final RxList<TableWidget> _tables = <TableWidget>[].obs;
  List<TableWidget> get tables => _tables;
  RxList<TableWidget> get tablesRx => _tables;

  final RxList<TableController> _usedTables = <TableController>[].obs;
  List<TableController> get usedTables => _usedTables;

  bool isTableUsed(TableController ctr) {
    return usedTables.any((element) => element.tableId == ctr.tableId);
  }

  void addTable(TableController ctr) {
    for (var element in tables) {
      element.controller.setIsSelected = false;
    }
    _usedTables.add(ctr);
    _tables.add(TableWidget(controller: ctr));
    selectTable(ctr, swap: false);
    update(
        [GridConstants.gridCanvasId, GridConstants.gridSidebarBarTableListId]);
  }

  void removeTable() {
    _usedTables.removeWhere(
        (element) => element.tableId == getSelectedTable?.controller.tableId);
    _tables.removeWhere((element) =>
        element.controller.tableId == getSelectedTable?.controller.tableId);
    heightTEC.clear();
    widthTEC.clear();
    update([
      GridConstants.gridCanvasId,
      GridConstants.gridSidebarBarTableListId,
      GridConstants.gridSidebarTablePropsId,
    ]);
  }

  set _setSelectedTable(TableController value) {
    for (final table in tables) {
      if (table.controller.getIsSelected) {
        table.controller.setIsSelected = false;
      }
    }
    value.setIsSelected = true;
  }

  void clearSelectedTable() {
    getSelectedTable?.controller.callback?.call();
    if (tables.isNotEmpty) {
      for (final table in tables) {
        if (table.controller.getIsSelected) {
          table.controller.callback?.call();
          table.controller.setIsSelected = false;
        }
      }
      for (var element in tables) {
        element.controller.callback?.call();
      }
      heightTEC.clear();
      widthTEC.clear();
      update([
        GridConstants.gridSidebarTablePropsId,
        GridConstants.gridCanvasId,
      ]);
    }
  }

  void selectTable(TableController ctr, {bool swap = true}) {
    _setSelectedTable = ctr;
    heightTEC.text = ctr.getSize.toCellIndex.height.toString();
    widthTEC.text = ctr.getSize.toCellIndex.width.toString();
    if (swap && tables.length >= 2) {
      final indexOf1 = tables.indexOf(tables
          .firstWhere((element) => element.controller.tableId == ctr.tableId));
      if (getSelectedTable != null) {
        List<TableWidget> l =
            Utils.swapList<TableWidget>(tables, indexOf1, tables.length - 1);
        _tables.assignAll(l);
      }
    }
    ctr.callback?.call();

    logger("selectTable: ${ctr.getSize}");
    update([
      GridConstants.gridCanvasId,
      GridConstants.gridSidebarTablePropsId,
    ]);
  }

  @override
  void onReady() {
    super.onReady();
    heightTEC.addListener(() {
      if (heightTEC.text.endsWith(".0")) {
        heightTEC.text = heightTEC.text.substring(0, heightTEC.text.length - 2);
      }
    });
    widthTEC.addListener(() {
      if (widthTEC.text.endsWith(".0")) {
        widthTEC.text = widthTEC.text.substring(0, widthTEC.text.length - 2);
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
