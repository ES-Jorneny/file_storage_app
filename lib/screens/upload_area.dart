import 'package:file_picker/file_picker.dart';
import 'package:file_storage_app/services/cloudinary_services.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class UploadArea extends StatefulWidget {
  const UploadArea({super.key});

  @override
  State<UploadArea> createState() => _UploadAreaState();
}

class _UploadAreaState extends State<UploadArea> {
  double _progress = 0.0;
  bool _isUploading = false;
  int totalBytesUploaded = 0;

  @override
  Widget build(BuildContext context) {
    final selectedFile =
    ModalRoute.of(context)!.settings.arguments as FilePickerResult;

    return Scaffold(

      appBar: AppBar(
        title: const Text("Uploaded File",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black87,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(

              initialValue: selectedFile.files.first.name,
              decoration: const InputDecoration(labelText: "Name",labelStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black87
                ),

              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black87
                )
              )),

            ),
            TextFormField(

              initialValue: selectedFile.files.first.extension,
              decoration: const InputDecoration(
                  labelText:"Extension",
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black87
                    ),

                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black87
                      )
                  )
              ),
            ),
            TextFormField(

              initialValue: "${selectedFile.files.first.size} bytes",
              decoration: const InputDecoration(
                  labelText: "Size",
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black87
                    ),

                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black87
                      )
                  )
              ),
            ),
            const SizedBox(height: 30),

            // Show progress bar if uploading
            if (_isUploading)
              Column(
                children: [
                  Text("Uploading: ${(_progress * 100).toStringAsFixed(1)}%"),
                  const SizedBox(height: 10),
                  LinearPercentIndicator(
                    lineHeight: 14.0,
                    percent: _progress,
                    backgroundColor: Colors.grey.shade300,
                    progressColor: Colors.black87,
                  ),
                  const SizedBox(height: 20),
                ],
              ),

            // Upload button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // 👈 your desired radius
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        _isUploading = true;
                        _progress = 0.0;
                      });

                      bool? result = await uploadToCloudinaryWithProgress(
                        selectedFile,
                        context,
                            (double progress) {
                          setState(() {
                            _progress = progress;
                          });
                        },
                      );

                      setState(() {
                        _isUploading = false;
                      });

                      if (result == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("File Uploaded Successfully.")),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                              Text("File Upload Failed. Please Try Again.")),
                        );
                      }
                    },
                    child: const Text(
                      "Upload",
                      style: TextStyle(color: Colors.white),

                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }}