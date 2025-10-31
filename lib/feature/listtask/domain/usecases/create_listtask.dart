import '../entities/listtask.dart';
import '../repositories/listtask_repository.dart';

class CreateListtask {
  final ListtaskRepository repo;
  CreateListtask(this.repo);

  Future<void> call(Listtask s) => repo.createListtask(s);
}