
import 'dart:math';

import 'package:figmatic/figma_v2/utils/color_utils.dart';
import 'package:figmatic/utils.dart';

// Map<String,dynamic> parseVector(){
//   return null;
// }


Map<String,dynamic> parseVector(Map<String,dynamic> data){
  printJson(data);
  var path =safeGetPath(data, ["fillGeometry", 0, "path"]);
  var fillColor =safeGetPath(data, ["fills", 0, "color"]);
  var fillOpacity =safeGetPath(data, ["fills", 0,"opacity"]);
  if(path==null || fillColor==null)return null;
  
  return {
          "path":data['fillGeometry'][0]['path'],
          "color": getColorString(
                         fillColor,
                          opacity: fillOpacity??1.0,
                        ),
          "strokeWidth": 2.0,
          "paintingStyle": "fill",
        };
}

