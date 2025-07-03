import 'package:file_storage_app/screens/home_screen.dart';
import 'package:file_storage_app/screens/image_screen.dart';
import 'package:file_storage_app/screens/pdf_screen.dart';
import 'package:file_storage_app/screens/video_screen.dart';
import 'package:file_storage_app/services/auth_services.dart';
import 'package:flutter/material.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "File Storage App",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              color: Colors.white,
              onSelected: (value) {
                if (value == 'logout') {
                  AuthService.logout();
                  Navigator.pushNamed(context, "/login");
                } else if (value == 'settings') {
                  // navigate to settings page
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'settings',
                  child: ListTile(
                    leading: Icon(Icons.settings, color: Colors.black87,size: 18,),
                    title: Text('Settings', style: TextStyle(color: Colors.black87)),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: ListTile(
                    leading: Icon(Icons.logout, color: Colors.black87,size: 18,),
                    title: Text('Logout', style: TextStyle(color: Colors.black87)),
                  ),
                ),
              ],
            ),
          ],
          backgroundColor: Colors.black87,
          centerTitle: true,
          bottom:  TabBar(
            // ✅ Disable hover effect
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            isScrollable: true, // ✅ allow spacing
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
           indicatorPadding:  EdgeInsets.only(left: 20),
            indicatorSize: TabBarIndicatorSize.tab, // ✅ wraps the label
            labelPadding: EdgeInsets.only(left: 20), // ✅ spacing
            tabs: [
              Tab(icon: Icon(Icons.home_outlined, color: Colors.white), text: "Home"),
              Tab(icon: Icon(Icons.image_outlined, color: Colors.white), text: "Images"),
              Tab(icon: Icon(Icons.movie_creation_outlined, color: Colors.white), text: "Videos"),
              Tab(icon: Icon(Icons.picture_as_pdf_outlined, color: Colors.white), text: "Pdf"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: HomeScreen()),
            Center(child: ImageScreen()),
            Center(child: VideoScreen()),
            Center(child: PdfScreen()),
          ],
        ),
      ),
    );
  }
}
