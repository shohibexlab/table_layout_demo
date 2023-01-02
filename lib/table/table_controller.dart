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
    size ??= GridSettingsConstants.defaultTableSize;
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

  VoidCallback? callback;
  set setCallback(VoidCallback cb) {
    if (callback != null) {
      logger('Callback RESET for tableID ${value.tableId}');
    } else {
      logger('Callback SET for tableID ${value.tableId}');
    }
    callback = cb;
  }

  TableController(
      {Size? size,
      Offset? offset,
      // Offset? coordinates,
      String? tableName,
      TableShape? shape,
      bool? isSelected,
      this.callback,
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

  void changeSize({double? width, double? height, bool isAsCellIndex = false}) {
    if (isAsCellIndex) {
      value = value.copyWith(
        width: GridSettingsConstants.defaultGridCellSize.width * width!,
        height: GridSettingsConstants.defaultGridCellSize.height * height!,
      );
    } else {
      value = value.copyWith(width: width, height: height);
    }
    callback?.call();

    // CanvasController.to.update([GridConstants.gridCanvasTableId]);
  }

  Offset get getCenterOffset {
    return Offset(
      CanvasController.to.getLeftTopCorner.dx + getSize.width / 2,
      CanvasController.to.getLeftTopCorner.dy + getSize.height / 2,
    );
  }

  Offset get getLeftTopCorner {
    return Offset(
      getOffset.dx + CanvasController.to.getLeftTopCorner.dx,
      getOffset.dy + CanvasController.to.getLeftTopCorner.dy,
    );
  }

  Offset get getRightTopCorner {
    return Offset(
      getOffset.dx + getSize.width + CanvasController.to.getLeftTopCorner.dx,
      getOffset.dy + CanvasController.to.getLeftTopCorner.dy,
    );
  }

  Offset get getLeftBottomCorner {
    return Offset(
      getOffset.dx + CanvasController.to.getLeftTopCorner.dx,
      getOffset.dy + getSize.height + CanvasController.to.getLeftTopCorner.dy,
    );
  }

  bool get isTouchingCanvasLeft {
    return getOffset.dx == 0.0;
  }

  bool get isTouchingCanvasTop {
    return getOffset.dy == 0.0;
  }

  bool get isTouchingCanvasRight {
    return getOffset.dx + getSize.width ==
        GlobalKeyConstants.canvasGridKey.getSize!.width;
  }

  bool get isTouchingCanvasBottom {
    return getOffset.dy + getSize.height ==
        GlobalKeyConstants.canvasGridKey.getSize!.height;
  }

  void moveToTopRight() {
    setOffset = Offset(
        GlobalKeyConstants.canvasGridKey.getSize!.width - getSize.width, 0);
    callback?.call();

    CanvasController.to.update([GridConstants.gridCanvasId]);
  }

  void moveToTopLeft() {
    setOffset = const Offset(0, 0);
    callback?.call();

    CanvasController.to.update([GridConstants.gridCanvasId]);
  }

  void moveToBottomRight() {
    setOffset = Offset(
        GlobalKeyConstants.canvasGridKey.getSize!.width - getSize.width,
        GlobalKeyConstants.canvasGridKey.getSize!.height - getSize.height);
    callback?.call();

    CanvasController.to.update([GridConstants.gridCanvasId]);
  }

  void moveToBottomLeft() {
    setOffset = Offset(
        0, GlobalKeyConstants.canvasGridKey.getSize!.height - getSize.height);
    callback?.call();

    CanvasController.to.update([GridConstants.gridCanvasId]);
  }

  void moveToCenter() {
    setOffset = Offset(
        GlobalKeyConstants.canvasGridKey.getSize!.width / 2 - getSize.width / 2,
        GlobalKeyConstants.canvasGridKey.getSize!.height / 2 -
            getSize.height / 2);
    callback?.call();

    CanvasController.to.update([GridConstants.gridCanvasId]);
  }

  void changeShape(TableShape shape) {
    value = value.copyWith(
        tableDecoration: value.tableDecoration!.copyWith(tableShape: shape));
    callback?.call();
    CanvasController.to.update([GridConstants.gridSidebarTablePropsId]);
  }

  void changePosition(Offset o) {
    Offset? canvasPosition = GlobalKeyConstants.canvasGridKey.getPosition;

    if (canvasPosition != null) {
      Offset off = Offset(o.dx - canvasPosition.dx, o.dy - canvasPosition.dy);

      final yRemainder =
          (off.dy % GridSettingsConstants.defaultGridCellSize.height);
      final xRemainder =
          (off.dx % GridSettingsConstants.defaultGridCellSize.width);

      final halfCell = GridSettingsConstants.defaultGridCellSize.width / 2;
      if (xRemainder != 0) {
        double dx = off.dx;
        if (halfCell < xRemainder) {
          final temp =
              GridSettingsConstants.defaultGridCellSize.width - xRemainder;
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
        if (halfCell < yRemainder) {
          final temp =
              GridSettingsConstants.defaultGridCellSize.width - yRemainder;
          dy += temp;
        } else if (halfCell > yRemainder) {
          final temp = halfCell - yRemainder;
          dy += temp;
          // dy -= yRemainder;
        }
        off = Offset(off.dx, dy);
      }

      //Check if the table goes off Canvas boundaries
      if (!GridSettingsConstants.canItemGoOffCanvasBoundaries) {
        //Left
        if (off.dx < 0) off = Offset(0, off.dy);
        //Top
        if (off.dy < 0) off = Offset(off.dx, 0);
        //Right
        if (off.dx + getSize.width >
            GlobalKeyConstants.canvasGridKey.getSize!.width) {
          off = Offset(
              GlobalKeyConstants.canvasGridKey.getSize!.width - getSize.width,
              off.dy);
        }
        //Bottom
        if (off.dy + getSize.height >
            GlobalKeyConstants.canvasGridKey.getSize!.height) {
          off = Offset(
              off.dx,
              GlobalKeyConstants.canvasGridKey.getSize!.height -
                  getSize.height);
        }
      }
      setOffset = off;
    }
  }
}
