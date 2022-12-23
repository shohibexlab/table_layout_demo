import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../canvas_controller.dart';
import '../constants.dart';
import 'custom_draggable_widget.dart';

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
                  Positioned(
                    top: table.controller.getOffset.dy,
                    left: table.controller.getOffset.dx,
                    child: CustomDraggableWidget(table: table),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
