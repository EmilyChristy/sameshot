import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'previewscreen/preview_screen.dart';
import 'package:intl/intl.dart';

//import 'package:photo_manager/photo_manager.dart';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatefulWidget {
  CameraPage({this.color, this.title, this.materialIndex: 500});
  final MaterialColor color;
  final String title;
  final int materialIndex;

  String overlayUrl =
      'https://images.dog.ceo/breeds/havanese/00100trPORTRAIT_00100_BURST20191103202017556_COVER.jpg';

  @override
  CameraPageState createState() {
    return CameraPageState();
  }
}

class CameraPageState extends State<CameraPage> {
  Image _pickedImage;
  final _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  String _retrieveDataError;
  double _opacity = 0;
  final double _opacityDefault = 0.5;
  bool isVideo = false;
  PickedFile _imageFile;
  File _image;
  dynamic _pickImageError;
  Directory _imagesFolder;

  List<CameraDescription> _cameras;
  CameraController _controller;
  int _selected = 0;

//Loading counter value on start
  void _loadPrefs() async {
    final _prefs = await SharedPreferences.getInstance();
    //set opacity to the saved value, or use the default if no user
    //preference has been saved
    setState(() {
      _opacity = (_prefs.getDouble('opacity') ?? _opacityDefault);
    });

    //print("Got opacity level : $_opacity");
  }

  // Future getImage() async {
  //   print("Click to get image...");
  //   final pickedFile = await _picker.getImage(source: ImageSource.camera);
  //   bool kIsWeb = true;

