import 'package:flutter/material.dart';
import '../../domain/usecases/create_course.dart';
import '../../domain/usecases/update_course.dart';
import '../../domain/entities/course.dart';

class CourseFormPage extends StatefulWidget {
  final Course? course;
  final CreateCourse createUsecase;
  final UpdateCourse updateUsecase;

  const CourseFormPage({
    super.key,
    this.course,
    required this.createUsecase,
    required this.updateUsecase,
  });
  @override
  State<CourseFormPage> createState() {
    return _CourseFormPageState();
  }
}
class _CourseFormPageState extends State<CourseFormPage>{
  final _formkey = GlobalKey<FormState>();

  late String _courseTitle;
  late String _title;
  late String _description;
  late String _duration;
  late String _videoUrl;
  late String _thumbnail;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _courseTitle = widget.course?.courseTitle ?? '';
    _title = widget.course?.title ?? '';
    _description = widget.course?.description ?? '';
    _duration = widget.course?.duration ?? '';
    _videoUrl = widget.course?.videoUrl ?? '';
    _thumbnail= widget.course?.thumbnail ?? '';
  }
  Future<void> _save() async {
    if(!_formkey.currentState!.validate()) return;//doan nay kiem tra validate cua form
    _formkey.currentState!.save();

    final newCourse = Course(
      id: widget.course?.id ?? '', 
      courseTitle: _courseTitle, 
      title: _title, 
      description: _description, 
      duration: _duration, 
      videoUrl: _videoUrl,
      thumbnail: _thumbnail,
      );
      if(widget.course == null){
        await widget.createUsecase(newCourse);
      }
      else{
        await widget.updateUsecase(newCourse);
      }
      if(mounted) Navigator.pop(context, true);
      print('da an button nay');
  }
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.course != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Course' : 'Add Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formkey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _courseTitle,
                decoration: const InputDecoration(labelText: 'Course Title'),
                validator: (v) => v!.isEmpty ? 'Enter course title' : null,
                onSaved: (v) => _courseTitle = v!.trim(),
              ),
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v!.isEmpty ? 'Enter title' : null,
                onSaved: (v) => _title = v!.trim(),
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Desciption'),
                validator: (v) => v!.isEmpty ? 'Enter description' : null,
                onSaved: (v) => _description = v!.trim(),
              ),
              TextFormField(
                initialValue: _duration,
                decoration: const InputDecoration(labelText: 'Duration'),
                validator: (v) => v!.isEmpty ? 'Enter duration' : null,
                onSaved: (v) => _duration = v!.trim(),
              ),
              TextFormField(
                initialValue: _videoUrl,
                decoration: const InputDecoration(labelText: 'video Url'),
                validator: (v) => v!.isEmpty ? 'Enter video url' : null,
                onSaved: (v) => _videoUrl = v!.trim(),
              ),
              TextFormField(
                initialValue: _thumbnail,
                decoration: const InputDecoration(labelText: 'thumbnail'),
                validator: (v) => v!.isEmpty ? 'Enter thumbnail' : null,
                onSaved: (v) => _thumbnail = v!.trim(),
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