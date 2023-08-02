import 'package:flutter/material.dart';

class QuantitySelector extends StatefulWidget {
  final int initialValue;
  final int maxQuantity;
  final Function(int) onValueChanged;

  const QuantitySelector({
    super.key,
    required this.initialValue,
    required this.maxQuantity,
    required this.onValueChanged,
  });

  @override
  QuantitySelectorState createState() => QuantitySelectorState();
}

class QuantitySelectorState extends State<QuantitySelector> {
  late int _numOfItem;

  @override
  void initState() {
    super.initState();
    _numOfItem = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            if (_numOfItem == 1) {
              return;
            }
            setState(() {
              _numOfItem--;
              widget.onValueChanged(_numOfItem);
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(8),
          ),
          child: const Icon(
            Icons.remove,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Text(
          'x $_numOfItem',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(
          width: 15,
        ),
        ElevatedButton(
          onPressed: () {
            if (_numOfItem == widget.maxQuantity) {
              return;
            }
            setState(() {
              _numOfItem++;
              widget.onValueChanged(_numOfItem);
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(8),
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
