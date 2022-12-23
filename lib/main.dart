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
