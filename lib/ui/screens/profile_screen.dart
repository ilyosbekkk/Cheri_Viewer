
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:image_picker/image_picker.dart';


class ProfileScreen extends StatefulWidget {
  static String route = "/profile_screen";

  const ProfileScreen();

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late InAppWebViewController _controller;
  File? _file;
  ImagePicker _imagePicker = ImagePicker();
  List<int> _pictureBlob = [];

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String?>;

    return Scaffold(

      body: SafeArea(
        child: InAppWebView(
                initialUrlRequest: URLRequest(url: Uri.parse("https://cheri.weeknday.com/member/profile?m=${args["encrypt_id"]}")),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    javaScriptEnabled: true,
                  ),
                  android: AndroidInAppWebViewOptions(
                    useHybridComposition: true,
                  ),
                ),
                onWebViewCreated: (InAppWebViewController controller) {
                  setState(() {
                    _controller = controller;
                  });
                  _controller.addJavaScriptHandler(handlerName: "photo_handler", callback: (args) {
                         _buildBottomSheet(context).then((value) {
                           if(_pictureBlob.isNotEmpty)
                             return _pictureBlob;
                         });
                  });

                }),
          ),
    );
  }

  Future<void> _buildBottomSheet(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (context) =>
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    onPressed: () async {
                      await getImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    child: Text("Camera"),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      await getImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    child: Text("Photo"),
                  ),
                ],
              ),
            ));
  }
  Future getImage(ImageSource imageSource) async {
    final pickedFile = await _imagePicker.getImage(source: imageSource);
    final bytes = await pickedFile?.readAsBytes();
    if (pickedFile != null) {
      setState(() {
        _file = File(pickedFile.path);
        _pictureBlob.addAll(bytes!);
      });
    } else {
      print("No image selected");
    }
  }
}
