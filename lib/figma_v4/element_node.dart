




import 'dart:math';

import 'package:figmatic/figma_v2/utils/widget_utils.dart';
import 'package:figmatic/figma_v3/color_util.dart';
import 'package:figmatic/figma_v3/parsers/parse_container.dart';
import 'package:figmatic/figma_v4/build/text.dart';
import 'package:figmatic/figma_v4/parse/position.dart';
import 'package:figmatic/figma_v4/parse/text.dart';
import 'package:figmatic/figma_v4/parse/vector.dart';
import 'package:figmatic/figma_v4/utils.dart';
import 'package:figmatic/utils.dart';
import 'package:flutter/material.dart';

////
///
///
class ElementNode {
  String id, type,name, figmaClass;
  Map<String,dynamic> figmaData;
  Map<String,dynamic> widgetData;
  Map<String,dynamic> positionData;
  Map<String,dynamic> containerData;
  Map<String,dynamic> contentData;
  String widgetString, layoutMode;
  bool image, isWidget=false;
  Point figmaOffset;
  List parentPath;
  List childrenIDs;


  //List<String> get path =>[id]..addAll(parentPath??[]);

  ElementNode({
    @required this.id,
    @required this.type,
    @required this.name,
    @required this.figmaClass,
    @required this.positionData,
    this.layoutMode,
    @required Map<String, dynamic> data, 
    this.parentPath, 

    }){
    figmaData={};
    data.forEach((key, value) {
      if(key=="children"){
        childrenIDs=value.map((childData)=>childData["id"]).toList();
      }
      else figmaData[key]=value;
    });
    _parse();
   // _print();
  }

  

  _parse(){
        if(figmaClass=="text") contentData=parseText(figmaData);
       if(figmaClass=="vector")contentData=parseVector(figmaData);
    containerData=  parseContainer(
          data: figmaData,
          figmaClass:figmaClass,
          isVectorPath: (figmaClass=="vector"&&contentData!=null)
        );
  

    ////Layer 1 (wrapped) -> if stacked
    ///Layer 2 ( container) 
   
  }
  
  Widget buildWidget({List<Widget> children,bool root=false,@required double scale }){
 
    if(layoutMode!=null){
      Widget inner;
      if(layoutMode=="Stack") inner = Stack(children: children,);
      if(layoutMode=="Column") inner = Column(children: children,);
      if(layoutMode=="Row") inner = Row(children: children,);
     // if (root) return inner;
      return positionWidget(positionData, 
      Container(child: inner,
          width: positionData["width"]*scale,
           height:positionData["height"]*scale,
      ), scale, true);
    }

      Widget inner= Container(
       width:positionData["width"]*scale,
        height:positionData["height"]*scale,
        decoration: getDecoration(containerData),
         //color:Color.fromARGB(Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), Random().nextInt(255)),
         child:_contentWidget(pcntSize:scale)
      ); 
     
    return positionWidget(positionData, inner, scale, false);

  }
  String printWidget({String children,bool root=false, int push=0}){
   
    String out="";
  //  String pushStr = 
    if(children!="" && layoutMode!=null){
      String inner= '''
      #fw700##colorgreen#$layoutMode#colorwhite##/fw#(
        children:[
          $children
        ]
      ),
      '''.padLeft(6); 
      out = positionWidgetString(positionData, inner);
      if(root)return printStatelessWidget(out);
      return out;
    }
      
   
      String randC="Color.fromARGB(${Random().nextInt(255)}, ${Random().nextInt(255)}, ${Random().nextInt(255)}, ${Random().nextInt(255)}),";
      String inner= '''#fw700##colorgreen#Container#colorwhite##/fw#(
       width:${positionData["width"]},
        height:${positionData["height"]},
         color:$randC,
         child: Center(child:Text(\"$name\"))
      ),

      '''; 
      out = positionWidgetString(positionData, inner);
    return out;
  }

 String printStatelessWidget(String out){
   return '''#colorblue600##fw700#class#colorgreen700# $name #colorblue#extends #colorgreen#StatelessWidget#colorwhite##/fw# {
    #fw700#@override
    #colorgreen#Widget#coloryellow600# build#colorwhite##/fw#(BuildContext context) {
      #fw700##colorpurple#return $out;
    }
  }
    ''';
  
  }

