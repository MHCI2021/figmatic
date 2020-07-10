
import 'package:flutter/material.dart';

String getColorString(Map<String,dynamic> c, {double opacity=1}){
  if(c==null)return null;
  if(opacity==0)return null;
    int r = (255*c['r']).toInt(); 
    int g=  (255*c['g']).toInt();
    int b =(255*c['b']).toInt(); 
    int a = (255*c['a']).toInt();
    //print(c);
   // print("colorr$r&g$g&b$b&a$a&o$opacity");
  return "colorr$r&g$g&b$b&a$a&o$opacity";
}




Color colorFromString(String color){
  
  if(color==null)return null;
  if(color.contains("color"))color=color.substring("color".length);
  List<int> parts=[];
  color.split("&").forEach((e) {
    parts.add(int.tryParse(e.substring(1))??0);
  });
  
  //print(color);
  //print(parts);
  if(parts.length==4)return Color.fromARGB(
        parts[3], 
        parts[0], 
        parts[1], 
        parts[2],);
  else if (parts.length==5){
    double op = double.tryParse(color.split("&").last.substring(1))??1.0;
    return Color.fromARGB(
        parts[3], 
        parts[0], 
        parts[1], 
        parts[2],)..withOpacity(op);
  }
  return null;
}    


// List<String> colorOptions=["", "black","white","pink","red","orange", "amber", "yellow","lime", "lightGreen","green","teal","cyan","lightBlue","blue","indigo","purple","grey","brown","blueGrey"];
// //String to(String baseName) => capWord(baseName) + "Model";

// Map<String, Function> e={
//        "":(int incr, double opacity)=>Colors.transparent,
//         "transparent":(int incr, double opacity)=>Colors.transparent,
//        "black":(int incr, double opacity)=>Colors.black.withOpacity(opacity),
//        "red":(int incr, double opacity)=>(incr!=null)?Colors.red[incr].withOpacity(opacity): Colors.red.withOpacity(opacity),
//        "grey":(int incr, double opacity)=>(incr!=null)?Colors.grey[incr].withOpacity(opacity): Colors.grey.withOpacity(opacity),
//        "indigo":(int incr, double opacity)=>(incr!=null)?Colors.indigo[incr].withOpacity(opacity): Colors.indigo.withOpacity(opacity),
//        "blue":(int incr, double opacity)=>(incr!=null)?Colors.blue[incr].withOpacity(opacity): Colors.blue.withOpacity(opacity),
//        "green": (int incr, double opacity)=>(incr!=null)?Colors.green[incr].withOpacity(opacity): Colors.green.withOpacity(opacity),
//        "purple":(int incr, double opacity)=>(incr!=null)?Colors.purple[incr].withOpacity(opacity): Colors.purple.withOpacity(opacity),
//        "pink": (int incr, double opacity)=>(incr!=null)?Colors.pink[incr].withOpacity(opacity): Colors.pink.withOpacity(opacity),
//        "amber": (int incr, double opacity)=>(incr!=null)?Colors.amber[incr].withOpacity(opacity): Colors.amber.withOpacity(opacity),
//        "lime":(int incr, double opacity)=>(incr!=null)?Colors.lime[incr].withOpacity(opacity): Colors.lime.withOpacity(opacity),
//         "brown":(int incr, double opacity)=>(incr!=null)?Colors.brown[incr].withOpacity(opacity): Colors.brown.withOpacity(opacity),
//         "blueGrey":(int incr, double opacity)=>(incr!=null)?Colors.blueGrey[incr].withOpacity(opacity): Colors.blueGrey.withOpacity(opacity),
//         "cyan":(int incr, double opacity)=>(incr!=null)?Colors.cyan[incr].withOpacity(opacity): Colors.cyan.withOpacity(opacity),
//         "teal":(int incr, double opacity)=>(incr!=null)?Colors.teal[incr].withOpacity(opacity): Colors.teal.withOpacity(opacity),
//         "lightBlue":(int incr, double opacity)=>(incr!=null)?Colors.lightBlue[incr].withOpacity(opacity): Colors.lightBlue.withOpacity(opacity),
//        "lightGreen":(int incr, double opacity)=>(incr!=null)?Colors.lightGreen[incr].withOpacity(opacity): Colors.lightGreen.withOpacity(opacity),
//        "white":(int incr, double opacity)=>Colors.white.withOpacity(opacity),
//        "orange":(int incr, double opacity)=>(incr!=null)?Colors.orange[incr].withOpacity(opacity): Colors.orange.withOpacity(opacity),
//        "yellow":(int incr, double opacity)=>(incr!=null)?Colors.yellow[incr].withOpacity(opacity): Colors.yellow.withOpacity(opacity),
//     };
