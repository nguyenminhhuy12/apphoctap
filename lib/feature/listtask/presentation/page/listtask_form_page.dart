import 'package:flutter/material.dart';
import '../../domain/entities/listtask.dart';
import '../../domain/usecases/create_listtask.dart';
import '../../domain/usecases/update_listtask.dart';
import 'package:apphoctap/feature/listtask/domain/usecases/create_task_collection.dart';

class ListtaskFormPage extends StatefulWidget {
  final Listtask? listtask;
  final CreateListtask createUsecase;
  final UpdateListtask updateUsecase;
  final CreateTaskCollection createCollectionUsecase;

  const ListtaskFormPage({
    super.key,
    this.listtask,
    required this.createUsecase,
    required this.updateUsecase,
    required this.createCollectionUsecase,
  });

  @override
  State<ListtaskFormPage> createState() => _ListtaskFormPageState();
}

class _ListtaskFormPageState extends State<ListtaskFormPage> {
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late String _taskname;
  late int _times;

  @override
  void initState() {
    super.initState();
    _name = widget.listtask?.name ?? '';
    _taskname = widget.listtask?.taskname ?? '';
    _times = widget.listtask?.times ?? 0;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final newListtask = Listtask(
      id: widget.listtask?.id ?? '',
      name: _name,
      taskname: _taskname,
      times: _times,
    );

    if (widget.listtask == null) {
      await widget.createUsecase(newListtask);
      await widget.createCollectionUsecase(_taskname);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã tạo listtask và collection "$_taskname"')),
      );
    } else {
      await widget.updateUsecase(newListtask);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật listtask thành công')),);
    }

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.listtask != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Sửa Listtask' : 'Thêm Listtask'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Tên Listtask'),
                validator: (v) => v!.isEmpty ? 'Nhập tên listtask' : null,
                onSaved: (v) => _name = v!.trim(),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _taskname,
                decoration: const InputDecoration(labelText: 'Taskname (bộ đề)'),
                validator: (v) => v!.isEmpty ? 'Nhập taskname' : null,
                onSaved: (v) => _taskname = v!.trim(),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _times.toString(), // ✅ ép sang String
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Times (số lần làm bài)'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Nhập times';
                  if (int.tryParse(v) == null) return 'Phải nhập số nguyên';
                  return null;
                },
                onSaved: (v) => _times = int.parse(v!.trim()), // ✅ parse lại int
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _save,
                icon: Icon(isEdit ? Icons.save : Icons.add),
                label: Text(isEdit ? 'Cập nhật' : 'Thêm mới'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
