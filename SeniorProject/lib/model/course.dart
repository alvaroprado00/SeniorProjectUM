import 'package:flutter/material.dart';

class Course {
  String imageURL;
  String title;
  int numberOfQuestions;
  int experiencePoints;
  String description;
  List<String> outcomes;

  Course({
    required this.imageURL,
    required this.title,
    required this.numberOfQuestions,
    required this.experiencePoints,
    required this.description,
    required this.outcomes,
  });

  factory Course.fromJson(Map<String, dynamic> json){
    return Course(
      imageURL:json['imageURL'],
      title:json['title'],
      experiencePoints: json['experiencePoints'],
      numberOfQuestions: json['numberOfQuestions'],
      description: json['description'],
      outcomes: List.castFrom(json['outcomes'])
    );
  }

  Map<String, Object?> toJson() {
    return {
      'imageURL': imageURL,
      'title': title,
      'experiencePoints': experiencePoints,
      'numberOfQuestions': numberOfQuestions,
      'description': description,
      'outcomes': outcomes,
    };
  }

  /**
   * Function to get an already built course
   */

  getFixedCourse() {
    return Course(
        imageURL:
              'https://photos5.appleinsider.com/gallery/40572-90020-iPhone-14-cameras-xl.jpg',
        title: 'Passwords',
        experiencePoints: 1000,
        numberOfQuestions: 15,
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc ut ipsum mollis, malesuada sem id, iaculis ante. Aenean egestas neque sed erat mollis imperdiet. Quisque rutrum lacinia nunc ut cursus. Nunc lobortis tortor ac rutrum tincidunt. Vestibulum at nisi molestie, scelerisque lectus quis, aliquam sapien. Nullam porta viverra erat, id tempor erat. Phasellus fermentum risus turpis, id bibendum elit tempor at. Sed id sollicitudin massa. In ullamcorper diam quis ipsum congue, at pharetra massa sodales. Mauris congue quis ante at suscipit.',
        outcomes: [
          'Learn how to create good passwords',
          'Learn the difference between long and secure passwords',
          'What characters should you use on a password'
        ]);
  }
}
