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
  //Reference to the collection of courses
  CollectionReference courses =
      FirebaseFirestore.instance.collection(courseCollectionName);

  /**
   * Function to get a Course from the database when the title is specified.
   * First the course is gotten from the DB, after that, the ID is initialized
   * Then using another method the questions are initialized
   */
  Future getCourseByTitle({required String title}) async {
    return courses
        .where('title', isEqualTo: title)
        .get()
        .then((snapshot) async {
      //We get the first course from the list
      Map<String, dynamic> json =
          snapshot.docs[0].data() as Map<String, dynamic>;

      //Here I build the course from the json however the questions are not initialized
      Course course = Course.fromJson(json);
      course.id = snapshot.docs[0].id;

      //To add the questions to the course I need to call to another future

      try{
        Course courseFilled = await getQuestionsForCourse(
            course: course, courseId: snapshot.docs[0].id);
        return courseFilled;
      }catch(error){
        throw Exception('Could not get the questions for the course');
      }

    }).catchError((error) {
      print('Could not find a course with that name');
      return Exception(error.toString());
    });
  }

  /**
   * This function is used by the function getCourse to be able to get
   * the subcollection of questions of the course and add them to the instance
   */
  Future getQuestionsForCourse(
      {required Course course, required String courseId}) async {

    //I create a reference to the subcollection of questions
    CollectionReference questions =
        courses.doc(courseId).collection(questionCollectionName);

    Question q;
    return questions.get().then((snapshot) {
      for (int i = 0; i < snapshot.size; i++) {
        //For each document in the questions collection I create a json

        Map<String, dynamic> json =
            snapshot.docs[i].data() as Map<String, dynamic>;

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
      course.questions.sort((a, b) => a.number.compareTo(b.number));

      return course;
    }).catchError((error){
      print('Could not get the questions for the course specified');
      throw Exception('Could not get the questions for the course');
    }
        );
  }

  /**
   * Function to add the course that has been filled in the admin pages
   * to firebase. The course to be added is a global variable
   */
  Future addCourseToFirebase() {
    return courses.add(newCourse!.toJson()).then((value) async {


      print('Course created');
      try {
        await addQuestionsToFirebase(courseId: value.id);
        print('Questions added');

      } catch (e) {
        throw Exception('Could not add Questions to course');
      }

    }).catchError((error) {
      print('Course NOT created');
      throw Exception(error.toString());
    });
  }

  /**
   * Function used by addCourseToFirebase to create a subcollection of questions
   * in the document of the course
   */
  Future addQuestionsToFirebase({required String courseId}) {
    CollectionReference questions =
        courses.doc(courseId).collection(questionCollectionName);

    try {
      for (Question q in newCourse!.questions) {
        if (q is MultipleChoiceQuestion) {
          questions.add(q.toJson());
        } else if (q is FillInTheBlanksQuestion) {
          questions.add(q.toJson());
        }
      }
    }catch(error){
      print('Error when adding questions to course');
      throw Exception(error.toString());
    }
    print('Questions added');
    return Future<String>.value('Complete course added');
  }

  /**
   * Function that returns a Map with the following map entries
   * <courseID, title> for all the courses in the category specified.
   * If not any then the map will be empty.
   */
  Future getCoursesFromCategory({required Category category}) {
    Map<String, String> coursesInCategory = {};

    return courses
        .where('category', isEqualTo: categoryToString[category]!)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc) {
        coursesInCategory[doc.id] = doc['title'];
      });
      return coursesInCategory;
    }).catchError((error) {
      print('Error when looking for a category');

      throw Exception('No courses in ${categoryToString[category]!}');
    });
  }

  /**
   * This method returns a course from the DB. The param id is the courses' id
   * It will also be filled with its questions.
   */
  Future getCourseByID({required String id}) {
    return courses.doc(id).get().then((snapshot) async {
      Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
      Course course = Course.fromJson(json);
      course.id = snapshot.id;

      try {
        Course courseFilled =
            await getQuestionsForCourse(course: course, courseId: id);
        return courseFilled;
      } catch (error) {
        throw Exception('Failed when getting questions for course');
      }
    }).catchError((error) {
      throw Exception(error.toString());
    });
  }

  /**
   * This method is used to get the recommended course from the collection
   * created in Firestore for that purpose
   */
  Future getRecommendedCourse() {
    CollectionReference recommendedCollection =
        FirebaseFirestore.instance.collection(recommendedCollectionName);

    return recommendedCollection
        .doc(recommendedDocName)
        .get()
        .then((snapshot) async {
      Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
      try {
        Course c = await getCourseByID(id: json['courseID']);
        return c;
      } catch (error) {
        throw Exception('Did not found course with that ID');
      }
    }).catchError((error) {
      throw Exception('Not recommended course found');
    });
  }
}
