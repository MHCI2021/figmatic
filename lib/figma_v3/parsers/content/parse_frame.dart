
import 'package:figmatic/utils.dart';
import 'package:flutter/material.dart';

////
/// Everything necessary for building `frameWidget`
/// Will be wrapped in `Positioned` and/or `Container` widget depending on the rest of figma data
///
///
///
///
///

Map<String,dynamic> parseFrame({
  List childrenIds,
  Map<String,dynamic> size,
  @required String layoutMode
}){

    if(childrenIds==null || size==null)return null;

    Map<String,dynamic> out={
        "size":size,
        "layoutMode":layoutMode,
        "children":childrenIds,
         "transitionNode":null
      };
  return out;
}
 

