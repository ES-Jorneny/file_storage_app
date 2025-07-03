import 'package:flutter/material.dart';

class PreviewImage extends StatefulWidget {
  final String url;
  final String name;
  const PreviewImage({super.key,required this.url,required this.name});

  @override
  State<PreviewImage> createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(widget.name,style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Center(child: Image.network(widget.url,)),
    );
  }
}
