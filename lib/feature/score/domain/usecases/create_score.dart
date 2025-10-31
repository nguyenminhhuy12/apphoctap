import '../entities/score.dart';
import '../repositories/score_repository.dart';

class CreateScore {
  final ScoreRepository repo;
  CreateScore(this.repo);

  Future<void> call(Score s) => repo.createScore(s);
}