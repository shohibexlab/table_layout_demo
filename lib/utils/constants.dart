import 'package:flutter/material.dart';
import 'package:table_layout_demo/utils/utils.dart';

class GlobalKeyConstants {
  static GlobalKey canvasGridKey = GlobalKey(debugLabel: 'CANVAS_GRID_KEY');
}

class GridSettingsConstants {
  static double defaultGridInterval = 10;

  static const int columnCount = 10;
  static const double columnGutter = 30;
  static const Color columnColor = Colors.pink;

  ///When true, the selected table can go off through the canvas boundaries
  ///
  /// Default to: false
  static bool canItemGoOffCanvasBoundaries = false;

  ///Number of cells in the grid => (x,y)
  ///
  /// Default to: (x = 120, y = 10)
  static Offset defaultGridCells =
      const Offset(108, 16); // Number of pixels in the grid x and y

  static Size defaultGridCellSize = const Size(10, 10);

  /// Makes 1 cell [_defaultGridCellSize.height] pixels
  static int get defaultGridSubdivision =>
      defaultGridInterval ~/ defaultGridCellSize.height;
  static Size get defaultTableSize =>
      const Size(8, 8).toSizeFromCellIndex; // 8 is pixels of table
  static double defaultSidebarWidth = 300;
}

class GridConstants {
  static const String gridCanvasId = "grid_canvas";
  static const String gridSidebarTablePropsId = "sidebar_table_props";
  static const String gridSidebarBarTableListId = "sidebar_table_list";
}

class GridDecorations {
  static Color defaultGridColor = Colors.black12;
  static String? defaultGridBackgroundImage = null; //"assets/floor.jpg";
  static Color defaultBackgroundColor = Colors.black12;
}
