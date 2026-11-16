import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('HSVColor to hex string converts accurately', () {
    final hsv = HSVColor.fromAHSV(1.0, 120.0, 1.0, 1.0); // pure green
    final color = hsv.toColor();
    final hex = (color.toARGB32() & 0x00FFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase();

    expect(hex, '00FF00');
  });

  test('reorder list index math matches Flutter ReorderableListView', () {
    final list = ['A', 'B', 'C', 'D'];
    int oldIndex = 0;
    int newIndex = 3;
    if (newIndex > oldIndex) newIndex -= 1;
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);

    expect(list, ['B', 'C', 'A', 'D']);
  });
}
