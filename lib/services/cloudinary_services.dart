// uploading files to cloudinary
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_storage_app/services/db_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
int totalBytesUploaded = 0;


/// upload file from cloudinary
Future<bool?> uploadToCloudinaryWithProgress(
    FilePickerResult result,
    BuildContext context,
    Function(double) onProgress,
    ) async {
  if (result.files.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No file selected")),
    );
    return false;
  }

  File file = File(result.files.single.path!);
  String fileName = file.path.split("/").last;
  String fileExt = result.files.single.extension?.toLowerCase() ?? "";

  String cloudName = dotenv.env["CLOUDINARY_NAME"] ?? "";
  String uploadPreset = "upload_file_preset";

  Uri uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/auto/upload");

  var request = http.MultipartRequest("POST", uri);
  request.fields['upload_preset'] = uploadPreset;

  var fileLength = await file.length();
  var stream = http.ByteStream(file.openRead().transform(
    StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        sink.add(data);
        totalBytesUploaded += data.length;
        double progress = totalBytesUploaded / fileLength;
        onProgress(progress);
      },
    ),
  ));
  totalBytesUploaded = 0;

  var multipartFile = http.MultipartFile(
    'file',
    stream,
    fileLength,
    filename: fileName,
  );

  request.files.add(multipartFile);

  var response = await request.send();
  var responseBody = await response.stream.bytesToString();

  if (response.statusCode == 200) {
    var responseData = jsonDecode(responseBody);
    print(responseData);
    Map<String, dynamic> requiredData = {
      "name": result.files.first.name,
      "public_id": responseData["public_id"],
      "secure_url": responseData["secure_url"],
      "resource_type": responseData["resource_type"],
      "created_at": responseData["created_at"],
      "bytes": responseData["bytes"].toString(),
      "extension": fileExt,
    };

    await DbServices().saveUploadedFileData(requiredData);
    return true;
  } else {
    print("Upload failed: ${response.statusCode} $responseBody");
    return false;
  }
}


/// Delete File from cloudinary
Future<bool> deleteFromCloudinary(String publicId, String resourceType) async {
  String cloudName = dotenv.env["CLOUDINARY_NAME"] ?? "";
  String apiKey = dotenv.env["CLOUDINARY_API_KEY"] ?? "";
  String secretApiKey = dotenv.env["CLOUDINARY_SECRET_API_KEY"] ?? "";

  int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  String toSign = "public_id=$publicId&timestamp=$timestamp$secretApiKey";
  var bytes = utf8.encode(toSign);
  var digest = sha1.convert(bytes);
  String signature = digest.toString();

  var uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/$resourceType/destroy");

  var response = await http.post(
    uri,
    body: {
      "public_id": publicId,
      "api_key": apiKey,
      "timestamp": timestamp.toString(),
      "signature": signature,
    },
  );

  if (response.statusCode == 200) {
    var result = json.decode(response.body);
    return result["result"] == "ok";
  } else {
    print("Cloudinary Delete Error: ${response.body}");
    return false;
  }
}
 /// Download file from cloudinary
Future<bool> downloadFileFromCloudinary(String url,String fileName)async{
  try{
    var status=await Permission.storage.request();
    var manageStatus=await Permission.manageExternalStorage.request();
    if(status==PermissionStatus.granted && manageStatus==PermissionStatus.granted){
      print("Storage Permission granted");
    }else{
      await openAppSettings();
    }
    Directory? downloadDir=Directory("/storage/emulated/0/Download");
    if(!downloadDir.existsSync()){
      print('download directory na found');
      return false;
    }
    String filePath="${downloadDir.path}/$fileName";
    var response=await http.get(Uri.parse(url));
    if(response.statusCode==200){
      File file=File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      print("file download successfully: $filePath");
      return true;
    }else{
      print('file download fail: ${response.statusCode}');
      return false;
    }

  }catch(e){
    print('Error download file');
    return false;

  }

}