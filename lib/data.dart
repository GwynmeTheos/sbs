// ignore_for_file: unnecessary_this

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class GameData {
  Map<String, Event?> events = new Map<String, Event?>();
  Map<String, Variable?> variables = new Map<String, Variable?>();
  Save? save;
  Event? rootEvent;
  Event? gamestateEvt;
  Scene? gameStateScn;
  bool preload;

  GameData._({
    this.preload = true
  });

  factory GameData.preloadFromDisk(){
    return GameData._(
      preload: true
    );
  }

  // factory GameData.streamFromDisk(){
  //   return GameData._(
  //     preload: false
  //   );
  // }

  Future<bool> loadData() async {
    try {
      // Load saves
      SharedPreferences prefs = await SharedPreferences.getInstance();
      this.save = Save(prefs);
      // Load variables
      await rootBundle.loadString("assets/variables/var_base00.json")
        .then((value) {
          List<dynamic> varRes = jsonDecode(value);
          for (var variable in varRes){
            this.variables[variable['name']] = Variable.fromJson(variable);
          }
        });
      // Load events
      await rootBundle.loadString("assets/variables/evt_base00.json")
        .then((value) {
          List<dynamic> evtRes = jsonDecode(value);
          for (var event in evtRes){
            this.events[event['id']] = Event.fromJson(event);
          }
        });
      // Load root event
      this.rootEvent = this.events['EG_001'];
      // Load last seen event
      String? lastKey = this.save?.eventHist?.last;
      if (lastKey == null) {
        this.gamestateEvt = this.rootEvent;
      } else {
        List<String> keys = lastKey.split("-");
        this.gamestateEvt = this.events[keys[0]];
        if (this.gamestateEvt == null) {
          this.gameStateScn = this.rootEvent!.scenes[0]!;
        } else {
          for (var scene in this.gamestateEvt!.scenes){
            if (scene == null) continue;
            if (scene.id == lastKey) this.gameStateScn = scene;
          }
        }
      }

      return true;
    } catch (exx) {
      return false;
    }
  }

}

enum VariableBehaviour{
  closest,
  none
}
enum SideBarBehaviour{
  pointer,
  filler,
  none
}
class Variable {
  dynamic value;
  String name;
  VariableBehaviour variableBehaviour;
  SideBarBehaviour sidebarBehaviour;
  List<Map<String, dynamic>> possibleValues;
  bool showSidebar;
  bool showValue;
  dynamic min;
  dynamic max;

  Variable({
    this.value,
    required this.name,
    required this.variableBehaviour,
    required this.sidebarBehaviour,
    required this.possibleValues,
    required this.showSidebar,
    required this.showValue,
    required this.min,
    required this.max,
  });

  static Variable? fromJson(String json){
    try {
      Map<String, dynamic> res = jsonDecode(json);
      return Variable(
        name: res['name'],
        variableBehaviour: Variable.variableBehaviourFromString(res['descriptor']['behaviour']),
        sidebarBehaviour: Variable.sidebarBehaviourFromString(res['sidebar']['behaviour']),
        possibleValues: List.from(res['descriptor']['possibleValues'], growable: false),
        showSidebar: res['sidebar']['showSidebar'],
        showValue: res['sidebar']['showValue'],
        min: res['sidebar']['min'],
        max: res['sidebar']['max']);
    } catch (exx){
      print(exx);
      return null;
    }
  }

  static VariableBehaviour variableBehaviourFromString(String name){
    switch(name){
      case 'closest':
        return VariableBehaviour.closest;
      default:
        return VariableBehaviour.none;
    }
  }
  static SideBarBehaviour sidebarBehaviourFromString(String name){
    switch(name){
      case 'pointer':
        return SideBarBehaviour.pointer;
      case 'filler':
        return SideBarBehaviour.filler;
      default:
        return SideBarBehaviour.none;
    }
  }
}

class Event {
  String id;
  String name;
  List<Scene?> scenes;

  Event({
    required this.id,
    required this.name,
    required this.scenes,
  });

  static Event? fromJson(String json){
    try {
      Map<String, dynamic> res = jsonDecode(json);
      return Event(
        id: res['id'],
        name: res['name'],
        scenes: List.generate(
          res['scenes'].length,
          (index) => Scene.fromJson(res['scenes'][index].toString())
        ) 
      );
    } catch (exx){
      print(exx);
      return null;
    }
  }
}

class Scene {
  String id;
  String name;
  String body;
  List<Choice?> choices;

  Scene({
    required this.id,
    required this.name,
    required this.body,
    required this.choices,
  });

  static Scene? fromJson(String json){
    try {
      Map<String, dynamic> res = jsonDecode(json);
      return Scene(
        id: res['id'],
        name: res['name'],
        body: res['body'],
        choices: List.generate(
          res['choices'].length,
          (index) => Choice.fromJson(res['choices'][index].toString())
        )
      );
    } catch (exx){
      print(exx);
      return null;
    }
  }
}

class Choice {
  String body; 
  List<Requirement?> requirements;
  List<Outcome?> outcomes;
  String route;

  Choice({
    required this.body,
    required this.requirements,
    required this.outcomes,
    required this.route,
  });

  static Choice? fromJson(String json){
    try {
      Map<String, dynamic> res = jsonDecode(json);
      return Choice(
        body: res['body'],
        requirements: List.generate(
          res['requirements'].length,
          (index) => Requirement.fromJson(res['requirements'][index].toString())
        ),
        outcomes: List.generate(
          res['outcomes'].length,
          (index) => Outcome.fromJson(res['outcomes'][index].toString())
        ),
        route: res['route']
      );
    } catch (exx){
      print(exx);
      return null;
    }
  }
}

class Requirement {
  String variable;
  int? min;
  int? max;
  dynamic exact;
  bool hidden;

  Requirement({
    required this.variable,
    this.min,
    this.max,
    this.exact,
    required this.hidden,
  });

  static Requirement? fromJson(String json){
    try {
      Map<String, dynamic> res = jsonDecode(json);
      return Requirement(
        variable: res['variable'],
        min: res['min'],
        max: res['max'],
        exact: res['exact'],
        hidden: res['hidden']
      );
    } catch (exx){
      print(exx);
      return null;
    }
  }
}

enum OutcomeBehaviour{
  offset,
  none
}
class Outcome {
  String variable;
  dynamic value;
  OutcomeBehaviour behaviour;

  Outcome({
    required this.variable,
    required this.value,
    required this.behaviour,
  });

  static Outcome? fromJson(String json){
    try {
      Map<String, dynamic> res = jsonDecode(json);
      return Outcome(
        variable: res['variable'],
        value: res['value'],
        behaviour: res['behaviour']
      );
    } catch (exx){
      print(exx);
      return null;
    }
  }
  
  static OutcomeBehaviour outcomeBehaviourFromString(String name){
    switch(name){
      case 'offset':
        return OutcomeBehaviour.offset;
      default:
        return OutcomeBehaviour.none;
    }
  }
}

class Save {
  List<String>? eventHist;
  String? theme;
  String? loadType;

  Save(SharedPreferences prefs){
    eventHist = prefs.getStringList("eventHist");
    theme = prefs.getString("theme");
    loadType = prefs.getString("loadType");
  }

  Future<bool> savePreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (this.eventHist != null) prefs.setStringList("eventHist", this.eventHist!);
      if (this.theme != null) prefs.setString("theme", this.theme!);
      if (this.loadType != null) prefs.setString("loadType", this.loadType!);

      return true;
    } catch (exx) {
      return false;
    }
  }
}