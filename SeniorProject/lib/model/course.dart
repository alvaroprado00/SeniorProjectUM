import 'package:cyber/model/question.dart';
import 'package:cyber/view/useful/k_values.dart';

class Course {
  String? id;
  String imageURL;
  String title;
  Category category;
  int positionInCategory;
  int numberOfQuestions;
  int experiencePoints;
  String description;
  String badgeIcon;
  List<String> outcomes;
  List<Question> questions;

  Course({
    required this.imageURL,
    required this.title,
    required this.category,
    required this.positionInCategory,
    required this.numberOfQuestions,
    required this.experiencePoints,
    required this.description,
    required this.badgeIcon,
    required this.outcomes,
    required this.questions,
  });


  factory Course.fromJson(Map<String, dynamic> json){
    return Course(
      imageURL:json['imageURL'],
      title:json['title'],
      category: categoryFromString[json['category']]!,
      experiencePoints: json['experiencePoints'],
      numberOfQuestions: json['numberOfQuestions'],
      description: json['description'],
      outcomes: List.castFrom(json['outcomes']),
      questions: [],
      badgeIcon: '',
      positionInCategory: 1,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'category': categoryToString[category],
      'description': description,
      'experiencePoints': experiencePoints,
      'imageURL':imageURL,
      'numberOfQuestions':numberOfQuestions,
      'outcomes': outcomes,
      'title': title,
      'badgeIcon':badgeIcon,
      'positionInCategory':positionInCategory,
    };
  }


}
