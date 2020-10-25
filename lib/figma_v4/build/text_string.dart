



import 'package:figmatic/figma_v2/figma_text/utils/get_google_fonts.dart';
import 'package:figmatic/figma_v2/utils/figma_utils.dart';
import 'package:figmatic/figma_v2/utils/widget_utils.dart';
import 'package:figmatic/figma_v3/color_util.dart';
import 'package:figmatic/utils.dart';
import 'package:flutter/material.dart';

String textDataToString(double pcntSize, Map<String,dynamic> data){
  Rect windowRect = toWindowRect(positionData: data["positioning"], pcntSize:pcntSize);
  String tx = data["styleText"]??"";
  var fontFam = checkPath(data, ["style", "fontFamily"])[1];
  double fontSize= data["style"]["figmaFontSize"]??12.0;

  return positionedWrapperString(
    windowRect: windowRect,
    child: toRichTextString(
      tx: tx,
      fontFam: fontFam,
      fontSize: fontSize*pcntSize,
     // windowRect: windowRect,
      pcntSize: pcntSize
    )
  );
}




String toRichTextString({@required String tx, double fontSize=12.0, String fontFam, double pcntSize=1.0, String align = "TextAlign.left" }) {
  
  List<String> textSpans = toTextSpanString(
      tx: tx,
      fontSize: fontSize,
      fontFam: fontFam,
      pcntSize: pcntSize
      );
  return
  '''RichText(
    overflow: TextOverflow.visible,
    textAlign: $align,
    text: TextSpan(children: ${textSpans.join(",\n")}
    )
  )''';
}




List<String> toTextSpanString({@required String tx, double fontSize=12.0, String fontFam, double pcntSize=1.0 }) {

  String fontFamily = (getGoogleFonts.containsKey(fontFam))?fontFam:null;
  //print(tx);
  var vars = {
    "token": "#", // "#"
    "isItalic": "FontStyle.normal",
    "fontSize":fontSize,
    // autoSize( quoteLength: basicText.length,  parentArea: (windowRect.width*windowRect.height).toInt() ),
    "color": "Colors.black",
    "fontWeight": "FontWeight.normal",
    "fontFamily": fontFamily,
    "fontType": "FontStyle.normal"
  };
  List<String> links = [];
  bool hasLink = false;

  List<String> textWidgets = [];
  List v = ["100", "200", "300", "400", "500", "600", "700", "800", "900"];
  tx.split(vars["token"]).forEach((textSeg) {

    if (textSeg.length>2&& textSeg.substring(0,3)=="/fw")
      vars["fontWeight"] = "FontWeight.w400";
    else if (textSeg.contains("fw") && v.contains(textSeg.substring(2)))
      vars["fontWeight"] = "FontWeight.values[${v.indexOf(textSeg.substring(2))}]";
    else if (textSeg == "/italic")
      vars["fontType"] = "FontStyle.normal";
    else if (textSeg == "italic")
      vars["fontType"] = "FontStyle.italic";
    else if (textSeg.contains("/color"))
      vars["color"] = "Colors.black"; 
    else if (textSeg.contains("color"))
      vars["color"] =colorStringFromString(textSeg.substring("color".length)) ?? "Colors.black";
    else if (textSeg.length>4&& textSeg.substring(0,4)=="size"){}//TODO font size
    //   vars["fontSize"] =double.tryParse(textSeg.substring("size".length)) ?? 12.0;
    else if (textSeg.length>5&& textSeg.substring(0,5)=="/size"){}
    //   vars["fontSize"] = 16.0;
    else if (textSeg.contains("/link"))
      hasLink = false;
    else if (textSeg.contains("link")) {
      hasLink = true;
      links.add(textSeg.substring("link".length));
     // print(links);
    } else {
      //
      
       // print(textSeg);
       String s = '''TextStyle(
                fontStyle: ${vars["fontType"]},
                fontSize: ${vars["fontSize"]},
                fontWeight: ${vars["fontWeight"]},
                color: ${vars["color"]})''';
        textWidgets.add(
          '''TextSpan(
            text: \"$textSeg\",
            style: $s
            ),''');
            // TextSpan(
            // text: textSeg,
            // style: (vars["fontFamily"]!=null)
            // ?getGoogleFonts[vars["fontFamily"]](s)
            // :s
            // ),
      
    }
  });
  return textWidgets;
}

String getTextAlign(String al){
 // String al= jsonData['style']['textAlign'];
  return (al=="LEFT")?"TextAlign.left":(al=="RIGHT")?"TextAlign.right":(al=="CENTER")?"TextAlign.center":"TextAlign.left";
}

