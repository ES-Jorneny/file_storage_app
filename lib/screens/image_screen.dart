import 'package:file_storage_app/screens/preview_image.dart';
import 'package:file_storage_app/services/db_services.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: StreamBuilder(
        stream: DbServices().getImageFiles(), // ✅ sirf image fetch karega
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
            return const Center(
              child: Text(
                "No Images Uploaded",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            );
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

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PreviewImage(url: url,name: name,)),
                  );
                },
                onLongPress: () =>
                    showDeleteDialog(context,docId, publicId, resourceType),
                child: imageCard(context:context,ext: ext, url: url, name: name),
              );
            },
          );
        },
      ),
    );
  }
}
void showDeleteDialog(BuildContext context, String docId, String publicId, String resourceType) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // ❌ No rounded corners
        ),
        title: const Text(
          "Delete File",
          style: TextStyle(color: Colors.black87),
        ),
        content: const Text(
          "Are you sure you want to delete this file?",
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No", style: TextStyle(color: Colors.black87)),
          ),
          TextButton(
            onPressed: () async {
              final bool deleteResult =
              await DbServices().deleteFiles(docId, publicId, resourceType);
              Navigator.pop(context);
              if (deleteResult) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Deleted Successfully")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Error deleting file")),
                );
              }
            },
            child: const Text("Yes", style: TextStyle(color: Colors.black87)),
          ),
        ],
      );
    },
  );
}
