import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:star_basis/services/globals.dart';

class ImageSelectForUpdate extends StatefulWidget {
  final Function onTap;
  final String imageName;

  const ImageSelectForUpdate({Key? key, required this.onTap, required this.imageName}) : super(key: key);

  @override
  State<ImageSelectForUpdate> createState() => _ImageSelectForUpdateState();
}

class _ImageSelectForUpdateState extends State<ImageSelectForUpdate> {

  final _picker = ImagePicker();
  File? imageData;

  Future getImageFromGallery(String type) async {
    try {
      PickedFile? image = await _picker.getImage( preferredCameraDevice: CameraDevice.rear, imageQuality: 50, source: type=='camera' ? ImageSource.camera : ImageSource.gallery );
      if(image == null) return;
      final tempImage = File(image.path);
      setState(() {
        imageData = tempImage;
        widget.onTap(imageData);
      });
      Navigator.pop(context);
    } on PlatformException catch(e){
      errorSnackBar(context, 'Faield to pick an Image!');
    }

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        // getImageFromGallery();
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context, builder: (BuildContext context) {
          return Container(
            height: 200,
            padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 50),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
            ),
            child: Column(
              children:  [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Please select a action',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                          color: Colors.black
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        getImageFromGallery('camera');
                      },
                      child: Column(
                        children: const [
                          SizedBox(
                            child: Icon(
                              Icons.camera_alt_rounded,
                              size: 50,
                            ),
                          ),
                          Text('Camera')
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        getImageFromGallery('gallery');
                      },
                      child: Column(
                        children: const [
                          SizedBox(
                            child: Icon(
                              Icons.cloud_upload_rounded,
                              size: 50,
                            ),
                          ),
                          Text('Files')
                        ],
                      ),
                    ),
                  ],
                )
              ],
            )
          );
          },
        );
      },
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width/2.3,
       child: Stack(
         alignment: Alignment.center,
         children: [
          Container(
            height: 200,
            child: Column(
              children: [
                imageData != null ?
                Image.file(
                    imageData!,
                  fit: BoxFit.cover,
                  height: 200,
                )
                :
                Image.asset(
                  'assets/images/add-icon.jpg',
                  fit: BoxFit.cover,
                ),
              ],
            )
          ),
           Positioned(
               child: Container(
                   padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 15),
                   decoration: BoxDecoration(
                   color: Colors.black.withOpacity(0.4),
                   borderRadius: BorderRadius.circular(10),
                 ),
                 child: Text(
                   widget.imageName,
                   style: const TextStyle(
                       fontSize: 16,
                       fontWeight: FontWeight.w700,
                       fontFamily: 'Inter',
                       color: Colors.white
                   ),
                 ),
               ),
           ),
         ],
       ),
      ),
    );
  }
}
