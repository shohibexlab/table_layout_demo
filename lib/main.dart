import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:table_layout_demo/table/table_controller.dart';

import 'table/table_widget.dart';

class Constants {
  static const defaultScreenPadding = 60.0;
  static Size _defaultGridCellSize = const Size(10, 10);
  static Size get defaultGridCellSize => _defaultGridCellSize;
  static set setDefaultGridCellSize(Size size) => _defaultGridCellSize = size;
  static Size get defaultContainerSize => Size(200, 200);
}

void main() {
  debugRepaintRainbowEnabled = true;
  runApp(MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      home: const Material(child: Homepage())));
}

class CustomContainer extends StatefulWidget {
  const CustomContainer({Key? key}) : super(key: key);

  @override
  State<CustomContainer> createState() => CustomContainerState();
}

class CustomContainerState extends State<CustomContainer> {
  Size size = Constants.defaultContainerSize;
  Offset offset = const Offset(0, 0);

  void changePosition(Offset o) {
    Offset off = Offset(o.dx - Constants.defaultScreenPadding,
        o.dy - Constants.defaultScreenPadding);
    final yRemainder = off.dy % Constants.defaultGridCellSize.height;
    final xRemainder = off.dx % Constants.defaultGridCellSize.width;
    final halfCell = Constants.defaultGridCellSize.width / 2;
    if (xRemainder != 0) {
      double dx = off.dx;
      if (halfCell < xRemainder) {
        final temp = Constants.defaultGridCellSize.width - xRemainder;
        dx += temp;
      } else if (halfCell > xRemainder) {
        dx -= xRemainder;
      }
      off = Offset(dx, off.dy);
    }
    if (yRemainder != 0) {
      double dy = off.dy;
      if (halfCell < yRemainder) {
        final temp = Constants.defaultGridCellSize.width - yRemainder;
        dy += temp;
      } else if (halfCell > yRemainder) {
        dy -= yRemainder;
      }
      off = Offset(off.dx, dy);
    }
    setState(() {
      offset = off;
    });
  }

  void increaseSizeBy(double width, double height) {
    setState(() {
      Constants.setDefaultGridCellSize = Size(width, height);
      size = Size(size.width + width, size.height + height);
    });
  }

  Icon icon = const Icon(
    Icons.do_not_disturb_on_total_silence_outlined,
    color: Colors.blueAccent,
    size: 20,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Container(
          color: Colors.red.withOpacity(0.5),
          height: size.height,
          width: size.width),
    );
  }
  //Stack(
//         children: [
//           Positioned(
//               child: Container(
//                   color: Colors.red.withOpacity(0.5),
//                   height: size.height,
//                   width: size.width)),
//           Positioned(
//               top: size.height - 10,
//               left: (size.width - (icon.size?.toDouble() ?? 0.0)) / 2,
//               child: icon),
//           Positioned(
//               left: size.width - 10,
//               top: (size.width - (icon.size?.toDouble() ?? 0.0)) / 2,
//               child: icon),
//         ],
//       )
}

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      floatingActionButton: SizedBox(
        width: 100,
        height: 100,
        child: FloatingActionButton(
          onPressed: () {
            // print(customContainer?.controller.getSize);
            // final State<TableWidgetState> cs = customContainer!.createState();
            // final LabeledGlobalKey<CustomContainerState> k = customContainer!
            //     .key as LabeledGlobalKey<CustomContainerState>;
            // k.currentState?.increaseSizeBy(interval / 10, interval / 10);
          },
          child: const Icon(
            Icons.edit,
            size: 50,
          ),
        ),
      ),
      body: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(Constants.defaultScreenPadding),
            width: MediaQuery.of(context).size.width - 300,
            height: MediaQuery.of(context).size.height,
            child: Container(
              color: Colors.white,
              child: const GridCanvas(),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: Colors.black)),
              color: Colors.white,
            ),
            width: 300,
            height: MediaQuery.of(context).size.height,
            child: const Center(child: Text('Sidebar Utils')),
          ),
        ],
      ),
    );
  }
}

class CustomDraggable extends StatelessWidget {
  const CustomDraggable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class GridCanvas extends StatefulWidget {
  const GridCanvas({Key? key}) : super(key: key);

  @override
  State<GridCanvas> createState() => _GridCanvasState();
}

class _GridCanvasState extends State<GridCanvas> {
  TableWidget? customContainer;
  TableWidget? customContainerFeedback;
  late TableController ctr;
  @override
  void initState() {
    super.initState();
    ctr = TableController();
    customContainer = TableWidget(
      controller: ctr,
    );
    customContainerFeedback = TableWidget(controller: ctr);
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      child: GridPaper(
        divisions: 2,
        color: Colors.black26,
        interval: 100,
        subdivisions: 5,
        child: Stack(
          children: [
            Positioned(
              // left: ctr.getOffset.dx,
              // top: ctr.getOffset.dy,
              child: TextButton(
                child: const Text('test'),
                onPressed: () {
                  print(ctr.value.key);
                },
              ),
            ),
            Positioned(
              left: ctr.getOffset.dx,
              top: ctr.getOffset.dy,
              child: Draggable(
                  onDraggableCanceled: onDraggableCanceled,
                  onDragStarted: onDragStarted,
                  feedback: Container(
                    width: 200,
                    height: 200,
                    color: Colors.blueGrey.withOpacity(0.5),
                  ),
                  child: customContainer!),
            ),
          ],
        ),
      ),
    );
  }

  void onDragStarted() {}

  void onDraggableCanceled(Velocity v, Offset o) {
    // final LabeledGlobalKey<CustomContainerState> k =
    //     customContainer!.key as LabeledGlobalKey<CustomContainerState>;
    // final LabeledGlobalKey<CustomContainerState> k1 =
    //     customContainer!.key as LabeledGlobalKey<CustomContainerState>;
    ctr.changePosition(o);
    print(ctr.getOffset);
    setState(() {});
    // k1.currentState?.changePosition(o);
  }
}
