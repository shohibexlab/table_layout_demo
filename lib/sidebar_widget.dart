import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_layout_demo/canvas_controller.dart';
import 'package:table_layout_demo/general_table_controller.dart';
import 'package:table_layout_demo/general_table_controller.dart';
import 'package:table_layout_demo/table/table_controller.dart';
import 'constants.dart';
import 'table/table_widget.dart';

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
              GetBuilder<CanvasController>(
                id: Constants.defaultGridConstants.gridSidebarBarTableListId,
                builder: (controller) => SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (int i = 0; i < 5; i++)
                          _buildTableButton("Table $i"),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(color: Colors.blueGrey),
              const SizedBox(height: 20),
              GetBuilder<CanvasController>(
                  id: Constants.defaultGridConstants.gridSidebarTablePropsId,
                  builder: (controller) => Opacity(
                      opacity: controller.getSelectedTable == null ? 0.5 : 1,
                      child: IgnorePointer(
                          ignoring: controller.getSelectedTable == null,
                          child: _buildTableParamsWidget(controller)))),
            ],
          ),
          GetBuilder<CanvasController>(
            id: Constants.defaultGridConstants.gridSidebarTablePropsId,
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
      void onTap() {
        GeneralTableController.to.onChangeTableShape(shape);
      }

      bool isSelected =
          controller.getSelectedTable?.controller.getTableShape == shape;
      final decoration = BoxDecoration(
        color: isSelected ? Colors.lightBlueAccent : Colors.white,
        border: Border.all(color: Colors.black, width: isSelected ? 2 : 1),
      );
      switch (shape) {
        case TableShape.rectangle:
          return GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: decoration,
              padding: const EdgeInsets.all(5),
              child: const SizedBox(
                width: 50,
                height: 30,
              ),
            ),
          );
        case TableShape.circle:
          return GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: decoration,
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
              onFieldSubmitted: (value) =>
                  GeneralTableController.to.onChangeTableSize(width: value),
              keyboardType: TextInputType.number,
              controller: controller.widthTEC,
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
              onFieldSubmitted: (value) =>
                  GeneralTableController.to.onChangeTableSize(height: value),
              // onChanged: (value) {
              //   print("height: $value");
              //   controller.heightTEC.text = value;
              //   controller.getSelectedTable?.controller.setSize(
              //     height: double.parse(controller.heightTEC.text),
              //   );
              // },
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
    return TableWidget(
      onTap: () {
        CanvasController.to.addTable(TableController(tableName: title));
      },
      controller: TableController(
          tableName: title,
          size: const Size(80, 70),
          tableDecoration: TableDecoration(
            inactiveBorder: Border.all(color: Colors.blueGrey),
            inactiveBgColor: Colors.black12,
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 11,
            ),
          )),
    );
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
