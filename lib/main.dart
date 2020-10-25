import 'package:figmatic/extensions/copy_to_clipboard.dart';
import 'package:figmatic/figma_v2/figma_api_parser.dart';
import 'package:figmatic/figma_v2/figma_controller.dart';
//import 'package:figmatic/extensions/zoom_widget.dart';
//import 'package:figmatic/figma/figma_frame/frame_print.dart';
//import 'package:figmatic/figma/figma_text/text_widget.dart';
import 'package:figmatic/secret.dart';
import 'package:flutter/material.dart';
import 'package:framy_annotation/framy_annotation.dart';

//import 'figma/figma_api_parser.dart';
import 'package:http/browser_client.dart';

import 'figma_v2/figma_text/text_widget.dart';
//import 'figma_v3/figma_build.dart';
//import 'figma_v3/figma_build/text.dart';
//import 'figma_v3/figma_parser.dart';
//import 'figma_v4/figma_api.dart';
//import 'figma/figma_controller.dart';
//import 'figma/utils/widget_utils.dart';
//https://www.figma.com/file/RTq3F6ZKzuJdgJ9cTpPkuW/Test-Figmagic?node-id=0%3A1
final Map figmafiles = {
  "test":"RTq3F6ZKzuJdgJ9cTpPkuW",
  "a": "rCp1ekGyTPz1K92TE32ZwL",
  "unit test": "yEpBlZuNn0mMm69I8ktVml",
  "b": "58ieGqOKtHUp9rwoTBnJBk",
  "c": "NBrXfF9tqmaNu4xlXtSY7d",
  "prototyping": "Uvf5arrdAPCgXbSV8a2lT1",
  "d": "d1Eutahvfkif8mTxZ82MKk",
  "e": "98kcWQFBNV616AKjjl96v7",
  "f": "FaHF8gZii05NmqoP80vc6c",
  "bookApp":"KMGilRf3zgJvZu9vbQQAxD"

};
//https://www.figma.com/file/98kcWQFBNV616AKjjl96v7/Course-Dashboard-Copy?node-id=1%3A10
// /https://www.figma.com/file/yEpBlZuNn0mMm69I8ktVml/Unit-Tests?node-id=0%3A1&viewport=577%2C427%2C0.697896420955658




void main() async {
  
  //var api2 = FigmaApi2(BrowserClient(), figmaSecret);
  //await api2.init(figmafiles["bookApp"]);
  //await Future.delayed(Duration(seconds: 5));
   var api = FigmaApiManager(BrowserClient(), figmaSecret);
   await api.init(figmafiles["test"]);
  // // var api = FigmaApiManager(BrowserClient(), figmaSecret);
  // // await api.init(figmafiles["a"]);
  //  var figmaView = FigmaViewController2();
  //  figmaView.init(figmaApiManager: api);
   runApp(MyApp(figmaApi:api));//figmaView,));
}
@FramyApp()
class MyApp extends StatelessWidget {
  final FigmaApiManager figmaApi;

  const MyApp({Key key, this.figmaApi}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:MyHomePage(
        title: 'Flutter Demo Home Page',
        figmaApi: figmaApi,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
   final FigmaApiManager figmaApi;

  MyHomePage({Key key, this.title, this.figmaApi}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String currentScreen;
  FigmaViewController figmaViewController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    figmaViewController = FigmaViewController();
    figmaViewController.init(figmaApiManager: widget.figmaApi);

  }
  //widget.figmaViewController.buildScreens(0.5, s)
  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
   // print(widget.figmaApi.getTestString());

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: //S()
        Row(
          children:[
           Container(
              width:s.width*0.3,
              height: double.infinity,
            
              child: Column(
                children:[
                Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("Preview", style: TextStyle(color: Colors.black ),),
                  ),

                  Container(
                    color: Colors.grey[800],
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("Code", style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        copyToClipboard( '''class MDIStar extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Stack(children: [SizedBox( 
          height:9.200, 
          width:9.200,
          child: 
       CustomPaint(
                        size: Size(9.200,9.200),
                        painter: VectorPathPainter(
                          "M11.5 18.4847L18.607 23L16.721 14.49L23 8.76421L14.7315 8.02579L11.5 0L8.2685 8.02579L0 8.76421L6.279 14.49L4.393 23L11.5 18.4847Z",
                          Color(0xfffeb22c),
                          PaintingStyle.fill
                        )),
        ),]),;
    }
  }''');
                     },
                      child: Container(
                        width: double.infinity,
                          color: Colors.grey[800],
                        child: SingleChildScrollView(
                          // child:
                          // toRichText(
                          //  // tx: widget.figmaApi.getTestString()
                          //   ),
                        ),
                      ),
                    ),
                  )
                ]
            )
          ),
            Container(
              width: s.width*0.7,
              height:double.infinity,
             child: figmaViewController.buildScreens(0.5, Size(s.width/2, s.height))
            //  Stack(
            //    children:[widget.figmaApi.getTestWidget(height:s.height, width:s.width*0.5)
            //      ]  )
              ),
          ]
        )
            
        //  )
        );
  }
}





// void main() async {
//   var api = FigmaApi(BrowserClient(), figmaSecret);
//   await api.init(figmafiles["a"]);
//   // var api = FigmaApiManager(BrowserClient(), figmaSecret);
//   // await api.init(figmafiles["a"]);
//    var figmaView = FigmaViewController2();
//    figmaView.init(figmaApiManager: api);
//   runApp(MyApp(figmaViewController: figmaView));//figmaView,));
// }

