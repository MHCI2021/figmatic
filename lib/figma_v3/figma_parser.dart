import 'dart:async';
import 'dart:convert';
//import 'package:figmatic/utils.dart';
//import 'package:flutter/material.dart';
import 'package:figmatic/figma_v2/utils/parse_utils.dart';
import 'package:figmatic/figma_v3/parsers/parse_position.dart';
import 'package:http/http.dart';
import 'package:universal_html/html.dart';

import 'dart:math';

import 'package:figmatic/utils.dart';

import 'parsers/content/parse_frame.dart';
import 'parsers/content/parse_text.dart';
import 'parsers/parse_container.dart';
import 'parsers/content/parse_vector.dart';



/*
Each node has it's info + children.
The info is in the form of json and is only rendered at runtime
Nodes are rendered in the order of children...starting with screen 1
*/

class FigmaApi{ //extends ChangeNotifier{
  final String authToken;
  final BaseClient http;
  Map<String, dynamic> nodes={};
  Map<String, dynamic> pages = {};
  //Map<String, String> screens = {};
  Map<String, String> widgets = {};

  String currentScreenID;
  //List pages = [];
  bool loading=true;
  FigmaApi(this.http, this.authToken);
  
  Future<dynamic> _apiCall(String path) async {
    var response = await http.get(
        "https://api.figma.com/v1/$path",
        headers: {
          "X-FIGMA-TOKEN": this.authToken,
        });
        //print(response.body);
    return json.decode(response.body);
  } 


  init(String fileKey,{bool getImages = true}) async {
    loading=true;
    var _data = await _apiCall("files/$fileKey?geometry=paths");
  // print(_data);
    // Add page info
    _data['document']['children'].forEach((page){
          pages[page["name"]]={};
        //// Get `screen info`
        page['children'].forEach((screen)  {
              pages[page["name"]][screen["name"]]=screen["id"];
              _getFigmaItem(
                data: screen, 
                figmaOffset: getOffsetPoint(safeGet(key: "absoluteBoundingBox", map: screen, alt: null)),
                parentPath: []
              );
      });
    });

 
  // if(getImages)
    await _addImageUrls(fileKey);
  }


_addImageUrls(String fileKey) async {
   List<String> ids=[];
    nodes?.forEach((nodeID, nodeData) {
        if(nodeData.containsKey("isImage")&& nodeData["isImage"]==true){
         // print(nodeID);
          ids.add(nodeID);
        }
    });
   // print(ids);

    if(ids.isNotEmpty){
      String urlids = ids.join(",");
      var data = await _apiCall("images/$fileKey?ids=$urlids");
     // printJson(data);
      Map<String,dynamic> imagenodes = await data["error"]??data["images"];
      imagenodes.forEach((nodeID, imageUrl) {
        if(nodes[nodeID]["content"]==null)nodes[nodeID]["content"]={};
       // nodes[nodeID]["imageUrl"]= imageUrl;
       //print(nodes[nodeID]);
        nodes[nodeID]["content"]["imageUrl"]= imageUrl;
      });
  }
}

  

  _getFigmaItem({
    Map<String, dynamic> data, 
    Point figmaOffset,
    List parentPath
  }){
    String type = data["type"];   
    List<String> frames = ["CANVAS", "FRAME", "COMPONENT","INSTANCE", "GROUP"];
    List<String> vectors = ["RECTANGLE", "VECTOR", "STAR","LINE","ELLIPSE", "REGULAR_ POLYGON","SLICE"];
    String figClass;
    bool hasChildren = data.containsKey("children");
    Map<String, dynamic> contentData;
    if(type =="TEXT"){
      figClass ="text";
      contentData=parseText(data);
    }else if (vectors.contains(type)){
      figClass ="vector";
      contentData=parseVector(data);
    }else if (frames.contains(type)){
      figClass ="frame";
      contentData=parseFrame(
        childrenIds: !hasChildren?null:data["children"].map((childData)=>childData["id"]).toList(),
        size: data["size"],
        layoutMode: (data.containsKey("layoutMode"))?
                          data["layoutMode"]=="HORIZONTAL"?"Row":
                          data["layoutMode"]=="VERTICAL"?"Column"
                          :"Stack":"Stack",
      );
    //   print("---------------------------------------------");
    //   print("");
    //   printJson(contentData);
    //        data.forEach((key, value) {
    // if(key!="children"){
    //   //print(key);
    //   printJsonDynamic(value, key: key);
    // }
  //});
    }


    nodes[data["id"]]= parseNode(
      figmaData: data,
      figmaOffset:figmaOffset,
      figmaClass: figClass,
      content: contentData,
      parentPath: parentPath
    );
    if(hasChildren){
      Point _figmaOffset;
      // TODO deal with padding and layout
     if(nodes[data["id"]]["type"]=="COMPONENT"){
       widgets[data["name"]]=data["id"];
       _figmaOffset= getOffsetPoint(safeGet(key: "absoluteBoundingBox", map: data, alt: null));
     }
     _figmaOffset= getOffsetPoint(safeGet(key: "absoluteBoundingBox", map: data, alt: null));
     List l=[data["id"]];
     l.addAll(parentPath);
      data["children"].forEach((childData){
       
        _getFigmaItem(
          data:childData, 
          figmaOffset: _figmaOffset??figmaOffset,
          parentPath:l
          );
      });
    }
  }
}

