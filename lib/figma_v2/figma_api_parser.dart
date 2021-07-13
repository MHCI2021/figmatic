import 'dart:async';
import 'dart:convert';
//import 'package:figmatic/utils.dart';
//import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'utils/figma_utils.dart';
import 'figma_frame/frame_parse.dart';
import 'figma_text/text_parse.dart';
import 'figma_vector/vector_parse.dart';

/*
Each node has it's info + children.
The info is in the form of json and is only rendered at runtime
Nodes are rendered in the order of children...starting with screen 1
*/

class FigmaApiManager{ //extends ChangeNotifier{
  final String authToken;
  final BaseClient http;
  Map<String, dynamic> nodes={};
  Map<String, String> screens = {};
  Map<String, String> widgets = {};

  String currentScreenID;
  List pages = [];
  bool loading=true;
  FigmaApiManager(this.http, this.authToken);
  
  init(String fileKey,{bool getImages = false}) async {
    loading=true;
    Map<String, dynamic> _data = await _getFile(fileKey);
    _data['document']['children'].forEach((page){
      pages.add(page["name"]);
    });
    //int l= _data['document']['children'].length;
    var page1 = _data['document']['children'][0];
    page1['children'].forEach((screen)  {
          screens[screen["name"]]=screen["id"];
          _getFigmaItem(screen, null);
   });

   
    List<String> ids=[];
    nodes?.forEach((nodeID, nodeData) {
        if(nodeData.containsKey("isImage")&& nodeData["isImage"]==true)ids.add(nodeID);
    });
   
    if(ids.isNotEmpty){

      Map<String,dynamic> imagenodes = await _getImages(fileKey, ids);
      imagenodes.forEach((nodeID, imageUrl) {
        nodes[nodeID]["imageUrl"]= imageUrl;
      });
  }
  }


  Future<dynamic> _getFile(String fileKey) async {
    var response = await http.get(
        "https://api.figma.com/v1/files/$fileKey?geometry=paths",
        headers: {
          "X-FIGMA-TOKEN": this.authToken,
        });
    return json.decode(response.body);
  } 

  Future<Map<String,dynamic>> _getImages(String fileKey, List<String> ids) async {

    String urlids = ids.join(",");
    var response = await http.get(
        "https://api.figma.com/v1/images/$fileKey?ids=$urlids",
        headers: {
          "X-FIGMA-TOKEN": this.authToken,
        });
     var jsonData = json.decode(response.body);
     return jsonData["error"]??jsonData["images"];
  }

  _getFigmaItem(Map<String, dynamic> data, ScreenSizeInfo screenSizeInfo){
    //Get sizing info of the parent nodes ==> 
    bool _root = screenSizeInfo==null;
    ScreenSizeInfo _screenSizeInfo= screenSizeInfo??ScreenSizeInfo.fromJson(data);
    
    String type = data["type"];   
    List<String> frames = ["CANVAS", "FRAME", "COMPONENT","INSTANCE", "GROUP"];
    List<String> vectors = ["RECTANGLE", "VECTOR", "STAR","LINE","ELLIPSE", "REGULAR_ POLYGON","SLICE"];

    if(type =="TEXT"){
      nodes[data["id"]]=parseFigmaText(data, _screenSizeInfo);//components.add(FigmaText.fromJson(component, screenSizeInfo));
    }else if (vectors.contains(type)){
      nodes[data["id"]]=parseFigmaVector(data, _screenSizeInfo);
    }else if (frames.contains(type)){
      nodes[data["id"]]=parseFigmaFrame(data, _screenSizeInfo, isRoot: _root);
      if(nodes[data["id"]]["type"]=="COMPONENT")widgets[data["name"]]=data["id"];
      data["children"]?.forEach((childData){
        _getFigmaItem(childData, ScreenSizeInfo.fromJson(data));
      });
    }
  }
}



 // var s1 = page1['children'][0]; //{
    // screens[s1["name"]]=s1["id"];
    // widgets[s1["name"]]=s1["id"];
   //printJson(s1);
 //    _getFigmaItem(s1, null);
   //});
   //printJson(page1);
   //Get Images
  // String currentScreen;
  // String currentPage;
  // nodes.forEach((nodeID, nodeData) {
  //  // print(nodeData);
  //   JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  //   String prettyprint = encoder.convert(nodeData);
  //   print(prettyprint);
  // });
      //print(ids);