import 'dart:async';
import 'dart:convert';
//import 'package:figmatic/utils.dart';
//import 'package:flutter/material.dart';
import 'package:figmatic/figma_v4/parse/position.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:universal_html/html.dart';

import 'dart:math';
import 'package:figmatic/utils.dart';
import 'element_node.dart';


/*
Each node has it's info + children.
The info is in the form of json and is only rendered at runtime
Nodes are rendered in the order of children...starting with screen 1
*/

class FigmaApi2{ //extends ChangeNotifier{
  final String authToken;
  final BaseClient http;
  Map<String, ElementNode> nodes={};
  Map<String, dynamic> pages = {};
  Map<String, String> widgets = {};

  Map<String, dynamic> imageIds={};
  String currentScreenID;
  bool loading=true;
  FigmaApi2(this.http, this.authToken);
  
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
    bool first=true;
    _data['document']['children']
    .forEach((page){
      if(first){
      first=false;
          pages[page["name"]]={};
        //// Get `screen info`
        page['children'].forEach((screenData)  {
              pages[page["name"]][screenData["name"]]=screenData["id"];
              print(screenData["id"]);
              Map<String,dynamic> absoluteBoundingBox =safeGet(key: "absoluteBoundingBox", map: screenData, alt: null);
              Point p = getOffsetPoint(absoluteBoundingBox);
              _getFigmaItem(
                data: screenData, 
                //figmaOffset: p,
                parentPath: [],
                positionData: parsePosition(
                  absoluteBoundingBox:absoluteBoundingBox, 
                  figmaOffset: p)
              );
      });
      }
    });

   //print();
}
String getTestString()=>_printFromNode("39:2", root: true);
Widget getTestWidget({double height, double width}){
    double scale = width/nodes["7:3"].positionData["width"];
    print(scale);
    return Container(
      height: height,
      width: width,
      child: _buildFromNode("7:3", root: true,scale:scale)
    );
  
  }
//// Pass in root location, data, position data
///
///
  _getFigmaItem({
    @required Map<String, dynamic> data, 
    List parentPath,
    @required Map<String,dynamic> positionData,

  }){
    bool hasChildren = data.containsKey("children");
    // Create the node
    nodes[data["id"]]=ElementNode(
      id:data["id"],
      type: data["type"],
      name: data["name"],
      figmaClass: _getFigmaClass(data["id"]),
      data: data, 
      positionData: positionData, 
      parentPath: parentPath,
      layoutMode:!hasChildren?null:getLayoutMode(safeGet(key: "layoutMode", map:data, alt: "Stack"))
    );
     if(hasChildren)_getChildren(data,  [data["id"]]..addAll(parentPath));
  }

 _getChildren(Map data,  List parentPath,){
    // Get parent layout mode
    List children  =safeGet(key: "children", map:data, alt: null);
    if(children==null)return null;

    String layoutMode= getLayoutMode(safeGet(key: "layoutMode", map:data, alt: "Stack"));
      Map<String,dynamic> absoluteBoundingBox =safeGet(key: "absoluteBoundingBox", map:data, alt: null);
     Point figmaOffset =getOffsetPoint(absoluteBoundingBox);
    if(layoutMode=="Stack"){
      children.forEach((childData) {
         _getFigmaItem(
            data:childData, 
           // figmaOffset:figmaOffset,
            parentPath:parentPath,
            positionData: parsePosition(
              absoluteBoundingBox:safeGet(key: "absoluteBoundingBox", map: childData, alt: null), 
              figmaOffset: figmaOffset
            ));
      });
    }
    else{
  
      double left,top;
        left =absoluteBoundingBox["x"];
        top = absoluteBoundingBox["y"];
        for(int i=0; i<children.length;i++){
          Map<String,dynamic> childBox =safeGet(key: "absoluteBoundingBox", map:children[i], alt: null);
            _getFigmaItem(
            data:children[i], 
           // figmaOffset: figmaOffset,
            parentPath: parentPath,
            positionData:{
              "parentLayout":layoutMode,
              "left": childBox['x']-left, 
              "top":childBox['y']-top, 
              "width":childBox['width'], 
              "height":childBox['height']
            });
            if (layoutMode=="Row")
              left=childBox['x']+childBox['width'];
            else if (layoutMode=="Column")
              top=  childBox['y']+childBox['height'];
        }
      
    }
 }
 Widget _buildFromNode(String id, {bool root=false, double scale}){
   //39:2
  // print(nodes[id].name);
   List<Widget> childs =[];
   if(nodes[id].childrenIDs!=null){
      nodes[id].childrenIDs.forEach((childID) {
        childs.add(_buildFromNode(childID, scale: scale));
      });
   }
//print(childs);
   return nodes[id].buildWidget(children: childs, root: root, scale: scale);
  
 }

 String _printFromNode(String id, {bool root=false}){
   //39:2
  // print(nodes[id].name);

   List<String> childs =[];
   if(nodes[id].childrenIDs!=null){
      nodes[id].childrenIDs.forEach((childID) {
        childs.add(_printFromNode(childID));
      });
   }
//print(childs);
   return nodes[id].printWidget(children: childs.join("\n"), root: root);
  
 }

}







