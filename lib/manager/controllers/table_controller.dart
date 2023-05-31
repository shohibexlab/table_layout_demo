import 'package:flutter/material.dart';
import 'package:table_layout_demo/manager/models/models.dart';
import 'package:table_layout_demo/utils/utils.dart';
import 'controllers.dart';

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
  Widget? get child => getTableDecoration.child;

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

  //copyWith
  TableController copyWith({
    String? tableId,
    Function()? callback,
    Size? size,
    Offset? offset,
    TableShape? shape,
    bool? isSelected,
    TableDecoration? tableDecoration,
    String? tableName,
  }) {
    return TableController(
      tableId: tableId ?? this.tableId,
      callback: callback ?? this.callback,
      offset: offset,
      size: size,
      shape: shape,
      isSelected: isSelected,
      tableDecoration: tableDecoration?.copyWith(),
      tableName: tableName,
    );
  }
}
