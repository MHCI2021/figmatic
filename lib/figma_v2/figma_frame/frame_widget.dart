

import 'package:figmatic/figma_v2/utils/color_utils.dart';
import 'package:flutter/material.dart';

import '../utils/figma_utils.dart';
import '../utils/widget_utils.dart';

Widget frameDataToWidget(double pcntSize, Map<String,dynamic> data, List<Widget> children){
  Rect windowRect = toWindowRect(positionData: data["positioning"], pcntSize:pcntSize);
  //print(windowRect);
  if(children==null && colorFromString(data["style"]["color"])==null){
    print("null");
  }

  return positionedWrapper(
    windowRect: windowRect,
    child:Container(
          width:double.infinity, height:double.infinity,
          decoration:  BoxDecoration( 
            color: colorFromString(data["style"]["color"],),
            //border: 
          
  ),
  child: Stack(
    children:children
  ),
    )
  );
}
 //getFrameColor(data["style"]["backgroundColor"])
