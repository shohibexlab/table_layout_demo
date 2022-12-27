import 'package:flutter/material.dart';
import 'package:table_layout_demo/utils.dart';

class GlobalKeyConstants {
  static GlobalKey canvasGridKey = GlobalKey(debugLabel: 'CANVAS_GRID_KEY');
}

class Constants {
  static const double defaultGridInterval = 100;

  static Offset defaultGridCells =
      const Offset(120, 70); // Number of pixels in the grid x and y

  static Size defaultGridCellSize = const Size(10, 10);

  /// Makes 1 cell [_defaultGridCellSize.height] pixels
  static int get defaultGridSubdivision =>
      defaultGridInterval ~/ defaultGridCellSize.height;
  static set setDefaultGridCellSize(Size size) => defaultGridCellSize = size;
  static Size get defaultTableSize =>
      Size(defaultGridCellSize.width * 10, defaultGridCellSize.height * 10)
          .toCellIndex;
  static const double defaultSidebarWidth = 300;
}

class GridConstants {
  static const String gridCanvasId = "grid_canvas";
  static const String gridCanvasTableId = "grid_canvas_table";
  static const String gridSidebarTablePropsId = "sidebar_table_props";
  static const String gridSidebarBarTableListId = "sidebar_table_list";
}

class GridDecorations {
  static const Color defaultGridColor = Colors.black12;
  static const Color defaultBackgroundColor = Colors.white;
}
