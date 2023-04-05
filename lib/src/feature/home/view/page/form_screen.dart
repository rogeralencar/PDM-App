import 'package:flutter/material.dart';

import '../../../../common/form_model.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => FormScreenState();
}

class FormScreenState extends State<FormScreen> {
  List<String> inputItems = [
    'Futebol',
    'Praia',
    'Museu',
  ];
  List<String> droppedItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 162, 241, 255),
              Color.fromARGB(255, 20, 84, 109),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Text(
              'Quais são seus maiores interesses?',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            const SizedBox(height: 20),
            DragTarget<String>(
              builder: (context, acceptedItems, rejectedItems) => Container(
                width: 320,
                height: 80,
                color: Colors.white.withOpacity(0.5),
                child: Center(
                  child: droppedItems.isEmpty
                      ? const Text(
                          'Arraste aqui suas opções!',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        )
                      : FormModel(items: droppedItems),
                ),
              ),
              onWillAccept: (item) => true,
              onAccept: (item) {
                setState(() {
                  if (droppedItems.contains(item)) {
                    return;
                  } else {
                    droppedItems.add(item);
                    inputItems.remove(item);
                  }
                });
              },
              onLeave: (item) {
                setState(() {
                  if (inputItems.contains(item)) {
                    return;
                  } else {
                    inputItems.add(item!);
                    droppedItems.remove(item);
                  }
                });
              },
            ),
            const SizedBox(height: 20),
            FormModel(items: inputItems),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
