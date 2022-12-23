import 'package:get/get.dart';
import 'package:table_layout_demo/canvas_controller.dart';
import 'package:table_layout_demo/table/table_controller.dart';
import 'constants.dart';

class GeneralTableController extends GetxController {
  static GeneralTableController get to => Get.find();

  void onChangeTableSize({String? width, String? height}) {
    if (width != null || height != null) {
      final getSelectedTable = CanvasController.to.getSelectedTable;
      final widthTEC = CanvasController.to.widthTEC;
      final heightTEC = CanvasController.to.heightTEC;
      if (width != null) {
        if (width.isNotEmpty && width != "0") {
          widthTEC.text = width;
        } else if (getSelectedTable != null && width == "0") {
          widthTEC.text =
              getSelectedTable.controller.getSizeAsCellIndex.width.toString();
        }
      }
      if (height != null) {
        if (height.isNotEmpty && height != "0") {
          heightTEC.text = height;
        } else if (getSelectedTable != null && height == "0") {
          heightTEC.text =
              getSelectedTable.controller.getSizeAsCellIndex.height.toString();
        }
      }

      print("widthTEC.text: ${widthTEC.text}");
      print("heightTEC.text: ${heightTEC.text}");
      getSelectedTable?.controller.setSize(
          isAsCellIndex: true,
          height: double.parse(heightTEC.text),
          width: double.parse(widthTEC.text));
      CanvasController.to
          .update([Constants.defaultGridConstants.gridCanvasTableId]);
    }
  }

  void onChangeTableShape(TableShape shape) {
    final getSelectedTable = CanvasController.to.getSelectedTable;
    if (getSelectedTable != null) {
      getSelectedTable.controller.changeShape(shape);
      CanvasController.to.update([
        Constants.defaultGridConstants.gridCanvasTableId,
        Constants.defaultGridConstants.gridSidebarTablePropsId,
      ]);
    }
  }
}
