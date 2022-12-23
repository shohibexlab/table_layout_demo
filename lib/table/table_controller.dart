import 'package:flutter/material.dart';
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
  Border? activeBorder;
  Border? inactiveBorder;

  Color get getActiveBgColor => activeBgColor!;
  Color get getInactiveBgColor => inactiveBgColor!;
  TableShape get getTableShape => tableShape!;
  TextStyle? get getTextStyle => textStyle;
  Border get getActiveBorder => activeBorder!;
  Border get getInactiveBorder => inactiveBorder!;

  void defaultAll() {
    activeBgColor ??= Colors.blueAccent;
    inactiveBgColor ??= Colors.black38;
    tableShape ??= TableShape.rectangle;
    activeBorder ??= Border.all(color: Colors.black, width: 2);
    inactiveBorder ??= Border.all(color: Colors.transparent, width: 2);
  }

  TableDecoration({
    this.activeBgColor,
    this.inactiveBgColor,
    this.tableShape,
    this.textStyle,
    this.activeBorder,
    this.inactiveBorder,
  }) {
    defaultAll();
  }

  TableDecoration copyWith({
    Color? activeBgColor,
    Color? inactiveBgColor,
    TableShape? tableShape,
    TextStyle? textStyle,
    Border? activeBorder,
    Border? inactiveBorder,
  }) {
    return TableDecoration(
      activeBgColor: activeBgColor ?? this.activeBgColor,
      inactiveBgColor: inactiveBgColor ?? this.inactiveBgColor,
      tableShape: tableShape ?? this.tableShape,
      textStyle: textStyle ?? this.textStyle,
      activeBorder: activeBorder ?? this.activeBorder,
      inactiveBorder: inactiveBorder ?? this.inactiveBorder,
    );
  }

  @override
  String toString() {
    return 'TableDecoration(activeBgColor: $activeBgColor, inactiveBgColor: $inactiveBgColor, tableShape: $tableShape, textStyle: $textStyle, activeBorder: $activeBorder, inactiveBorder: $inactiveBorder)';
  }
}

class TableData {
  Size? size;
  Offset? offset;
  String? tableName;
  final UniqueKey key;
  bool? isSelected;
  TableDecoration? tableDecoration;

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
    );
  }

  TableData fromIndex({
    Offset? coordinates,
  }) {
    return TableData(
      offset: Offset(
        Constants.defaultGridCellSize.width * coordinates!.dx,
        Constants.defaultGridCellSize.height * coordinates.dy,
      ),
      size: size,
      key: key,
      tableName: tableName,
      isSelected: isSelected,
      tableDecoration: tableDecoration,
    );
  }

  TableData(
      {this.size,
      this.offset,
      required this.key,
      required this.tableName,
      required this.isSelected,
      this.tableDecoration}) {
    size ??= Constants.defaultContainerSize;
    offset ??= const Offset(0, 0);
    tableName ??= 'Table ${key.toString()}';
    isSelected ??= false;
    tableDecoration ??= TableDecoration();
  }

  @override
  String toString() {
    return 'TableData(size: $size, offset: $offset, key: $key, tableName: $tableName, isSelected: $isSelected, tableDecoration: ${tableDecoration.toString()})';
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
      Offset? coordinates,
      String? tableName,
      TableShape? shape,
      bool? isSelected,
      TableDecoration? tableDecoration})
      : super(
          coordinates != null
              ? TableData(
                  tableName: tableName,
                  key: UniqueKey(),
                  offset: offset,
                  isSelected: isSelected,
                  tableDecoration: tableDecoration,
                ).fromIndex(coordinates: coordinates)
              : TableData(
                  tableName: tableName,
                  size: size,
                  offset: offset,
                  key: UniqueKey(),
                  isSelected: isSelected,
                  tableDecoration: tableDecoration,
                ),
        );

  Size get getSize => value.size!;
  Size get getSizeAsCellIndex => Size(
      getSize.width / Constants.defaultGridCellSize.width,
      getSize.height / Constants.defaultGridCellSize.height);
  Offset get getOffset => value.offset!;
  Offset get getOffsetAsCellIndex => Offset(
      getOffset.dx / Constants.defaultGridCellSize.width,
      getOffset.dy / Constants.defaultGridCellSize.height);
  bool get getIsSelected => value.getIsSelected;
  String get getTableName => value.tableName!;
  TableDecoration get getTableDecoration => value.tableDecoration!;
  TableShape get getTableShape => value.tableDecoration!.tableShape!;

  set setOffset(Offset offset) => value = value.copyWith(offset: offset);
  set setIsSelected(bool isSelected) =>
      value = value.copyWith(isSelected: isSelected);

  void setSize({double? width, double? height, bool isAsCellIndex = false}) {
    if (isAsCellIndex) {
      value = value.copyWith(
        width: width! * Constants.defaultGridCellSize.width,
        height: height! * Constants.defaultGridCellSize.height,
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
    Offset off = Offset(o.dx - Constants.defaultCanvasPadding,
        o.dy - Constants.defaultCanvasPadding);
    final yRemainder = off.dy % Constants.defaultGridCellSize.height;
    final xRemainder = off.dx % Constants.defaultGridCellSize.width;
    final halfCell = Constants.defaultGridCellSize.width / 2;
    if (xRemainder != 0) {
      double dx = off.dx;
      if (halfCell < xRemainder) {
        final temp = Constants.defaultGridCellSize.width - xRemainder;
        dx += temp;
      } else if (halfCell > xRemainder) {
        dx -= xRemainder;
      }
      off = Offset(dx, off.dy);
    }
    if (yRemainder != 0) {
      double dy = off.dy;
      if (halfCell < yRemainder) {
        final temp = Constants.defaultGridCellSize.width - yRemainder;
        dy += temp;
      } else if (halfCell > yRemainder) {
        dy -= yRemainder;
      }
      off = Offset(off.dx, dy);
    }

    setOffset = off;
    CanvasController.to.update([
      Constants.defaultGridConstants.gridCanvasId,
      Constants.defaultGridConstants.gridCanvasTableId
    ]);
  }
}
