import 'package:flutter/material.dart';
import 'package:table_layout_demo/table/table_widget.dart';

class DraggableWidget extends StatelessWidget {
  final TableWidget table;
  const DraggableWidget({Key? key, required this.table}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSelected = table.controller.getIsSelected;
    if (isSelected) {
      return Draggable(
          onDragEnd: onDragEnd,
          onDragStarted: onDragStarted,
          childWhenDragging: const SizedBox(),
          feedback: Material(color: Colors.transparent, child: table),
          child: table);
    } else {
      return GestureDetector(
          onPanStart: (details) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                    "You can only drag selected tables. Please select the table first.")));
          },
          child: table);
    }
  }

  void onDragStarted() async {
    print("Drag started");
  }

  void onDragEnd(DraggableDetails o) {
    print("DraggableDetails: ${o.offset}");
    table.controller.changePosition(o.offset);
  }
}
