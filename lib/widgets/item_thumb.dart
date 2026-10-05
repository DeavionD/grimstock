import 'dart:io';

import 'package:flutter/material.dart';

import '../theme/grim_theme.dart';

/// A small square photo for list rows, or a placeholder when there is none.
class ItemThumb extends StatelessWidget {
  const ItemThumb({super.key, this.path, this.size = 56});

  final String? path;
  final double size;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: size,
      height: size,
      color: GrimColors.slab,
      child: const Icon(Icons.image_outlined, color: GrimColors.mist),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: path == null
          ? placeholder
          : Image.file(
              File(path!),
              width: size,
              height: size,
              fit: BoxFit.cover,
              cacheWidth: (size * 3).round(),
              errorBuilder: (_, _, _) => placeholder,
            ),
    );
  }
}
