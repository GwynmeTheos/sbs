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

  Variable({
    this.value,
    required this.descriptor,
    required this.behaviour,
    required this.possibleValues,
  });

}

class Event {
  String id;
  String name;
  List<Scene> scenes;

  Event({
    required this.id,
    required this.name,
    required this.scenes,
  });

}

class Scene {
  String id;
  String name;
  String body;
  List<Choice> choices;

  Scene({
    required this.id,
    required this.name,
    required this.body,
    required this.choices,
  });

}

class Choice {
  String body; 
  List<Requirement> requirements;
  List<Outcome> outcomes;
  String route;

  Choice({
    required this.body,
    required this.requirements,
    required this.outcomes,
    required this.route,
  });
}

class Requirement {
  Variable variable;
  int? min;
  int? max;
  dynamic exact;
  bool show;

  Requirement({
    required this.variable,
    this.min,
    this.max,
    required this.exact,
    required this.show,
  });
}

class Outcome {
  Variable variable;
  dynamic value;
  String behaviour;

  Outcome({
    required this.variable,
    required this.value,
    required this.behaviour,
  });
}

class Save {

}