////
///
Map<String,dynamic> parseNode(
  {
  Map<String,dynamic> figmaData, 
  String figmaClass,
  Point figmaOffset, 
  List parentPath,
  Map<String,dynamic> content
  }){

    Map<String,dynamic> out={
        "id":figmaData["id"],
        "type":figmaData["type"],
        "class": figmaClass,
        "name":figmaData["name"],
        "isImage":isImage(figmaData),
        "parentPath":parentPath??[],
        "positioning":parsePosition(
          absoluteBoundingBox: safeGet(key: "absoluteBoundingBox", map: figmaData, alt: null),
          figmaOffset: figmaOffset
        ),
        "container": // check visible
        parseContainer(
          data: figmaData,
          figmaClass:figmaClass,
          isVectorPath: (figmaClass=="vector"&&content!=null)
        ),
        "content":content,
      };
     // printJson(out);
  return out;
}
 

Point getOffsetPoint(Map<String,dynamic> absoluteBoundingBox, )=>
  absoluteBoundingBox==null?null:Point(absoluteBoundingBox["x"],absoluteBoundingBox["y"] );





  // List paint,
  // Map<String, dynamic> border,
  // dynamic cornerRadii,
  // List effects,


// Map<String,dynamic> parseContainer({
//   Map<String,dynamic> data
//   }){
//   printJson(data);
//     return {
//       "paint":null,
//       "border":null,
//       "boxRadius":_parseBoxRadius(cornerRadii:safeGet(key: "cornerRadius", map: data, alt: safeGet(key: "rectangleCornerRadii", map: data, alt: null))),
//       "boxShadow":_parseBoxShadow(safeGet(key: "effects", map: data, alt: null),),
//       "gradient":null, // todo
//       "backgroundBlendMode":null, //todo
//     };
// }


// List _parseBoxShadow(List effects){
//       if(effects==null)return null;
//       List b =[];          
//       effects.forEach((effect){
//                 try{
//                   b.add({
//                   "color":getColorString(safeGet(key:"color", map:effect, alt:null)),
//                   //parseEffectsColor(effect),
//                   "offset":{
//                     "x":effect['offset']['x'],
//                     "y":effect['offset']['y']
//                   },
//                   "blurRadius":effect['radius'].toDouble(),
//                 });
//                 }catch(e){
//                   b.add({
//                   "color":getColorString(safeGet(key:"color", map:effect, alt:null)),
//                   //parseEffectsColor(effect),
//                   "offset":null,
//                   "blurRadius":effect['radius'].toDouble(),
//                 });

//                 }
//                 });
//       return b;
// }


// dynamic _parseBoxRadius({dynamic cornerRadii,})=>
//     (cornerRadii==null)?
//     null
//     :(cornerRadii is double)?
//     cornerRadii:
//     (cornerRadii is List && cornerRadii.length==4)? 
//     {
//               "topLeft": cornerRadii[0],
//               "topRight": cornerRadii[1],
//               "bottomLeft": cornerRadii[2],
//               "bottomRight": cornerRadii[3],
//     }:null;



// // TODO 
// Map<String,dynamic> parseBorder(Map<String,dynamic>  figmaData){


//     Map<String,dynamic>  out = { "type": figmaData["strokes"][0]["type"],
//         "color":figmaData["strokes"][0]["color"],
//         "weight": figmaData["strokeWeight"],
//         "align": figmaData["strokeAlign"],
//         "paint":(figmaData["strokeGeometry"].length>0)?{
//             "path":figmaData["strokeGeometry"][0]["path"]
//         }:null};
//         return out;
// }




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

// /*
// fills: figmaData["fills"],
//           fillGeometry: figmaData["fillGeometry"],
          
// */
