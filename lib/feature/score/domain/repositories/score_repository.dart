import '../entities/score.dart';

abstract class ScoreRepository {
  Future<List<Score>> getScores();
  Future<Score> getScore(String id);
  Future<void> createScore(Score s);
}