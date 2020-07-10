import 'package:figmatic/extensions/zoom_widget.dart';
import 'package:figmatic/secret.dart';
import 'package:flutter/material.dart';
import 'package:framy_annotation/framy_annotation.dart';

import 'figma/figma_api_parser.dart';
import 'package:http/browser_client.dart';

import 'figma/figma_controller.dart';
 final Map figmafiles ={
"a":"rCp1ekGyTPz1K92TE32ZwL",
"unit test":"yEpBlZuNn0mMm69I8ktVml",
"b":"58ieGqOKtHUp9rwoTBnJBk",
"c":"NBrXfF9tqmaNu4xlXtSY7d",
"prototyping":"Uvf5arrdAPCgXbSV8a2lT1",
"d":"d1Eutahvfkif8mTxZ82MKk",
"e":"98kcWQFBNV616AKjjl96v7",
"f":"FaHF8gZii05NmqoP80vc6c"
};
//https://www.figma.com/file/98kcWQFBNV616AKjjl96v7/Course-Dashboard-Copy?node-id=1%3A10
// /https://www.figma.com/file/yEpBlZuNn0mMm69I8ktVml/Unit-Tests?node-id=0%3A1&viewport=577%2C427%2C0.697896420955658

void main() async {
 var api = FigmaApiManager(BrowserClient(), figmaSecret);
  await api.init(figmafiles["b"]);
 var figmaView = FigmaViewController();
  figmaView.init(figmaApiManager: api);
  runApp(MyApp(figmaViewController: figmaView ));
  //figmaView,));
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
      home: MyHomePage(title: 'Flutter Demo Home Page', figmaViewController: figmaViewController,),
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
    Size s = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: 
        
        widget.figmaViewController.buildScreens(0.4, s)
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