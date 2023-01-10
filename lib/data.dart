// ignore_for_file: unnecessary_this

import 'dart:convert';
import 'dart:ffi';
import 'dart:developer';
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
            if (variable['name'] != null) {
              this.variables[variable['name']] = Variable.fromMap(variable);
            }
          }
        });
      // Load events
      await rootBundle.loadString("assets/events/evt_base00.json")
        .then((value) {
          List<dynamic> evtRes = jsonDecode(value);
          for (var event in evtRes){
            this.events[event['id']] = Event.fromMap(event);
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
    } catch (exx, stack) {
      log('${exx.toString()}\n\t${stack.toString()}', time: DateTime.now());
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

  static Variable? fromMap(Map<String, dynamic> map){
    try {
      return Variable(
        name: map['name'],
        value: map['initialValue'] ?? 0,
        variableBehaviour: Variable.variableBehaviourFromString(map['descriptor']['behaviour']),
        sidebarBehaviour: Variable.sidebarBehaviourFromString(map['sidebar']['behaviour']),
        possibleValues: List.from(map['descriptor']['possibleValues'] ?? [], growable: false),
        showSidebar: map['sidebar']['showSidebar'] ?? false,
        showValue: map['sidebar']['showValue'] ?? false,
        min: map['sidebar']['min'] ?? 0,
        max: map['sidebar']['max'] ?? 0);
    } catch (exx, stack){
      log('${exx.toString()}\n\t${stack.toString()}', time: DateTime.now());
      return null;
    }
  }

  static Variable? fromJson(String json){
    try {
      Map<String, dynamic> res = jsonDecode(json);
      return fromMap(res);
    } catch (exx, stack){
      log('${exx.toString()}\n\t${stack.toString()}', time: DateTime.now());
      return null;
    }
  }

  static VariableBehaviour variableBehaviourFromString(String? name){
    switch(name){
      case 'closest':
        return VariableBehaviour.closest;
      case null:
        return VariableBehaviour.none;
      default:
        return VariableBehaviour.none;
    }
  }
  static SideBarBehaviour sidebarBehaviourFromString(String? name){
    switch(name){
      case 'pointer':
        return SideBarBehaviour.pointer;
      case 'filler':
        return SideBarBehaviour.filler;
      case null:
        return SideBarBehaviour.none;
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

  static Event? fromMap(Map<String, dynamic> map) {
    try {
      return Event(
        id: map['id'],
        name: map['name'],
        scenes: List.generate(
          map['scenes'].length,
          (index) => Scene.fromMap(map['scenes'][index])
        ) 
      );
    } catch (exx, stack){
      log('${exx.toString()}\n\t${stack.toString()}', time: DateTime.now());
      return null;
    }
  }

  static Event? fromJson(String json){
    try {
      Map<String, dynamic> res = jsonDecode(json);
      return fromMap(res);
    } catch (exx, stack){
      log('${exx.toString()}\n\t${stack.toString()}', time: DateTime.now());
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

  static Scene? fromMap(Map<String, dynamic> map){
    try {
      return Scene(
        id: map['id'],
        name: map['name'],
        body: map['body'],
        choices: List.generate(
          map['choices'].length,
          (index) => Choice.fromMap(map['choices'][index])
        )
      );
    } catch (exx, stack){
      log('${exx.toString()}\n\t${stack.toString()}', time: DateTime.now());
      return null;
    }
  }

  static Scene? fromJson(String json){
    try {
      Map<String, dynamic> res = jsonDecode(json);
      return fromMap(res);
    } catch (exx, stack){
      log('${exx.toString()}\n\t${stack.toString()}', time: DateTime.now());
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

  static Choice? fromMap(Map<String, dynamic> map){
    try {
      return Choice(
        body: map['body'],
        requirements: List.generate(
          map['requirements'].length,
          (index) => Requirement.fromMap(map['requirements'][index])
        ),
        outcomes: List.generate(
          map['outcomes'].length,
          (index) => Outcome.fromMap(map['outcomes'][index])
        ),
        route: map['route']
      );
    } catch (exx, stack){
      log('${exx.toString()}\n\t${stack.toString()}', time: DateTime.now());
      return null;
    }
  }

  static Choice? fromJson(String json){
    try {
      Map<String, dynamic> res = jsonDecode(json);
      return fromMap(res);
    } catch (exx, stack){
      log('${exx.toString()}\n\t${stack.toString()}', time: DateTime.now());
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

  static Requirement? fromMap(Map<String, dynamic> map){
    try {
      return Requirement(
        variable: map['variable'],
        min: map['min'],
        max: map['max'],
        exact: map['exact'],
        hidden: map['hidden']
      );
    } catch (exx, stack){
      log('${exx.toString()}\n\t${stack.toString()}', time: DateTime.now());
      return null;
    }
  }

  static Requirement? fromJson(String json){
    try {
      Map<String, dynamic> res = jsonDecode(json);
      return fromMap(res);
    } catch (exx, stack){
      log('${exx.toString()}\n\t${stack.toString()}', time: DateTime.now());
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

  static Outcome? fromMap(Map<String, dynamic> map){
    try {
      return Outcome(
        variable: map['variable'],
        value: map['value'],
        behaviour: outcomeBehaviourFromString(map['behaviour'])
      );
    } catch (exx, stack){
      log('${exx.toString()}\n\t${stack.toString()}', time: DateTime.now());
      return null;
    }
  }

  static Outcome? fromJson(String json){
    try {
      Map<String, dynamic> res = jsonDecode(json);
      return fromMap(res);
    } catch (exx, stack){
      log('${exx.toString()}\n\t${stack.toString()}', time: DateTime.now());
      return null;
    }
  }
  
  static OutcomeBehaviour outcomeBehaviourFromString(String? name){
    switch(name){
      case 'offset':
        return OutcomeBehaviour.offset;
      case null:
        return OutcomeBehaviour.none;
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
    } catch (exx, stack) {
      return false;
    }
  }
}