import 'dart:io';
import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as image_lib;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class PlantDiseaseDetectionPage extends StatefulWidget {
  @override
  _PlantDiseaseDetectionPageState createState() =>
      _PlantDiseaseDetectionPageState();
}

class _PlantDiseaseDetectionPageState extends State<PlantDiseaseDetectionPage> {
  File? _imageFile;
  String? _diseaseName;

  ImageClassificationHelper? imageClassificationHelper;
  final imagePicker = ImagePicker();
  String? imagePath;
  late img.Image image;
  Map<String, double>? classification;

  @override
  void initState() {
    imageClassificationHelper = ImageClassificationHelper();
    imageClassificationHelper!.initHelper();
    super.initState();
  }

  Future<void> _pickImageGallery(ImageSource source) async {
    cleanResult();
    final result = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    imagePath = result?.path;
    processImage();
  }

  Future<void> _pickImageCam(ImageSource source) async {
    cleanResult();
    final result = await imagePicker.pickImage(
      source: ImageSource.camera,
    );

    imagePath = result?.path;
    setState(() {});
    processImage();
  }

  void cleanResult() {
    imagePath = null;
    classification = null;
    setState(() {});
  }

  // Process picked image
  Future<void> processImage() async {
    if (imagePath != null) {
      // Read image bytes from file
      final imageData = File(imagePath!).readAsBytesSync();

      img.Image? res = img.decodeImage(imageData);
      image = res!;
      setState(() {});
      classification = await imageClassificationHelper?.inferenceImage(image);
      print(classification);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    String highestProbDisease = '';
    double highestProb = 0.0;
    if (classification != null) {
      classification!.forEach((key, value) {
        if (value > highestProb) {
          highestProb = value;
          highestProbDisease = key;
        }
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Disease Detection'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.all(8.0),
              width: double.infinity,
              child: imagePath != null
                  ? Image.file(File(imagePath!), fit: BoxFit.cover)
                  : Icon(Icons.image, size: 100.0, color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: classification != null
                  ? SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(
                        'Disease Detected: $highestProbDisease \nConfidence: ${(highestProb * 100).toStringAsFixed(2)}%',
                        style: TextStyle(fontSize: 24.0),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Text(
                      'No Disease Detected',
                      style: TextStyle(fontSize: 24.0),
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: "fab1",
                  onPressed: () => _pickImageGallery(ImageSource.gallery),
                  tooltip: 'Pick Image from gallery',
                  child: Icon(Icons.photo_library),
                ),
                FloatingActionButton(
                  heroTag: "fab2",
                  onPressed: () => _pickImageCam(ImageSource.camera),
                  tooltip: 'Take a Photo',
                  child: Icon(Icons.camera_alt),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImageClassificationHelper {
  static const modelPath = './assets/models/model.tflite';
  static const labelsPath = './assets/models/label.txt';

  late final Interpreter interpreter;
  late final List<String> labels;
  late final IsolateInference isolateInference;
  late Tensor inputTensor;
  late Tensor outputTensor;

  // Load model
  Future<void> _loadModel() async {
    final directory = await getApplicationDocumentsDirectory();

// final dir = directory.path;
//   String pdfDirectory = '$dir/';
//   final myDir = new Directory(pdfDirectory);
//     List<FileSystemEntity> _folders = myDir.listSync(recursive: true, followLinks: false);
//   print(_folders,);

    final options = InterpreterOptions();

    // Use XNNPACK Delegate
    if (Platform.isAndroid) {
      options.addDelegate(XNNPackDelegate());
    }

    // Use GPU Delegate
    // doesn't work on emulator
    // if (Platform.isAndroid) {
    //   options.addDelegate(GpuDelegateV2());
    // }

    // Use Metal Delegate
    if (Platform.isIOS) {
      options.addDelegate(GpuDelegate());
    }

    // Load model from assets
    interpreter = await Interpreter.fromAsset(modelPath, options: options);
    // Get tensor input shape [1, 224, 224, 3]
    inputTensor = interpreter.getInputTensors().first;
    // Get tensor output shape [1, 1001]
    outputTensor = interpreter.getOutputTensors().first;
  }

  // Load labels from assets
  Future<void> _loadLabels() async {
    final labelTxt = await rootBundle.loadString(labelsPath);
    labels = labelTxt.split('\n');
  }

  Future<void> initHelper() async {
    _loadLabels();
    _loadModel();
    isolateInference = IsolateInference();
    await isolateInference.start();
  }

  Future<Map<String, double>> _inference(InferenceModel inferenceModel) async {
    ReceivePort responsePort = ReceivePort();
    isolateInference.sendPort
        .send(inferenceModel..responsePort = responsePort.sendPort);
    // get inference result.
    var results = await responsePort.first;
    print(results);
    return results;
  }

  // inference camera frame
  Future<Map<String, double>> inferenceCameraFrame(
      CameraImage cameraImage) async {
    var isolateModel = InferenceModel(cameraImage, null, interpreter.address,
        labels, inputTensor.shape, outputTensor.shape);
    return _inference(isolateModel);
  }

  // inference still image
  Future<Map<String, double>> inferenceImage(img.Image image) async {
    var isolateModel = InferenceModel(null, image, interpreter.address, labels,
        inputTensor.shape, outputTensor.shape);
    return _inference(isolateModel);
  }

  Future<void> close() async {
    isolateInference.close();
  }
}

class InferenceModel {
  CameraImage? cameraImage;
  image_lib.Image? image;
  int interpreterAddress;
  List<String> labels;
  List<int> inputShape;
  List<int> outputShape;
  late SendPort responsePort;

  InferenceModel(this.cameraImage, this.image, this.interpreterAddress,
      this.labels, this.inputShape, this.outputShape);

  // check if it is camera frame or still image
  bool isCameraFrame() {
    return cameraImage != null;
  }
}

class IsolateInference {
  static const String _debugName = "TFLITE_INFERENCE";
  final ReceivePort _receivePort = ReceivePort();
  late Isolate _isolate;
  late SendPort _sendPort;

  SendPort get sendPort => _sendPort;

  Future<void> start() async {
    _isolate = await Isolate.spawn<SendPort>(entryPoint, _receivePort.sendPort,
        debugName: _debugName);
    _sendPort = await _receivePort.first;
  }

  Future<void> close() async {
    _isolate.kill();
    _receivePort.close();
  }

  static void entryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (final InferenceModel isolateModel in port) {
      image_lib.Image? img;
      if (isolateModel.isCameraFrame()) {
        img = ImageUtils.convertCameraImage(isolateModel.cameraImage!);
      } else {
        img = isolateModel.image;
      }

      // resize original image to match model shape.
      image_lib.Image imageInput = image_lib.copyResize(
        img!,
        width: isolateModel.inputShape[1],
        height: isolateModel.inputShape[2],
      );

      if (Platform.isAndroid && isolateModel.isCameraFrame()) {
        imageInput = image_lib.copyRotate(imageInput, angle: 90);
      }

      final imageMatrix = List.generate(
        imageInput.height,
        (y) => List.generate(
          imageInput.width,
          (x) {
            final pixel = imageInput.getPixel(x, y);
            return [pixel.r, pixel.g, pixel.b];
          },
        ),
      );

      // Set tensor input [1, 224, 224, 3]
      final input = [imageMatrix];
      // Set tensor output [1, 1001]
      final output = [List<int>.filled(isolateModel.outputShape[1], 0)];
      // // Run inference
      Interpreter interpreter =
          Interpreter.fromAddress(isolateModel.interpreterAddress);
      interpreter.run(input, output);
      // Get first output tensor
      final result = output.first;
      int maxScore = result.reduce((a, b) => a + b);
      // Set classification map {label: points}
      var classification = <String, double>{};
      for (var i = 0; i < result.length; i++) {
        if (result[i] != 0) {
          // Set label: points
          classification[isolateModel.labels[i]] =
              result[i].toDouble() / maxScore.toDouble();
        }
      }
      isolateModel.responsePort.send(classification);
    }
  }
}

class ImageUtils {
  // Converts a [CameraImage] in YUV420 format to [imageLib.Image] in RGB format
  static image_lib.Image? convertCameraImage(CameraImage cameraImage) {
    if (cameraImage.format.group == ImageFormatGroup.yuv420) {
      return convertYUV420ToImage(cameraImage);
    } else if (cameraImage.format.group == ImageFormatGroup.bgra8888) {
      return convertBGRA8888ToImage(cameraImage);
    } else {
      return null;
    }
  }

  // Converts a [CameraImage] in BGRA888 format to [imageLib.Image] in RGB format
  static image_lib.Image convertBGRA8888ToImage(CameraImage cameraImage) {
    image_lib.Image img = image_lib.Image.fromBytes(
        width: cameraImage.planes[0].width!,
        height: cameraImage.planes[0].height!,
        bytes: cameraImage.planes[0].bytes.buffer,
        order: image_lib.ChannelOrder.bgra);
    return img;
  }

  static image_lib.Image convertYUV420ToImage(CameraImage cameraImage) {
    final imageWidth = cameraImage.width;
    final imageHeight = cameraImage.height;

    final yBuffer = cameraImage.planes[0].bytes;
    final uBuffer = cameraImage.planes[1].bytes;
    final vBuffer = cameraImage.planes[2].bytes;

    final int yRowStride = cameraImage.planes[0].bytesPerRow;
    final int yPixelStride = cameraImage.planes[0].bytesPerPixel!;

    final int uvRowStride = cameraImage.planes[1].bytesPerRow;
    final int uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final image = image_lib.Image(width: imageWidth, height: imageHeight);

    for (int h = 0; h < imageHeight; h++) {
      int uvh = (h / 2).floor();

      for (int w = 0; w < imageWidth; w++) {
        int uvw = (w / 2).floor();

        final yIndex = (h * yRowStride) + (w * yPixelStride);

        // Y plane should have positive values belonging to [0...255]
        final int y = yBuffer[yIndex];

        // U/V Values are subsampled i.e. each pixel in U/V chanel in a
        // YUV_420 image act as chroma value for 4 neighbouring pixels
        final int uvIndex = (uvh * uvRowStride) + (uvw * uvPixelStride);

        // U/V values ideally fall under [-0.5, 0.5] range. To fit them into
        // [0, 255] range they are scaled up and centered to 128.
        // Operation below brings U/V values to [-128, 127].
        final int u = uBuffer[uvIndex];
        final int v = vBuffer[uvIndex];

        // Compute RGB values per formula above.
        int r = (y + v * 1436 / 1024 - 179).round();
        int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
        int b = (y + u * 1814 / 1024 - 227).round();

        r = r.clamp(0, 255);
        g = g.clamp(0, 255);
        b = b.clamp(0, 255);

        image.setPixelRgb(w, h, r, g, b);
      }
    }
    return image;
  }
}
