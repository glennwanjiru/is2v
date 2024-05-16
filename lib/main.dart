import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class ImageToVideoConverter extends StatefulWidget {
  @override
  _ImageToVideoConverterState createState() => _ImageToVideoConverterState();
}

class _ImageToVideoConverterState extends State<ImageToVideoConverter> {
  final ImagePicker _picker = ImagePicker();
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

  List<XFile> _selectedImages = [];
  int _selectedFrameRate = 24; // Default frame rate

  Future<void> _pickImages() async {
    List<XFile> images = await _picker.pickMultiImage();
    setState(() {
      _selectedImages = images;
    });
  }

  Future<void> _convertToVideo() async {
    if (_selectedImages.isEmpty) return;

    String outputPath = '/path/to/output/video.mp4';

    String inputImages = _selectedImages.map((img) => img.path).join('|');
    String command =
        '-framerate $_selectedFrameRate -i $inputImages -s 1280x720 $outputPath';

    int rc = await _flutterFFmpeg.execute(command);
    if (rc == 0) {
      print('Video conversion successful');
      // Optionally, you can play or share the video here
    } else {
      print('Video conversion failed');
    }
  }

  void _showFrameRatePicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Frame Rate'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text('24 fps'),
                  onTap: () {
                    setState(() {
                      _selectedFrameRate = 24;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('30 fps'),
                  onTap: () {
                    setState(() {
                      _selectedFrameRate = 30;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('60 fps'),
                  onTap: () {
                    setState(() {
                      _selectedFrameRate = 60;
                    });
                    Navigator.pop(context);
                  },
                ),
                // Add more options as needed
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image to Video Converter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickImages,
              child: Text('Select Images'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showFrameRatePicker,
              child: Text('Choose Frame Rate: $_selectedFrameRate fps'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertToVideo,
              child: Text('Convert to Video'),
            ),
          ],
        ),
      ),
    );
  }
}
