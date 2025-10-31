import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../domain/entities/course.dart';

class CourseStudyPage extends StatefulWidget {
  final Course course;
  const CourseStudyPage({super.key, required this.course});

  @override
  State<CourseStudyPage> createState() => _CourseStudyPageState();
}

class _CourseStudyPageState extends State<CourseStudyPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Sử dụng videoUrl từ Firestore
    _controller = VideoPlayerController.asset(widget.course.videoUrl)
      ..initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.course;

    return Scaffold(
      appBar: AppBar(title: Text(c.courseTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ❌ Đã bỏ phần hiển thị ảnh thumbnail

            // Tiêu đề & mô tả
            Text(
              c.title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(c.description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),

            // Thời lượng
            if (c.duration.isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.access_time, size: 20),
                  const SizedBox(width: 8),
                  Text('Thời lượng: ${c.duration}'),
                ],
              ),
            const SizedBox(height: 20),

            // Video Player
            if (_controller.value.isInitialized)
              Column(
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        onPressed: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.stop),
                        onPressed: () {
                          _controller.pause();
                          _controller.seekTo(Duration.zero);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ],
              )
            else
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
