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
  double height = 50;

  for (var _ in items) {
    height += 56; // 每个选项的高度
  }

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: height,
        child: ListView(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.only(top: 13, bottom: 13),
                height: 30,
                child: Container(
                  width: 30,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
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
