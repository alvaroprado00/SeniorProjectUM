import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber/config/k_collection_names_firebase.dart';
import 'package:cyber/globals.dart';
import 'package:cyber/model/course.dart';
import 'package:cyber/model/fill_in_the_blanks_question.dart';
import 'package:cyber/model/multiple_choice_question.dart';
import 'package:cyber/model/question.dart';
import 'package:cyber/view/useful/k_values.dart';

class CourseController {


  /**
   * Function to get a Course from the database when the title is specified
   */
  Future getCourse({required String title}) async {
    //First of all I create a reference to the collection of courses

    CollectionReference courses = FirebaseFirestore.instance.collection(
        courseCollectionName);

    return courses
          .where('title', isEqualTo: title)
          .get()
          .then((snapshot)  async {
        Map<String, dynamic> json = snapshot.docs[0].data() as Map<String,
            dynamic>;
  
        //Here I build the course from the json however the questions are an empty set
        Course course = Course.fromJson(json);

        //To add the questions to the course I need to call to another future

         Course courseFilled= await getQuestionsForCourse(course: course, courseId: snapshot.docs[0].id);
        return courseFilled;
          }).catchError((error)=> print('Could not find a course with that name'));
  }

  /**
   * This function is used by the function getCourse to be able to get
   * the subcollection of questions of the course and add them to the object
   */
  Future getQuestionsForCourse(
      {required Course course, required String courseId}) async {

    //I create a reference to the subcollection of questions in the document
    //of the course

    CollectionReference questions = FirebaseFirestore.instance.collection(
        courseCollectionName).doc(courseId).collection(questionCollectionName);

    Question q;
    return questions.get().then((snapshot) {
      for (int i = 0; i < snapshot.size; i++) {
        //For each document in the questions collection I create a json

        Map<String, dynamic> json = snapshot.docs[i].data() as Map<
            String,
            dynamic>;

        //Then I check what kind of question it is so I can create an object from it

        if (typeOfQuestionFromString[json['typeOfQuestion']] ==
            TypeOfQuestion.multipleChoice) {
          q = MultipleChoiceQuestion.fromJson(json);
        } else {
          q = FillInTheBlanksQuestion.fromJson(json);
        }

        //Finally I can add the question to the course
        course.questions.add(q);

      }

      //Here I order the questions according to their number
      course.questions.sort((a,b)=>a.number.compareTo(b.number));

      return course;
    }).catchError((error)=> print('Could not get the questions for the course specified'));

  }

  /**
   * Function to add the course that has been filled in the adming pages
   * to firebase.
   */

  Future addCourseToFirebase(){

    //Since the course is stored as a global variable we dont need to get it
    //as a param
    CollectionReference courses = FirebaseFirestore.instance.collection(
        courseCollectionName);

    return courses.add({
      'category': stringFromCategory[newCourse!.category],
      'description': newCourse!.description,
      'experiencePoints': newCourse!.experiencePoints,
      'imageURL':newCourse!.imageURL,
      'numberOfQuestions': newCourse!.numberOfQuestions,
      'outcomes': newCourse!.outcomes,
      'title': newCourse!.title,
      'badgeIcon':newCourse!.badgeIcon,
      'positionInCategory':newCourse!.positionInCategory,
    }).then((value) async {
      //Once I have added the course I need to add the questions
     // await addQuestionsToFirebase(courseId:value.id);
      String s='';

      print('Course created');
      try{
        await addQuestionsToFirebase(courseId: value.id).then((value){s=value;});
      }catch(e){
        s=e.toString();
      }
      print(s);
      return s;
    }).catchError((error){
      print('Course NOT created');
      return 'Error: course not created';
    });
  }

  /**
   * Function used by addCourseToFirebase to create a subcollection of questions
   * in the document of the course
   */
  Future addQuestionsToFirebase({required String courseId}){

    CollectionReference questions = FirebaseFirestore.instance.collection(
        courseCollectionName).doc(courseId).collection(questionCollectionName);


    for (Question q in newCourse!.questions){

      if(q is MultipleChoiceQuestion){
        questions.add({
          'longFeedback': q.longFeedback,
          'number': q.number,
          'options': q.options,
          'rightOption': q.rightOption,
          'description': q.description,
          'typeOfQuestion': stringFromTypeOfQuestion[q.typeOfQuestion],
        });
      }else if(q is FillInTheBlanksQuestion){

        questions.add({
        'longFeedback': q.longFeedback,
        'number': q.number,
        'options': q.options,
        'solution': Map.from(q.solution.map((key,value){
         return MapEntry(
               key.toString(),
               value);
          })),
        'typeOfQuestion': stringFromTypeOfQuestion[q.typeOfQuestion],
          'text':q.text,
        });
      }
    }

    print('Questions added');
    return Future<String>.value('Complete course added');

  }
}

