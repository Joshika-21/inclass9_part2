import 'package:flutter/material.dart';
import 'package:card_organizer/db_helper.dart';
import 'cards_screen.dart';

class FolderListScreen extends StatefulWidget {
  @override
  _FolderListScreenState createState() => _FolderListScreenState();
}

class _FolderListScreenState extends State<FolderListScreen> {
  List<Map<String, dynamic>> _folders = [];

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  void _loadFolders() async {
    final data = await DatabaseHelper.instance.getFolders();
    setState(() {
      _folders = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Card Organizer')),
      body: ListView.builder(
        itemCount: _folders.length,
        itemBuilder: (context, index) {
          final folder = _folders[index];
          return ListTile(
            title: Text(folder['name']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => CardGridScreen(
                        folderId: folder['_id'],
                        folderName: folder['name'],
                      ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
