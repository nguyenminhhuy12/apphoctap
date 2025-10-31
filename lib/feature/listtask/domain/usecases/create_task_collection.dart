import '../repositories/listtask_repository.dart';

class CreateTaskCollection {
  final ListtaskRepository repo;
  CreateTaskCollection(this.repo);

  Future<void> call(String s) => repo.createCollectionTask(s);
}