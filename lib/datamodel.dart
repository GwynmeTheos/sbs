class GameData {
  late List<Event> events;

  GameData._({
    preload: true
  }){

  }

  factory GameData.preloadFromDisk(){
    return GameData._(
      preload: true
    );
  }

}

class Event {

}