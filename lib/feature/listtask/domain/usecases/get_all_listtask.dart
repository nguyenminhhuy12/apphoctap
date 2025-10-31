import '../entities/listtask.dart';
import '../repositories/listtask_repository.dart';

class GetAllListtask {
  final ListtaskRepository repo;
  GetAllListtask(this.repo);

  Future<List<Listtask>> call() => repo.getListtasks();
}