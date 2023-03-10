import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'constants.dart';

class Utils {
  static List<T> swapList<T>(List<T> list, int from, int to) {
    final List<T> l = [...list];
    T temp = l[from];
    l[from] = l[to];
    l[to] = temp;
    return l;
  }
}

extension SizeHelpers on Size {
  Size get toCellIndex => Size(
      width / GridSettingsConstants.defaultGridCellSize.width,
      height / GridSettingsConstants.defaultGridCellSize.height);
}

extension OffsetHelpers on Offset {
  Offset get toCellIndex {
    return Offset(dx / GridSettingsConstants.defaultGridCellSize.width,
        dy / GridSettingsConstants.defaultGridCellSize.height);
  }

  Offset get toOffsetFromCellIndex {
    final off = Offset(dx * GridSettingsConstants.defaultGridCellSize.width,
        dy * GridSettingsConstants.defaultGridCellSize.height);
    return off;
  }
}

extension GlobalKeyExtentions on GlobalKey {
  Offset? get getPosition => (currentContext?.findRenderObject() as RenderBox?)
      ?.localToGlobal(Offset.zero);
  Size? get getSize => (currentContext?.findRenderObject() as RenderBox?)?.size;
}