String _getFigmaClass(String type){
  List<String> frames = ["CANVAS", "FRAME", "COMPONENT","INSTANCE", "GROUP"];
  List<String> vectors = ["RECTANGLE", "VECTOR", "STAR","LINE","ELLIPSE", "REGULAR_ POLYGON","SLICE"];
  return (type =="TEXT")?"text":(vectors.contains(type))?"vector":frames.contains(type)?"frame":"unknown";
}


Point getOffsetPoint(Map<String,dynamic> absoluteBoundingBox, )=>
  absoluteBoundingBox==null?null:Point(absoluteBoundingBox["x"],absoluteBoundingBox["y"] );

///
String getLayoutMode(String layoutMode){
  return (layoutMode!=null)?
        layoutMode=="HORIZONTAL"?"Row":
        layoutMode=="VERTICAL"?"Column"
        :"Stack":"Stack";
}

bool isImage(Map json){
  try{
    String type = json["fills"][0]["type"];
    if(type=="IMAGE")return true;
    return false;
  }catch(e){
    return false;
  }
}  



   //
    //f(data.containsKey("children")){
      //int i = 0;
      //List<Map<String,dynamic>> positionsData = 
      //List<Map<String,dynamic>>
//List<String>
// List _getPadding(Map data, String layoutMode){
//     String layoutMode= data["content"]["layoutMode"];
//     if(layoutMode=="Stack")return data["content"]["children"].map((i)=>null).toList();
//     List out = [];
//     double left=0;
//     data["children"]?.forEach((childNodeID){
//        Map nodeData = safeGet(key: childNodeID, map: apiManager.nodes, alt: null);
//        double l=nodeData["positioning"]["left"]-left;
//        if(l>0.0)
//         out.add(EdgeInsets.only(left:l*pcntsize));
//         else out.add(null);
//        left=nodeData["positioning"]["width"]+nodeData["positioning"]["left"];
//     });
//     return out;
// }


// class ChildPositionData {
//   String parentLayoutMode;
//   double 

// }

// {
//                   "layoutType":"Stack",
//                   "left": 0, 
//                   "top":0, 
//                   "width":absoluteBoundingBox['width'], 
//                   "height":absoluteBoundingBox['height']
//                 }

  //   double left=0;
  //   bool first=false;
  //   double top=0;
  //   data["children"]?.forEach((childNodeData){
  //      Map nodeData;
  //      double l=nodeData["positioning"]["left"]-left;
  //      //EdgeInsets.only(left:l*pcntsize)
  //      if(l>0.0)
  //       out.add({

  //       });
  //       else out.add(null);
  //      left=nodeData["positioning"]["width"]+nodeData["positioning"]["left"];
  //   });
  //   return out;
  // }