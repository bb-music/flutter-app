import 'package:flutter/material.dart';

class SheetItem {
  final Widget title;
  final Widget? icon;
  final Function()? onPressed;
  bool? hidden;

  SheetItem({
    required this.title,
    this.icon,
    this.onPressed,
    this.hidden,
  });
}

void openBottomSheet(BuildContext context, List<SheetItem> items) {
  double height =
      (55 * items.where((e) => e.hidden != true).length).toDouble() + 30;

  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (BuildContext ctx) {
      return SafeArea(
        bottom: true,
        child: Container(
          color: Theme.of(context).colorScheme.background,
          height: height,
          child: ListView(
            children: [
              ...items.toList().map((e) {
                if (e.hidden == true) {
                  return Container();
                }
                return SizedBox(
                  height: 55,
                  child: ListTile(
                    leading: e.icon,
                    title: e.title,
                    onTap: e.onPressed != null
                        ? () {
                            Navigator.of(context).pop();
                            e.onPressed!();
                          }
                        : null,
                  ),
                );
              })
            ],
          ),
        ),
      );
    },
  );
}
