import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:table_layout_demo/canvas_controller.dart';
import 'package:table_layout_demo/sidebar_widget.dart';
import 'package:table_layout_demo/table/custom_draggable_widget.dart';

class Constants {
  static const defaultCanvasPadding = 60.0;
  static const double defaultGridInterval = 100;
  static Size _defaultGridCellSize = const Size(10, 10);
  static Size get defaultGridCellSize => _defaultGridCellSize;
  static set setDefaultGridCellSize(Size size) => _defaultGridCellSize = size;
  static Size get defaultContainerSize => const Size(200, 200);
  static const double defaultSidebarWidth = 300;
}

void main() {
  // debugRepaintRainbowEnabled = true;
  Get.lazyPut(() => CanvasController());
  runApp(const MaterialApp(home: Material(child: Homepage())));
}

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(Constants.defaultCanvasPadding),
            width: MediaQuery.of(context).size.width - 300,
            height: MediaQuery.of(context).size.height,
            child: const GridCanvas(),
          ),
          const SidebarWidget(),
        ],
      ),
    );
  }
}

class GridCanvas extends StatelessWidget {
  const GridCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CanvasController>(
      id: "canvas",
      builder: (ctr) => InteractiveViewer(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: GridPaper(
            divisions: 2,
            color: Colors.black26,
            interval: Constants.defaultGridInterval,
            subdivisions: 5,
            child: Stack(
              children: [
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
