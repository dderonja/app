import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:myapp/passage.dart';

class HasAsync{

  HasAsync(){
    loadPassages().then((val){
      return val;
    }
    );
  }
}

Future<String> _loadPassageAsset() async {
  return await rootBundle.loadString('assets/content.json');
}

Future loadPassages() async {
  String jsonPhotos = await _loadPassageAsset();
  final jsonResponse = json.decode(jsonPhotos);
  PassagesList passagesList = PassagesList.fromJson(jsonResponse);
  print("photos " + passagesList.passages[0].content);
  return passagesList;
}