

import 'package:figmatic/figma/utils/color_utils.dart';
import 'package:flutter/material.dart';

import '../utils/figma_utils.dart';
import '../utils/widget_utils.dart';

Widget frameDataToWidget(double pcntSize, Map<String,dynamic> data){
  Rect windowRect = toWindowRect(positionData: data["positioning"], pcntSize:pcntSize);
  //print(windowRect);
  return positionedWrapper(
    windowRect: windowRect,
    child:Container(
          width:double.infinity, height:double.infinity,
          decoration:  BoxDecoration( color: colorFromString(data["style"]["color"])
  )
        )
  );
}
 //getFrameColor(data["style"]["backgroundColor"])
