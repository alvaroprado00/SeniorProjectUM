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
   * First the course is gotten from the DB, after that, the ID is initialized
   * Then using another method the questions are initialized
   * Before the course is returned I set the attribute featuredCourse
   */
  Future getCourseByTitle({required String title}) async {
    //Before doing anything I format the title

    //I eliminate any blank space
    title = title.trim();

    //I set the first letter as capital and the rest as normal
    title = title[0].toUpperCase() + title.substring(1).toLowerCase();

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

      Course courseFilled = await getQuestionsForCourse(
          course: course, courseId: snapshot.docs[0].id);

      //Then we also need to set the attribute isFeatured
      String featuredCourseID = await getFeaturedCourseID();

      courseFilled.isFeatured = false;
      if (featuredCourseID == course.id) {
        courseFilled.isFeatured = true;
      }
      return courseFilled;
    }).catchError((error) {
      print('Error when getting course by title');
      throw Exception('Error when getting course by title');
    });
  }

  /**
   * Method to get a course from the DB by specifying its ID
   * To see how this method works refer to getCourseByTitle
   */
  Future getCourseByID({required String id}) {
    return coursesRef.doc(id).get().then((snapshot) async {
      Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
      Course course = Course.fromJson(json);

      //I set the Id
      course.id = snapshot.id;

      //I get the questions for the course

      Course courseFilled =
          await getQuestionsForCourse(course: course, courseId: id);

      //After that I check if it is the featured course

      String featuredCourseID = await getFeaturedCourseID();

      courseFilled.isFeatured = false;
      if (featuredCourseID == course.id) {
        courseFilled.isFeatured = true;
      }
      return courseFilled;
    }).catchError((error) {
      print('Error getting the course by its id');
      throw Exception('Error getting the course by its id');
    });
  }

  /**
   * This function is used by the function getCourseByID and getCourseByTitle to be able to get
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
      print('Could not get the questions for the course specified');
      throw Exception('Error getting questions for specified course');
    });
  }

  /**
   * This method is used to get the recommended course from the collection
   * created in Firestore for that purpose
   */
  Future getRecommendedCourse() async {
    try {
      final String recommendedCourseID = await this.getRecommendedCourseID();
      final Course course = await this.getCourseByID(id: recommendedCourseID);

      return course;
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future getRecommendedCourseID() {
    return recommendedCollectionRef
        .doc(recommendedDocName)
        .get()
        .then((snapshot) async {
      Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;

      return json['courseID'] as String;
    }).catchError((error) {
      print('Error when getting recommended course');
      throw Exception('Not recommended found');
    });
  }

  /**
   * Function to get all the courses in the DB in a map
   * with the format Map<courseID, title>.
   */
  Future getCourseNames() {
    Map<String, String> courses = {};

    return coursesRef.get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        courses[doc.id] = doc['title'];
      });
      return courses;
    }).catchError((error) {
      print('Error when looking for courses');

      throw Exception('No courses found');
    });
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
    try {
      final String featuredCourseID = await this.getFeaturedCourseID();
      final Course course = await this.getCourseByID(id: featuredCourseID);

      return course;
    } catch (error) {
      throw Exception(error.toString());
    }
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
      print('Failed to access the collection recommended');
      throw Exception('Failed to access the collection recommended');
    });
  }

  /**
   * Function to add the new-course that has been filled in the admin pages
   * to firebase. The new-course to be added is a global variable
   */
  Future addCourseToFirebase({required Course courseToAdd}) {
    return coursesRef.add(courseToAdd.toJson()).then((value) async {
      print('Course added');
      await addQuestionsToFirebase(courseId: value.id);
      print('Course created');
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
      print('Error when adding questions to course');
      throw Exception('Error when adding questions to course');
    }
    print('Questions added');
    return Future<String>.value('Complete new-course added');
  }

  /**
   * Function to update the course Id of the document in the
   * recommended collection
   */
  Future updateRecommendedCourseByID({required String courseID}) async {

    if (await courseExists(courseID: courseID)) {
      recommendedCollectionRef
          .doc(recommendedDocName)
          .set({'courseID': courseID});
    } else {
      throw Exception('Course does not exist');
    }
  }

  /**
   * This Method updates the recommended course when provided with
   * the name of the new course. To do so, I use the method getCourseByTitle
   * and then I update the recommended course with updateRecommendedCourseWithID
   *
   * If completed correctly it returns the id of the course
   */
  Future updateRecommendedCourseByTitle(String title) async {
    try {
      Course newRecommendedCourse = await getCourseByTitle(title: title);
      await updateRecommendedCourseByID(courseID: newRecommendedCourse.id!);
      return newRecommendedCourse.id;
    } catch (error) {
      print('Error when updating course');
      throw Exception('Error updating course');
    }
  }

  /**
   * Method to update the featured Course using the course's title
   * To do so, I get the Course from the DB so i can get the ID and
   * I can call updateFeaturedCourseByID
   */
  Future updateFeaturedCourseByTitle(String title) async {
    try {
      Course newFeatured = await getCourseByTitle(title: title);
      await updateFeaturedCourseByID(courseID: newFeatured.id!);
      return newFeatured.id;
    } catch (error) {
      print('Error when updating featured course');
      throw Exception('Error updating featured course');
    }
  }

  /**
   * Method to set the field courseID of the
   * featuredCourse to the one specified in the param
   */
  Future updateFeaturedCourseByID({required String courseID}) async {
    try {
      if (await courseExists(courseID: courseID)) {
        featuredCollectionRef.doc(featuredDocName).set({'courseID': courseID});
      } else {
        throw Exception('Course does not exist');
      }
    } catch (error) {
      print('Error setting field courseID in featured course');
      throw Exception('Error when setting new id');
    }
  }

  Future deleteCourseByTitle(String title) async {
    try {
      Course courseToDelete = await getCourseByTitle(title: title);

      //Before deleting the document of the course, you have to delete the subcollection questions
      await deleteQuestionsFromCourse(cr:coursesRef.doc(courseToDelete.id).collection(questionCollectionName));
      await coursesRef.doc(courseToDelete.id!).delete();
      return courseToDelete.id;
    } catch (error) {
      print('Error deleting a course');
      throw Exception('Error deleting the course');
    }
  }

  Future deleteQuestionsFromCourse({required CollectionReference cr}){

    //Get the documents in the collection

    return cr.get().then((QdSnapshot) {
      for (int i = 0; i < QdSnapshot.size; i++) {
        //I delete each document
        QdSnapshot.docs[i].reference.delete();
      }
    }).catchError((error) {
      print('Error deleting questions from course');
      throw Exception('Error deleting questions from course');
    });
  }
}
