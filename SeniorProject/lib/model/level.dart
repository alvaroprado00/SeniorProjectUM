import 'package:cyber/config/fixed_values.dart';
import 'package:json_annotation/json_annotation.dart';

part 'level.g.dart';

@JsonSerializable()
class Level {
  int totalXP;
  int xpEarnedInLevel;
  int levelNumber;
  int xpAvailableInLevel;

  Level(
      {required int this.xpEarnedInLevel,
      required int this.levelNumber,
      required int this.totalXP,
      int this.xpAvailableInLevel = 0}) {
    initializeXPAvailableInLevel();
  }

  factory Level.fromJson(Map<String, dynamic> json) => _$LevelFromJson(json);

  Map<String, dynamic> toJson() => _$LevelToJson(this);

  bool updateLevel({required int xpToAdd}) {
    bool levelUp = false;
    int newXpInLevel = this.xpEarnedInLevel + xpToAdd;

    //Regardless the leveling up we update the Xp

    this.totalXP = totalXP + xpToAdd;

    if (newXpInLevel > (baseLevel + ((levelNumber - 1) * levelScale))) {
      //That means the user has leveled up

      xpEarnedInLevel = newXpInLevel - (baseLevel + (levelNumber) * levelScale);
      levelUp = true;
      levelNumber++;
    } else {
      xpEarnedInLevel = newXpInLevel;
    }

    return levelUp;
  }

  void initializeXPAvailableInLevel() {
    this.xpAvailableInLevel = (levelNumber - 1) * levelScale + baseLevel;
  }
}
