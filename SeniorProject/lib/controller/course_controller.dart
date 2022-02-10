
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber/config/k_collection_names_firebase.dart';
import 'package:cyber/model/course.dart';

class CourseController{

  final courseRef = FirebaseFirestore.instance.collection(courseCollectionName).withConverter<Course>(
    fromFirestore: (snapshot, _) => Course.fromJson(snapshot.data()!),
    toFirestore: (course, _) => course.toJson(),
  );

  Future getCourse({required String title}) async {

    return await courseRef
        .where('title', isEqualTo: title)
        .get()
        .then((snapshot) => snapshot.docs[0]);
  }
}