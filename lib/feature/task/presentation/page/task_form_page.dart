import 'package:flutter/material.dart';
import '../../domain/usecases/create_task.dart';
import '../../domain/usecases/update_task.dart';
import '../../domain/entities/task.dart';

class TaskFormPage extends StatefulWidget {
  final Task? task;
  final CreateTask createUsecase;
  final UpdateTask updateUsecase;

  const TaskFormPage({
    super.key,
    this.task,
    required this.createUsecase,
    required this.updateUsecase,
  });
  @override
  State<TaskFormPage> createState() {
    return _TaskFormPageState();
  }
}
class _TaskFormPageState extends State<TaskFormPage>{
  final _formkey = GlobalKey<FormState>();

  late String _question;
  late String _a;
  late String _b;
  late String _c;
  late String _d;
  late String _answer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _question = widget.task?.question ?? '';
    _a = widget.task?.a ?? '';
    _b = widget.task?.b ?? '';
    _c = widget.task?.c ?? '';
    _d = widget.task?.d ?? '';
    _answer = widget.task?.answer ?? '';
  }
  Future<void> _save() async {
    if(!_formkey.currentState!.validate()) return;//doan nay kiem tra validate cua form
    _formkey.currentState!.save();

    final newTask = Task(
      id: widget.task?.id ?? '', 
      question: _question, 
      a: _a, 
      b: _b, 
      c: _c, 
      d: _d,
      answer: _answer,
      );
      if(widget.task == null){
        await widget.createUsecase(newTask);
      }
      else{
        await widget.updateUsecase(newTask);
      }
      if(mounted) Navigator.pop(context, true);
      print('da an button nay');
  }
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Task' : 'Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formkey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _question,
                decoration: const InputDecoration(labelText: 'Question'),
                validator: (v) => v!.isEmpty ? 'Enter title' : null,
                onSaved: (v) => _question = v!.trim(),
              ),
              TextFormField(
                initialValue: _a,
                decoration: const InputDecoration(labelText: 'a'),
                validator: (v) => v!.isEmpty ? 'Enter a' : null,
                onSaved: (v) => _a = v!.trim(),
              ),
              TextFormField(
                initialValue: _b,
                decoration: const InputDecoration(labelText: 'b'),
                validator: (v) => v!.isEmpty ? 'Enter b' : null,
                onSaved: (v) => _b = v!.trim(),
              ),
              TextFormField(
                initialValue: _c,
                decoration: const InputDecoration(labelText: 'c'),
                validator: (v) => v!.isEmpty ? 'Enter c' : null,
                onSaved: (v) => _c = v!.trim(),
              ),
              TextFormField(
                initialValue: _d,
                decoration: const InputDecoration(labelText: 'd'),
                validator: (v) => v!.isEmpty ? 'Enter d' : null,
                onSaved: (v) => _d = v!.trim(),
              ),
              DropdownButtonFormField<String>(
                initialValue: _answer.isNotEmpty ? _answer : null, // nếu có giá trị cũ thì chọn
                decoration: const InputDecoration(labelText: 'Answer'),
                items: const [
                  DropdownMenuItem(value: 'a', child: Text('a')),
                  DropdownMenuItem(value: 'b', child: Text('b')),
                  DropdownMenuItem(value: 'c', child: Text('c')),
                  DropdownMenuItem(value: 'd', child: Text('d')),
                ],
                onChanged: (value) {
                  setState(() {
                    _answer = value!;
                  });
                },
                validator: (value) => value == null || value.isEmpty ? 'Select answer' : null,
                onSaved: (value) => _answer = value!,
              ),
              
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _save,
                icon: Icon(isEdit ? Icons.save : Icons.add),
                label: Text(isEdit ? 'Update' : 'Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}