import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/listtask.dart';

class ListtaskModel extends Listtask {
  const ListtaskModel({
    required super.id,
    required super.name,
    required super.taskname,
    required super.times,
  });
  factory ListtaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ListtaskModel(
      id: doc.id,
      name: data['name'] ?? '',
      taskname: data['taskname']?? '',
      times: data['times']?? 0,
    );
  }
  Map<String, dynamic> toJson() => {
        'name': name,
        'taskname': taskname,
        'times': times,
      };
  factory ListtaskModel.fromEntity(Listtask s) => ListtaskModel(
    id: s.id, 
    name: s.name, 
    taskname: s.taskname,
    times: s.times, 
    );
}