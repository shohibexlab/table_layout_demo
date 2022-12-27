import 'package:get/get.dart';
import 'package:table_layout_demo/canvas_controller.dart';
import 'package:table_layout_demo/table/table_controller.dart';
import 'constants.dart';
import './utils.dart';

class GeneralTableController extends GetxController {
  static GeneralTableController get to => Get.find();

  void onResizeTableByCellIndex({double? addingWidth, double? addingHeight}) {
    if (addingWidth != null || addingHeight != null) {
      final getSelectedTable = CanvasController.to.getSelectedTable;
      if (getSelectedTable != null) {
        double width = getSelectedTable.controller.getSize.toCellIndex.width;
        double height = getSelectedTable.controller.getSize.toCellIndex.height;
        if (addingWidth != null) {
          width += addingWidth;
          CanvasController.to.widthTEC.text = width.toString();
        }
        if (addingHeight != null) {
          height += addingHeight;
          CanvasController.to.heightTEC.text = height.toString();
        }
        getSelectedTable.controller
            .setSize(height: height, width: width, isAsCellIndex: true);
        CanvasController.to.update([GridConstants.gridCanvasTableId]);
      }
    }
  }

  void onChangeTableSize({String? width, String? height}) {
    if (width != null || height != null) {
      final getSelectedTable = CanvasController.to.getSelectedTable;
      final widthTEC = CanvasController.to.widthTEC;
      final heightTEC = CanvasController.to.heightTEC;
      if (width != null) {
        if ((width.isNotEmpty && width != "0") && (num.parse(width) > 0)) {
          widthTEC.text = width;
        } else if (getSelectedTable != null && width == "0") {
          widthTEC.text =
              getSelectedTable.controller.getSize.toCellIndex.width.toString();
        } else {
          if (getSelectedTable != null) {
            widthTEC.text = getSelectedTable
                .controller.getSize.toCellIndex.width
                .toString();
          }
        }
      }
      if (height != null) {
        if ((height.isNotEmpty && height != "0") && (num.parse(height) > 0)) {
          heightTEC.text = height;
        } else if ((getSelectedTable != null && height == "0")) {
          heightTEC.text =
              getSelectedTable.controller.getSize.toCellIndex.height.toString();
        } else {
          if (getSelectedTable != null) {
            heightTEC.text = getSelectedTable
                .controller.getSize.toCellIndex.height
                .toString();
          }
        }
      }

      // print("widthTEC.text: ${widthTEC.text}");
      // print("heightTEC.text: ${heightTEC.text}");
      // print("Offset: ${getSelectedTable?.controller.getOffsetAsCellIndex}");
      getSelectedTable?.controller.setSize(
          isAsCellIndex: true,
          height: double.parse(heightTEC.text),
          width: double.parse(widthTEC.text));
      CanvasController.to.update([GridConstants.gridCanvasTableId]);
    }
  }

  void onChangeTableShape(TableShape shape) {
    final getSelectedTable = CanvasController.to.getSelectedTable;
    if (getSelectedTable != null) {
      getSelectedTable.controller.changeShape(shape);

      CanvasController.to.update([
        GridConstants.gridCanvasTableId,
        GridConstants.gridSidebarTablePropsId,
      ]);
    }
  }
}
