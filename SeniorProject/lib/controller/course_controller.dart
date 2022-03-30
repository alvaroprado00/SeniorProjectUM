import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber/config/k_collection_names_firebase.dart';
import 'package:cyber/globals.dart';
import 'package:cyber/model/course.dart';
import 'package:cyber/model/fill_in_the_blanks_question.dart';
import 'package:cyber/model/multiple_choice_question.dart';
import 'package:cyber/model/question.dart';
import 'package:cyber/view/util/k_values.dart';

class CourseController {
  //Reference to the collection of courses
  CollectionReference coursesRef =
      FirebaseFirestore.instance.collection(courseCollectionName);

  //Reference to the collection of recommended
  CollectionReference recommendedCollectionRef =
      FirebaseFirestore.instance.collection(recommendedCollectionName);


  //Reference to the collection featured
  CollectionReference featuredCollectionRef =
      FirebaseFirestore.instance.collection(featuredCollectionName);


  /**
   * Function to get a Course from the database when the title is specified.
   * First the new-course is gotten from the DB, after that, the ID is initialized
   * Then using another method the questions are initialized
   */
  Future getCourseByTitle({required String title}) async {
    return coursesRef
        .where('title', isEqualTo: title)
        .get()
        .then((snapshot) async {
      //We get the first new-course from the list
      Map<String, dynamic> json =
          snapshot.docs[0].data() as Map<String, dynamic>;

      //Here I build the new-course from the json however the questions are not initialized
      Course course = Course.fromJson(json);
      course.id = snapshot.docs[0].id;

      //To add the questions to the new-course I need to call to another future

      try {
        Course courseFilled = await getQuestionsForCourse(
            course: course, courseId: snapshot.docs[0].id);


        //Then we also need to set the attribute isFeatured
        try {
          String featuredCourseID = await getFeaturedCourseID();

          courseFilled.isFeatured = false;
          if (featuredCourseID == course.id) {
            courseFilled.isFeatured = true;
          }
          return courseFilled;
        } catch (error) {
          throw Exception('Could not get the ID for the featured Course');
        }
      } catch (error) {
        throw Exception('Could not get the questions for the new-course');
      }
    }).catchError((error) {
      print('Could not find a new-course with that name');
      return Exception(error.toString());
    });
  }

  /**
   * This function is used by the function getCourse to be able to get
   * the subcollection of questions of the new-course and add them to the instance
   */
  Future getQuestionsForCourse(
      {required Course course, required String courseId}) async {
    //I create a reference to the subcollection of questions
    CollectionReference questions =
        coursesRef.doc(courseId).collection(questionCollectionName);

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

        //Finally I can add the question to the new-course
        course.questions.add(q);
      }

      //Here I order the questions according to their number
      course.questions.sort((a, b) => a.number.compareTo(b.number));

