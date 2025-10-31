import '../entities/score.dart';
import '../repositories/score_repository.dart';

class GetScore {
  final ScoreRepository repo;
  GetScore(this.repo);
  
  Future<Score> call(String id) => repo.getScore(id);
}