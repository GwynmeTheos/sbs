class GameData {
  Map<String, Event>? events;
  Map<String, dynamic>? variables;
  Map<String, Save>? saves;
  Event? gamestate;
  Save? currentSave;
  bool preload;

  GameData._({
    this.preload = true
  }){

  }

  factory GameData.preloadFromDisk(){
    return GameData._(
      preload: true
    );
  }

  factory GameData.streamFromDisk(){
    return GameData._(
      preload: false
    );
  }

}

class Variable {
  dynamic value;
  String descriptor;
  String behaviour;
  List<Map<String, dynamic>> possibleValues;

}

class Event {
  String id;
  String name;
  List<Scene> scenes;

}

class Scene {
  String id;
  String name;
  String body;
  List<Choice> choices;

}

class Choice {
  String body; 
  List<Requirement> requirements;
  List<Outcome> outcomes;
}

class Requirement {
  Variable variable;
  int? min;
  int? max;
  dynamic exact;
  bool show;

}

class Outcome {
  Variable variable;
  dynamic value;
  String behaviour;

}

class Save {

}