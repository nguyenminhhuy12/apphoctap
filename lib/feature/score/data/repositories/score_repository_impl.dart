import '../data/score_remote_datasource.dart';
import '../../domain/entities/score.dart';
import '../model/score_model.dart';
import '../../domain/repositories/score_repository.dart';

class ScoreRepositoryImpl extends ScoreRepository {
  final ScoreRemoteDatasource remoteDatasource;

  ScoreRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<Score>> getScores() async {
    List<ScoreModel> listScore = await remoteDatasource.getAllStu();
    return listScore;
  }
  @override
  Future<Score> getScore(String id) async {
    ScoreModel? scoreModel = await remoteDatasource.getStuById(id);
    if(scoreModel == null)
    {
      throw Exception('Score not found');
    }
    return scoreModel;
  }
  @override
  Future<void> createScore(Score s) async {
    ScoreModel bm = ScoreModel.fromEntity(s);
    await remoteDatasource.addstu(bm);
  }
}