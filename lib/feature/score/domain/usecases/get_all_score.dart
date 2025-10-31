import '../entities/score.dart';
import '../repositories/score_repository.dart';

class GetAllScore {
  final ScoreRepository repo;
  GetAllScore(this.repo);

  Future<List<Score>> call() => repo.getScores();
}