import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_storage_app/services/cloudinary_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DbServices{
  /// Get Current User:
  User? user=FirebaseAuth.instance.currentUser;

  /// Save files links to firestore
  Future<void> saveUploadedFileData(Map<String,dynamic> data)async{
    FirebaseFirestore.instance
    .collection("user_files")
    .doc(user!.uid)
    .collection("uploads")
    .doc()
    .set(data);
  }

  /// Read all uploaded files
  Stream<QuerySnapshot> readUploadedFiles(){
    return FirebaseFirestore.instance
        .collection("user_files")
        .doc(user!.uid)
        .collection("uploads")
        .snapshots();
  }

  /// Delete File From Firestore
    Future<bool> deleteFiles(String docId,String publicId,String resourceType)async{
    final result=await deleteFromCloudinary(publicId,resourceType);
    if(result){
      await FirebaseFirestore.instance
          .collection("user_files")
          .doc(user!.uid)
          .collection('uploads')
          .doc(docId)
          .delete();
      return true;
    }
    return false;
    }
/// Get all Images
  Stream<QuerySnapshot> getImageFiles() {
    return FirebaseFirestore.instance
        .collection("user_files")
        .doc(user!.uid)
        .collection("uploads")
        .where("extension", whereIn: ["jpg", "jpeg", "png"])
        .snapshots();
  }
/// Get all Videos
  Stream<QuerySnapshot> getVideoFiles() {
    return FirebaseFirestore.instance
        .collection("user_files")
        .doc(user!.uid)
        .collection("uploads")
        .where("extension", isEqualTo: "mp4")
        .snapshots();
  }
  /// Get all pdf
  Stream<QuerySnapshot> getPdfFiles() {
    return FirebaseFirestore.instance
        .collection("user_files")
        .doc(user!.uid)
        .collection("uploads")
        .where("extension", isEqualTo: "pdf")
        .snapshots();
  }




}