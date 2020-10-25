
// import 'package:figmatic/figma/figma_frame/frame_print.dart';
// import 'package:figmatic/figma/figma_text/text_widget.dart';
import 'dart:math';

import 'package:figmatic/figma_v2/utils/widget_utils.dart';
import 'package:figmatic/figma_v3/figma_parser.dart';
import 'package:figmatic/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
//import 'figma_text/text_print.dart';
//import 'figma_vector/vector_print.dart';
import '../figma_v2/utils/figma_utils.dart';
import 'color_util.dart';
import 'figma_build/text.dart';

/*
API Manager is pure dart code,
this one controls the entire view and builds the widgets
*/

class FigmaViewController2{
  String activeWidget;
  FigmaApi apiManager;
  Map<String, String> widgetStrings={};
  FigmaViewController2();

  init({@required figmaApiManager}){
    apiManager=figmaApiManager;
  }
  Widget buildScreens(double pcntSize, Size screenSize, String pageName){
    if(pageName==null)return Container();
    List screenIDs = apiManager.pages[pageName].values.toList();
 //  print(pcntSize);
    return ListView(
     children:  
           screenIDs.map((nodeid) {
                Rect window = toWindowRect(
                  positionData:apiManager.nodes[nodeid]["positioning"],
                  pcntSize: pcntSize);
                 return 
                       Padding(
                        padding: EdgeInsets.all(50.0),
                        child: Container(
                          height: window.height,
                          width:  window.width,
                          child:SingleChildScrollView(
                            child: Stack(children: [
                              Container(height: window.height),
                             _buildWidget(nodeid, pcntSize)
                            ])
                      )
                       )
                    );
           }).toList()
      
    );
  }

  Widget _buildWidget(String nodeID, double pcntSize, {String layoutMode = "Stack", EdgeInsets padding}){// TODO check null
    Map nodeData = safeGet(key: nodeID, map: apiManager.nodes, alt: null);
  printJson(nodeData);
    if(nodeData==null)return null;
    return _positionWidget(data: nodeData,pcntSize: pcntSize,layoutMode: layoutMode , padding: padding);
  }

  Widget _positionWidget({@required Map data, double pcntSize=1, String layoutMode = "Stack",EdgeInsets padding}){// TODO check null
    //print(pcntSize);

    Map positionData= data["positioning"];
    if(positionData==null || layoutMode!="Stack")
      return _containerWidget(data: data,isSized: false, pcntSize: pcntSize, padding:padding);

    
    return Positioned(
          top:pcntSize*positionData["top"],
          left: pcntSize*positionData["left"],
          height:pcntSize*positionData["height"],
          width:pcntSize*positionData["width"], 
        child: _containerWidget(data: data, pcntSize:pcntSize, isSized: true));
  }

  Widget _containerWidget({@required Map data, double pcntSize=1,bool isSized=false, EdgeInsets padding}){// TODO check null
    Map containerData = data["container"];
   
    if(containerData==null)return _contentWidget(data: data, pcntSize: pcntSize, isSized: false);
  // printJson(data);

  if(padding!=null){
    //print(padding.left);
    return Padding(padding: padding, 
    child:Container(
    
      height: isSized?double.infinity:(data["positioning"]["height"]*pcntSize),
      width: isSized?double.infinity:data["positioning"]["width"]*pcntSize,
      decoration: getDecoration(containerData),
     
      child: _contentWidget(data: data, pcntSize: pcntSize, isSized: isSized)
    )
    );
  }
  return Container(
      height: isSized?double.infinity:data["positioning"]["height"]*pcntSize,
      width: isSized?double.infinity:data["positioning"]["width"]*pcntSize,
      decoration: getDecoration(containerData),
     
      child: _contentWidget(data: data, pcntSize: pcntSize, isSized: isSized)
    );
  }

  Widget _contentWidget({@required Map data, bool isSized=false,double pcntSize=1,}){// TODO check null
    if(data["class"]=="text")return textDataToWidget(pcntSize:pcntSize, data:data,);
    //printJson(data["content"]);

    if(safeGetPath(data, ["content", "imageUrl"])!=null){
     // print(data["content"]["imageUrl"]);
      return Image.network(data["content"]["imageUrl"], fit: BoxFit.cover,);
    }
    if(data["class"]=="vector" && data["content"]!=null){
      print(data["positioning"]["width"]*pcntSize);
      print( data["positioning"]["height"]*pcntSize);
      return Container(
        height: double.infinity,
        width: double.infinity,
        child: CustomPaint(
              size: Size(data["positioning"]["width"]*pcntSize, data["positioning"]["height"]*pcntSize),
              painter: VectorPathPainter(
                  data['content']['path'],
                  colorFromString(data['content']["color"]) ?? Colors.black,
                  PaintingStyle.fill)),
      );
    }
    
    if(data["class"]=="frame"){
      List<Widget> out = [];
      List<EdgeInsets> padding= getPadding(data, pcntSize);
      String layoutMode= data["content"]["layoutMode"];
      int i =0;
      data["content"]["children"]?.forEach((childNodeID){
      //  printJsonDynamic(childNodeData);
          Widget w = _buildWidget(childNodeID, pcntSize, layoutMode: layoutMode, padding: padding[i]);
            if(w!=null)
              out.add(w);
            i++;
          });
        
          return layoutMode=="Row"?Row(children: out,):
          layoutMode=="Column"?Column(children: out,):
          Stack(children: out,);
    }
    return null;
  }