// @FramyApp()
// class MyApp extends StatelessWidget {
//   final FigmaViewController2 figmaViewController;

//   const MyApp({Key key, this.figmaViewController}) : super(key: key);
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home:MyHomePage(
//         title: 'Flutter Demo Home Page',
//         figmaViewController: figmaViewController,
//       ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   final FigmaViewController2 figmaViewController;

//   MyHomePage({Key key, this.title, this.figmaViewController}) : super(key: key);
//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {

//   String currentScreen;
//   //widget.figmaViewController.buildScreens(0.5, s)
//   @override
//   Widget build(BuildContext context) {
//     Size s = MediaQuery.of(context).size;
//      List<Widget> pages=[];
//     widget.figmaViewController.apiManager.pages.forEach((key, value) {
//         pages.add(
//           RaisedButton(
//             child: Text(key),
//           onPressed: (){
//             currentScreen = key;
//             setState(() {});
//           },)
//           );       
//     });

//     return Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title),
//         ),
//         body: //S()
//         Row(
//           children:[
//             Container(
//               width: s.width*0.2,
//               height: double.infinity,
//               color: Colors.grey,
//               child: Column(
//                 children:pages
              
//             )
//           ),
//            Container(
//               width:s.width*0.2,
//               height: double.infinity,
            
//               child: Column(
//                 children:[
//                 Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Text("Preview", style: TextStyle(color: Colors.black ),),
//                   ),

//                   Container(
//                     color: Colors.grey[800],
//                     width: double.infinity,
//                     child: Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: Text("Code", style: TextStyle(color: Colors.white),),
//                     ),
//                   ),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: (){
//                         copyToClipboard( '''class MDIStar extends StatelessWidget {
//     @override
//     Widget build(BuildContext context) {
//       return Stack(children: [SizedBox( 
//           height:9.200, 
//           width:9.200,
//           child: 
//        CustomPaint(
//                         size: Size(9.200,9.200),
//                         painter: VectorPathPainter(
//                           "M11.5 18.4847L18.607 23L16.721 14.49L23 8.76421L14.7315 8.02579L11.5 0L8.2685 8.02579L0 8.76421L6.279 14.49L4.393 23L11.5 18.4847Z",
//                           Color(0xfffeb22c),
//                           PaintingStyle.fill
//                         )),
//         ),]),;
//     }
//   }''');
//                      },
//                       child: Container(
//                           color: Colors.grey[800],
//                         child: toRichText(
//                           tx:'''#colorblue600##fw700#class#colorgreen700# MDIStar #colorblue#extends #colorgreen#StatelessWidget#colorwhite##/fw# {
//     #fw700#@override
//     #colorgreen#Widget#coloryellow600# build#colorwhite##/fw#(BuildContext context) {
//       #fw700##colorpurple#return #colorgreen#SizedBox#colorwhite##/fw#( 
//             height:9.200, 
//             width:9.200,
//             child: #fw700##colorgreen#CustomPaint#/fw##colorwhite#(
//             size:#colorblue#Size#colorwhite#(9.200,9.200),
//            #colorwhite#painter: #fw700##colorgreen#VectorPathPainter#colorwhite##/fw#(
//             #colororange#"M11.5 18.4847L18.607 23L16.721 14.49L23 8.76421L14.7315 8.02579L11.5 0L8.2685 8.02579L0 8.76421L6.279 14.49L4.393 23L11.5 18.4847Z"#colorwhite#,
//             #fw700##colorgreen#Color#colorwhite##/fw#(0xfffeb22c),
//             #fw700##colorgreen#PaintingStyle#colorwhite##/fw#.fill
//             )),
//         ),;
//     }
//   }#/color###''' ),
//                       ),
//                     ),
//                   )
//                 ]
//             )
//           ),
//             Container(
//               width: s.width*0.6,
//              child: 
//              widget.figmaViewController.buildScreens(0.5, s, currentScreen)
//               ),
//           ]
//         )
            
//         //  )
//         );
//   }
// }















    // List<Widget> w = [];
    // List<Widget> p = [];
    //     List<Widget> j = [];
    // widget.figmaViewController.apiManager.pages.forEach(
    //               (key) {
    //                 j.add(ExpansionTile(
    //                   title: Text(key)
    //                 ));
    //                } );
    //  widget.figmaViewController.apiManager.screens.forEach(
    //               (key, value) {
    //                 w.add(ExpansionTile(
    //                   title: Text(key)
    //                 ));
    //                } );
    //         widget.figmaViewController.apiManager.widgets.forEach(
    //               (key, value) {
    //                 print(value);
    //                // reg.add(frameDataToStylizedString(0.4, widget.figmaViewController.apiManager.nodes[value], [], "Stack"));
    //                 p.add(ExpansionTile(
    //                   title: Text(key)
    //                 ));
    //                } ); 

//  ExpansionTile(
//                     title:Text("Pages"),
//                     children:j
//                   ),
//                   ExpansionTile(
//                     title:Text("Screens"),
//                     children:w
//                   ),
//                   ExpansionTile(
//                     title:Text("Components"),
//                     children:p
//                   ),