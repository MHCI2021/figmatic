
import 'package:figmatic/utils.dart';
import 'package:flutter/material.dart';

import 'figma_api_parser.dart';
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
                            ..._buildWidgets(nodeid, pcntSize)
                            ])
                      ) 
                      )//),
                    );
             //_buildWidgets(nodeid, pcntSize);
           }).toList()
      ),
    );
  }

 
  List<Widget> _buildWidgets(String nodeID, double pcntSize){
    // TODO check null
    Map nodeData = safeGet(key: nodeID, map: apiManager.nodes, alt: null);
    if(nodeData==null)return [];
    //print(nodeData);
    String nodeClass = nodeData["class"];
    switch (nodeClass) {
      case "frame":
        List<Widget> out = [frameDataToWidget(pcntSize, nodeData)];
       // out.addAll(_buildWidgets(nodeData["children"][0], pcntSize));
        nodeData["children"]?.forEach((childNodeData){
          //print(childNodeData);
           out.addAll(_buildWidgets(childNodeData, pcntSize)??[]);
          });
        return out;
        break;
      case "vector":return [vectorDataToWidget(pcntSize, nodeData)];break;
      case "text":return [textDataToWidget(pcntSize, nodeData)];break;
      
      default:return [];
    }
  }
}

 // Widget _buildFigmaScreen(){

  // }
