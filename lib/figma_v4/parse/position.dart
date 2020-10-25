import 'dart:math';

import 'package:flutter/material.dart';

Map<String,dynamic> parsePosition({
  Map<String,dynamic> absoluteBoundingBox, 
  Point figmaOffset
  }){
  figmaOffset??=Point(absoluteBoundingBox['x'],absoluteBoundingBox['y']);
  return (absoluteBoundingBox==null ||figmaOffset==null)?null:
  {
            "parentLayout":"Stack",
             "left": absoluteBoundingBox['x']-figmaOffset.x, 
              "top":absoluteBoundingBox['y']-figmaOffset.y, 
              "width":absoluteBoundingBox['width'], 
              "height":absoluteBoundingBox['height']
    };
}

String positionWidgetString(Map<String,dynamic> position, String child){
 
 if(position["parentLayout"]=="Stack"){
    return ''' #fw700##colorgreen#Positioned#colorwhite##/fw#(
        left:${position["left"]},top:${position["top"]},
        width:${position["width"]},height:${position["height"]},
        child: $child),''';
  }
  
  else{
    print(child);
   // print(position);
    return ''' #fw700##colorgreen#Padding#colorwhite##/fw#(
        padding: #fw700##colorgreen#EdgeInsets#colorwhite##/fw#.only(left:${position["left"]},top:${position["top"]} ),
        child: $child),
        ''';
  }
}

Widget positionWidget(Map<String,dynamic> position, Widget child, double scale, bool container){
 
 if(position["parentLayout"]=="Stack"){
    return Positioned(
        left:position["left"]*scale,
        top:position["top"]*scale,
        width:position["width"]*scale,
        height:position["height"]*scale,
        child: child);
  }
  
  else{
    return Padding(
        padding: EdgeInsets.only(
          left:position["left"]*scale,
          top:position["top"]*scale ),
        child: 
        child
        )
        ;
  }
}