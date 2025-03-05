import 'package:flutter/material.dart';
import 'package:card_organizer/db_helper.dart';

class CardGridScreen extends StatefulWidget {
  final int folderId;
  final String folderName;

  CardGridScreen({required this.folderId, required this.folderName});

  @override
  _CardGridScreenState createState() => _CardGridScreenState();
}

class _CardGridScreenState extends State<CardGridScreen> {
  List<Map<String, dynamic>> _cards = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  void _loadCards() async {
    final data = await DatabaseHelper.instance.getCardsInFolder(
      widget.folderId,
    );
    setState(() {
      _cards = data;
    });
  }

  void _addCard() async {
    try {
      await DatabaseHelper.instance.addCardToFolder(
        _cards.length + 1,
        widget.folderId,
      );
      _loadCards();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _updateCard(int cardId) async {
    // Logic to update card (e.g., move it to another folder)
  }

  void _deleteCard(int cardId) async {
    await DatabaseHelper.instance.deleteCard(cardId);
    _loadCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.folderName} Cards')),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];

          return GestureDetector(
            onLongPress: () => _deleteCard(card['_id']),
            child: Card(
              elevation: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(card['image_url'], width: 60, height: 60),
                  Text(card['name'], textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCard,
        child: Icon(Icons.add),
      ),
    );
  }
}
