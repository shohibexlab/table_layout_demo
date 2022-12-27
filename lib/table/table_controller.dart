import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_layout_demo/utils.dart';
import '../canvas_controller.dart';
import '../constants.dart';

enum TableShape {
  rectangle,
  circle,
}

class TableDecoration {
  Color? activeBgColor;
  Color? inactiveBgColor;
  TableShape? tableShape;
  TextStyle? textStyle;

  Color get getActiveBgColor => activeBgColor!;
  Color get getInactiveBgColor => inactiveBgColor!;
  TableShape get getTableShape => tableShape!;
  TextStyle? get getTextStyle => textStyle;

  void defaultAll() {
    activeBgColor ??= Colors.blueAccent;
    inactiveBgColor ??= Colors.black38;
    tableShape ??= TableShape.rectangle;
  }

  TableDecoration({
    this.activeBgColor,
    this.inactiveBgColor,
    this.tableShape,
    this.textStyle,
  }) {
    defaultAll();
  }

  TableDecoration copyWith({
    Color? activeBgColor,
    Color? inactiveBgColor,
    TableShape? tableShape,
    TextStyle? textStyle,
  }) {
    return TableDecoration(
      activeBgColor: activeBgColor ?? this.activeBgColor,
      inactiveBgColor: inactiveBgColor ?? this.inactiveBgColor,
      tableShape: tableShape ?? this.tableShape,
      textStyle: textStyle ?? this.textStyle,
    );
  }

  @override
  String toString() {
    return 'TableDecoration(activeBgColor: $activeBgColor, inactiveBgColor: $inactiveBgColor, tableShape: $tableShape, textStyle: $textStyle)';
  }
}

class TableData {
  Size? size;
  Offset? offset;
  String? tableName;
  final UniqueKey key;
  bool? isSelected;
  TableDecoration? tableDecoration;

  String tableId;

  Offset get getOffset => offset!;
  Size get getSize => size!;
  String get getTableName => tableName!;
  bool get getIsSelected => isSelected!;
  TableDecoration get getTableDecoration => tableDecoration!;

  TableData copyWith({
    double? width,
    double? height,
    Offset? offset,
    UniqueKey? key,
    String? tableName,
    bool? isSelected,
    TableDecoration? tableDecoration,
  }) {
    return TableData(
      size: Size(width ?? size!.width, height ?? size!.height),
      offset: offset ?? this.offset,
      key: key ?? this.key,
      tableName: tableName ?? this.tableName,
      isSelected: isSelected ?? this.isSelected,
      tableDecoration: tableDecoration ?? this.tableDecoration,
      tableId: tableId,
    );
  }

  TableData(
      {this.size,
      this.offset,
      required this.key,
      required this.tableName,
      required this.isSelected,
      this.tableDecoration,
      required this.tableId}) {
    size ??= Constants.defaultTableSize;
    offset ??= const Offset(0, 0);
    tableName ??= 'Table ${key.toString()}';
    isSelected ??= false;
    tableDecoration ??= TableDecoration();
  }

  @override
  String toString() {
    return 'TableData(tableId: $tableId, size: $size, offset: $offset, key: $key, tableName: $tableName, isSelected: $isSelected, tableDecoration: ${tableDecoration.toString()})';
  }
}

class TableController extends ValueNotifier<TableData> {
  /// To assign initial position of the widget, use [index] parameter
  ///
  /// and pass Offset(dx, dy) where dx = x-coordinate and dy = y-coordinate.
  ///
  /// This will divide the passed values to [Constants.defaultGridCellSize]
  ///
  /// Use offset parameter to assign initial position of the widget
  ///
  /// but using Offset(dx, dy) where dx and dy is Flutter offset.

  TableController(
      {Size? size,
      Offset? offset,
      // Offset? coordinates,
      String? tableName,
      TableShape? shape,
      bool? isSelected,
      TableDecoration? tableDecoration,
      required String tableId})
      : super(
          TableData(
            tableName: tableName,
            size: size,
            offset: offset,
            key: UniqueKey(),
            isSelected: isSelected,
            tableDecoration: tableDecoration,
            tableId: tableId,
          ),
        );

  Size get getSize => value.size!;

  Offset get getOffset => value.offset!;

  bool get getIsSelected => value.getIsSelected;
  String get getTableName => value.tableName!;
  TableDecoration get getTableDecoration => value.tableDecoration!;
  TableShape get getTableShape => value.tableDecoration!.tableShape!;
  String get tableId => value.tableId;

  set setOffset(Offset offset) => value = value.copyWith(offset: offset);

  set setIsSelected(bool isSelected) =>
      value = value.copyWith(isSelected: isSelected);

  void setSize({double? width, double? height, bool isAsCellIndex = false}) {
    if (isAsCellIndex) {
      value = value.copyWith(
        width: Constants.defaultGridCellSize.width * width!,
        height: Constants.defaultGridCellSize.height * height!,
      );
    } else {
      value = value.copyWith(width: width, height: height);
    }
  }

  void changeShape(TableShape shape) {
    value = value.copyWith(
        tableDecoration: value.tableDecoration!.copyWith(tableShape: shape));
  }

  void changePosition(Offset o) {
    Offset? canvasPosition = GlobalKeyConstants.canvasGridKey.getPosition;

    if (canvasPosition != null) {
      Offset off = Offset(o.dx - canvasPosition.dx, o.dy - canvasPosition.dy);

      final yRemainder = (off.dy % Constants.defaultGridCellSize.height);
      final xRemainder = (off.dx % Constants.defaultGridCellSize.width);

      final halfCell = Constants.defaultGridCellSize.width / 2;
      print("Initial Offset: $off");
      print('XRemainder: $xRemainder');
      print('YRemainder: $yRemainder');
      print('HalfCell: $halfCell');
      print(
          'Width: ${Get.width - (Constants.defaultGridCells.dx - Constants.defaultTableSize.width + 10)}');
      if (xRemainder != 0) {
        double dx = off.dx;
        print('dx: $dx');
        if (halfCell < xRemainder) {
          final temp = Constants.defaultGridCellSize.width - xRemainder;
          dx += temp;
        } else if (halfCell > xRemainder) {
          final temp = halfCell - xRemainder;
          dx += temp;
          // dx -= xRemainder;
        }
        off = Offset(dx, off.dy);
      }
      if (yRemainder != 0) {
        double dy = off.dy;
        print('dy: $dy');
        if (halfCell < yRemainder) {
          final temp = Constants.defaultGridCellSize.width - yRemainder;
          dy += temp;
        } else if (halfCell > yRemainder) {
          final temp = halfCell - yRemainder;
          dy += temp;
          // dy -= yRemainder;
        }
        off = Offset(off.dx, dy);
      }
      print("Final Offset: $off");
      // setOffset = Offset(1500, 700).toCellIndex;
      setOffset = off;

      CanvasController.to.update(
          [GridConstants.gridCanvasId, GridConstants.gridCanvasTableId]);
    }
  }

  void changePositionByIndex(Offset o) {
    setOffset = o.toOffsetFromCellIndex;
    CanvasController.to
        .update([GridConstants.gridCanvasId, GridConstants.gridCanvasTableId]);
  }
}
