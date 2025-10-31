import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';

class TaskResultPage extends StatelessWidget {
  final List<Task> tasks;
  final Map<String, String> userAnswers;
  final double score;
  final int times;

  const TaskResultPage({
    super.key,
    required this.tasks,
    required this.userAnswers,
    required this.score,
    required this.times,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kết quả bài kiểm tra')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Điểm của bạn: $score\nso lan thi: ${times} ',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  final userAnswer = userAnswers[task.id];
                  final isCorrect = userAnswer == task.answer;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.question,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Bạn chọn: $userAnswer',
                            style: TextStyle(
                                fontSize: 14,
                                color: isCorrect
                                    ? Colors.green
                                    : Colors.red),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Đáp án đúng: ${task.answer}',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Trở lại'),
            ),
          ],
        ),
      ),
    );
  }
}
