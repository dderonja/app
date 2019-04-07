class DecisionList {
  final List<Decision> decisions;

  DecisionList({
    this.decisions
  });

  factory DecisionList.fromJson(List<dynamic> parsedJson){
    List<Decision> decisions = new List<Decision>();
    decisions = parsedJson.map((i) => Decision.fromJson(i)).toList();
    return new DecisionList(
        decisions: decisions
    );
  }
}
class Decision{
  final double id;
  final String optionText;
  final int diaden;
  final int moral;
  final int leben;
  final int targetId;

  Decision({this.id, this.optionText, this.diaden, this.moral, this.leben,
      this.targetId});



  factory Decision.fromJson(Map<String, dynamic> json){
    return new Decision(
      id: json['id'],
      optionText: json['option_text'],
      diaden: json['diaden'],
      moral: json['moral'],
      leben: json['leben'],
      targetId: json['target_id'],
    );
  }
}