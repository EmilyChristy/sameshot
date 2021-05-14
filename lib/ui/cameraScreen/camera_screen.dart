import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../previewscreen/preview_screen.dart';
import 'package:intl/intl.dart';

//import 'package:photo_manager/photo_manager.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() {
    return _CameraScreenState();
  }
}

class _CameraScreenState extends State with WidgetsBindingObserver {
  List<CameraDescription> _cameras;
  CameraController _controller;
  int _selected = 0;
  Directory _imagesFolder;

   List images;
  File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    setupCamera();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (_controller == null || !_controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      setupCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  Future<void> setupCamera() async {
    await [
      Permission.camera,
    ].request();
    _cameras = await availableCameras();

    //check for available cameras
    if (_cameras.length > 0) {
      var controller = await selectCamera();
      setState(() => _controller = controller);

      // setState(() {
      //   selectedCameraIdx = 0;
      // });

      //_initCameraController(cameras[selectedCameraIdx]).then((void v) {});
    } else {
      print("No camera available");
    }

    // var controller = await selectCamera();
    // setState(() => _controller = controller);
  }

  selectCamera() async {
    var controller =
        CameraController(_cameras[_selected], ResolutionPreset.low);
    await controller.initialize();
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Click To Share'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: _cameraPreviewWidget(),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // _cameraTogglesRowWidget(),
                  _captureControlRowWidget(context),
                  Spacer()
                ],
              ),
              SizedBox(height: 20.0)
            ],
          ),
        ),
      ),
              floatingActionButton: FloatingActionButton(
          onPressed: getImage,
          tooltip: 'Pick Image',
          child: Icon(Icons.add_a_photo),
        ));

    );
  }

Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  /// Display Camera preview.
  Widget _cameraPreviewWidget() {
    if (_controller == null || !_controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: CameraPreview(_controller),
    );
  }

  /// Display the control bar with buttons to take pictures
  Widget _captureControlRowWidget(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            FloatingActionButton(
                child: Icon(_getCameraLensIcon(
                    CameraLensDirection.front)), //Icon(Icons.camera),
                backgroundColor: Colors.lightBlue,
                onPressed: () {
                  _onCapturePressed(context);
                })
          ],
        ),
      ),
    );
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }

  // void _onSwitchCamera() {
  //   selectedCameraIdx =
  //       selectedCameraIdx < cameras.length - 1 ? selectedCameraIdx + 1 : 0;
  //   CameraDescription selectedCamera = cameras[selectedCameraIdx];
  //   _initCameraController(selectedCamera);
  // }

  void _onCapturePressed(context) async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Attempt to take a picture and log where it's been saved
      // final path = join(
      //   // In this example, store the picture in the temp directory. Find
      //   // the temp directory using the `path_provider` plugin.
      //   (await getTemporaryDirectory()).path,
      //   '${DateTime.now()}.png',
      // );

      final DateFormat formatter = DateFormat('yyyyMMddHHmmss');
      String fileName = 'image_${formatter.format(DateTime.now())}';

      final Directory directory = await getApplicationDocumentsDirectory();
      _imagesFolder = Directory(join('${directory.path}', 'gallery'));
      if (!_imagesFolder.existsSync()) {
        _imagesFolder.createSync();
      }

      final String path = '${_imagesFolder.path}/$fileName.png';

      print(path);
      await _controller.takePicture(path);

      // If the picture was taken, display it on a new screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewImageScreen(imagePath: path),
        ),
      );
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
    print(errorText);

    print('Error: ${e.code}\n${e.description}');
  }
}