  _print({String child, List<String> children}){
    print("___________________");

    print(name);
    print(id);
    print(parentPath);
    // if(positionData["layoutType"=="Stack"]){
    //   print();
    // }
    printJson(positionData);
  }


  Widget _contentWidget({ bool isSized=false, @required double pcntSize,}){// TODO check null
    if(figmaClass=="text")return textDataToWidget(pcntSize:pcntSize, data:contentData,);
    //printJson(data["content"]);

    if(safeGet(key:"imageUrl", map:contentData, alt:null)!=null){
     // print(data["content"]["imageUrl"]);
      return Image.network(contentData["imageUrl"], fit: BoxFit.cover,);
    }
    if(figmaClass=="vector" && contentData!=null){
      print(positionData["width"]*pcntSize);
      print( positionData["height"]*pcntSize);
      return Container(
        height: double.infinity,
        width: double.infinity,
        child: CustomPaint(
              size: Size(positionData["width"]*pcntSize, positionData["height"]*pcntSize),
              painter: VectorPathPainter(
                  contentData['path'],
                  colorFromString(contentData["color"]) ?? Colors.black,
                  PaintingStyle.fill)),
      );
    }
    return null;
  }


}




class FigmaParser {



}







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




//  String getDecorationString(
//     Map containerData,
//   ){
//     String c = safeGet(key: "color", map: containerData, alt: null);
//     String col = colorStringFromString(c);
//     return '''BoxDecoration(
//              color: $col,
//             ),''';
//   }


//   Widget _positionWidget({@required Map data, double pcntSize=1, String layoutMode = "Stack",EdgeInsets padding}){// TODO check null
//     //print(pcntSize);

//     Map positionData= data["positioning"];
//     if(positionData==null || layoutMode!="Stack")
//       return _containerWidget(data: data,isSized: false, pcntSize: pcntSize, padding:padding);

    
//     return Positioned(
//           top:pcntSize*positionData["top"],
//           left: pcntSize*positionData["left"],
//           height:pcntSize*positionData["height"],
//           width:pcntSize*positionData["width"], 
//         child: _containerWidget(data: data, pcntSize:pcntSize, isSized: true));
//   }



  // Widget _containerWidget({@required Map data, double pcntSize=1,bool isSized=false, EdgeInsets padding}){// TODO check null
  //   Map containerData = data["container"];
   
  //   if(containerData==null)return _contentWidget(data: data, pcntSize: pcntSize, isSized: false);
  // // printJson(data);

  // if(padding!=null){
  //   //print(padding.left);
  //   return Padding(padding: padding, 
  //   child:Container(
    
  //     height: isSized?double.infinity:(data["positioning"]["height"]*pcntSize),
  //     width: isSized?double.infinity:data["positioning"]["width"]*pcntSize,
  //     decoration: getDecoration(containerData),
     
  //     child: _contentWidget(data: data, pcntSize: pcntSize, isSized: isSized)
  //   )
  //   );
  // }
  // return Container(
  //     height: isSized?double.infinity:data["positioning"]["height"]*pcntSize,
  //     width: isSized?double.infinity:data["positioning"]["width"]*pcntSize,
  //     decoration: getDecoration(containerData),
     
  //     child: _contentWidget(data: data, pcntSize: pcntSize, isSized: isSized)
  //   );
  // }


//   List<EdgeInsets> getPadding(Map data, double pcntsize){
//     String layoutMode= data["content"]["layoutMode"];
//     if(layoutMode=="Stack")return data["content"]["children"].map<EdgeInsets>((i)=>null).toList();
//     //printJson(data["positioning"]);
//     List<EdgeInsets> out = [];
//     double left=0;
//     bool first=false;
//     double top=0;
//     data["content"]["children"]?.forEach((childNodeID){
//        Map nodeData = safeGet(key: childNodeID, map: apiManager.nodes, alt: null);
//        double l=nodeData["positioning"]["left"]-left;
//        if(l>0.0)
//         out.add(EdgeInsets.only(left:l*pcntsize));
//         else out.add(null);
//       // print(nodeData["positioning"]["left"]-left);
//        left=nodeData["positioning"]["width"]+nodeData["positioning"]["left"];
//        //printJson(nodeData["positioning"]);
//     });
//     //print(out.length);
//     return out;
//   }
// }



// //10 million a year
// //

//  //Color.fromARGB(Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), Random().nextInt(255)),


