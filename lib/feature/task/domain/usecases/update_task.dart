import '../entities/task.dart';
import '../repositories/task_repository.dart';

class UpdateTask {
  final TaskRepository repo;
  UpdateTask(this.repo);

  Future<void> call(Task t) => repo.updateTask(t);
}