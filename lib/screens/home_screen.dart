import 'package:file_picker/file_picker.dart';
import 'package:file_storage_app/screens/preview_image.dart';
import 'package:file_storage_app/screens/preview_pdf.dart';
import 'package:file_storage_app/screens/preview_video.dart';
import 'package:file_storage_app/services/cloudinary_services.dart';

import 'package:file_storage_app/services/db_services.dart';
import 'package:flutter/material.dart';

import 'image_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FilePickerResult? result;
  bool _isPickingFile = false;

  void _openFilePicker() async {
    if (_isPickingFile) return;
    _isPickingFile = true;
    try {
      FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        allowedExtensions: ["jpg", "jpeg", "png", "mp4", "pdf"],
        type: FileType.custom,
      );

      if (filePickerResult != null) {
        setState(() {
          result = filePickerResult;
        });
        Navigator.pushNamed(context, "/upload", arguments: result);
      }
    } catch (e) {
      print("File Picker Error: $e");
    } finally {
      _isPickingFile = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.black54,
      body: StreamBuilder(
        stream: DbServices().readUploadedFiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Files Uploaded",style: TextStyle(color: Colors.white,fontSize: 14),));
          }

          List userUploadedFiles = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),

            itemCount: userUploadedFiles.length,
            itemBuilder: (context, index) {
              var data = userUploadedFiles[index].data() as Map<String, dynamic>;
              String name = data["name"] ?? "";
              String ext = data["extension"]?.toLowerCase() ?? "";
              String publicId = data["public_id"] ?? "";
              String url = data["secure_url"] ?? "";
              String resourceType = data["resource_type"] ?? "";
              String docId = userUploadedFiles[index].id;

              // Decide preview screen
              Widget? targetScreen;
              if (["jpg", "jpeg", "png"].contains(ext)) {
                targetScreen = PreviewImage(url: url,name: name,);
              } else if (ext == "mp4") {
                targetScreen = PreviewVideo(videoUrl: url,name: name,);
              } else if (ext == "pdf") {
                targetScreen = PreviewPdf(fileName: name, url: url);
              }

              return GestureDetector(
                onTap: () {
                  if (targetScreen != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => targetScreen!),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Unsupported file format")),
                    );
                  }
                },
                onLongPress: () => showDeleteDialog(context,docId, publicId, resourceType),
                child: imageCard(context:context,ext: ext, url: url, name: name),
              );
            },
          );

        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openFilePicker,
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.black87,
      ),
    );
  }
}
Widget imageCard({
  required String ext,
  required String url,
  required String name,
  required BuildContext context
}) {
  return Card(
    color: Colors.grey.shade700, // Softer black instead of pure black
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    elevation: 1,
    child: SizedBox(
      height: 150,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ["jpg", "jpeg", "png"].contains(ext)
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  width: double.infinity,

                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, color: Colors.white),
                ),
              )
                  : ext == "pdf"
                  ? const Icon(Icons.picture_as_pdf, size: 48, color: Colors.white)
                  : const Icon(Icons.movie, size: 48, color: Colors.white),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(
                  ["jpg", "jpeg", "png"].contains(ext)
                      ? Icons.image
                      : ext == "pdf"
                      ? Icons.picture_as_pdf
                      : Icons.movie,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 6), // spacing between icon and text
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 3,),
                IconButton(onPressed: () async{
                  final download_result=await downloadFileFromCloudinary(url, name);
                  if(download_result){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Download Successfully")));
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Download Failed")));
                  }
                }, icon: Icon(Icons.download,color: Colors.white, size: 20,))
              ],
            ),

          ],
        ),
      ),
    ),
  );
}
