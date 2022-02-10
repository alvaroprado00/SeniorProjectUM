import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber/config/k_collection_names_firebase.dart';
import 'package:cyber/model/course.dart';

class CourseController{

  /**
   * If you create a reference to the collection this way, then automatically the data in
   * the snapshot is in the form of a Course object, you dont have to do any changes
   * after getting the snapshot
   */
  final courseRef = FirebaseFirestore.instance.collection(courseCollectionName).withConverter<Course>(
    fromFirestore: (snapshot, _) => Course.fromJson(snapshot.data()!),
    toFirestore: (course, _) => course.toJson(),
  );

  /**
   * Function to get a Course from the database when the title is specified
   */
  Future getCourse({required String title}) async {

    return await courseRef
        .where('title', isEqualTo: title)
        .get()
        .then((snapshot) => snapshot.docs[0]);
  }
}