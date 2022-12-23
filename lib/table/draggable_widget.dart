import 'package:flutter/material.dart';
import 'package:indexed/indexed.dart';
import 'package:table_layout_demo/canvas_controller.dart';
import 'package:table_layout_demo/table/table_widget.dart';

class DraggableWidget extends StatelessWidget with IndexedInterface {
  final TableWidget table;
  const DraggableWidget({Key? key, required this.table}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSelected = table.controller.getIsSelected;
    if (isSelected) {
      return Draggable(
          onDragEnd: onDragEnd,
          onDragStarted: onDragStarted,
          feedback: Material(color: Colors.transparent, child: table),
          child: table);
    } else {
      return GestureDetector(
          onPanStart: (details) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                duration: Duration(seconds: 5),
                content: Text(
                    "You can only drag selected tables. Please select the table first.")));
          },
          child: table);
    }
  }

  void onDragStarted() {}

  void onDragEnd(DraggableDetails o) {
    table.controller.changePosition(o.offset);
  }

  @override
  int get index {
    print(CanvasController.to.tables.indexOf(table));
    return CanvasController.to.tables.indexOf(table);
  }
}
