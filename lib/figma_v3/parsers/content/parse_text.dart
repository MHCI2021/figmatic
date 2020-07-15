
import 'package:figmatic/figma_v3/color_util.dart';
import 'package:figmatic/utils.dart';

Map<String,dynamic> parseText(Map<String,dynamic> figmaData){
  //printJson(figmaData);
 try{
  Map<String,dynamic> out={
    "text":figmaData["characters"],
    "styleText":_toTokenizedText(figmaData),
    "style":{//"color":parseTextColor(figmaData),
      "figmaFontSize":figmaData['style']['fontSize'],
      "textAlign":figmaData['style']['textAlignHorizontal'],
      "fontFamily": figmaData['style']["fontFamily"],
      "textShadow":figmaData.containsKey("effects")?_parseBoxShadow(figmaData["effects"]):null
    },
  };
 
  return out;
 }
 catch(e){
   //printJson(figmaData);
   return {};
 }
}

String _toTokenizedText(Map<String,dynamic> figmaData){
  // fills 
  Map<String,dynamic> styles={};
  String text= figmaData["characters"];
  styles["0"]= _getTokens(figmaData);
  String out = "#"+styles["0"].join("#")+"#";//print(out);
  if(!figmaData.containsKey("characterStyleOverrides") || figmaData["characterStyleOverrides"].length==0){
    out+= text;
  }else{
    figmaData["styleOverrideTable"].forEach((id, styleData){
      styles[id]= _getTokens(styleData);
    });
    String last="0";
    int textIndex=0;
    figmaData["characterStyleOverrides"].forEach((styleID){
      String _styleID = styleID.toString();
      if(last!=_styleID){
        out+= "#"+styles[last].map((i)=>"/"+i).toList().join("#")+"#";
        out+= "#"+styles[_styleID].join("#")+"#";
        last=_styleID;
      }
      out+=text[textIndex];
      textIndex+=1;
    });
  }
  return out;
}


List<String> _getTokens(Map<String,dynamic> styleData){
  List<String> out=[];
  if(styleData.containsKey("style")){
    if(styleData.containsKey("fills")) {
      List fills = styleData["fills"];
      styleData= styleData["style"];
      styleData["fills"]= fills;
    }else{
      styleData= styleData["style"];
    }
  }
  //print(styleData);
  if(styleData.containsKey("fontWeight")) out.add("fw${styleData["fontWeight"]}");
  if(styleData.containsKey("italic")) out.add("italic");
  if(styleData.containsKey("fontSize")) out.add("size${styleData["fontSize"]}");
  if(styleData.containsKey("hyperlink")) 
    out.add("link${styleData["hyperlink"]["url"]}");
  // FontFamily
  if(styleData.containsKey("fills")) 
    out.add(getColorString(styleData["fills"][0]["color"]));
  return out;
}
List _parseBoxShadow(List effects){
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


// Using text span
// "Guiding Objective\nI want to build things that improve people’s lives.\n \n\n"
// #fw700# #color



/*
{
  "id":,
  "name":,
  "type":"TEXT",
  "class": "text",
  "text":,
  "style":
  "color":,
  "fontFamily":,
  "fontWeight":,
  "textAlign":,
  "figmaFontSize":,
  "relativeFontSize":
  "positioning":{
    "height":
    "width":
    "left":
    "right":
  }
}
*/
/*
"style": {
        "fontFamily": "Playfair Display",
        "fontPostScriptName": "PlayfairDisplay-Regular",
        "fontWeight": 400,
        "fontSize": 32,
        "textAlignHorizontal": "LEFT",
        "textAlignVertical": "TOP",
        "letterSpacing": 0,
        "lineHeightPx": 37.5,
        "lineHeightPercent": 100,
        "lineHeightUnit": "INTRINSIC_%"
      },
*/

/*{
          "fontFamily": "Playfair Display",
          "fontPostScriptName": "PlayfairDisplay-Bold",
          "fontWeight": 700,
          "italic": true,
          "fills": [
            {
              "blendMode": "NORMAL",
              "type": "SOLID",
              "color": {
                "r": 0.03656250238418579,
                "g": 0.13040637969970703,
                "b": 0.9750000238418579,
                "a": 1
              }
            }
          ]
        }*/
        //flutter run -d chrome