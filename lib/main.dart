import 'package:figmatic/extensions/copy_to_clipboard.dart';
import 'package:figmatic/extensions/zoom_widget.dart';
import 'package:figmatic/figma/figma_frame/frame_print.dart';
import 'package:figmatic/figma/figma_text/text_widget.dart';
import 'package:figmatic/secret.dart';
import 'package:flutter/material.dart';
import 'package:framy_annotation/framy_annotation.dart';

import 'figma/figma_api_parser.dart';
import 'package:http/browser_client.dart';

import 'figma/figma_controller.dart';
import 'figma/utils/widget_utils.dart';

final Map figmafiles = {
  "a": "rCp1ekGyTPz1K92TE32ZwL",
  "unit test": "yEpBlZuNn0mMm69I8ktVml",
  "b": "58ieGqOKtHUp9rwoTBnJBk",
  "c": "NBrXfF9tqmaNu4xlXtSY7d",
  "prototyping": "Uvf5arrdAPCgXbSV8a2lT1",
  "d": "d1Eutahvfkif8mTxZ82MKk",
  "e": "98kcWQFBNV616AKjjl96v7",
  "f": "FaHF8gZii05NmqoP80vc6c"
};
//https://www.figma.com/file/98kcWQFBNV616AKjjl96v7/Course-Dashboard-Copy?node-id=1%3A10
// /https://www.figma.com/file/yEpBlZuNn0mMm69I8ktVml/Unit-Tests?node-id=0%3A1&viewport=577%2C427%2C0.697896420955658

void main() async {
  var api = FigmaApiManager(BrowserClient(), figmaSecret);
  await api.init(figmafiles["a"]);
  var figmaView = FigmaViewController();
  figmaView.init(figmaApiManager: api);
  runApp(MyApp(figmaViewController: figmaView));//figmaView,));
}

@FramyApp()
class MyApp extends StatelessWidget {
  final FigmaViewController figmaViewController;

  const MyApp({Key key, this.figmaViewController}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        figmaViewController: figmaViewController,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final FigmaViewController figmaViewController;

  MyHomePage({Key key, this.title, this.figmaViewController}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> w = [];
    List<Widget> p = [];
    List<String> reg = [];
    List<String> sty = [];
     widget.figmaViewController.apiManager.screens.forEach(
                  (key, value) {
                    w.add(ExpansionTile(
                      title: Text(key)
                    ));
                   } );
            widget.figmaViewController.apiManager.widgets.forEach(
                  (key, value) {
                    print(value);
                   // reg.add(frameDataToStylizedString(0.4, widget.figmaViewController.apiManager.nodes[value], [], "Stack"));
                    p.add(ExpansionTile(
                      title: Text(key)
                    ));
                   } );     
    Size s = MediaQuery.of(context).size;
    
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: //S()
        Row(
          children:[
            Container(
              width: 300.0,
              height: double.infinity,
              color: Colors.grey,
              child: Column(
                children:[
                  ExpansionTile(
                    title:Text("Screens"),
                    children:w
                  ),
                  ExpansionTile(
                    title:Text("Components"),
                    children:p
                  ),
                ]
            )
          ),
           Container(
              width: 300.0,
              height: double.infinity,
            
              child: ListView(
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
                        copyToClipboard("");
                      },
                      child: Container(
                          color: Colors.grey[800],
                        child: toRichText(
                          tx:"" ),
                      ),
                    ),
                  )
                ]
            )
          ),
            Expanded(child: 
            widget.figmaViewController.buildScreens(0.4, s),)
          ]
        )
            
        //  )
        );
  }
}









// Container(
//         height: double.infinity,
//         width: double.infinity,
//         color: Colors.grey,
//         child: Zoom(
//           height: 300.0,
//           width: 300.0,
//           child:Container(
//             color: Colors.blue,
//             height: double.infinity,
//             width: double.infinity,
//             )
//         )


/*
 Expanded(
                    child: GestureDetector(
                      onTap: (){
                        copyToClipboard('''class MDIStar extends StatelessWidget {
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
                          color: Colors.grey[800],
                        child: toRichText(
                          tx: '''#colorblue600##fw700#class#colorgreen700# MDIStar #colorblue#extends #colorgreen#StatelessWidget#colorwhite##/fw# {
    #fw700#@override
    #colorgreen#Widget#coloryellow600# build#colorwhite##/fw#(BuildContext context) {
      #fw700##colorpurple#return #colorgreen#SizedBox#colorwhite##/fw#( 
            height:9.200, 
            width:9.200,
            child: #fw700##colorgreen#CustomPaint#/fw##colorwhite#(
            size:#colorblue#Size#colorwhite#(9.200,9.200),
           #colorwhite#painter: #fw700##colorgreen#VectorPathPainter#colorwhite##/fw#(
            #colororange#"M11.5 18.4847L18.607 23L16.721 14.49L23 8.76421L14.7315 8.02579L11.5 0L8.2685 8.02579L0 8.76421L6.279 14.49L4.393 23L11.5 18.4847Z"#colorwhite#,
            #fw700##colorgreen#Color#colorwhite##/fw#(0xfffeb22c),
            #fw700##colorgreen#PaintingStyle#colorwhite##/fw#.fill
            )),
        ),;
    }
  }#/color###'''),
                      ),
                    ),
                  )


*/