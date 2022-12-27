import 'package:get/get.dart';
import 'package:table_layout_demo/canvas_controller.dart';
import './utils.dart';

class GeneralTableController extends GetxController {
  static GeneralTableController get to => Get.find();

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

      getSelectedTable?.controller.changeSize(
          isAsCellIndex: true,
          height: double.parse(heightTEC.text),
          width: double.parse(widthTEC.text));
    }
  }
}