      return course;
    }).catchError((error) {
      print('Could not get the questions for the new-course specified');
      throw Exception('Could not get the questions for the new-course');
    });
  }

  /**
   * Function to add the new-course that has been filled in the admin pages
   * to firebase. The new-course to be added is a global variable
   */
  Future addCourseToFirebase() {
    return coursesRef.add(newCourse!.toJson()).then((value) async {
      print('Course created');
      try {
        await addQuestionsToFirebase(courseId: value.id);
        print('Questions added');
      } catch (e) {
        throw Exception('Could not add Questions to new-course');
      }
    }).catchError((error) {
      print('Course NOT created');
      throw Exception(error.toString());
    });
  }

  /**
   * Function used by addCourseToFirebase to create a subcollection of questions
   * in the document of the new-course
   */
  Future addQuestionsToFirebase({required String courseId}) {
    CollectionReference questions =
        coursesRef.doc(courseId).collection(questionCollectionName);

    try {
      for (Question q in newCourse!.questions) {
        if (q is MultipleChoiceQuestion) {
          questions.add(q.toJson());
        } else if (q is FillInTheBlanksQuestion) {
          questions.add(q.toJson());
        }
      }
    } catch (error) {
      print('Error when adding questions to new-course');
      throw Exception(error.toString());
    }
    print('Questions added');
    return Future<String>.value('Complete new-course added');
  }

  /**
   * Function that returns a Map with the following map entries
   * <courseID, title> for all the courses in the category specified.
   * If not any then the map will be empty.
   */
  Future getCourseNamesFromCategory({required Category category}) {
    Map<String, String> coursesInCategory = {};

    return coursesRef
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
   * This method returns a new-course from the DB. The param id is the courses' id
   * It will also be filled with its questions.
   */
  Future getCourseByID({required String id}) {
    return coursesRef.doc(id).get().then((snapshot) async {
      Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
      Course course = Course.fromJson(json);

      //I set the Id
      course.id = snapshot.id;

      //I get the questions for the course
      try {
        Course courseFilled =
            await getQuestionsForCourse(course: course, courseId: id);

        //After that I check if it is the featured course
        try {
          String featuredCourseID = await getFeaturedCourseID();

          courseFilled.isFeatured = false;
          if (featuredCourseID == course.id) {
            courseFilled.isFeatured = true;
          }
          return courseFilled;
        } catch (error) {
          throw Exception(
              'Failed when getting the course ID of the featured Course');
        }
      } catch (error) {
        throw Exception('Failed when getting questions for new-course');
      }
    }).catchError((error) {
      throw Exception(error.toString());
    });
  }

  /**
   * This method is used to get the recommended new-course from the collection
   * created in Firestore for that purpose
   */
  Future getRecommendedCourse() {
    return recommendedCollectionRef
        .doc(recommendedDocName)
        .get()
        .then((snapshot) async {
      Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
      try {
        Course c = await getCourseByID(id: json['courseID']);
        return c;
      } catch (error) {
        throw Exception('Did not found new-course with that ID');
      }
    }).catchError((error) {
      throw Exception('Not recommended new-course found');
    });
  }

  /**
   * Function to check if a course exists on the courses collection
   */
  Future courseExists({required String courseID}) {
    return coursesRef.doc(courseID).get().then((docSnapshot) {
      if (docSnapshot.exists) {
        return true;
      } else {
        return false;
      }
    }).catchError((onError) {
      throw Exception('Failed to access the collection recommended');
    });
  }

  /**
   * Function to update the course Id of the document in the
   * recommended collection
   */
  Future updateRecommendedCourse({required String courseID}) async {
    try {
      bool exists = await courseExists(courseID: courseID);

      if (exists) {
        return recommendedCollectionRef
            .doc(recommendedDocName)
            .set({'courseID': courseID}).then((val) {
          return 'Course Updated';
        });
      } else {
        return 'Course not Found';
      }
    } catch (error) {
      throw Exception('Error when looking for the course');
    }
  }

  /**
   * This function is used to get a map with entries
   * <courseID, title> when provided just with the ids
   */
  Future getCourseNamesByIDs({required List<String> ids}) async {
    Map<String, String> courses = {};

    try {
      for (String id in ids) {
        Course newCourse = await getCourseByID(id: id);
        courses[id] = newCourse.title;
      }
    } catch (err) {
      throw Exception('Error when getting the courses');
    }

    return courses;

  }

  /**
   * Method to search the FeaturedCollection looking for the ID
   * of the featuredCourse
   */
  Future getFeaturedCourseID() {
    return featuredCollectionRef
        .doc(featuredDocName)
        .get()
        .then((snapshot) async {
      Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;

      return json['courseID'] as String;
    }).catchError((error) {
      throw Exception('Could not get the Featured Course\'s ID');
    });
  }

  /**
   * Method to get the Featured Course complete by using the method
   * getFeaturedCourseID and getCourseByID
   */
  Future getFeaturedCourse() async {
    try{
      final String featuredCourseID =await this.getFeaturedCourseID();
      final Course course =await this.getCourseByID(id:featuredCourseID);

      return course;
    }catch(error){
      throw Exception(error.toString());
    }

  }
}
