

import 'package:figmatic/figma/utils/color_utils.dart';

import '../../utils.dart';
import '../utils/figma_utils.dart';

Map<String,dynamic> parseFigmaFrame(Map<String,dynamic> figmaData, ScreenSizeInfo screenSizeInfo, {bool isRoot=false}){
 //  print( '****************************** ${figmaData["name"]} ******************************');
  // figmaData.forEach((key, value) {
  //   if(key!="children"){
  //     //print(key);
  //     printJsonDynamic(value, key: key);
  //   }
  // });
  
 //parseFrameColor(figmaData),
    // if(Random().nextInt(20)==3){
    //     printJson(figmaData);
    //     //printJson(out);
    //   }
  Map<String,dynamic>  _parseStyle(){

    return {
      "color":safeGetPath(figmaData, ["fills", 0, "visible"])??true?
      getColorString(
                          safeGetPath(figmaData, ["fills", 0, "color"]),
                          opacity: safeGetPath(figmaData, ["fills", 0, "opacity"]),
                        ):null,
      "border":(figmaData["strokes"].length>0)?{
        "type": figmaData["strokes"][0]["type"],
        "color":figmaData["strokes"][0]["color"],
        "weight": figmaData["strokeWeight"],
        "align": figmaData["strokeAlign"],
        "paint":(figmaData["strokeGeometry"].length>0)?{
          "path":figmaData["strokeGeometry"][0]["path"]
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
                  //parseEffectsColor(effect),
                  "offset":{
                    "x":effect['offset']['x'],
                    "y":effect['offset']['y']
                  },
                  "blurRadius":effect['radius'].toDouble(),
                }).toList(),
      "gradient":null, // todo
      "backgroundBlendMode":null, //todo
      };
  }



    Map<String,dynamic> out={
        "id":figmaData["id"],
        "type":figmaData["type"],
        "class":"frame",
        "name":figmaData["name"],
        "isRoot":isRoot,
        "layoutMode":(figmaData.containsKey("layoutMode"))?
                          figmaData["layoutMode"]=="HORIZONTAL"?"Row":
                          figmaData["layoutMode"]=="VERTICAL"?"Column"
                          :"Stack":"Stack",
        //"blendMode":,
        "style":_parseStyle(),
        "positioning":screenSizeInfo.toFigmaJson(data: figmaData),
        "children":figmaData.containsKey("children")?figmaData["children"].map((childData)=>childData["id"]).toList():[],
         "transitionNode":null
      };
    // printJson(out);

  return out;
}
 


//(safeGet(key: "blendMode", map: figmaData, alt: null)=="PASS_THROUGH")?null:



// _getTransitionNode(){
// transitionNodeID:,
//     transitionDuration:,
//     transitionEasing:,
//   }
// }


/*
{
  "id":,
  "type":"__" of ["CANVAS", "FRAME","COMPONENT","INSTANCE"]
  "class":"frame",
  "name":,
  "isRoot":[default=false],
  "blendMode":,
  "style":{
    "backgroundColor":{
      "r",
      "b",
      "g",
      "a",
      "opacity"
    },
    "border":,
    "boxRadius":,
    "gradient":,
    "backgroundBlendMode":,
  },
  "positioning":{
    "height":
    "width":
    "left":
    "right":
  },
  children:[
    "node id"
  ],
  transitionNode:{
    transitionNodeID:,
    transitionDuration:,
    transitionEasing:,
  }
}
*/
