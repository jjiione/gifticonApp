import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class image_data with ChangeNotifier{
  File? image;
  final picker = ImagePicker();
  //CroppedFile? cropped_image;
  File? cropped_image;
  XFile? original_image;

  String? ml_result;
  String? read_date;
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.korean);

  getImage(ImageSource imageSource) async {
    //final image = await picker.pickImage(source: imageSource);
    original_image = await picker.pickImage(source: imageSource);
    image = File(original_image!.path);
    print(image);// 가져온 이미지를 _image에 저장
    notifyListeners();
  }

  textDetect() async {
    //var image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    String path = cropped_image!.path;
    await processImage(InputImage.fromFilePath(path));
    notifyListeners();
  }

  // 실제 텍스트를 인식하는 함수
  processImage(InputImage inputImage) async {
    ml_result = '';

    final recognizedText = await textRecognizer.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
    } else {
      //_text = 'Recognized text:\n\n${recognizedText.blocks[0].text}';
      //ml_result = 'Recognized text:\n\n${recognizedText.text}';
    }

    final splitted = recognizedText.text.split('\n');

    final date_regExp = RegExp(r"년");
    for (int i = 0; i < splitted.length ; i++) {
      if (date_regExp.hasMatch(splitted[i])){
        print('=================True==============');
        print(splitted[i]);
        ml_result = 'Recognized date : \n\n ${splitted[i]}';
        read_date = splitted[i];
      }
      else{
        continue;
      }
    }
    print('===');
    print(splitted);

    notifyListeners();
  }

  crop_image() async {
    if(image != null){
      print('================');
      print(image.toString());
      CroppedFile? cropped = await ImageCropper().cropImage(
          sourcePath: original_image!.path,
          // aspectRatioPresets: [
          //   CropAspectRatioPreset.square,
          //   CropAspectRatioPreset.original,
          // ],
          aspectRatio: CropAspectRatio(
              ratioX: 1, ratioY: 1
          ),
          compressQuality: 100,
          // maxWidth: 700,
          // maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          uiSettings: [
            AndroidUiSettings(
              //toolbarColor: Colors.deepOrange,
              toolbarTitle: '바코드, 유효기간을 캡처해주세요',
              //statusBarColor: Colors.deepOrange.shade900,
              backgroundColor: Colors.white,
            )
          ]
      );
      cropped_image = File(cropped!.path);
      //image = File(cropped_image!.path);

    }
    notifyListeners();
  }

}