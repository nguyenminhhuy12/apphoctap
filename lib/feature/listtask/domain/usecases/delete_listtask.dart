import '../repositories/listtask_repository.dart';

class DeleteListtask {
  final ListtaskRepository repo;
  DeleteListtask(this.repo);

  Future<void> call(String id) => repo.deleteListtask(id);
}