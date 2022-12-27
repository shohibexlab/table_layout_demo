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
    return GetBuilder<CanvasController>(
      id: GridConstants.gridCanvasId,
      builder: (ctr) => InteractiveViewer(
        child: GridPaper(
          key: GlobalKeyConstants.canvasGridKey,
          divisions: 2,
          color: GridDecorations.defaultGridColor,
          interval: Constants.defaultGridInterval,
          subdivisions: Constants.defaultGridSubdivision,
          child: Container(
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
                  Stack(
                    children: [
                      Positioned(
                          top: table.controller.getOffset.dy,
                          left: table.controller.getOffset.dx,
                          child: DraggableWidget(table: table)),
                      Positioned(
                          top: table.controller.getOffset.dy - 10,
                          left: table.controller.getOffset.dx -
                              10 +
                              table.controller.getSize.width / 2,
                          child: GestureDetector(
                              onVerticalDragUpdate: (details) {
                                const subtract = 10;
                                final lcPosition = details.localPosition;
                                Offset wentUpTo = Offset(lcPosition.dx,
                                        (lcPosition.dy - subtract).abs())
                                    .toCellIndex;

                                bool isGoingUp = details.delta.dy < 0;
                                if (details.delta.dy == 0.0) {
                                  return;
                                }
                                DragDirection newDragDir = dragDirection;
                                if (newDragDir == DragDirection.none) {
                                  if (isGoingUp) {
                                    newDragDir = DragDirection.up;
                                  } else {
                                    newDragDir = DragDirection.down;
                                  }
                                  dragDirection = newDragDir;
                                  return;
                                }
                                if (isGoingUp) {
                                  newDragDir = DragDirection.up;
                                } else {
                                  newDragDir = DragDirection.down;
                                }

                                if (newDragDir != dragDirection) {
                                  dragDirection = newDragDir;
                                  print("Direction Changed to $newDragDir");
                                  // oldDy = 0;
                                  reversed = true;
                                  _handleDirChange(table, wentUpTo);
                                } else {
                                  _handleResize(table, wentUpTo);
                                }
                              },
                              onTap: () {
                                final RenderBox? renderBox = GlobalKeyConstants
                                    .canvasGridKey.currentContext
                                    ?.findRenderObject() as RenderBox?;
                                print(
                                    "renderBox: ${GlobalKeyConstants.canvasGridKey.getPosition}");
                              },
                              onVerticalDragEnd: (details) {
                                dragDirection = DragDirection.none;
                                oldDy = 0;
                                reversed = false;
                                reversedAt = 0;
                              },
                              child: const Icon(
                                Icons.circle,
                              ))),
                    ],
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
    print('DIR_CHANGE');
    // print('dy: $dy');
    // print('oldDy: $oldDy');
    // print('DIR_CHANGE');
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
      // print('RESIZE');
      // print('dy: $dy');
      // print('oldDy: $oldDy');
      // print('RESIZE');
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

      print(
          'HANDLE_REVERSED, Reversed At => $reversedAt, dy => $dy, oldDy => $oldDy');
      if (dy > reversedAt) {
        if (dragDirection == DragDirection.up) {
          print('UP');
          // table.controller.changePositionByIndex(Offset(
          //     table.controller.getOffset.toCellIndex.dx,
          //     table.controller.getOffset.toCellIndex.dy - 1.toDouble()));
          // GeneralTableController.to
          //     .onResizeTableByCellIndex(addingHeight: 1.toDouble());
          // oldDy = dy;
        } else {
          print('DOWN');
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
//                                 // print("reversed: $reversed");
//                                 // print("isGoingUp: $isGoingUp");
//                                 print("oldDragDir: $dragDirection");
//                                 print("dragDir: $dragDir");
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
//                                 // print(
//                                 //     'update ${details.globalPosition}, $isGoingUp, startDy: $startDy, delta: ${details.delta.dy}, didChangeDirection: ${details.globalPosition.dy != startDy}');
//                                 print("oldDy: $oldDy");
//                                 print("wentUpTo1: $wentUpTo1");
//                                 if (isGoingUp1) {
//                                   //dy ni yaxlitla
//                                   int dy = wentUpTo1.dy.toInt();
//                                   // if (dy < 0) dy = 0;
//                                   print('going up, dy: $dy');
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
//                                   print('going down dy: $dy');
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
//                                 print('down: ${details.localPosition}');
//                               },
//                               onVerticalDragStart: (details) {
//                                 print('start: ${details.kind}');
//                               },
//                               onVerticalDragCancel: () {
//                                 print('cancel');
//                               },
//                               onVerticalDragEnd: (details) {
//                                 // print('onVerticalDragEnd');
//                                 oldDy = 0;
//                                 dragDirection = DragDirection.none;
//                               },
//                               child: const Icon(
//                                 Icons.circle,
//                               ))

//XGestureDetector(
//                             onMoveUpdate: (details) {
//                               // print('onMoveUpdate pointer ${details.pointer}');
//                               // print('onMoveUpdate delta ${details.delta}');
//                               // print(
//                               //     'onMoveUpdate localDelta ${details.localDelta}');
//                               // print(
//                               //     'onMoveUpdate localPos ${details.localPos}');
//                               // print(
//                               //     'onMoveUpdate position ${details.position}');
//                               const subtract = 10;
//                               final lcPosition = details.localPos;
//                               final wentUpTo = Offset(lcPosition.dx,
//                                       (lcPosition.dy - subtract).abs())
//                                   .toCellIndex;
//                               bool isGoingUp = details.delta.dy < 0;
//                               print("reversed: $reversed");
//                               print("isGoingUp: $isGoingUp");
//                               if (isGoingUp != reversed) {
//                                 reversed = true;
//                                 oldDy = 0;
//                               }
//                               // print(
//                               //     'update ${details.globalPosition}, $isGoingUp, startDy: $startDy, delta: ${details.delta.dy}, didChangeDirection: ${details.globalPosition.dy != startDy}');
//                               if (isGoingUp) {
//                                 if (reversed) {
//                                   reversed = false;
//                                   oldDy = 0;
//                                 }
//                                 //dy ni yaxlitla
//                                 int dy = wentUpTo.dy.toInt();
//                                 // print('going up, dy: $dy');
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
//                                 // print('going down $dy');
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
//                                 // print("reversed: $reversed");
//                                 // print(
//                                 //     'update ${details.globalPosition}, $isGoingUp, startDy: $startDy, delta: ${details.delta.dy}, didChangeDirection: ${details.globalPosition.dy != startDy}');
//                                 if (isGoingUp) {
//                                   if (reversed) {
//                                     reversed = false;
//                                     oldDy = 0;
//                                   }
//                                   //dy ni yaxlitla
//                                   int dy = wentUpTo.dy.toInt();
//                                   // print('going up, dy: $dy');
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
//                                   // print('going down $dy');
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
//                                 print('down: ${details.localPosition}');
//                               },
//                               onVerticalDragStart: (details) {
//                                 print('start: ${details.kind}');
//                               },
//                               onVerticalDragCancel: () {
//                                 print('cancel');
//                               },
//                               onVerticalDragEnd: (details) {
//                                 // print('onVerticalDragEnd');
//                                 oldDy = 0;
//                                 reversed = false;
//                               },
//                               child: const Icon(
//                                 Icons.circle,
//                               ))
