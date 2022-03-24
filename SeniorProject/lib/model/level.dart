import 'package:cyber/config/fixed_values.dart';
import 'package:json_annotation/json_annotation.dart';

part 'level.g.dart';

@JsonSerializable()
class Level {
  Level(
      {int this.totalXP = 0,
      required int this.xpInLevel,
      required int this.levelNumber});

  int totalXP;
  int xpInLevel;
  int levelNumber;

  factory Level.fromJson(Map<String, dynamic> json) => _$LevelFromJson(json);

  Map<String, dynamic> toJson() => _$LevelToJson(this);

  bool updateLevel({required int xpToAdd}) {
    bool levelUp = false;
    int newXpInLevel = this.xpInLevel + xpToAdd;

    //Regardless the leveling up we update the Xp

    this.totalXP = totalXP + xpToAdd;

    if (newXpInLevel > (baseLevel + ((levelNumber - 1) * levelScale))) {
      //That means the user has leveled up

      xpInLevel = newXpInLevel - (baseLevel + (levelNumber) * levelScale);
      levelUp = true;
      levelNumber++;
    } else {
      xpInLevel = newXpInLevel;
    }

    return levelUp;
  }
}
