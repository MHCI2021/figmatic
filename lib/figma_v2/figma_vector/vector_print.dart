


import 'package:figmatic/figma_v2/utils/color_utils.dart';
import 'package:figmatic/utils.dart';
import 'package:flutter/material.dart';

import '../utils/figma_utils.dart';
import '../utils/widget_utils.dart';


String vectorDataToWidgetString(double pcntSize, Map<String,dynamic> data, String layoutMode){
  Rect windowRect = toWindowRect(positionData: data["positioning"], pcntSize:pcntSize); 
  return (layoutMode == "stack")? positionedWrapperString(
    windowRect: windowRect,
    child:  _getVectorWidgetString(windowRect,data)
    ): containerWrapperString(
    windowRect: windowRect,
    child:  _getVectorWidgetString(windowRect,data)
    );   
}

String _getVectorWidgetString(Rect windowRect, Map<String,dynamic> data){
  if(data["imageUrl"]!=null)return "Image.network(\"${data["imageUrl"]}\", fit: BoxFit.cover,)";
  if(data["paint"]!=null) {
    if(data['paint']["color"]==null){
     // printJson(data);
      return "";
    }
    return 
      '''//${data["name"]}
       CustomPaint(
                    size: Size(${windowRect.size.height.toStringAsFixed(3)},${windowRect.size.width.toStringAsFixed(3)}),
                    painter: VectorPathPainter(
                      \'''${data['paint']['path']}\''', 
                      ${colorFromString(data['paint']["color"])},
                      PaintingStyle.fill
                    )),
        ''';
    }
  if(safeGetPath(data, ["style", "border","paint"])!=null){
      //printJson(data);
          return 
          '''//${data["name"]}
           CustomPaint(
                  size: Size(${windowRect.size.height},${windowRect.size.width}),
                  painter: VectorPathPainter(
                    \'''${data["style"]["border"]['paint']['path']}\''', 
                    ${colorStringFromString(data["style"]["border"]['paint']["color"])},
                    PaintingStyle.stroke)),''';
    }
  return '''//${data["name"]}
  Container(width:double.infinity, height:double.infinity,
            decoration: ${FigmaStyles(data).getDecorationString(data['style']["color"])}),''';
}

String vectorDataToStylizedString(double pcntSize, Map<String,dynamic> data, String layoutMode){
  Rect windowRect = toWindowRect(positionData: data["positioning"], pcntSize:pcntSize); 
  return (layoutMode == "stack")? positionedWrapperString(
    windowRect: windowRect,
    child:  _getVectorStylizedString(windowRect,data)
    ): containerWrapperString(
    windowRect: windowRect,
    child:  _getVectorStylizedString(windowRect,data)
    );   
}
String _getVectorStylizedString(Rect windowRect, Map<String,dynamic> data){
  if(data["imageUrl"]!=null)return "#colorgreen##fw700#Image#colorwhite##/fw#.network(\"${data["imageUrl"]}\", fit: BoxFit.cover,)";
  if(data["paint"]!=null) {
    if(data['paint']["color"]==null){
     // printJson(data);
      return "";
    }
    return 
      '''//${data["name"]}
       #colorgreen##fw700#CustomPaint#colorwhite##/fw#(
                    size: Size(${windowRect.size.height.toStringAsFixed(3)},${windowRect.size.width.toStringAsFixed(3)}),
                    painter: VectorPathPainter(
                      \'''${data['paint']['path']}\''', 
                      ${colorFromString(data['paint']["color"])},
                      PaintingStyle.fill
                    )),
        ''';
    }
  if(safeGetPath(data, ["style", "border","paint"])!=null){
      //printJson(data);
          return 
          '''//${data["name"]}
           CustomPaint(
                  size: Size(${windowRect.size.height},${windowRect.size.width}),
                  painter: VectorPathPainter(
                    \'''${data["style"]["border"]['paint']['path']}\''', 
                    ${colorStringFromString(data["style"]["border"]['paint']["color"])},
                    PaintingStyle.stroke)),''';
    }
  return '''//${data["name"]}
  Container(width:double.infinity, height:double.infinity,
            decoration: ${FigmaStyles(data).getDecorationString(data['style']["color"])}),''';
}

  // //print(data['paint']["color"]);
  // //print(getVectorColor(data['paint']["color"]));
  // return positionedWrapper(
  //   windowRect: windowRect,
  //   child:
  //   (data["paint"]==null)?
  //   Container(width:double.infinity, height:double.infinity,
  //           decoration: FigmaStyles(data).getDecoration(getVectorColor(data["style"]["backgroundColor"])))
  //   : 
  //       );

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


/*
   '''//${data["name"]}
      Container(width:double.infinity, height:double.infinity,
      child: CustomPaint(
                    size: Size(${windowRect.size.height},${windowRect.size.width}),
                    painter: VectorPathPainter(
                      \'''${data['paint']['path']}\''', 
                      ${colorFromString(data['paint']["color"])},
                      PaintingStyle.fill
                    ))),
        ''';
    }
  if(safeGetPath(data, ["style", "border","paint"])!=null){
      printJson(data);
          return 
          '''//${data["name"]}
          Container(width:double.infinity,height:double.infinity,
                child: CustomPaint(
                  size: Size(${windowRect.size.height},${windowRect.size.width}),
                  painter: VectorPathPainter(
                    \'''${data["style"]["border"]['paint']['path']}\''', 
                    ${colorStringFromString(data["style"]["border"]['paint']["color"])},
                    PaintingStyle.stroke))
            ),''';
    }
  return '''//${data["name"]}
  Container(width:double.infinity, height:double.infinity,
            decoration: ${FigmaStyles(data).getDecorationString(data['style']["color"])}),''';



*/