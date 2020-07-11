


import 'package:figmatic/figma/utils/color_utils.dart';
//import 'package:figmatic/utils.dart';
import 'package:flutter/material.dart';

import '../utils/figma_utils.dart';
import '../utils/widget_utils.dart';


String frameDataToWidgetString(double pcntSize, Map<String,dynamic> data, List<String> children, String layoutMode){
  Rect windowRect = toWindowRect(positionData: data["positioning"], pcntSize:pcntSize);
  //print(windowRect);
  String _checkDec(String inner){
    String s = colorStringFromString(data["style"]["color"]);
    if(s==null)return inner;
    else return'''Container(
        decoration:  BoxDecoration(color: $s),
        child: $inner)''';
  }
  String ty= data["type"];
  if(data["type"]=="INSTANCE"){
    print("INSTANCE ${data["name"]}");
  }
  String childs = children.join("\n");
  String out = _checkDec("$layoutMode(children: [$childs]),");
  if(ty=="COMPONENT"){
    print('''
  class ${data["name"]} extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return $out;
    }
  }
    ''');
  }
  return positionedWrapperString(
    windowRect: windowRect,
    child: (ty=="INSTANCE"||ty=="COMPONENT")?"${data["name"]}(),":
'''//${data["name"]}
$out
'''
  );
}

String frameDataToStylizedString(double pcntSize, Map<String,dynamic> data, List<String> children, String layoutMode){
  Rect windowRect = toWindowRect(positionData: data["positioning"], pcntSize:pcntSize);
  //print(windowRect);
  String _checkDec(String inner){
    String s = colorStringFromString(data["style"]["color"]);
    if(s==null)return inner;
    else return'''#fw700##colorgreen#Container#colorwhite##/fw#(
        decoration:  #fw700##colorgreen#BoxDecoration#colorwhite##/fw#(color: $s),
        child: $inner)''';
  }
  String ty= data["type"];
  if(data["type"]=="INSTANCE"){
    print("INSTANCE ${data["name"]}");
  }
  String childs = children.join("\n");
  String out = _checkDec("$layoutMode(children: [$childs]),");
  if(ty=="COMPONENT"){
    print('''
  #colorblue600##fw700#class#colorgreen700# ${data["name"]} #colorblue#extends #colorgreen#StatelessWidget#colorwhite##/fw# {
    #fw700#@override
    #colorgreen#Widget#coloryellow600# build#colorwhite##/fw#(BuildContext context) {
      #fw700##colorpurple#return $out;
    }
  }
    ''');
  }
  return positionedWrapperString(
    windowRect: windowRect,
    child: (ty=="INSTANCE"||ty=="COMPONENT")?"${data["name"]}(),":
'''//${data["name"]}
$out
'''
  );
}

  //     Container(width:double.infinity, height:double.infinity,
  // decoration:  BoxDecoration(color: ${colorStringFromString(data["style"]["color"])}),
  // child: Stack(children: [$childs]),)

// Container(width:double.infinity, height:double.infinity,
//   decoration:  BoxDecoration(color: ${colorStringFromString(data["style"]["color"])}),
//   child: Stack(children: [$childs]),),