  //   if (kIsWeb) {
  //     //for web platform
  //     setState(() {
  //       _pickedImage = Image.network(pickedFile.path);
  //     });
  //   } else {
  //     //for device platforms
  //     setState(() {
  //       _pickedImage = Image.file(File(pickedFile.path));
  //     });
  //   }
  // }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    await _displayPickImageDialog(context,
        (double maxWidth, double maxHeight, int quality) async {
      try {
        final pickedFile = await _picker.getImage(
          source: source,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: quality,
        );
        setState(() {
          _imageFile = pickedFile;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    print("Camera INITSTATE");
    _loadPrefs();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //print("did change dependencies");
  }

  @override
  void didUpdateWidget(covariant CameraPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    _loadPrefs();
    // id changed in the widget, I need to make a new API call
    //if(oldWidget != widget.id) update();
  }

  @override
  Widget build(BuildContext context) {
    print("Widget build....");
    //_loadPrefs();
    return Scaffold(
      body: Container(
        color: widget.color[widget.materialIndex],
        child: Center(child: Text('No image selected.')),
        decoration: BoxDecoration(
          color: const Color(0xff7c94b6),
          image: new DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(_opacity), BlendMode.dstATop),
            repeat: ImageRepeat.repeatY,
            image: getOverlayImage(),
          ),
        ),
      ),
      //
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 14.0, 0.0, 8.0),
            child: Container(
                child: _imageFile != null
                    ? Image.asset(
                        _imageFile.path,
                        height: 20.0,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'images/sameshotlogo.png',
                        height: 20.0,
                        fit: BoxFit.cover,
                      )),
          ),
          Semantics(
            label: 'image_picker_example_from_gallery',
            child: FloatingActionButton(
              onPressed: () {
                isVideo = false;
                _onImageButtonPressed(ImageSource.gallery, context: context);
              },
              heroTag: 'image0',
              tooltip: 'Pick Image from gallery',
              child: const Icon(Icons.photo_library),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                // isVideo = false;
                // _onImageButtonPressed(ImageSource.camera, context: context);
              },
              heroTag: 'image1',
              tooltip: 'Take a Photo',
              child: const Icon(Icons.camera_alt),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 14.0, 0.0, 8.0),
            child: Container(
                child: Image.asset(
              'images/sameshotlogo.png',
              height: 20.0,
              fit: BoxFit.cover,
            )),
          ),
        ],
      ),
    );
  }

  ImageProvider getOverlayImage() {
    if (_pickedImage == null) {
      //load local asset
      return new AssetImage(
        'images/funnydog1.jpg',
      );
      // } else {
      //   //return picked image
      //   return _pickedImage;
      // }
    }
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add optional parameters'),
            content: Column(
              children: <Widget>[
                TextField(
                  controller: maxWidthController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration:
                      InputDecoration(hintText: "Enter maxWidth if desired"),
                ),
                TextField(
                  controller: maxHeightController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration:
                      InputDecoration(hintText: "Enter maxHeight if desired"),
                ),
                TextField(
                  controller: qualityController,
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(hintText: "Enter quality if desired"),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text('PICK'),
                  onPressed: () {
                    double width = maxWidthController.text.isNotEmpty
                        ? double.parse(maxWidthController.text)
                        : null;
                    double height = maxHeightController.text.isNotEmpty
                        ? double.parse(maxHeightController.text)
                        : null;
                    int quality = qualityController.text.isNotEmpty
                        ? int.parse(qualityController.text)
                        : null;
                    onPick(width, height, quality);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  //camera package
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

  //camera package
  selectCamera() async {
    var controller =
        CameraController(_cameras[_selected], ResolutionPreset.low);
    await controller.initialize();
    return controller;
  }

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        //_image = File(pickedFile.path);
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

typedef void OnPickImageCallback(
    double maxWidth, double maxHeight, int quality);

// class _CameraScreenState extends State with WidgetsBindingObserver {
//   List<CameraDescription> _cameras;
//   CameraController _controller;
//   int _selected = 0;
//   Directory _imagesFolder;

//   List images;
//   File _image;
//   final picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     setupCamera();
//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) async {
//     if (_controller == null || !_controller.value.isInitialized) {
//       return;
//     }

//     if (state == AppLifecycleState.inactive) {
//       _controller?.dispose();
//     } else if (state == AppLifecycleState.resumed) {
//       setupCamera();
//     }
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _controller?.dispose();
//     super.dispose();
//   }

//   Future<void> setupCamera() async {
//     await [
//       Permission.camera,
//     ].request();
//     _cameras = await availableCameras();

//     //check for available cameras
//     if (_cameras.length > 0) {
//       var controller = await selectCamera();
//       setState(() => _controller = controller);

//       // setState(() {
//       //   selectedCameraIdx = 0;
//       // });

//       //_initCameraController(cameras[selectedCameraIdx]).then((void v) {});
//     } else {
//       print("No camera available");
//     }

//     // var controller = await selectCamera();
//     // setState(() => _controller = controller);
//   }

//   selectCamera() async {
//     var controller =
//         CameraController(_cameras[_selected], ResolutionPreset.low);
//     await controller.initialize();
//     return controller;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Click To Share'),
//         backgroundColor: Colors.blueGrey,
//       ),
//       body: Container(
//         child: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               Expanded(
//                 flex: 1,
//                 child: _cameraPreviewWidget(),
//               ),
//               SizedBox(height: 10.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   // _cameraTogglesRowWidget(),
//                   _captureControlRowWidget(context),
//                   Spacer()
//                 ],
//               ),
//               SizedBox(height: 20.0)
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future getImage() async {
//     final pickedFile = await picker.getImage(source: ImageSource.camera);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   /// Display Camera preview.
//   Widget _cameraPreviewWidget() {
//     if (_controller == null || !_controller.value.isInitialized) {
//       return const Text(
//         'Loading',
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 20.0,
//           fontWeight: FontWeight.w900,
//         ),
//       );
//     }

//     return AspectRatio(
//       aspectRatio: _controller.value.aspectRatio,
//       child: CameraPreview(_controller),
//     );
//   }

//   /// Display the control bar with buttons to take pictures
//   Widget _captureControlRowWidget(context) {
//     return Expanded(
//       child: Align(
//         alignment: Alignment.center,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             FloatingActionButton(
//                 child: Icon(_getCameraLensIcon(
//                     CameraLensDirection.front)), //Icon(Icons.camera),
//                 backgroundColor: Colors.lightBlue,
//                 onPressed: () {
//                   _onCapturePressed(context);
//                 })
//           ],
//         ),
//       ),
//     );
//   }

//   IconData _getCameraLensIcon(CameraLensDirection direction) {
//     switch (direction) {
//       case CameraLensDirection.back:
//         return Icons.camera_rear;
//       case CameraLensDirection.front:
//         return Icons.camera_front;
//       case CameraLensDirection.external:
//         return Icons.camera;
//       default:
//         return Icons.device_unknown;
//     }
//   }

//   // void _onSwitchCamera() {
//   //   selectedCameraIdx =
//   //       selectedCameraIdx < cameras.length - 1 ? selectedCameraIdx + 1 : 0;
//   //   CameraDescription selectedCamera = cameras[selectedCameraIdx];
//   //   _initCameraController(selectedCamera);
//   // }

//   void _onCapturePressed(context) async {
//     // Take the Picture in a try / catch block. If anything goes wrong,
//     // catch the error.
//     try {
//       // Attempt to take a picture and log where it's been saved
//       // final path = join(
//       //   // In this example, store the picture in the temp directory. Find
//       //   // the temp directory using the `path_provider` plugin.
//       //   (await getTemporaryDirectory()).path,
//       //   '${DateTime.now()}.png',
//       // );

//       final DateFormat formatter = DateFormat('yyyyMMddHHmmss');
//       String fileName = 'image_${formatter.format(DateTime.now())}';

//       final Directory directory = await getApplicationDocumentsDirectory();
//       _imagesFolder = Directory(join('${directory.path}', 'gallery'));
//       if (!_imagesFolder.existsSync()) {
//         _imagesFolder.createSync();
//       }

//       final String path = '${_imagesFolder.path}/$fileName.png';

//       print(path);
//       await _controller.takePicture(path);

//       // If the picture was taken, display it on a new screen
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => PreviewImageScreen(imagePath: path),
//         ),
//       );
//     } catch (e) {
//       // If an error occurs, log the error to the console.
//       print(e);
//     }
//   }

//   void _showCameraException(CameraException e) {
//     String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
//     print(errorText);

//     print('Error: ${e.code}\n${e.description}');
//   }
// }
