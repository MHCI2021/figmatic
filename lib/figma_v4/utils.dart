String colorStringFromString(String color){
  
  if(color==null)return null;
  if(color.contains("color"))color=color.substring("color".length);
  List<int> parts=[];
  color.split("&").forEach((e) {
    parts.add(int.tryParse(e.substring(1))??0);
  });
  
  //print(color);
  //print(parts);
  if(parts.length==4)return 
  '''Color.fromARGB(${parts[3]}, ${parts[0]}, ${parts[1]}, ${parts[2]},),''';
  else if (parts.length==5){
    double op = double.tryParse(color.split("&").last.substring(1))??1.0;
    return '''Color.fromARGB( ${parts[3]}, ${parts[0]}, ${parts[1]}, ${parts[2]},)..withOpacity($op)''';
  }
  return null;
}    
