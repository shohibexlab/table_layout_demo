import 'package:flutter/material.dart';
import '../main.dart';

class TableData {
  Size? size;
  Offset? offset;

  final UniqueKey key;

  Offset get getOffset => offset!;
  Size get getSize => size!;

  TableData copyWith({
    Size? size,
    Offset? offset,
    UniqueKey? key,
  }) {
    return TableData(
      size: size ?? this.size,
      offset: offset ?? this.offset,
      key: key ?? this.key,
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
    );
  }

  TableData({this.size, this.offset, required this.key}) {
    size ??= Constants.defaultContainerSize;
    offset ??= const Offset(0, 0);
  }

  @override
  String toString() {
    return 'TableData(size: $size, offset: $offset, key: $key)';
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
  TableController({Size? size, Offset? offset, Offset? coordinates})
      : super(
          coordinates != null
              ? TableData(
                  key: UniqueKey(),
                  offset: offset,
                ).fromIndex(coordinates: coordinates)
              : TableData(
                  size: size,
                  offset: offset,
                  key: UniqueKey(),
                ),
        ) {
    print("TableController constructor");
    print("TableController constructor: ${value}");
  }

  Size get getSize => value.size!;
  Offset get getOffset => value.offset!;
  set setSize(Size size) => value = value.copyWith(size: size);
  set setOffset(Offset offset) => value = value.copyWith(offset: offset);

  void changePosition(Offset o) {
    Offset off = Offset(o.dx - Constants.defaultScreenPadding,
        o.dy - Constants.defaultScreenPadding);
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
