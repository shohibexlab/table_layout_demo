import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_layout_demo/canvas_controller.dart';
import 'package:table_layout_demo/main.dart';
import 'package:table_layout_demo/table/table_controller.dart';
import 'package:table_layout_demo/table/table_widget.dart';

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: Colors.black)),
        color: Colors.white,
      ),
      width: Constants.defaultSidebarWidth,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Center(
                child: Text(
                  'Room #1',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (int i = 0; i < 5; i++) _buildTableButton("Table $i"),
                    ],
                  ),
                ),
              ),
              const Divider(color: Colors.blueGrey),
              const SizedBox(height: 20),
              GetBuilder<CanvasController>(
                  builder: (controller) => _buildTableParamsWidget(controller)),
            ],
          ),
          GetBuilder<CanvasController>(
            id: "table_props",
            assignId: true,
            builder: (controller) => TextButton(
                onPressed: controller.getSelectedTable != null
                    ? controller.removeTable
                    : null,
                style: TextButton.styleFrom(
                    minimumSize: const Size(Constants.defaultSidebarWidth, 50),
                    side: const BorderSide(
                      color: Colors.blueGrey,
                      width: 1,
                    )),
                child: const Text("Delete")),
          ),
        ],
      ),
    );
  }

  Widget _buildTableParamsWidget(CanvasController controller) {
    List<Widget> params = [];
    Widget getTitle(String title) {
      return Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    Widget getShapeWidget(TableShape shape) {
      void _onTap() {
        print("shape: $shape");
      }

      bool isSelected =
          controller.getSelectedTable?.controller.getShape == shape;
      // print("isSelected: ${controller.selectedTable.toString()}");
      switch (shape) {
        case TableShape.rectangle:
          return GestureDetector(
            onTap: _onTap,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              padding: const EdgeInsets.all(5),
              child: const SizedBox(
                width: 50,
                height: 30,
              ),
            ),
          );
        case TableShape.circle:
          return GestureDetector(
            onTap: _onTap,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              padding: const EdgeInsets.all(5),
              child: Container(
                width: 50,
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(18)),
                ),
              ),
            ),
          );
      }
    }

    params.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getTitle("Shape"),
          Row(
            children: [
              getShapeWidget(TableShape.rectangle),
              const SizedBox(width: 10),
              getShapeWidget(TableShape.circle),
            ],
          )
        ],
      ),
    );

    params.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getTitle("Width"),
          SizedBox(
            width: 150,
            height: 30,
            child: TextFormField(
              onChanged: (value) {
                print("width: $value");
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter table width',
                hintStyle: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );

    params.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getTitle("Height"),
          SizedBox(
            width: 150,
            height: 30,
            child: TextFormField(
              onChanged: (value) {
                print("height: $value");
                controller.heightTEC.text = value;
                controller.getSelectedTable?.controller.setSize(
                  height: double.parse(controller.heightTEC.text),
                );
              },
              keyboardType: TextInputType.number,
              controller: controller.heightTEC,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter table height',
                hintStyle: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );

    return Column(
      children: [
        for (Widget param in params) ...[
          param,
          const SizedBox(height: 20),
        ],
      ],
    );
  }

  Widget _buildTableButton(String title) {
    print("build table button");
    return GestureDetector(
      onTap: () {
        CanvasController.to.addTable(TableController(tableName: title));
      },
      child: Container(
        width: 80,
        height: 70,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey),
          color: Colors.black12,
        ),
        child: Center(child: Text(title)),
      ),
    );
  }
}
