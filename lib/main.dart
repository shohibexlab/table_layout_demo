import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_layout_demo/canvas_controller.dart';
import 'package:table_layout_demo/general_table_controller.dart';
import 'package:table_layout_demo/sidebar_widget.dart';
import 'package:table_layout_demo/utils.dart';
import 'constants.dart';
import 'table/grid_canvas_widget.dart';

void main() {
  // debugRepaintRainbowEnabled = true;
  Get.lazyPut(() => CanvasController());
  Get.lazyPut(() => GeneralTableController());
  runApp(const MaterialApp(home: Material(child: Homepage())));
}

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BoxConstraints constraints = BoxConstraints(
      maxWidth: Get.width,
      maxHeight: Get.height,
    );
    print('Screen size : => ${constraints.maxWidth} ${constraints.maxHeight}');
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print("Canvas Size : ${GlobalKeyConstants.canvasGridKey.getSize}");
          print(
              "Canvas left top corner : ${CanvasController.to.getLeftTopCorner}");
          print(
              "Canvas right top corner : ${CanvasController.to.getRightTopCorner}");
          print(
              "Canvas left bottom corner : ${CanvasController.to.geLeftBottomCorner}");
          print(
              "Canvas right bottom corner : ${CanvasController.to.getRightBottomCorner}");

          print("--------------------------");
          print(
              "Selected table center position : ${CanvasController.to.getSelectedTable?.controller.getCenterOffset}");
          print(
              "Selected table left top corner : ${CanvasController.to.getSelectedTable?.controller.getLeftTopCorner}");
          print(
              "Selected table right top corner : ${CanvasController.to.getSelectedTable?.controller.getRightTopCorner}");
          print(
              "Selected table left bottom corner : ${CanvasController.to.getSelectedTable?.controller.getLeftBottomCorner}");
          print(
              "Table touching top : ${CanvasController.to.getSelectedTable?.controller.isTouchingCanvasTop}");
          print(
              "Table touching left : ${CanvasController.to.getSelectedTable?.controller.isTouchingCanvasLeft}");
          print(
              "Table touching right : ${CanvasController.to.getSelectedTable?.controller.isTouchingCanvasRight}");
          print(
              "Table touching bottom : ${CanvasController.to.getSelectedTable?.controller.isTouchingCanvasBottom}");
          // CanvasController.to.getSelectedTable?.controller.moveToCenter();
        },
        label: const Text(
          'Test Button',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      backgroundColor: Colors.black26,
      body: GridPaper(
        divisions: 2,
        color: Colors.redAccent.withOpacity(.0),
        interval: GridSettingsConstants.defaultGridInterval,
        subdivisions: GridSettingsConstants.defaultGridSubdivision,
        child: Row(
          children: [
            Expanded(
              child: Align(
                child: SizedBox(
                  width: (GridSettingsConstants.defaultGridCellSize.width *
                      GridSettingsConstants.defaultGridCells.dx),
                  height: (GridSettingsConstants.defaultGridCellSize.height *
                      GridSettingsConstants.defaultGridCells.dy),
                  child: GridCanvas(),
                ),
              ),
            ),
            const SidebarWidget(),
          ],
        ),
      ),
    );
  }
}
