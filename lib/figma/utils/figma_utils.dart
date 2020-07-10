

import 'package:flutter/material.dart';


class ScreenSizeInfo{
  final Size figmaScreenSize;
  final double figmaOffsetX;
  final double figmaOffsetY;
  Rect windowFrame;

  ScreenSizeInfo(this.figmaScreenSize, this.figmaOffsetX, this.figmaOffsetY);
  ScreenSizeInfo.fromJson(var jsonData):
    this.figmaScreenSize= Size(jsonData["absoluteBoundingBox"]['width'], jsonData["absoluteBoundingBox"]['height']), 
    this.figmaOffsetX=jsonData["absoluteBoundingBox"]['x'], 
    this.figmaOffsetY=jsonData["absoluteBoundingBox"]['y'];

  Map<String, dynamic> toFigmaJson({@required Map<String, dynamic> data}){
    Map absoluteBoundingBox = data["absoluteBoundingBox"];
    return {
             "left": absoluteBoundingBox['x']-figmaOffsetX, 
              "top":absoluteBoundingBox['y']-figmaOffsetY, 
              "width":absoluteBoundingBox['width'], 
              "height":absoluteBoundingBox['height']
    };
  }
}


  Rect toWindowRect({@required Map<String, dynamic> positionData, double pcntSize=1.0})
        =>Rect.fromLTWH(
              positionData["left"]*pcntSize, 
              positionData["top"]*pcntSize,
              positionData["width"]*pcntSize, 
              positionData["height"]*pcntSize,
            );




