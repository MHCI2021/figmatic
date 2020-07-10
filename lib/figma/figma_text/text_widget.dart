


import 'package:figmatic/figma/utils/color_utils.dart';
import 'package:flutter/material.dart';

import '../../utils.dart';
import '../utils/figma_utils.dart';
import '../utils/widget_utils.dart';
import 'package:flutter/gestures.dart';
import 'dart:math' as math;

import 'utils/get_google_fonts.dart';



Widget textDataToWidget(double pcntSize, Map<String,dynamic> data){
  Rect windowRect = toWindowRect(positionData: data["positioning"], pcntSize:pcntSize);
  return positionedWrapper(
    windowRect: windowRect,
    child: toRichText(
      data: data,
      windowRect: windowRect,
      pcntSize: pcntSize
    )
  );
}



RichText toRichText({@required Rect windowRect ,@required Map<String,dynamic> data, @required double pcntSize}) {
  return RichText(
    overflow: TextOverflow.visible,
    textAlign: getTextAlign(data),
    text: TextSpan(children: toTextSpan(
      windowRect: windowRect,
      data: data,
      pcntSize: pcntSize
      )
    )
  );
}


List<TextSpan> toTextSpan({@required Rect windowRect ,@required Map<String,dynamic> data, @required double pcntSize}) {
  String tx = data["styleText"]??"";
  String basicText = data["text"]??"";
  //printJson(data);
  var fontFam = checkPath(data, ["style", "fontFamily"]);
  String fontFamily = (fontFam[0] && getGoogleFonts.containsKey(fontFam[1]))?fontFam[1]:null;
  
  var vars = {
    "token": "#", // "#"
    "isItalic": FontStyle.normal,
    "fontSize":data["style"]["figmaFontSize"]*pcntSize,
    // autoSize( quoteLength: basicText.length,  parentArea: (windowRect.width*windowRect.height).toInt() ),
    "color": Colors.black,
    "fontWeight": FontWeight.normal,
    "fontFamily": fontFamily,
    "fontType": FontStyle.normal
  };
  List<String> links = [];
  bool hasLink = false;

  List<TextSpan> textWidgets = [];
  List v = ["100", "200", "300", "400", "500", "600", "700", "800", "900"];
  tx.split(vars["token"]).forEach((textSeg) {

    if (textSeg.contains("/fw"))
      vars["fontWeight"] = FontWeight.w400;
    else if (textSeg.contains("fw") && v.contains(textSeg.substring(2)))
      vars["fontWeight"] = FontWeight.values[v.indexOf(textSeg.substring(2))];
    else if (textSeg == "/italic")
      vars["fontType"] = FontStyle.normal;
    else if (textSeg == "italic")
      vars["fontType"] = FontStyle.italic;
    else if (textSeg.contains("/color"))
      vars["color"] = Colors.black; 
    else if (textSeg.contains("color"))
      vars["color"] =colorFromString(textSeg.substring("color".length)) ?? Colors.black;
    else if (textSeg.contains("size")){}//TODO font size
    //   vars["fontSize"] =double.tryParse(textSeg.substring("size".length)) ?? 12.0;
    else if (textSeg.contains("/size")){}
    //   vars["fontSize"] = 16.0;
    else if (textSeg.contains("/link"))
      hasLink = false;
    else if (textSeg.contains("link")) {
      hasLink = true;
      links.add(textSeg.substring("link".length));
     // print(links);
    } else {
      //
      
      final int o = links.length - 1;
      if (hasLink) {
      //  print(textSeg);
        TextStyle s =TextStyle(
              fontSize: vars["fontSize"]*pcntSize,
              fontWeight: vars["fontWeight"],
              color: Colors.blue,
              decoration: TextDecoration.underline, 
        );
        textWidgets.add(TextSpan(
            text: textSeg,
            recognizer: TapGestureRecognizer()
              ..onTap = () //{
               // print("tapped");
               // print(links[o]);
               => launch(links[o]),
             // },
            style:(vars["fontFamily"]!=null)
            ?getGoogleFonts[vars["fontFamily"]](s)
            :s
            )
          );
      } else {
        TextStyle s = TextStyle(
                fontStyle: vars["fontType"],
                fontSize: vars["fontSize"]*(0.5+ 0.5*pcntSize).clamp(0, 1.0),
                fontWeight: vars["fontWeight"],
                color: vars["color"]);
        textWidgets.add(TextSpan(
            text: textSeg,
            style: (vars["fontFamily"]!=null)
            ?getGoogleFonts[vars["fontFamily"]](s)
            :s
            ));
      }
    }
  });
  return textWidgets;
}





TextAlign getTextAlign(dynamic jsonData){
  String al= jsonData['style']['textAlign'];
  return (al=="LEFT")?TextAlign.left:(al=="RIGHT")?TextAlign.right:(al=="CENTER")?TextAlign.center:TextAlign.left;
}


// double autoSize({@required int quoteLength, @required int parentArea}) {
//     assert(quoteLength != null, "`quoteLength` may not be null");
//     assert(parentArea != null, "`parentArea` may not be null");
//     final areaOfLetter = parentArea / quoteLength;
//     final pixelOfLetter = math.sqrt(areaOfLetter);
//     final pixelOfLetterP = pixelOfLetter - (pixelOfLetter * 1) / 100;
//     return pixelOfLetterP;
//   }
  // String text = data["styleText"]??"";
  // String basictext = data["text"]??"";

  //  Text(
  //         text, 
  //         textAlign:getTextAlign(data),
  //         style: TextStyle(
  //           color: getTextColor(data),
  //           fontSize: autoSize(
  //             quoteLength: text.length, 
  //             parentArea: (windowRect.width*windowRect.height).toInt()
  //           ),
  //         ),
  //         ),