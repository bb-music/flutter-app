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
  const double itemHeight = 55;
  final double height =
      (itemHeight * items.where((e) => e.hidden != true).length).toDouble() +
          30;

  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (BuildContext ctx) {
      return SafeArea(
        bottom: true,
        child: Container(
          color: Theme.of(context).cardTheme.color,
          height: height,
          child: ListView(
            children: [
              ...items.toList().map((e) {
                if (e.hidden == true) return Container();

                return ListTile(
                  minTileHeight: itemHeight,
                  leading: e.icon,
                  title: e.title,
                  onTap: e.onPressed != null
                      ? () {
                          Navigator.of(context).pop();
                          e.onPressed!();
                        }
                      : null,
                );
              }),
            ],
          ),
        ),
      );
    },
  );
}
