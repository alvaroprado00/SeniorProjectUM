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

  CollectionReference courses = FirebaseFirestore.instance.collection(
      courseCollectionName);

  /**
   * Function to get a Course from the database when the title is specified
   */
  Future getCourse({required String title}) async {
    //First of all I create a reference to the collection of courses

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

    CollectionReference questions = courses.doc(courseId).collection(questionCollectionName);

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

    CollectionReference questions = courses.doc(courseId).collection(questionCollectionName);


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

  /**
   * Function that retrieves a list of strings with the names
   * of the courses from a certain category. If not any then the
   * list will be empty.
   */
  Future getCourseNamesFromCategory({required String nameOfCategory}){

    List<String> courseNames=[];

    return courses
        .where('category', isEqualTo: nameOfCategory)
        .get()
        .then((snapshot) {

          snapshot.docs.forEach((doc) {
            courseNames.add(doc['title']);
          });
      return courseNames;
    }).catchError((error)=> print('Error when looking for a category'));
  }

  Future getCourseByID({required String id}) {

    return courses.doc(id).get().then((snapshot){
      Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
      return Course.fromJson(json);
    }).catchError((error){
      throw Exception('Course not found');
    });
  }

  Future getRecommendedCourse() {

    CollectionReference recommendedCollection= FirebaseFirestore.instance.collection(recommendedCollectionName);

    return recommendedCollection.doc(recommendedDocName).get().then((snapshot) async {
      Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
      try{
        Course c=await getCourseByID(id: json['courseID']);
        return c;
      }catch(error){
        throw Exception('Did not found course with that ID');
      }
    }).catchError((error){
      throw Exception('Not recommended course found');
    });

  }
}

