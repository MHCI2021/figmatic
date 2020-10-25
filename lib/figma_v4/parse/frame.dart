

import 'package:flutter/foundation.dart';

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
 