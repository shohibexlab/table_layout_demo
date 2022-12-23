import 'package:flutter/material.dart';
import 'package:table_layout_demo/canvas_controller.dart';
import 'package:table_layout_demo/table/table_widget.dart';

class CustomDraggableWidget extends StatelessWidget {
  final TableWidget table;
  const CustomDraggableWidget({Key? key, required this.table})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable(
        onDraggableCanceled: onDraggableCanceled,
        onDragStarted: onDragStarted,
        feedback: Container(
          width: table.controller.getSize.width,
          height: table.controller.getSize.height,
          color: Colors.blueGrey.withOpacity(0.5),
        ),
        child: table);
  }

  void onDragStarted() {}

  void onDraggableCanceled(Velocity v, Offset o) {
    table.controller.changePosition(o);
    CanvasController.to.update();
  }
}
