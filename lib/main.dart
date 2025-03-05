import 'package:flutter/material.dart';
import 'screens/folders_screen.dart';

void main() {
  runApp(CardOrganizerApp());
}

class CardOrganizerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Card Organizer',
      home: FolderListScreen(),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 26e74b83f8c33bada97601000850e1addc401a1f