// String frameDataToWidgetString(double pcntSize, Map<String,dynamic> data, List<String> children, String layoutMode){
//   Rect windowRect = toWindowRect(positionData: data["positioning"], pcntSize:pcntSize);
//   //print(windowRect);
//   String _checkDec(String inner){
//     String s = colorStringFromString(data["style"]["color"]);
//     if(s==null)return inner;
//     else return'''Container(
//         decoration:  BoxDecoration(color: $s),
//         child: $inner)''';
//   }
//   String ty= data["type"];
//   if(data["type"]=="INSTANCE"){
//     print("INSTANCE ${data["name"]}");
//   }
//   String childs = children.join("\n");
//   String out = _checkDec("$layoutMode(children: [$childs]),");
//   if(ty=="COMPONENT"){
//     print('''
//   class ${data["name"]} extends StatelessWidget {
//     @override
//     Widget build(BuildContext context) {
//       return $out;
//     }
//   }
//     ''');
//   }
//   return positionedWrapperString(
//     windowRect: windowRect,
//     child: (ty=="INSTANCE"||ty=="COMPONENT")?"${data["name"]}(),":
// '''//${data["name"]}
// $out
// '''
//   );
// }

// String frameDataToStylizedString(double pcntSize, Map<String,dynamic> data, List<String> children, String layoutMode){
//   Rect windowRect = toWindowRect(positionData: data["positioning"], pcntSize:pcntSize);
//   //print(windowRect);
//   String _checkDec(String inner){
//     String s = colorStringFromString(data["style"]["color"]);
//     if(s==null)return inner;
//     else return'''#fw700##colorgreen#Container#colorwhite##/fw#(
//         decoration:  #fw700##colorgreen#BoxDecoration#colorwhite##/fw#(color: $s),
//         child: $inner)''';
//   }
//   String ty= data["type"];
//   if(data["type"]=="INSTANCE"){
//     print("INSTANCE ${data["name"]}");
//   }
//   String childs = children.join("\n");
//   String out = _checkDec("$layoutMode(children: [$childs]),");
//   if(ty=="COMPONENT"){
//     print('''
//   #colorblue600##fw700#class#colorgreen700# ${data["name"]} #colorblue#extends #colorgreen#StatelessWidget#colorwhite##/fw# {
//     #fw700#@override
//     #colorgreen#Widget#coloryellow600# build#colorwhite##/fw#(BuildContext context) {
//       #fw700##colorpurple#return $out;
//     }
//   }
//     ''');
//   }
//   return positionedWrapperString(
//     windowRect: windowRect,
//     child: (ty=="INSTANCE"||ty=="COMPONENT")?"${data["name"]}(),":
// '''//${data["name"]}
// $out
// '''
//   );
// }

  // figmaClass=_getFigmaClass(figmaData["type"]);
  //   id= figmaData["id"];
  //   type= figmaData["type"];
  //   image=isImage(figmaData);






// Map<String,dynamic> parseNode(
//   {
  
//   Map<String,dynamic> figmaData, 
//   String figmaClass,
//   Point figmaOffset, 
//   List parentPath,
//   Map<String,dynamic> content
//   }){

//     Map<String,dynamic> out={
//         "id":figmaData["id"],
//         "type":figmaData["type"],
//         "class": figmaClass,
//         "name":figmaData["name"],
//         "isImage":isImage(figmaData),
//         "parentPath":parentPath??[],
//         "positioning":parsePosition(
//           absoluteBoundingBox: safeGet(key: "absoluteBoundingBox", map: figmaData, alt: null),
//           figmaOffset: figmaOffset
//         ),
//         "container": // check visible
//         parseContainer(
//           data: figmaData,
//           figmaClass:figmaClass,
//           isVectorPath: (figmaClass=="vector"&&content!=null)
//         ),
//         "content":content,
//       };
//      // printJson(out);
//   return out;
// }
 



// String type = data["type"];   
    
//     bool hasChildren = data.containsKey("children");
//     Map<String, dynamic> contentData;
//     if(type =="TEXT"){
//       figClass ="text";
//       contentData=parseText(data);
//     }else if (vectors.contains(type)){
//       figClass ="vector";
//       contentData=parseVector(data);
//     }else if (frames.contains(type)){
//       figClass ="frame";
//       contentData=parseFrame(
//         childrenIds: !hasChildren?null:data["children"].map((childData)=>childData["id"]).toList(),
//         size: data["size"],
//         layoutMode: (data.containsKey("layoutMode"))?
//                           data["layoutMode"]=="HORIZONTAL"?"Row":
//                           data["layoutMode"]=="VERTICAL"?"Column"
//                           :"Stack":"Stack",
//       );
//     }


