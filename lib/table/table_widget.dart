import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_layout_demo/canvas_controller.dart';
import 'package:table_layout_demo/table/table_controller.dart';

class TableWidget extends StatelessWidget {
  final TableController controller;
  final VoidCallback? onTap;
  TableWidget({Key? key, required this.controller, this.onTap})
      : super(key: key);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'TableWidget(key: $key, controller: ${controller.toString()})';
  }

  Color color = Colors.red.withOpacity(0.5);
  Icon icon = const Icon(
    Icons.do_not_disturb_on_total_silence_outlined,
    color: Colors.blueAccent,
    size: 20,
  );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CanvasController>(
      builder: (canvasCtr) => GestureDetector(
        onTap: () {
          CanvasController.to.selectTable(controller);
          onTap?.call();
        },
        child: SizedBox(
          width: controller.getSize.width,
          height: controller.getSize.height,
          child: Container(
              decoration: BoxDecoration(
                borderRadius: _getRadius(),
                color: _getColor(),
              ),
              height: controller.getSize.height,
              width: controller.getSize.width,
              child: Center(
                  child: Text(
                      "${controller.getTableName}\nIs Selected: ${controller.getIsSelected}"))),
        ),
      ),
    );
  }

  Color _getColor() {
    if (controller.getIsSelected) {
      return Colors.blueAccent;
    } else {
      return Colors.black38;
    }
  }

  BorderRadiusGeometry _getRadius() {
    switch (controller.getShape) {
      case TableShape.circle:
        return BorderRadius.circular(controller.getSize.width / 2);
      case TableShape.rectangle:
      default:
        return BorderRadius.zero;
    }
  }
}
