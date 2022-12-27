import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_layout_demo/general_table_controller.dart';
import 'package:table_layout_demo/table/table_widget.dart';
import 'package:table_layout_demo/utils.dart';
import '../canvas_controller.dart';
import '../constants.dart';
import 'draggable_widget.dart';

class GridCanvas extends StatelessWidget {
  GridCanvas({super.key});

  DragDirection dragDirection = DragDirection.none;
  int oldDy = 0;
  bool reversed = false;
  int reversedAt = 0;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GetBuilder<CanvasController>(
        id: GridConstants.gridCanvasId,
        builder: (ctr) => GridPaper(
          key: GlobalKeyConstants.canvasGridKey,
          divisions: 1,
          color: GridDecorations.defaultGridColor,
          interval: GridSettingsConstants.defaultGridInterval,
          subdivisions: GridSettingsConstants.defaultGridSubdivision,
          child: ColoredBox(
            color: GridDecorations.defaultBackgroundColor,
            child: Stack(
              children: [
                if (ctr.tables.isEmpty)
                  Center(
                      child: Text(
                    'Add tables',
                    style: Theme.of(context).textTheme.headline1,
                  )),
                //Handles the outside click to deselect the selected table
                GestureDetector(
                    onTap: ctr.clearSelectedTable,
                    child: Container(color: Colors.transparent)),
                for (var table in ctr.tables)
                  RepaintBoundary(
                    child: Stack(
                      children: [
                        table,
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleDirChange(TableWidget table, Offset wentUpTo) {
    int dy = wentUpTo.dy.toInt();
    logger('DIR_CHANGE');
    // logger('dy: $dy');
    // logger('oldDy: $oldDy');
    // logger('DIR_CHANGE');
    if (dy > oldDy) {
      if (dragDirection == DragDirection.up) {
        // table.controller.changePositionByIndex(Offset(
        //     table.controller.getOffset.toCellIndex.dx,
        //     table.controller.getOffset.toCellIndex.dy - 1.toDouble()));
        // GeneralTableController.to
        //     .onResizeTableByCellIndex(addingHeight: 1.toDouble());
        // } else {
        //   table.controller.changePositionByIndex(Offset(
        //       table.controller.getOffset.toCellIndex.dx,
        //       table.controller.getOffset.toCellIndex.dy + 1.toDouble()));
        //   GeneralTableController.to
        //       .onResizeTableByCellIndex(addingHeight: -1.toDouble());
      }
    }
    reversedAt = dy.toInt();
    oldDy = dy.toInt() + 1;
  }

  void _handleResize(TableWidget table, Offset wentUpTo) {
    int dy = wentUpTo.dy.toInt();
    if (!reversed) {
      // logger('RESIZE');
      // logger('dy: $dy');
      // logger('oldDy: $oldDy');
      // logger('RESIZE');
      if (dy > oldDy) {
        if (dragDirection == DragDirection.up) {
          // table.controller.changePositionByIndex(Offset(
          //     table.controller.getOffset.toCellIndex.dx,
          //     table.controller.getOffset.toCellIndex.dy - 1.toDouble()));
          // GeneralTableController.to
          //     .onResizeTableByCellIndex(addingHeight: 1.toDouble());
          // oldDy = dy;
        } else {
          // table.controller.changePositionByIndex(Offset(
          //     table.controller.getOffset.toCellIndex.dx,
          //     table.controller.getOffset.toCellIndex.dy + 1.toDouble()));
          // GeneralTableController.to
          //     .onResizeTableByCellIndex(addingHeight: -1.toDouble());
          // oldDy = dy;
        }
      }
    } else {
      int dy = wentUpTo.dy.toInt();

      logger(
          'HANDLE_REVERSED, Reversed At => $reversedAt, dy => $dy, oldDy => $oldDy');
      if (dy > reversedAt) {
        if (dragDirection == DragDirection.up) {
          logger('UP');
          // table.controller.changePositionByIndex(Offset(
          //     table.controller.getOffset.toCellIndex.dx,
          //     table.controller.getOffset.toCellIndex.dy - 1.toDouble()));
          // GeneralTableController.to
          //     .onResizeTableByCellIndex(addingHeight: 1.toDouble());
          // oldDy = dy;
        } else {
          logger('DOWN');
          // table.controller.changePositionByIndex(Offset(
          //     table.controller.getOffset.toCellIndex.dx,
          //     table.controller.getOffset.toCellIndex.dy + 1.toDouble()));
          // GeneralTableController.to
          //     .onResizeTableByCellIndex(addingHeight: -1.toDouble());
          // oldDy = dy;
        }
      }
    }
  }
}

enum DragDirection { up, down, none }

//GestureDetector(
//                               onVerticalDragUpdate: (details) {
//                                 const subtract = 10;
//                                 final lcPosition = details.localPosition;
//                                 Offset wentUpTo = Offset(lcPosition.dx,
//                                         (lcPosition.dy - subtract).abs())
//                                     .toCellIndex;
//                                 // bool isGoingUp = details.delta.dy < 0;
//                                 // wentUpTo1 = Offset(lcPosition.dx,
//                                 //         (lcPosition.dy - subtract).abs())
//                                 //     .toCellIndex;
//                                 if (wentUpTo != wentUpTo1) {
//                                   isGoingUp1 = details.delta.dy < 0;
//                                   wentUpTo1 = wentUpTo;
//                                 }
//                                 // isGoingUp1 = details.delta.dy < 0;
//                                 DragDirection dragDir = DragDirection.none;
//                                 if (isGoingUp1) {
//                                   dragDir = DragDirection.up;
//                                 } else {
//                                   dragDir = DragDirection.down;
//                                 }
//                                 // logger("reversed: $reversed");
//                                 // logger("isGoingUp: $isGoingUp");
//                                 logger("oldDragDir: $dragDirection");
//                                 logger("dragDir: $dragDir");
//
//                                 if (dragDir != dragDirection) {
//                                   // oldDy = 0;
//                                   dragDirection = dragDir;
//                                   wentUpTo1 = Offset.zero;
//                                 }
//                                 // if (reversed) {
//                                 //   reversed = false;
//                                 //   oldDy = 0;
//                                 // }
//                                 // logger(
//                                 //     'update ${details.globalPosition}, $isGoingUp, startDy: $startDy, delta: ${details.delta.dy}, didChangeDirection: ${details.globalPosition.dy != startDy}');
//                                 logger("oldDy: $oldDy");
//                                 logger("wentUpTo1: $wentUpTo1");
//                                 if (isGoingUp1) {
//                                   //dy ni yaxlitla
//                                   int dy = wentUpTo1.dy.toInt();
//                                   // if (dy < 0) dy = 0;
//                                   logger('going up, dy: $dy');
//                                   // tepaga dy chiqib pasga dy qush
//                                   if (dy > oldDy) {
//                                     table.controller.changePositionByIndex(
//                                         Offset(
//                                             table.controller
//                                                 .getOffsetAsCellIndex.toCellIndex.dx,
//                                             table.controller
//                                                     .getOffsetAsCellIndex.toCellIndex.dy -
//                                                 1.toDouble()));
//                                     GeneralTableController.to
//                                         .onResizeTableByCellIndex(
//                                             addingHeight: 1.toDouble());
//                                     oldDy = dy;
//                                   }
//                                 } else {
//                                   //dy ni yaxlitla
//                                   int dy = wentUpTo1.dy.toInt();
//                                   // if (dy < 0) dy = 0;
//
//                                   logger('going down dy: $dy');
//                                   // tepaga dy chiqib pasga dy qush
//                                   if (dy > oldDy) {
//                                     table.controller.changePositionByIndex(
//                                         Offset(
//                                             table.controller
//                                                 .getOffsetAsCellIndex.toCellIndex.dx,
//                                             table.controller
//                                                     .getOffsetAsCellIndex.toCellIndex.dy +
//                                                 1.toDouble()));
//                                     GeneralTableController.to
//                                         .onResizeTableByCellIndex(
//                                             addingHeight: -1.toDouble());
//                                     oldDy = dy;
//                                   }
//                                 }
//                               },
//                               onVerticalDragDown: (details) {
//                                 logger('down: ${details.localPosition}');
//                               },
//                               onVerticalDragStart: (details) {
//                                 logger('start: ${details.kind}');
//                               },
//                               onVerticalDragCancel: () {
//                                 logger('cancel');
//                               },
//                               onVerticalDragEnd: (details) {
//                                 // logger('onVerticalDragEnd');
//                                 oldDy = 0;
//                                 dragDirection = DragDirection.none;
//                               },
//                               child: const Icon(
//                                 Icons.circle,
//                               ))

//XGestureDetector(
//                             onMoveUpdate: (details) {
//                               // logger('onMoveUpdate pointer ${details.pointer}');
//                               // logger('onMoveUpdate delta ${details.delta}');
//                               // logger(
//                               //     'onMoveUpdate localDelta ${details.localDelta}');
//                               // logger(
//                               //     'onMoveUpdate localPos ${details.localPos}');
//                               // logger(
//                               //     'onMoveUpdate position ${details.position}');
//                               const subtract = 10;
//                               final lcPosition = details.localPos;
//                               final wentUpTo = Offset(lcPosition.dx,
//                                       (lcPosition.dy - subtract).abs())
//                                   .toCellIndex;
//                               bool isGoingUp = details.delta.dy < 0;
//                               logger("reversed: $reversed");
//                               logger("isGoingUp: $isGoingUp");
//                               if (isGoingUp != reversed) {
//                                 reversed = true;
//                                 oldDy = 0;
//                               }
//                               // logger(
//                               //     'update ${details.globalPosition}, $isGoingUp, startDy: $startDy, delta: ${details.delta.dy}, didChangeDirection: ${details.globalPosition.dy != startDy}');
//                               if (isGoingUp) {
//                                 if (reversed) {
//                                   reversed = false;
//                                   oldDy = 0;
//                                 }
//                                 //dy ni yaxlitla
//                                 int dy = wentUpTo.dy.toInt();
//                                 // logger('going up, dy: $dy');
//                                 // tepaga dy chiqib pasga dy qush
//                                 if (dy > oldDy) {
//                                   table.controller.changePositionByIndex(Offset(
//                                       table.controller.getOffsetAsCellIndex.toCellIndex.dx,
//                                       table.controller.getOffsetAsCellIndex.toCellIndex.dy -
//                                           1.toDouble()));
//                                   GeneralTableController.to
//                                       .onResizeTableByCellIndex(
//                                           addingHeight: 1.toDouble());
//                                   oldDy = dy;
//                                 }
//                               } else {
//                                 //dy ni yaxlitla
//
//                                 int dy = wentUpTo.dy.toInt();
//                                 // logger('going down $dy');
//                                 // tepaga dy chiqib pasga dy qush
//                                 if (dy > oldDy) {
//                                   table.controller.changePositionByIndex(Offset(
//                                       table.controller.getOffsetAsCellIndex.toCellIndex.dx,
//                                       table.controller.getOffsetAsCellIndex.toCellIndex.dy +
//                                           1.toDouble()));
//                                   GeneralTableController.to
//                                       .onResizeTableByCellIndex(
//                                           addingHeight: -1.toDouble());
//                                   oldDy = dy;
//                                 }
//                               }
//                             },
//                             onMoveEnd: (event) {
//                               oldDy = 0;
//                               reversed = false;
//                             },
//                             child: const Icon(Icons.circle)),

// child: GestureDetector(
//                               onVerticalDragUpdate: (details) {
//                                 const subtract = 10;
//                                 final lcPosition = details.localPosition;
//                                 final wentUpTo = Offset(lcPosition.dx,
//                                         (lcPosition.dy - subtract).abs())
//                                     .toCellIndex;
//                                 bool isGoingUp = details.delta.dy < 0;
//                                 // logger("reversed: $reversed");
//                                 // logger(
//                                 //     'update ${details.globalPosition}, $isGoingUp, startDy: $startDy, delta: ${details.delta.dy}, didChangeDirection: ${details.globalPosition.dy != startDy}');
//                                 if (isGoingUp) {
//                                   if (reversed) {
//                                     reversed = false;
//                                     oldDy = 0;
//                                   }
//                                   //dy ni yaxlitla
//                                   int dy = wentUpTo.dy.toInt();
//                                   // logger('going up, dy: $dy');
//                                   // tepaga dy chiqib pasga dy qush
//                                   if (dy > oldDy) {
//                                     table.controller.changePositionByIndex(
//                                         Offset(
//                                             table.controller
//                                                 .getOffsetAsCellIndex.toCellIndex.dx,
//                                             table.controller
//                                                     .getOffsetAsCellIndex.toCellIndex.dy -
//                                                 1.toDouble()));
//                                     GeneralTableController.to
//                                         .onResizeTableByCellIndex(
//                                             addingHeight: 1.toDouble());
//                                     oldDy = dy;
//                                   }
//                                 } else {
//                                   //dy ni yaxlitla
//                                   int dy = wentUpTo.dy.toInt();
//                                   // logger('going down $dy');
//                                   // tepaga dy chiqib pasga dy qush
//                                   if (dy > oldDy) {
//                                     table.controller.changePositionByIndex(
//                                         Offset(
//                                             table.controller
//                                                 .getOffsetAsCellIndex.toCellIndex.dx,
//                                             table.controller
//                                                     .getOffsetAsCellIndex.toCellIndex.dy +
//                                                 1.toDouble()));
//                                     GeneralTableController.to
//                                         .onResizeTableByCellIndex(
//                                             addingHeight: -1.toDouble());
//                                     oldDy = dy;
//                                   }
//                                 }
//                               },
//                               onVerticalDragDown: (details) {
//                                 logger('down: ${details.localPosition}');
//                               },
//                               onVerticalDragStart: (details) {
//                                 logger('start: ${details.kind}');
//                               },
//                               onVerticalDragCancel: () {
//                                 logger('cancel');
//                               },
//                               onVerticalDragEnd: (details) {
//                                 // logger('onVerticalDragEnd');
//                                 oldDy = 0;
//                                 reversed = false;
//                               },
//                               child: const Icon(
//                                 Icons.circle,
//                               ))
