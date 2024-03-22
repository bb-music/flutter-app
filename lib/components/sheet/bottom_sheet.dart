import 'package:flutter/material.dart';

class SheetItem {
  final Widget title;
  final Widget? icon;
  final Function()? onPressed;

  const SheetItem({
    required this.title,
    this.icon,
    this.onPressed,
  });
}

void openBottomSheet(BuildContext context, List<SheetItem> items) {
  double height = 30;

  for (var _ in items) {
    height += 56; // 每个选项的高度
  }

  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (BuildContext context) {
      return SizedBox(
        height: height,
        child: ListView(
          children: [
            ...items.toList().map((e) {
              return ListTile(
                leading: e.icon,
                title: e.title,
                onTap: e.onPressed,
              );
            })
          ],
        ),
      );
    },
  );
}
