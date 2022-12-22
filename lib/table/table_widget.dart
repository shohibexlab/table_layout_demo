import 'package:flutter/material.dart';
import 'package:table_layout_demo/table/table_controller.dart';

class TableWidget extends StatefulWidget {
  final TableController controller;
  TableWidget({Key? key, required this.controller}) : super(key: key);

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  Color color = Colors.red.withOpacity(0.5);
  Icon icon = const Icon(
    Icons.do_not_disturb_on_total_silence_outlined,
    color: Colors.blueAccent,
    size: 20,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.controller.getSize.width,
      height: widget.controller.getSize.height,
      child: Container(
          color: color,
          height: widget.controller.getSize.height,
          width: widget.controller.getSize.width),
    );
  }
}
