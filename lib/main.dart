import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:table_layout_demo/canvas_controller.dart';
import 'package:table_layout_demo/general_table_controller.dart';
import 'package:table_layout_demo/sidebar_widget.dart';
import 'package:table_layout_demo/utils.dart';
import 'constants.dart';
import 'table/grid_canvas_widget.dart';

void main() {
  debugRepaintRainbowEnabled = false;
  Get.lazyPut(() => CanvasController());
  Get.lazyPut(() => GeneralTableController());
  runApp(const MaterialApp(
      // showPerformanceOverlay: true,
      home: Material(child: Homepage())));
}

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final BoxConstraints constraints = BoxConstraints(
    //   maxWidth: Get.width,
    //   maxHeight: Get.height,
    // );
    // logger('Screen size : => ${constraints.maxWidth} ${constraints.maxHeight}');
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          logger("Canvas Size : ${GlobalKeyConstants.canvasGridKey.getSize}");
          logger(
              "Canvas left top corner : ${CanvasController.to.getLeftTopCorner}");
          logger(
              "Canvas right top corner : ${CanvasController.to.getRightTopCorner}");
          logger(
              "Canvas left bottom corner : ${CanvasController.to.geLeftBottomCorner}");
          logger(
              "Canvas right bottom corner : ${CanvasController.to.getRightBottomCorner}");

          logger("--------------------------");
          logger(
              "Selected table center position : ${CanvasController.to.getSelectedTable?.controller.getCenterOffset}");
          logger(
              "Selected table left top corner : ${CanvasController.to.getSelectedTable?.controller.getLeftTopCorner}");
          logger(
              "Selected table right top corner : ${CanvasController.to.getSelectedTable?.controller.getRightTopCorner}");
          logger(
              "Selected table left bottom corner : ${CanvasController.to.getSelectedTable?.controller.getLeftBottomCorner}");
          logger(
              "Table touching top : ${CanvasController.to.getSelectedTable?.controller.isTouchingCanvasTop}");
          logger(
              "Table touching left : ${CanvasController.to.getSelectedTable?.controller.isTouchingCanvasLeft}");
          logger(
              "Table touching right : ${CanvasController.to.getSelectedTable?.controller.isTouchingCanvasRight}");
          logger(
              "Table touching bottom : ${CanvasController.to.getSelectedTable?.controller.isTouchingCanvasBottom}");
          // CanvasController.to.getSelectedTable?.controller.moveToBottomLeft();
        },
        label: const Text(
          'Test Button',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      backgroundColor: Colors.black26,
      body: Row(
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
    );
  }
}
