
// import 'package:figmatic/figma/figma_frame/frame_print.dart';
// import 'package:figmatic/figma/figma_text/text_widget.dart';

import 'package:figmatic/figma_v2/figma_text/utils/get_google_fonts.dart';
import 'package:figmatic/figma_v3/color_util.dart';
import 'package:figmatic/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';



Widget textDataToWidget({Map<String,dynamic> data, double pcntSize, }){
  String tx = data["content"]["styleText"]??"";
 // printJson(data);
  var fontFam = checkPath(data, ["content","style", "fontFamily"])[1];
  var shadows = checkPath(data, ["content","style", "textShadow"])[1];
  double fontSize= data["content"]["style"]["figmaFontSize"]??12.0;

  return toRichText(
      tx: tx,
      fontFam: fontFam,
      fontSize: fontSize*pcntSize,
      pcntSize: pcntSize,
      shadows: shadows

  );
}



RichText toRichText({@required String tx, double fontSize=12.0, String fontFam, double pcntSize=1.0, TextAlign align = TextAlign.left, List shadows }) {
  
  return RichText(
    overflow: TextOverflow.visible,
    textAlign: align,
    text: TextSpan(children: toTextSpan(
      tx: tx,
      fontSize: fontSize*(0.6+pcntSize*0.4),
      fontFam: fontFam,
      pcntSize: pcntSize,
      shadows: shadows
      )
    )
  );
}




List<TextSpan> toTextSpan({@required String tx, double fontSize=12.0, String fontFam, double pcntSize=1.0,List shadows  }) {

  String fontFamily = (getGoogleFonts.containsKey(fontFam))?fontFam:null;
  //print(tx);
  var vars = {
    "token": "#", // "#"
    "isItalic": FontStyle.normal,
    "fontSize":fontSize,
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

    if (textSeg.length>2&& textSeg.substring(0,3)=="/fw")
      vars["fontWeight"] = FontWeight.w400;
    else if (textSeg.length>2&&textSeg.substring(0,2)=="fw" && v.contains(textSeg.substring(2)))
      vars["fontWeight"] = FontWeight.values[v.indexOf(textSeg.substring(2))];
    else if (textSeg == "/italic")
      vars["fontType"] = FontStyle.normal;
    else if (textSeg == "italic")
      vars["fontType"] = FontStyle.italic;
    else if (textSeg.contains("/color"))
      vars["color"] = Colors.black; 
    else if (textSeg.contains("color") && colorFromString(textSeg.substring("color".length))!=null)
      vars["color"] =colorFromString(textSeg.substring("color".length)) ?? null;
    //else if (textSeg.length>4&& textSeg.substring(0,4)=="size"){}//TODO font size
    //   vars["fontSize"] =double.tryParse(textSeg.substring("size".length)) ?? 12.0;
   // else if (textSeg.length>5&& textSeg.substring(0,5)=="/size"){}
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
              fontSize: fontSize,
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
       // print(textSeg);
        TextStyle s = TextStyle(
                fontStyle: vars["fontType"],
                fontSize: vars["fontSize"],
                //??12.0*(0.5+ 0.5*pcntSize).clamp(0, 1.0),
                fontWeight: vars["fontWeight"],
                color: vars["color"],
               shadows: _getTextShadows(shadows)
                );
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

TextAlign getTextAlign(String al){
 // String al= jsonData['style']['textAlign'];
  return (al=="LEFT")?TextAlign.left:(al=="RIGHT")?TextAlign.right:(al=="CENTER")?TextAlign.center:TextAlign.left;
}

  List<Shadow> _getTextShadows(List shadows){
     if(shadows==null || shadows.isEmpty)return [];

     //print(shadows);
     return  shadows.map<Shadow>((effect){
       Offset o;
        try{o=Offset(effect['offset']['x'], effect['offset']['y']);}catch(e){}
              return Shadow(
                      color:colorFromString(effect["color"])??Colors.black,
                      offset:o??Offset(0, 0),
                      blurRadius:effect['blurRadius'].toDouble(),
                      //spreadRadius:,
                    );
                    
                    }
                ).toList();
  }
