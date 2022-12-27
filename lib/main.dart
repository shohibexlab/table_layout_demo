import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_layout_demo/canvas_controller.dart';
import 'package:table_layout_demo/general_table_controller.dart';
import 'package:table_layout_demo/sidebar_widget.dart';
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
      backgroundColor: Colors.black26,
      body: GridPaper(
        divisions: 2,
        color: Colors.redAccent.withOpacity(.0),
        interval: Constants.defaultGridInterval,
        subdivisions: Constants.defaultGridSubdivision,
        child: Row(
          children: [
            Expanded(
              child: Align(
                child: SizedBox(
                  width: (Constants.defaultGridCellSize.width *
                      Constants.defaultGridCells.dx),
                  height: (Constants.defaultGridCellSize.height *
                      Constants.defaultGridCells.dy),
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
