import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.question,
    required super.a,
    required super.b,
    required super.c,
    required super.d,
    required super.answer,
  });
  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      question: data['question'] ?? '',
      a: data['a']?? '',
      b: data['b']?? '',
      c: data['c'] ?? '',   
      d: data['d']?? '',  
      answer: data['answer'] ?? '',
    );
  }
  Map<String, dynamic> toJson() => {
        //'id' : id,
        'question': question,
        'a': a,
        'b': b,
        'c': c,
        'd': d,
        'answer': answer,
      };
  factory TaskModel.fromEntity(Task s) => TaskModel(
    id: s.id, 
    question: s.question, 
    a: s.a, 
    b: s.b, 
    c: s.c, 
    d: s.d,
    answer: s.answer,
    );
}