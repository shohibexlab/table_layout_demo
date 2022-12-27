import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_layout_demo/canvas_controller.dart';
import 'package:table_layout_demo/table/table_controller.dart';

import '../constants.dart';

class TableWidget extends StatelessWidget {
  final TableController controller;
  final VoidCallback? onTap;
  bool? isDisabled;
  TableWidget(
      {Key? key, required this.controller, this.onTap, this.isDisabled = false})
      : super(key: key) {
    isDisabled ?? false;
  }

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
        id: GridConstants.gridCanvasTableId,
        builder: (ctr) {
          String tableName = controller.getTableName;
          return InkWell(
            onTap: isDisabled!
                ? null
                : (onTap ?? () => CanvasController.to.selectTable(controller)),
            child: Opacity(
              opacity: isDisabled! ? 0.5 : 1,
              child: SizedBox(
                width: controller.getSize.height,
                height: controller.getSize.height,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: _getRadius(), color: _getColor()),
                    // height: controller.getSize.height,
                    // width: controller.getSize.height,
                    child: Center(
                        child: Text(tableName,
                            style:
                                controller.getTableDecoration.getTextStyle))),
              ),
            ),
          );
        });
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
