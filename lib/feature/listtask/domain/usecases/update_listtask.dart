import '../entities/listtask.dart';
import '../repositories/listtask_repository.dart';

class UpdateListtask {
  final ListtaskRepository repo;
  UpdateListtask(this.repo);

  Future<void> call(Listtask t) => repo.updateListtask(t);
}