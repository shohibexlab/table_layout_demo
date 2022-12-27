import 'package:flutter/material.dart';

class GlobalKeyConstants {
  static GlobalKey canvasGridKey = GlobalKey(debugLabel: 'CANVAS_GRID_KEY');
}

class GridSettingsConstants {
  static double defaultGridInterval = 100;

  ///When true, the selected table can go off through the canvas boundaries
  ///
  /// Default to: false
  static bool canItemGoOffCanvasBoundaries = false;

  ///Number of cells in the grid => (x,y)
  ///
  /// Default to: (x = 120, y = 10)
  static Offset defaultGridCells =
      const Offset(120, 70); // Number of pixels in the grid x and y

  static Size defaultGridCellSize = const Size(10, 10);

  /// Makes 1 cell [_defaultGridCellSize.height] pixels
  static int get defaultGridSubdivision =>
      defaultGridInterval ~/ defaultGridCellSize.height;
  static set setDefaultGridCellSize(Size size) => defaultGridCellSize = size;
  static Size get defaultTableSize => Size(defaultGridCellSize.width * 8,
      defaultGridCellSize.height * 8); // 8 is pixels of table
  static double defaultSidebarWidth = 300;
}

class GridConstants {
  static const String gridCanvasId = "grid_canvas";
  // static const String gridCanvasTableId = "grid_canvas_table";
  static const String gridSidebarTablePropsId = "sidebar_table_props";
  static const String gridSidebarBarTableListId = "sidebar_table_list";
}

class GridDecorations {
  static Color defaultGridColor = Colors.black26;
  static Color defaultBackgroundColor = Colors.black12;
}
