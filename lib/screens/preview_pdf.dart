import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PreviewPdf extends StatefulWidget {
  final String url;
  final String fileName;

  const PreviewPdf({super.key, required this.url, required this.fileName});

  @override
  State<PreviewPdf> createState() => _PreviewPdfState();
}

class _PreviewPdfState extends State<PreviewPdf> {
  bool _isLoading = true;
   PdfViewerController _pdfViewerController=PdfViewerController();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        title: Text(
          widget.fileName,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: () {
              try {
                _pdfViewerController.zoomLevel += 0.25;
              } catch (e) {
                print("Zoom In Error: $e");
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: () {
              try {
                _pdfViewerController.zoomLevel -= 0.25;
              } catch (e) {
                print("Zoom Out Error: $e");
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SfPdfViewer.network(

            canShowPageLoadingIndicator: false,

            widget.url,
            controller: _pdfViewerController,
            onDocumentLoaded: (details) {
              setState(() {
                _isLoading = false;
              });
            },
            onDocumentLoadFailed: (details) {
              setState(() {
                _isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Failed to load PDF: ${details.error}"),
                  backgroundColor: Colors.red,
                ),
              );
            },
          ),

          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.black87, // Custom loader color
                strokeWidth: 3,
              ),
            ),
        ],
      ),
    );
  }
}
