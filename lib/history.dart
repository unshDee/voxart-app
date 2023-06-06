import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('History'),
          ),
          SliverToBoxAdapter(
            child: StreamBuilder<Object>(
              stream: null,
              builder: (context, snapshot) {
                return ElevatedCard(
                  index: 1,
                  height: 400,
                  width: double.infinity,
                );
              }
            ),
          )
        ],
      ),
    );
  }
}

class ElevatedCard extends StatefulWidget {
  int index;
  double width;
  double height;

  ElevatedCard(
      {super.key,
      required this.index,
      required this.width,
      required this.height});

  @override
  State<ElevatedCard> createState() => _ElevatedCardState();
}

class _ElevatedCardState extends State<ElevatedCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: SizedBox(
          width: widget.width.toDouble(),
          height: widget.height.toDouble(),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: Text('Loading your image...'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
