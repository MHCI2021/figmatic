

import 'dart:math';

Map<String,dynamic> parsePosition({
  Map<String,dynamic> absoluteBoundingBox, 
  Point figmaOffset
  }){
    
  return (absoluteBoundingBox==null ||figmaOffset==null)?null:
  {
             "left": absoluteBoundingBox['x']-figmaOffset.x, 
              "top":absoluteBoundingBox['y']-figmaOffset.y, 
              "width":absoluteBoundingBox['width'], 
              "height":absoluteBoundingBox['height']
    };
}
 
        // "layoutMode":(figmaData.containsKey("layoutMode"))?
        //                   figmaData["layoutMode"]=="HORIZONTAL"?"Row":
        //                   figmaData["layoutMode"]=="VERTICAL"?"Column"
        //                   :"Stack":"Stack",