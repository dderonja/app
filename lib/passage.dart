import 'package:myapp/decision.dart';

class PassagesList {
  final List<Passage> passages;

  PassagesList({
    this.passages
  });

  factory PassagesList.fromJson(List<dynamic> parsedJson){
    List<Passage> passages = new List<Passage>();
    passages = parsedJson.map((i) => Passage.fromJson(i)).toList();
    return new PassagesList(
        passages: passages
    );
  }
}
class Passage{
  final int id;
  final String content;
  final DecisionList decision;

  Passage({
    this.id,
    this.content,
    this.decision
  }) ;

  factory Passage.fromJson(Map<String, dynamic> json){
    return new Passage(
      id: json['id'],
      content: json['content'],
      decision: DecisionList.fromJson(json['decision']),
    );
  }
}