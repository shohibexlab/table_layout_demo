import 'package:flutter/material.dart';
import '../canvas_controller.dart';
import '../main.dart';

enum TableShape {
  rectangle,
  circle,
}

class TableData {
  Size? size;
  Offset? offset;
  String? tableName;
  TableShape? shape;
  final UniqueKey key;
  bool? isSelected;

  Offset get getOffset => offset!;
  Size get getSize => size!;
  String get getTableName => tableName!;
  TableShape get getShape => shape!;
  bool get getIsSelected => isSelected!;

  TableData copyWith({
    double? width,
    double? height,
    Offset? offset,
    UniqueKey? key,
    String? tableName,
    TableShape? shape,
    bool? isSelected,
  }) {
    return TableData(
      size: Size(width ?? size!.width, height ?? size!.height),
      offset: offset ?? this.offset,
      key: key ?? this.key,
      tableName: tableName ?? this.tableName,
      shape: shape ?? this.shape,
      isSelected: isSelected ?? this.isSelected,
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
      shape: shape,
      isSelected: isSelected,
    );
  }

  TableData(
      {this.size,
      this.offset,
      required this.key,
      required this.tableName,
      required this.shape,
      required this.isSelected}) {
    size ??= Constants.defaultContainerSize;
    offset ??= const Offset(0, 0);
    tableName ??= 'Table ${key.toString()}';
    shape ??= TableShape.rectangle;
    isSelected ??= false;
  }

  @override
  String toString() {
    return 'TableData(size: $size, offset: $offset, key: $key, tableName: $tableName, shape: $shape, isSelected: $isSelected)';
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
      bool? isSelected})
      : super(
          coordinates != null
              ? TableData(
                  tableName: tableName,
                  key: UniqueKey(),
                  offset: offset,
                  shape: shape,
                  isSelected: isSelected,
                ).fromIndex(coordinates: coordinates)
              : TableData(
                  tableName: tableName,
                  size: size,
                  offset: offset,
                  key: UniqueKey(),
                  shape: shape,
                  isSelected: isSelected,
                ),
        );

  Size get getSize => value.size!;
  Offset get getOffset => value.offset!;

  bool get getIsSelected => value.isSelected!;
  TableShape get getShape => value.shape!;
  String get getTableName => value.tableName!;

  set setOffset(Offset offset) => value = value.copyWith(offset: offset);

  void setSize({double? width, double? height}) {
    value = value.copyWith(width: width, height: height);
    CanvasController.to.update();
  }

  set setIsSelected(bool isSelected) =>
      value = value.copyWith(isSelected: isSelected);
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
  }
}
