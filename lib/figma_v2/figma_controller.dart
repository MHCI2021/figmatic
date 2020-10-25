
import 'package:figmatic/figma_v2/figma_frame/frame_print.dart';
import 'package:figmatic/utils.dart';
import 'package:flutter/material.dart';

import 'figma_api_parser.dart';
import 'figma_text/text_print.dart';
import 'figma_vector/vector_print.dart';
import 'utils/figma_utils.dart';
import 'figma_frame/frame_widget.dart';
import 'figma_text/text_widget.dart';
import 'figma_vector/vector_widget.dart';


/*
API Manager is pure dart code,
this one controls the entire view and builds the widgets
*/

class FigmaViewController{
  FigmaApiManager apiManager;

  FigmaViewController();
  init({@required figmaApiManager}){
    apiManager=figmaApiManager;
  }

  // init(String fileKey,{bool getImages = false}) async {
  //   await apiManager.init(fileKey, getImages: getImages);
  // }

  Widget buildScreens(double pcntSize, Size screenSize){
    List<String> screenIDs = apiManager.screens.values.toList();
   
    return SingleChildScrollView(
      child: Wrap(
         children:  
           screenIDs.map((nodeid) {
             // print( 
               // _printWidget(nodeid, pcntSize);
               // );
                Rect window = toWindowRect(
                  positionData:apiManager.nodes[nodeid]["positioning"],
                  pcntSize: pcntSize
                  );
                 return 
              //   GestureDetector( onLongPress: (){}, child:
                       Padding(
                        padding: EdgeInsets.all(50.0),
                        child: Container(
                          height: window.height,
                          width:  window.width,
                          child:    SingleChildScrollView(
                            child: Stack(children: [
                              Container(height: window.height,),
                             _buildWidget(nodeid, pcntSize)
                            ])
                      ) 
                      )//),
                    );
             ////_buildWidgets(nodeid, pcntSize);
           }).toList()
      ),
    );
  }

 
  Widget _buildWidget(String nodeID, double pcntSize){// TODO check null
    Map nodeData = safeGet(key: nodeID, map: apiManager.nodes, alt: null);
    printJson(nodeData);
    if(nodeData==null)return null;
    //print(nodeData);
    String nodeClass = nodeData["class"];
    switch (nodeClass) {
      case "frame":

        List<Widget> out = [];
        nodeData["children"]?.forEach((childNodeData){
          //print(childNodeData);
          Widget w = _buildWidget(childNodeData, pcntSize);
           if(w!=null)out.add(w);
          });
        return frameDataToWidget(pcntSize, nodeData, out);
       // out.addAll(_buildWidgets(nodeData["children"][0], pcntSize));
        
  //      return out;
        break;
      case "vector":return vectorDataToWidget(pcntSize, nodeData);break;
      case "text":return textDataToWidget(pcntSize, nodeData);break;
      
      default:return null;
    }
  }


   
  String _printWidget(String nodeID, double pcntSize, {String layoutMode= "stack"}){
    Map nodeData = safeGet(key: nodeID, map: apiManager.nodes, alt: null);
    layoutMode??="Stack";
    if(nodeData==null)return null;
    String nodeClass = nodeData["class"];
    switch (nodeClass) {
      case "frame":
        List<String> outStrings= [];
        nodeData["children"]?.forEach((childNodeData){
           outStrings.add(_printWidget(childNodeData, pcntSize, layoutMode: nodeData["layoutMode"]));
          }); 
        return frameDataToWidgetString(pcntSize, nodeData, outStrings, layoutMode);
        break;
      case "vector":return vectorDataToWidgetString(pcntSize, nodeData, layoutMode);break;
      case "text":return textDataToWidgetString(pcntSize, nodeData, layoutMode);break;
      
      default:return "null";
    }
  }
}

 // Widget _buildFigmaScreen(){

  // }
