import '../entities/listtask.dart';

abstract class ListtaskRepository {
  Future<List<Listtask>> getListtasks();
  Future<Listtask> getListtask(String id);
  Future<void> createListtask(Listtask s);
  Future<void> updateListtask(Listtask s);
  Future<void> deleteListtask(String id);
  Future<void> createCollectionTask(String name);
}