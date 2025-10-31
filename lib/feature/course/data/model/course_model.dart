import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/course.dart';

class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.courseTitle,
    required super.title,
    required super.description,
    required super.duration,
    required super.videoUrl,
    required super.thumbnail,
  });
  factory CourseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CourseModel(
      id: doc.id,
      courseTitle: data['courseTitle'] ?? '',
      title: data['title']?? '',
      description: data['description']?? '',
      duration: data['duration'] ?? '',   
      videoUrl: data['videoUrl']?? '',  
      thumbnail: data['thumbnail'] ?? '',
    );
  }
  Map<String, dynamic> toJson() => {
        'courseTitle': courseTitle,
        'title': title,
        'description': description,
        'duration': duration,
        'videoUrl': videoUrl,
        'thumbnail': thumbnail,
      };
  factory CourseModel.fromEntity(Course s) => CourseModel(
    id: s.id, 
    courseTitle: s.title, 
    title: s.title, 
    description: s.description, 
    duration: s.duration, 
    videoUrl: s.videoUrl,
    thumbnail: s.thumbnail,
    );
}