import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/score.dart';

class ScoreModel extends Score {
  const ScoreModel({
    required super.id,
    required super.taskname,
    required super.username,
    required super.score,
    required super.times,
  });
  factory ScoreModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ScoreModel(
      id: doc.id,
      taskname: data['taskname'] ?? '',
      username: data['username']?? '',
      score: data['score']?? 0,
      times: data['times'] ?? 0,   
    );
  }
  Map<String, dynamic> toJson() => {
        'taskname': taskname,
        'username': username,
        'score': score,
        'times': times,
      };
  factory ScoreModel.fromEntity(Score s) => ScoreModel(
    id: s.id, 
    taskname: s.taskname, 
    username: s.username, 
    score: s.score, 
    times: s.times, 
    );
}