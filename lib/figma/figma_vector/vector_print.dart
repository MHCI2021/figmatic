


import 'package:figmatic/figma/utils/color_utils.dart';
import 'package:figmatic/utils.dart';
import 'package:flutter/material.dart';

import '../utils/figma_utils.dart';
import '../utils/widget_utils.dart';


Widget vectorDataToWidget(double pcntSize, Map<String,dynamic> data){
  Rect windowRect = toWindowRect(positionData: data["positioning"], pcntSize:pcntSize); 
  return 
  
  positionedWrapper(
    windowRect: windowRect,
    child:  _getVectorWidget(windowRect,data)
    );   
}

Widget _getVectorWidget(Rect windowRect, Map<String,dynamic> data){
  if(data["imageUrl"]!=null)return Image.network(data["imageUrl"], fit: BoxFit.cover,);
  if(data["paint"]!=null) {

    if(data['paint']["color"]==null){
     // printJson(data);
      return null;
    }
  
    return Container(width:double.infinity, height:double.infinity,
    child: CustomPaint(
                  size: windowRect.size,
                  painter: VectorPathPainter(
                    data['paint']['path'], 
                    colorFromString(data['paint']["color"])??Colors.black,
                    PaintingStyle.fill
                  )
                ));
    }
  if(safeGetPath(data, ["style", "border","paint"])!=null){
      printJson(data);
          return Container(width:double.infinity, height:double.infinity,
                child: CustomPaint(
                  size: windowRect.size,
                  painter: VectorPathPainter(
                    data["style"]["border"]['paint']['path'], 
                    colorFromString(data["style"]["border"]['paint']["color"])??Colors.black,
                    PaintingStyle.stroke
                  )
                ));
    }
  return Container(width:double.infinity, height:double.infinity,
            decoration: FigmaStyles(data).getDecoration(colorFromString(data['style']["color"])));
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
