import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indexed/indexed.dart';
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
            color: Colors.transparent, //black12
            interval: Constants.defaultGridInterval,
            subdivisions: Constants.defaultGridSubdivision,
            child: Indexer(
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
                for (int i = 0; i < ctr.tables.length; i++)
                  Positioned(
                    top: ctr.tables[i].controller.getOffset.dy,
                    left: ctr.tables[i].controller.getOffset.dx,
                    child: Stack(
                      children: [
                        DraggableWidget(table: ctr.tables[i]),
                        // Positioned(
                        //     top: table.controller.getOffset.dy - 10,
                        //     left: table.controller.getOffset.dx -
                        //         10 +
                        //         table.controller.getSize.width / 2,
                        //     child: GestureDetector(
                        //         onVerticalDragUpdate: (details) {
                        //           final lcPosition = details.localPosition;
                        //           bool isGoingUp = details.delta.dy < 0;
                        //           const subtractor = 10;
                        //           // print('table: ${table.controller.getOffset}');
                        //           print(
                        //               'lcPosition: ${lcPosition.dy - subtractor}');
                        //           print(
                        //               "TEST: ${(lcPosition.dy - 10) * Constants.defaultGridCellSize.height}");
                        //
                        //           GeneralTableController.to.onResizeTable(
                        //             addingHeight: -((lcPosition.dy - 10) *
                        //                     Constants
                        //                         .defaultGridCellSize.height) *
                        //                 0.08,
                        //           );
                        //         },
                        //         child: const Icon(Icons.circle))),
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
}
