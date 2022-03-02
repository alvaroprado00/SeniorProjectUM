import 'package:cyber/model/question.dart';
import 'package:cyber/view/useful/k_values.dart';
import 'package:flutter/material.dart';

class Course {
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
      'imageURL': imageURL,
      'title': title,
      'category': stringFromCategory[category],
      'experiencePoints': experiencePoints,
      'numberOfQuestions': numberOfQuestions,
      'description': description,
      'outcomes': outcomes,
    };
  }


}
