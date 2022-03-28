import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';


class ImageCropNewViewFileData extends StatefulWidget {
  final File imagefile;
  const ImageCropNewViewFileData(this.imagefile) : super();

  @override
  _ImageCropNewViewFileDataState createState() => _ImageCropNewViewFileDataState(this.imagefile);
}

class _ImageCropNewViewFileDataState extends State<ImageCropNewViewFileData> {
  final File imagefile;
  _ImageCropNewViewFileDataState(this.imagefile) : super();

  final cropKey = GlobalKey<CropState>();

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context, 'isreload');
            },
            iconSize: 32),
      ),
      body: Container(
        height: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
        child: _buildCroppingImage(),
      ),
    );
  }

  Widget _buildCroppingImage() {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width - 40,
          height: MediaQuery.of(context).size.width - 40,
          child: Crop.file(imagefile, key: cropKey, aspectRatio: 1.0 / 1.0),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          height: 50.0,
          width: MediaQuery.of(context).size.width - 50.0,
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))
            ),
            color: Colors.black,
            height: 50.0,
            elevation: 0.0,
            onPressed: () async {
              _cropImage();
            },
            child: Text(
              'Done',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 18.0
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> _cropImage() async {
    final scale = cropKey.currentState!.scale;
    final area = cropKey.currentState!.area;
    if (area == null) {
      // cannot crop, widget is not setup
      return;
    }

    // scale up to use maximum possible number of pixels
    // this will sample image in higher resolution to make cropped image larger
    final sample = await ImageCrop.sampleImage(
      file: imagefile,
      preferredSize: (600 / scale).round(),
    );

    final file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );

    sample.delete();
    debugPrint('${file.path}');
    //progressDialog.hide();
    Navigator.pop(context, file);
  }

}