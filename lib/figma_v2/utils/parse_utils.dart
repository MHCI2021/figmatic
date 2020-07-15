

import 'package:flutter/material.dart';
import 'dart:math' as math;


double autoSize({@required int quoteLength, @required int parentArea}) {
    assert(quoteLength != null, "`quoteLength` may not be null");
    assert(parentArea != null, "`parentArea` may not be null");
    final areaOfLetter = parentArea / quoteLength;
    final pixelOfLetter = math.sqrt(areaOfLetter);
    final pixelOfLetterP = pixelOfLetter - (pixelOfLetter * 3) / 100;
    return pixelOfLetterP;
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

// Map<String, dynamic> parseEffectsColor(var data){
//     try {
//        return data['color'];
//     }catch(r){
//       return null;
//     }
// }


// Map<String,dynamic> parseFrameColor(Map<String,dynamic> data){
//     double op; ///=1.0;
//     if(data.containsKey("blendMode") && data["blendMode"]=="PASS_THROUGH")return null;
//      try{ op=data['fills'][0]["opacity"]??1.0;}catch(e){op =1.0;}
//       Map<String,dynamic> c = data['fills'][0]['color'];
//       c["opacity"]= op;
//       return c;
// }

// Map<String, dynamic> parseTextColor(var data){
//     try {
//        return data['fills'][0]['color'];
//     }catch(r){
//       return null;
//     }
// }

