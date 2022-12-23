import 'package:flutter/material.dart';

class Constants {
  static const defaultCanvasPadding = 60.0;
  static const double defaultGridInterval = 100;
  static int get defaultGridSubdivision =>
      defaultGridInterval ~/ 10; // Makes 1 cell 10 pixels
  static Size _defaultGridCellSize = const Size(10, 10);
  static Size get defaultGridCellSize => _defaultGridCellSize;
  static set setDefaultGridCellSize(Size size) => _defaultGridCellSize = size;
  static Size get defaultContainerSize => const Size(200, 200);
  static const double defaultSidebarWidth = 300;
  static GridConstants defaultGridConstants = GridConstants();
}

class GridConstants {
  final String gridCanvasId = "grid_canvas";
  final String gridCanvasTableId = "grid_canvas_table";
  final String gridSidebarTablePropsId = "sidebar_table_props";
  final String gridSidebarBarTableListId = "sidebar_table_list";
}
