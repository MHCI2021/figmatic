
import 'package:figmatic/figma_v3/color_util.dart';

import '../../utils.dart';

enum BlendType{
  SOLID,
  LINEAR,
  RADIAL,
  IMAGE

}
Map<String,dynamic> parseContainer({
  Map<String,dynamic> data,
  String figmaClass,
  bool isVectorPath=false
  }){
    dynamic _parseColor(){
      if(isVectorPath)return null;
      if(figmaClass=="text")return null;

      if(!data.containsKey("fills") || data["fills"].isEmpty)return null;
      //if(data["fills"].length==1){
       // print(data["fills"]);
        var fill = data["fills"][0];
        if(!safeGet(key: "visible", map: fill, alt: true))return null;
        String blend = fill["blendMode"];
        if(blend=="IMAGE")return null;
        double opacity = safeGet(key: "opacity", map: fill, alt: 1.0);
        if(opacity==0.0)return null;
        return getColorString(fill["color"], opacity:opacity);
       // }
      //else{
      //  print("Not added yet");}
    //  return null;
    }
  dynamic _parseGradient(){
      if(figmaClass=="text")return null;if(!data.containsKey("fills") || data["fills"].isEmpty)return null;
      if(data["fills"].length==1){
        var fill = data["fills"][0];
        if(!safeGet(key: "visible", map: fill, alt: true))return null;
        String blend = fill["blendMode"];
        if(blend=="IMAGE")return null;
        double opacity = safeGet(key: "opacity", map: fill, alt: 1.0);
        if(opacity==0.0)return null;
        return getColorString(fill["color"], opacity:opacity);
        }
      else{}
       // print("Not added yet");}
      return null;
    }

  // data.forEach((key, value) {
  //   if(key!="children"){
  //     //print(key);
  //     printJsonDynamic(value, key: key);
  //   }
  // });
  //printJson(data);
    return {
      "color":_parseColor(),
      "border":parseBorder(data),
      "boxRadius":_parseBoxRadius(cornerRadii:safeGet(key:"rectangleCornerRadii", map: data, alt: safeGet(key: "cornerRadius", map: data, alt: null))),
      "boxShadow":_parseBoxShadow(safeGet(key: "effects", map: data, alt: null),figmaClass),
      "gradient":_parseGradient(), // todo
      "backgroundBlendMode":null, //todo
    };
}


List _parseBoxShadow(List effects, String figmaClass){
  if(figmaClass=="text")return null;
      if(effects==null)return null;
      List b =[];          
      effects.forEach((effect){
                try{
                  b.add({
                  "color":getColorString(safeGet(key:"color", map:effect, alt:null)),
                  //parseEffectsColor(effect),
                  "offset":{
                    "x":effect['offset']['x'],
                    "y":effect['offset']['y']
                  },
                  "blurRadius":effect['radius'].toDouble(),
                });
                }catch(e){
                  b.add({
                  "color":getColorString(safeGet(key:"color", map:effect, alt:null)),
                  //parseEffectsColor(effect),
                  "offset":null,
                  "blurRadius":effect['radius'].toDouble(),
                });

                }
                });
      return b;
}


dynamic _parseBoxRadius({dynamic cornerRadii,})=>
    (cornerRadii==null)?
    null
    :(cornerRadii is double)?
    cornerRadii:
    (cornerRadii is List && cornerRadii.length==4)? 
    {
              "topLeft": cornerRadii[0],
              "topRight": cornerRadii[1],
              "bottomRight": cornerRadii[2],
              "bottomLeft": cornerRadii[3],
    }:null;



// TODO 
Map<String,dynamic> parseBorder(Map<String,dynamic>  figmaData){

try{
    Map<String,dynamic>  out = { 
      "type": figmaData["strokes"][0]["type"],
        "color":
       getColorString(figmaData["strokes"][0]["color"]),
        "weight": figmaData["strokeWeight"],
        "align": figmaData["strokeAlign"],
        "paint":(figmaData["strokeGeometry"].length>0)?{
            "path":figmaData["strokeGeometry"][0]["path"]
        }:null};
        return out;

}catch(e){return null;}
}




// List _getPaint({Map<String,dynamic> data}){
//   //printJson(data);
//   // if(!data.containsKey('fillGeometry')||data['fillGeometry'].length==0){
//   //   return null;
//   // }
//   List out = [];
//   // print("\n\n");
//   // print(data["name"]);
//   // print(data['fillGeometry']);
//   // print(data['fills']);
//   for(int i=0; i<data['fills'].length; i++){
//   }
//   return [{
//           "path":data['fillGeometry'][0]['path'],
//           "color": getColorString(
//                           safeGetPath(data, ["fills", 0, "color"]),
//                           opacity: safeGetPath(data, ["fills", 0, "opacity"]),
//                         ),
//           "strokeWidth": 2.0,
//           "paintingStyle": "fill",
//         }];
// }

/*
fills: figmaData["fills"],
          fillGeometry: figmaData["fillGeometry"],
          
*/
