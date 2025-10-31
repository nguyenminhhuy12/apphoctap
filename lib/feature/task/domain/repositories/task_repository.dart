import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<Task> getTask(String id);
  Future<void> createTask(Task s);
  Future<void> updateTask(Task s);
  Future<void> deleteTask(String id);
}