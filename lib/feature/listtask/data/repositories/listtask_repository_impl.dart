import '../data/listtask_remote_datasource.dart';
import '../../domain/entities/listtask.dart';
import '../model/listtask_model.dart';
import '../../domain/repositories/listtask_repository.dart';

class ListtaskRepositoryImpl extends ListtaskRepository {
  final ListtaskRemoteDatasource remoteDatasource;

  ListtaskRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<Listtask>> getListtasks() async {
    List<ListtaskModel> listListtask = await remoteDatasource.getAlltea();
    return listListtask;
  }
  @override
  Future<Listtask> getListtask(String id) async {
    ListtaskModel? listtaskModel = await remoteDatasource.getteaById(id);
    if(listtaskModel == null)
    {
      throw Exception('Listtask not found');
    }
    return listtaskModel;
  }
  @override
  Future<void> createListtask(Listtask s) async {
    ListtaskModel listtaskModel = ListtaskModel.fromEntity(s);
    await remoteDatasource.addtea(listtaskModel);
  }
  @override
  Future<void> deleteListtask(String id) async {
    await remoteDatasource.deletetea(id);
  }
  @override
  Future<void> updateListtask(Listtask s) async {
    await remoteDatasource.updatetea(ListtaskModel.fromEntity(s));
  }
  @override
  Future<void> createCollectionTask(String name) async {
    // TODO: implement createEmptyCollection
    await remoteDatasource.createcollection(name);

  }
}