  List<EdgeInsets> getPadding(Map data, double pcntsize){
    String layoutMode= data["content"]["layoutMode"];
    if(layoutMode=="Stack")return data["content"]["children"].map<EdgeInsets>((i)=>null).toList();
    //printJson(data["positioning"]);
    List<EdgeInsets> out = [];
    double left=0;
    bool first=false;
    double top=0;
    data["content"]["children"]?.forEach((childNodeID){
       Map nodeData = safeGet(key: childNodeID, map: apiManager.nodes, alt: null);
       double l=nodeData["positioning"]["left"]-left;
       if(l>0.0)
        out.add(EdgeInsets.only(left:l*pcntsize));
        else out.add(null);
      // print(nodeData["positioning"]["left"]-left);
       left=nodeData["positioning"]["width"]+nodeData["positioning"]["left"];
       //printJson(nodeData["positioning"]);
    });
    //print(out.length);
    return out;
  }
}



//10 million a year
//

 //Color.fromARGB(Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), Random().nextInt(255)),




  BoxDecoration getDecoration(
    Map containerData,
  ){
    String c = safeGet(key: "color", map: containerData, alt: null);
    return BoxDecoration(
             color: colorFromString(c),
             //Color.fromARGB(Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), Random().nextInt(255)),
              border:_getBoxBorder(containerData["border"]),
              borderRadius:_getBorderRadius(containerData["boxRadius"]),
              boxShadow:_getBoxShadows(containerData["boxShadow"]),
              gradient: _getGradient(), //Todo
              backgroundBlendMode: _getBlendMode(),
            );
  }
 String getDecorationString(
    Map containerData,
  ){
    String c = safeGet(key: "color", map: containerData, alt: null);
    String col = colorStringFromString(c);
    return '''BoxDecoration(
             color: $col,
            ),''';
  }



  Gradient _getGradient()=>null; //todo
  BlendMode _getBlendMode()=>null; // todo






  BorderRadiusGeometry _getBorderRadius(dynamic rad){
   //print(rad);
    if(rad==null)return null;
    if(rad is double){
      return BorderRadius.all(Radius.circular(rad));
    }
    try{
    return BorderRadius.only(
                topLeft: Radius.circular(rad["topLeft"]),
                topRight: Radius.circular(rad["topRight"]),
                bottomLeft: Radius.circular(rad["bottomLeft"]),
                bottomRight: Radius.circular(rad["bottomRight"]),
              );
    }catch(e){
      return null;
    }
  }

BoxBorder _getBoxBorder(Map border){
   if(border==null)return null;
   return Border.all(
     color: colorFromString(border["color"]),
     width: border["weight"]
   );
}



  List<BoxShadow> _getBoxShadows(List boxShadow){
     if(boxShadow==null || boxShadow==[])return [];
     return  boxShadow.map<BoxShadow>((effect){
       Offset o;
        try{o=Offset(effect['offset']['x'], effect['offset']['y']);}catch(e){}
              return  BoxShadow(
                      color:colorFromString(effect["color"])??Colors.black,
                      offset:o??Offset(0, 0),
                      blurRadius:effect['blurRadius'].toDouble(),
                      //spreadRadius:,
                    );
                    
                    }
                ).toList();
  }







  //  String getDecorationString(String color){
  //   // check if visible/ pass through
      
  //   if(data.containsKey("blendMode") && data["blendMode"]=="PASS_THROUGH"){
  //         return "null,";
  //   }
  //   return '''BoxDecoration(
  //             color:$color,
  //           ),''';
  // }

  // List<BoxShadow> _getBoxShadows(){
  //    if(!data.containsKey("effects") || data["effects"].length==0)return [];
  //    return  data["effects"].map<BoxShadow>((effect)=>
  //               BoxShadow(
  //                     color:parseColor(effect),
  //                     offset:Offset(effect['offset']['x'], effect['offset']['y']),
  //                     blurRadius:effect['radius'].toDouble(),
  //                     //spreadRadius:,
  //                   )
  //               ).toList();
  // }




  //   String _printWidget(String nodeID, double pcntSize, {String layoutMode= "stack"}){
  //   Map nodeData = safeGet(key: nodeID, map: apiManager.nodes, alt: null);
  //   layoutMode??="Stack";
  //   if(nodeData==null)return null;
  //   String nodeClass = nodeData["class"];
  //   switch (nodeClass) {
  //     case "frame":
  //       List<String> outStrings= [];
  //       nodeData["children"]?.forEach((childNodeData){
  //          outStrings.add(_printWidget(childNodeData, pcntSize, layoutMode: nodeData["layoutMode"]));
  //         }); 
  //       return frameDataToWidgetString(pcntSize, nodeData, outStrings, layoutMode);
  //       break;
  //     case "vector":return vectorDataToWidgetString(pcntSize, nodeData, layoutMode);break;
  //     case "text":return textDataToWidgetString(pcntSize, nodeData, layoutMode);break;
      
  //     default:return "null";
  //   }
  // }