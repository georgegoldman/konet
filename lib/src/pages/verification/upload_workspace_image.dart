import 'dart:io';

import 'package:curnect/src/services/user.dart';
import 'package:curnect/src/pages/verification/add_service.dart';
import 'package:curnect/src/routes/route_animation.dart';
import 'package:curnect/src/style/animation/loading_gif.dart';
import 'package:curnect/src/widgets/emptyLoader.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:curnect/src/state_manager/add_service_manipulator.dart';

import '../../widgets/appbar.dart';
import '../../widgets/unauthenticatedPageHeader.dart';

class UploadWorkspaceImage extends StatefulWidget {
  const UploadWorkspaceImage({super.key});

  @override
  State<UploadWorkspaceImage> createState() => _UploadWorkspaceImageState();
}

class _UploadWorkspaceImageState extends State<UploadWorkspaceImage> {
  XFile? _pickedFile;
  CroppedFile? _croppedFile;
  Future<bool>? _uploadImageFuture;
  bool showError = false;
  bool successful = true;

  Future<bool> uploadImageRequest() async {
    String userId = Provider.of<AddServiceManipulator>(context, listen: false)
        .user['user_id']
        .toString();
    Map<String, String> data = {"_method": "patch", "id": userId};
    User user = User(email: '', password: '');
    if (_croppedFile != null) {
      var response = await user.uploadImage(_croppedFile!.path, data,
          'https://curnect.com/curnect-api/public/api/registerbusinessimage');
      return response;
    } else {
      var response = await user.uploadImage(_pickedFile!.path, data,
          'https://curnect.com/curnect-api/public/api/registerbusinessimage');
      return response;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: UnauthenticatedAppBar(
                context: context,
                screeenInfo:
                    "This is something that trips people up sometimes if for some reason they need to send us new or edited files for a job. The Queensberry team doesn't have access to your Workspace account, so we can't work directly with your Workspace image collections. Instead, when you send us an order the hi res files are automatically downloaded to our local server. For the same reason, if you need to send us new or edited files, simply adding more images to your Workspace Event doesn't give us access to them. This is how to send us the new files. 1. Upload the new images to the original Workspace Event (not a new Event!) 2. Create a new Collection for those additional files. Name the Collection something like \"New files\". 3. Go to Albums in the top navigation, ie https://workspace.queensberry.com/albumview/albums. You'll see a list of albums that have been, or are being, designed or made for you by Queensberry. Under each album there is an option to add images (if you're not sure which icon, mouse over them). 4. Click the icon to upload your new images to your Workspace Event. A pop up window will open and ask you to select a collection to upload. Select your \"New Files\" collection. You will be asked to give a reason for your upload. This just helps us to understand why we are receiving new files, or what to do with them. 5. Click Upload. Cheers, Pete")
            .preferredSize(),
        body: SafeArea(
            child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.20,
              width: MediaQuery.of(context).size.width * 0.1,
              child: const UnauthenticatedPageheader(
                subTitle: 'Where can your clients find you?',
                title: 'Upload your\nworskpace Image',
              ),
            ),
            _body(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
              child: showError
                  ? const Text(
                      "there error occured while uploading",
                      style: TextStyle(color: Colors.redAccent),
                    )
                  : const Text(''),
            ),
          ],
        )),
        persistentFooterButtons: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // <-- Radius
              ),
              backgroundColor: Colors.black,
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: _pickedFile == null
                ? null
                : () async {
                    setState(() {
                      _uploadImageFuture = uploadImageRequest();
                    });
                    _uploadImageFuture!.then((value) {
                      setState(() {
                        successful = value;
                      });
                    }).whenComplete(() {
                      if (successful) {
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).push(
                            RouteAnimation(Screen: AddService()).createRoute());
                      } else {}
                    });
                  },
            child: const Text(
              'Continue',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.white),
            ),
          )
        ],
      ),
      FutureBuilder(
          future: _uploadImageFuture,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                // ignore: todo
                // TODO: Handle this case.
                return const EmptyLoader();
              case ConnectionState.waiting:
                // ignore: todo
                // TODO: Handle this case.
                return const LoadingPageGif();
              case ConnectionState.active:
                // ignore: todo
                // TODO: Handle this case.
                return const Text('Loading');
              case ConnectionState.done:
                // ignore: todo
                // TODO: Handle this case.
                return const EmptyLoader();
            }
          })
    ]);
  }

  Widget _body() {
    if (_croppedFile != null || _pickedFile != null) {
      return _imageCard();
    } else {
      return _uploadCard();
    }
  }

  Widget _imageCard() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _image(),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          _menu(),
        ],
      ),
    );
  }

  Widget _image() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    if (_croppedFile != null) {
      final path = _croppedFile!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: Image.file(File(path)),
      );
    } else if (_pickedFile != null) {
      final path = _pickedFile!.path;

      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: Image.file(File(path)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _menu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: "delete",
              onPressed: () {
                _clear();
              },
              backgroundColor: Colors.black,
              tooltip: 'Delete',
              child: const Icon(Icons.delete),
            ),
            if (_croppedFile == null)
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: FloatingActionButton(
                  heroTag: "crop",
                  onPressed: () {
                    _cropImage();
                  },
                  backgroundColor: Colors.black,
                  tooltip: 'Crop',
                  child: const Icon(Icons.crop),
                ),
              ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.017,
        ),
      ],
    );
  }

  Widget _uploadCard() {
    return InkWell(
      onTap: () => _uploadImage(),
      child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.06),
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width * 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Icon(
                Icons.image,
                size: 100,
              ),
              Text(
                "Click here to upload workspace photo",
                textAlign: TextAlign.center,
              )
            ],
          )),
    );
  }

  Future<void> _cropImage() async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
        });
      }
    }
  }

  Future<void> _uploadImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    }
  }

  void _clear() {
    setState(() {
      _pickedFile = null;
      _croppedFile = null;
    });
  }
}
