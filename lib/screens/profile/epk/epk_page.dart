import 'package:flutter/material.dart';

class EpkPage extends StatefulWidget {
  static const String id = 'epk_page';
  EpkPage({Key? key}) : super(key: key);

  @override
  State<EpkPage> createState() => _EpkPageState();
}

class _EpkPageState extends State<EpkPage> {
  final List<String> _filters = ['Description', 'Medias', 'Tech Rider'];
  final List<GlobalKey> _keys = [GlobalKey(), GlobalKey(), GlobalKey()];
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EPK Page'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _filters.asMap().entries.map((entry) {
                return ElevatedButton(
                  child: Text(entry.value),
                  onPressed: () {
                    _scrollToIndex(entry.key);
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
      body: ListView(
        controller: _scrollController,
        children: _filters.asMap().entries.map((entry) {
          return Container(
            key: _keys[entry.key],
            child: Text('Content for ${entry.value}'),
          );
        }).toList(),
      ),
    );
  }

  void _scrollToIndex(int index) {
    final keyContext = _keys[index].currentContext;

    if (keyContext != null) {
      // Get the render object of the widget in question
      final box = keyContext.findRenderObject() as RenderBox;

      // Get the vertical position
      final position = box.localToGlobal(Offset.zero).dy;

      // Scroll to the desired position
      _scrollController.animateTo(position,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }
}
