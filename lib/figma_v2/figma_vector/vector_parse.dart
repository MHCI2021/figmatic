
import 'package:figmatic/figma_v2/utils/color_utils.dart';

import '../../utils.dart';
import '../utils/figma_utils.dart';
import '../utils/parse_utils.dart';


Map<String,dynamic> parseFigmaVector(Map<String,dynamic> figmaData, ScreenSizeInfo screenSizeInfo,){
    printJson(figmaData);
    Map<String,dynamic>  _parseStyle(){
        return {
          "color":
          (safeGet(key: "blendMode", map: figmaData, alt: null)=="PASS_THROUGH")
                        ?null:getColorString(
                          safeGetPath(figmaData, ["fills", 0, "color"]),
                          opacity: safeGetPath(figmaData, ["fills", 0, "opacity"]),
                        ),
          "border":(figmaData["strokes"].length>0)?{
            "type": figmaData["strokes"][0]["type"],
            "align": figmaData["strokeAlign"],
            "paint":(figmaData["strokeGeometry"].length>0)?{
              "path":figmaData["strokeGeometry"][0]["path"],
              "color":getColorString(figmaData["strokes"][0]["color"]),
              "strokeWidth": figmaData["strokeWeight"],
            }:null
          }:null,
          "boxRadius":figmaData.containsKey("rectangleCornerRadii")?{
              "topLeft": figmaData["rectangleCornerRadii"][0],
              "topRight": figmaData["rectangleCornerRadii"][1],
              "bottomLeft": figmaData["rectangleCornerRadii"][2],
              "bottomRight": figmaData["rectangleCornerRadii"][3],
          }:null,
          "boxShadow":!figmaData.containsKey("effects")?[]:figmaData["effects"].map((effect)=>
                    {
                      "color":getColorString(safeGet(key:"color", map:effect, alt:null)),
                      "offset":effect.containsKey('offset')?
                      {
                        "x":effect['offset']['x'],
                        "y":effect['offset']['y']
                      }:null,
                      "blurRadius":effect['radius'].toDouble(),
                    }).toList(),
          "gradient":null, // todo
          "backgroundBlendMode":null, //todo
          };
        }
      Map<String,dynamic> out={
        "id":figmaData["id"],
        "type":figmaData["type"],
        "class":"vector",
        "visible":safeGet(key: "visible", map: figmaData, alt: true),
        "name":figmaData["name"],
        "isImage":isImage(figmaData),
        "style":_parseStyle(),
        "paint":_getPaint(figmaData),
        "positioning":screenSizeInfo.toFigmaJson(data: figmaData),
      };

      
  return out;
}


Map<String,dynamic> _getPaint(Map<String,dynamic> data){
  if(!data.containsKey('fillGeometry')||data['fillGeometry'].length==0){
    return null;
  }
  return {
          "path":data['fillGeometry'][0]['path'],
          "color": getColorString(
                          safeGetPath(data, ["fills", 0, "color"]),
                          opacity: safeGetPath(data, ["fills", 0, "opacity"]),
                        ),
          "strokeWidth": 2.0,
          "paintingStyle": "fill",
        };
}



// Map<String,dynamic> parseVectorColor(Map<String,dynamic> data){
//     double op; ///=1.0;
    
//      try{ op=data['fills'][0]["opacity"]??1.0;}catch(e){op =1.0;}
//       try{ Map<String,dynamic> c = data['fills'][0]['color'];
//       c["opacity"]= op;
//       return c;
//       }catch(e){
//         return null;
//       }
// }


/*
{
  "id":,
  "type":"__" of ["RECTANGLE", "VECTOR", "STAR","LINE","ELLIPSE", "REGULAR_ POLYGON","SLICE"]
  "class":"vector",
  "name":,
  "imageUrl":,
  "style":{
    "backgroundColor":,
    "border":,
    "boxRadius":,
    "gradient":,
    "backgroundBlendMode":,
  },
  "paint":{
    "path":[default= null],
    "color": [default= null],
    "strokeWidth": [default= 1],
    "paintingStyle": [default= fill],
  }
  "positioning":{
    "height":
    "width":
    "left":
    "right":
  }
}
*/