//   nodes[data["id"]]= parseNode(
//       figmaData: data,
//       figmaOffset:figmaOffset,
//       figmaClass: figClass,
//       content: contentData,
//       parentPath: parentPath
//     );
//     if(hasChildren){
//       Point _figmaOffset;
//       // TODO deal with padding and layout
//      if(nodes[data["id"]]["type"]=="COMPONENT"){
//        widgets[data["name"]]=data["id"];
//        _figmaOffset= getOffsetPoint(safeGet(key: "absoluteBoundingBox", map: data, alt: null));
//      }
//      _figmaOffset= getOffsetPoint(safeGet(key: "absoluteBoundingBox", map: data, alt: null));
//      List l=[data["id"]];
//      l.addAll(parentPath);
//       data["children"].forEach((childData){
       

//       });
//     }




// _addImageUrls(String fileKey) async {
//    List<String> ids=[];
//     nodes?.forEach((nodeID, nodeData) {
//         if(nodeData.containsKey("isImage")&& nodeData["isImage"]==true){
//          // print(nodeID);
//           ids.add(nodeID);
//         }
//     });
   // print(ids);
  // }


  //   if(ids.isNotEmpty){
  //     String urlids = ids.join(",");
  //     var data = await _apiCall("images/$fileKey?ids=$urlids");
  //    // printJson(data);
  //     Map<String,dynamic> imagenodes = await data["error"]??data["images"];
  //     imagenodes.forEach((nodeID, imageUrl) {
  //       if(nodes[nodeID]["content"]==null)nodes[nodeID]["content"]={};
  //       nodes[nodeID]["content"]["imageUrl"]= imageUrl;
  //     });
  // }
//Map<String,dynamic> convertChildren


  // _getFigmaItem({
  //   Map<String, dynamic> data, 
  //   Point figmaOffset,
  //   List parentPath
  // }){
  //   String type = data["type"];   
  //   List<String> frames = ["CANVAS", "FRAME", "COMPONENT","INSTANCE", "GROUP"];
  //   List<String> vectors = ["RECTANGLE", "VECTOR", "STAR","LINE","ELLIPSE", "REGULAR_ POLYGON","SLICE"];
  //   String figClass;
  //   bool hasChildren = data.containsKey("children");
  //   Map<String, dynamic> contentData;
  //   if(type =="TEXT"){
  //     figClass ="text";
  //     contentData=parseText(data);
  //   }else if (vectors.contains(type)){
  //     figClass ="vector";
  //     contentData=parseVector(data);
  //   }else if (frames.contains(type)){
  //     figClass ="frame";
  //     contentData=parseFrame(
  //       childrenIds: !hasChildren?null:data["children"].map((childData)=>childData["id"]).toList(),
  //       size: data["size"],
  //       layoutMode: (data.containsKey("layoutMode"))?
  //                         data["layoutMode"]=="HORIZONTAL"?"Row":
  //                         data["layoutMode"]=="VERTICAL"?"Column"
  //                         :"Stack":"Stack",
  //     );
  //   }


  //   nodes[data["id"]]= parseNode(
  //     figmaData: data,
  //     figmaOffset:figmaOffset,
  //     figmaClass: figClass,
  //     content: contentData,
  //     parentPath: parentPath
  //   );
  //   if(hasChildren){
  //     Point _figmaOffset;
  //     // TODO deal with padding and layout
  //    if(nodes[data["id"]]["type"]=="COMPONENT"){
  //      widgets[data["name"]]=data["id"];
  //      _figmaOffset= getOffsetPoint(safeGet(key: "absoluteBoundingBox", map: data, alt: null));
  //    }
  //    _figmaOffset= getOffsetPoint(safeGet(key: "absoluteBoundingBox", map: data, alt: null));
  //    List l=[data["id"]];
  //    l.addAll(parentPath);
  //     data["children"].forEach((childData){
       
  //       _getFigmaItem(
  //         data:childData, 
  //         figmaOffset: _figmaOffset??figmaOffset,
  //         parentPath:l
  //         );
  //     });
  //   }
  // }