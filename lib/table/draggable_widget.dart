import 'package:flutter/material.dart';
import 'package:table_layout_demo/table/table_widget.dart';

class DraggableWidget extends StatelessWidget {
  final TableWidget table;
  const DraggableWidget({Key? key, required this.table}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSelected = table.controller.getIsSelected;
    if (isSelected) {
      return GestureDetector(onPanUpdate: onPanUpdate, child: table);
      return Draggable(
          onDragEnd: onDragEnd,
          childWhenDragging: const SizedBox(),
          feedback: Material(color: Colors.transparent, child: table),
          child: table);
    } else {
      return GestureDetector(
          onPanStart: (details) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                action: SnackBarAction(
                  onPressed: () {
                    ScaffoldMessenger.of(context).clearSnackBars();
                  },
                  label: "Close",
                ),
                content: const Text(
                    "You can only drag selected tables. Please select the table first.")));
          },
          child: table);
    }
  }

  void onDragEnd(DraggableDetails o) {
    table.controller.changePosition(o.offset);
  }

  void onPanUpdate(DragUpdateDetails details) {
    table.controller.changePosition(Offset(
        details.globalPosition.dx - table.controller.getSize.width / 2,
        details.globalPosition.dy - table.controller.getSize.height / 2));
  }
}
