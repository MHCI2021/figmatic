


/*
Future tests
- Bad data 
- No data 
-Wrong input type
- Scaling 
*/
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';


Widget positionedWrapper({@required Rect windowRect, @required Widget  child, double pcntSize=1.0, })
=> child==null?null:Positioned(
          top:pcntSize*windowRect.top,
          left: pcntSize*windowRect.left,
          height:pcntSize*windowRect.height,
          width:pcntSize*windowRect.width,
        child: child
        // SizedBox(
        //   height:pcntSize*windowRect.height,
        //   width:pcntSize*windowRect.width,
        //   child: child
        // )
);

String positionedWrapperString({@required Rect windowRect, @required String child, double pcntSize=1.0, })
=> '''Positioned( 
          top:${(pcntSize*windowRect.top).toStringAsFixed(3)},left: ${(pcntSize*windowRect.left).toStringAsFixed(3)},
          height:${(pcntSize*windowRect.height).toStringAsFixed(3)}, width:${(pcntSize*windowRect.width).toStringAsFixed(3)},
          child: $child),''';
String containerWrapperString({@required Rect windowRect, @required String child, double pcntSize=1.0, })
=> '''SizedBox( 
          height:${(pcntSize*windowRect.height).toStringAsFixed(3)}, width:${(pcntSize*windowRect.width).toStringAsFixed(3)},
          child: $child),''';




class VectorPathPainter extends CustomPainter {
  VectorPathPainter(String path, Color color, PaintingStyle paintingStyle) : 
  p = parseSvgPathData(path),
  ps=paintingStyle,
  c=color;


  final Path p;
  final Color c;
  final PaintingStyle ps;
  @override
  bool shouldRepaint(VectorPathPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {

    Path newP = getClip(size);
    final Paint paint = Paint()
        ..color=c
        ..strokeWidth = 1.0
        ..style = ps;
    newP.moveTo(size.width/2, size.height/2);
    canvas.drawPath(
      newP, 
      paint
    );
  }

  Path getClip(Size size) {
    //parseSvgPathData comes from a package
    //Library link: https://pub.dev/packages/path_drawing (Library link)
    //parseSvgPathData returns a Path object
    //extracting path from SVG data
    final Rect pathBounds = p.getBounds();
    final Matrix4 matrix4 = Matrix4.identity();
    matrix4.scale(size.width / pathBounds.width, size.height / pathBounds.height);
    return p.transform(matrix4.storage);// path is returned to ClipPath clipper
  }
}

class VectorClipper extends CustomClipper<Path> {
  VectorClipper(String path) : 
  p = parseSvgPathData(path);


  final Path p;
  @override
  Path getClip(Size size) {
     //parseSvgPathData comes from a package
    //Library link: https://pub.dev/packages/path_drawing (Library link)
    //parseSvgPathData returns a Path object
    //extracting path from SVG data
    final Rect pathBounds = p.getBounds();
    final Matrix4 matrix4 = Matrix4.identity();
    matrix4.scale(size.width / pathBounds.width, size.height / pathBounds.height);
    return p.transform(matrix4.storage);// path is returned to ClipPath clipper
  }

  @override
  bool shouldReclip(VectorClipper oldClipper) => false;
}











class FigmaStyles{
  final Map data;

  FigmaStyles(this.data);

  BoxDecoration getDecoration(Color color){
    // check if visible/ pass through
      
    if(data.containsKey("blendMode") && data["blendMode"]=="PASS_THROUGH"){
    //      if(data.containsKey("transitionNodeID")){
    //      return BoxDecoration(
    //           border:
    //           Border.all(
    //             color: Colors.yellow,
    //             width: 2,
    //           )
    //         );
    // }
         
          return null;
    }
    return BoxDecoration(
              color:color,
            //  border:_getBoxBorder(),
              //borderRadius:_getBorderRadius(),
            //  boxShadow:null_getBoxShadows(),
              gradient: _getGradient(), //Todo
              backgroundBlendMode: _getBlendMode(),
            );
  }

   String getDecorationString(String color){
    // check if visible/ pass through
      
    if(data.containsKey("blendMode") && data["blendMode"]=="PASS_THROUGH"){
          return "null,";
    }
    return '''BoxDecoration(
              color:$color,
            ),''';
  }

  // List<BoxShadow> _getBoxShadows(){
  //    if(!data.containsKey("effects") || data["effects"].length==0)return [];
  //    return  data["effects"].map<BoxShadow>((effect)=>
  //               BoxShadow(
  //                     color:parseColor(effect),
  //                     offset:Offset(effect['offset']['x'], effect['offset']['y']),
  //                     blurRadius:effect['radius'].toDouble(),
  //                     //spreadRadius:,
  //                   )
  //               ).toList();
  // }

  // BorderRadiusGeometry _getBorderRadius(){
  //   return data.containsKey("rectangleCornerRadii") ?BorderRadius.only(
  //               topLeft: Radius.circular(data["rectangleCornerRadii"][0]),
  //               topRight: Radius.circular(data["rectangleCornerRadii"][1]),
  //               bottomLeft: Radius.circular(data["rectangleCornerRadii"][2]),
  //               bottomRight: Radius.circular(data["rectangleCornerRadii"][3]),
  //             ):null;
  // }

  // BoxBorder _getBoxBorder(){

  //   return (data["strokes"].length>0)?Border.all(
  //               color: parseColor(data["strokes"][0]),
  //               width: data["strokeWeight"].toDouble(),
  //             ):
  //             null;
  // }
  Gradient _getGradient()=>null; //todo
  BlendMode _getBlendMode()=>null; // todo

}
// Color getTextColor(var data){
//     Color h;
//     try{
//        var c = data['style']['color'];
//         h= Color.fromARGB(
//         (255*c['a']).toInt(), 
//         (255*c['r']).toInt(), 
//         (255*c['g']).toInt(), 
//         (255*c['b']).toInt(),);
//     }catch(r){
//     h=Colors.black;
//     }
//     return h;
// }



// Color getFrameColor(var colorData){
  
//     if(colorData==null || colorData["opacity"]==0 )return null;
//       return Color.fromARGB(
//         (255*colorData['a']).toInt(), 
//         (255*colorData['r']).toInt(), 
//         (255*colorData['g']).toInt(), 
//         (255*colorData['b']).toInt(),)..withOpacity(colorData["opacity"]);
// }

// Color getVectorColor(var colorData){

//     if(colorData==null || colorData["opacity"]==0 )return null;
//     try{
//       return Color.fromARGB(
//         (255*colorData['a']).toInt(), 
//         (255*colorData['r']).toInt(), 
//         (255*colorData['g']).toInt(), 
//         (255*colorData['b']).toInt(),)..withOpacity(colorData["opacity"]);
//     }catch(e){
//       print("Error");
//       print(colorData);
//       return null;
//     }
// }
