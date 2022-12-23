import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_layout_demo/general_table_controller.dart';
import '../canvas_controller.dart';
import '../constants.dart';
import 'draggable_widget.dart';

class GridCanvas extends StatelessWidget {
  const GridCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CanvasController>(
      id: Constants.defaultGridConstants.gridCanvasId,
      builder: (ctr) => InteractiveViewer(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
            // image: DecorationImage(
            //   image: AssetImage('assets/images/room.png'),
            //   fit: BoxFit.cover,
            // ),
          ),
          child: GridPaper(
            divisions: 2,
            color: Colors.black12, //black26
            interval: Constants.defaultGridInterval,
            subdivisions: Constants.defaultGridSubdivision,
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
                                final lcPosition = details.localPosition;
                                final buttonPt = table.controller.getOffset.dy;
                                final wentUpTo = lcPosition.dy - 10;
                                final res = wentUpTo.abs().toInt() /
                                    Constants.defaultGridCellSize.height;
                                bool isGoingUp = details.delta.dy < 0;
                                print('isGoingUp: $isGoingUp');
                                print(
                                    'Button is: ${table.controller.getOffset.dy}');
                                print('I went: ${wentUpTo}');
                                // const subtractor = 10;
                                // // print('table: ${table.controller.getOffset}');
                                // // print(
                                // //     'lcPosition: ${lcPosition.dy - subtractor}');
                                // print(
                                //     "TEST: ${(lcPosition.dy - 10) * Constants.defaultGridCellSize.height}");
                                //
                                // GeneralTableController.to.onResizeTable(
                                //   addingHeight: -((lcPosition.dy - 10) *
                                //           Constants
                                //               .defaultGridCellSize.height) *
                                //       0.08,
                                // );
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
}
