import 'package:file_storage_app/screens/preview_video.dart';
import 'package:flutter/material.dart';

import '../services/db_services.dart';
import 'home_screen.dart';
import 'image_screen.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: StreamBuilder(
        stream: DbServices().getVideoFiles(), // ✅ sirf image fetch karega
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
                "No Videos Uploaded",
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
                    MaterialPageRoute(builder: (_) => PreviewVideo(videoUrl: url,name: name,)),
                  );
                },
                onLongPress: () =>
                    showDeleteDialog(context,docId, publicId, resourceType),
                child: imageCard(ext: ext, url: url, name: name,context: context),
              );
            },
          );
        },
      ),
    );
  }
}
