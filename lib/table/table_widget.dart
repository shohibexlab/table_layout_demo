import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_layout_demo/canvas_controller.dart';
import 'package:table_layout_demo/table/table_controller.dart';

import '../constants.dart';

class TableWidget extends StatelessWidget {
  final TableController controller;
  final VoidCallback? onTap;
  TableWidget({Key? key, required this.controller, this.onTap})
      : super(key: key);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'TableWidget(key: $key, controller: ${controller.toString()})';
  }

  // Icon icon = const Icon(
  //   Icons.do_not_disturb_on_total_silence_outlined,
  //   color: Colors.blueAccent,
  //   size: 20,
  // );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CanvasController>(
        id: Constants.defaultGridConstants.gridCanvasTableId,
        builder: (ctr) {
          String tableName = controller.getTableName;
          // if (kDebugMode) {
          //   tableName += "\nIs Selected: ${controller.getIsSelected}";
          // }
          return GestureDetector(
            onTap: onTap ?? () => CanvasController.to.selectTable(controller),
            child: SizedBox(
              width: controller.getSize.width,
              height: controller.getSize.height,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: _getRadius(),
                    color: _getColor(),
                    border: _getBorder(),
                  ),
                  height: controller.getSize.height,
                  width: controller.getSize.width,
                  child: Stack(
                    children: [
                      // Positioned(
                      //     child: Center(
                      //   child: Container(
                      //     width: 10,
                      //     height: 10,
                      //     decoration: BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       color: Colors.red,
                      //     ),
                      //   ),
                      // )),
                      Center(
                          child: Text(tableName,
                              style:
                                  controller.getTableDecoration.getTextStyle)),
                    ],
                  )),
            ),
          );
        });
  }

  Border _getBorder() {
    bool isSelected = controller.getIsSelected;
    if (isSelected) {
      return controller.getTableDecoration.getActiveBorder;
    } else {
      return controller.getTableDecoration.getInactiveBorder;
    }
    // return controller.getIsSelected
    //     ? Border.all(color: Colors.blueAccent, width: 2)
    //     : Border.all(color: Colors.transparent, width: 2);
  }

  Color _getColor() {
    if (controller.getIsSelected) {
      return controller.getTableDecoration.getActiveBgColor;
    } else {
      return controller.getTableDecoration.getInactiveBgColor;
    }
  }

  BorderRadiusGeometry _getRadius() {
    switch (controller.getTableShape) {
      case TableShape.circle:
        return BorderRadius.circular(controller.getSize.width / 2);
      case TableShape.rectangle:
      default:
        return BorderRadius.zero;
    }
  }
}
