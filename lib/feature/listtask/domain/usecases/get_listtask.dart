import '../entities/listtask.dart';
import '../repositories/listtask_repository.dart';

class GetListtask {
  final ListtaskRepository repo;
  GetListtask(this.repo);
  
  Future<Listtask> call(String id) => repo.getListtask(id);
}