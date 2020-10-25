
import 'package:flutter/material.dart';

import '../utils/figma_utils.dart';
import '../utils/widget_utils.dart';


String textDataToWidgetString(double pcntSize, Map<String,dynamic> data, String layoutMode){
  Rect windowRect = toWindowRect(positionData: data["positioning"], pcntSize:pcntSize);
  return "";
  // return positionedWrapperString(
  //   windowRect: windowRect,
  //   child:"Text(\"\"),"
  // );
}
