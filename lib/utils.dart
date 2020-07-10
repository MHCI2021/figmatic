
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;


dynamic safeGet({@required String key, @required Map map,@required dynamic alt}){
  try{
    return map.containsKey(key)?map[key]
    :map.containsKey(key.toLowerCase())?map[key.toLowerCase()]:alt;
  }catch(e){
    return alt;
  }
}

dynamic checkPath(var map, List path){
  int i = 0;
 // print(map);
 if(map ==null)return [false,null];
 // if(map is Map){//
    while ( map is Map &&map.containsKey(path[i])){
      map = map[path[i]];
      i++;
      if(i==path.length)return [true, map];
      if(map is List && path[i] is int){
        //print(map);
        if(map.length<=path[i]){
          return [false, null];
        }else{
          map=map[path[i]];
          i++;
        }
      }
    }
    return [false, null];
 // }
  //else return [false, null];
}

dynamic safeGetPath(var map, List path)=>checkPath(map, path)[1];

printJsonDynamic(dynamic data, {String key=""}){
  if(data is String) print("$key: $data");
  else if(data is List) data.forEach((l){
    printJsonDynamic(l);
  });
  else if(data is Map){
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String prettyprint = encoder.convert(data);
    print("$key: $prettyprint");
  }
}

printJson(Map<String,dynamic> data){
  
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  String prettyprint = encoder.convert(data);
  print(prettyprint);
}

bool launch(String url) {
  return html.window.open(url, '') != null;
}
bool noneEmpty({dynamic test}){
  if (test==null)return false;
  if (test==[]||test==""||test=={})return false;
  if(test is List){
    int i = 0;
    while (i< test.length){
      if(!noneEmpty(test:test[i])){
        return false;
      }
      i++;
    }
  }
  return true;
}
