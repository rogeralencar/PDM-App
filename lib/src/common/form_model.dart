import 'package:flutter/material.dart';

class FormModel extends StatelessWidget {
  final List<String> items;

  const FormModel({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: items
          .map(
            (item) => Draggable<String>(
              data: item,
              feedback: Material(
                child: Container(
                  width: 100,
                  height: 30,
                  color: Colors.red.withOpacity(0.5),
                  child: Center(
                    child: Text(
                      item,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8), fontSize: 16),
                    ),
                  ),
                ),
              ),
              childWhenDragging: Container(
                width: 100,
                height: 30,
                color: Colors.red.withOpacity(0.2),
                child: Center(
                  child: Text(
                    item,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.5), fontSize: 16),
                  ),
                ),
              ),
              child: Container(
                width: 100,
                height: 30,
                color: Colors.red,
                child: Center(
                  child: Text(
                    item,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
