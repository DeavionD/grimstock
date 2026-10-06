import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/item_repository.dart';
import '../../data/providers.dart';
import '../../theme/grim_theme.dart';
import '../pro/paywall_screen.dart';

/// A row of an item's photos with buttons to add (camera or library) and
/// long-press to remove.
class PhotoStrip extends ConsumerWidget {
  const PhotoStrip({super.key, required this.itemId});

  final int itemId;

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final fromCamera = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: GrimColors.tomb,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.of(context).pop(true),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from library'),
              onTap: () => Navigator.of(context).pop(false),
            ),
          ],
        ),
      ),
    );
    if (fromCamera == null) return;
    final path = await ref
        .read(photoStoreProvider)
        .pick(fromCamera: fromCamera);
    if (path != null) {
      await ref.read(itemRepositoryProvider).addPhoto(itemId, path);
    }
  }

  Future<void> _remove(BuildContext context, WidgetRef ref, int photoId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove this photo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: GrimColors.blood),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final path = await ref.read(itemRepositoryProvider).deletePhoto(photoId);
    if (path != null) await ref.read(photoStoreProvider).delete([path]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photos = ref.watch(itemPhotosProvider(itemId)).value ?? const [];
    final limit = ref.watch(itemRepositoryProvider).photoLimit;
    final canAdd = photos.length < limit;
    final canUpgrade = !canAdd && limit < ItemRepository.maxPhotosPerItem;

    return SizedBox(
      height: 96,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final photo in photos)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onLongPress: () => _remove(context, ref, photo.id),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(photo.localPath),
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const _PhotoPlaceholder(
                      icon: Icons.broken_image_outlined,
                    ),
                  ),
                ),
              ),
            ),
          if (canAdd)
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _add(context, ref),
              child: const _PhotoPlaceholder(
                icon: Icons.add_a_photo_outlined,
                label: 'Add photo',
              ),
            ),
          if (canUpgrade)
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => showPaywall(context),
              child: const _PhotoPlaceholder(
                icon: Icons.lock_outline,
                label: 'More with Pro',
              ),
            ),
        ],
      ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder({required this.icon, this.label});

  final IconData icon;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: GrimColors.slab,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GrimColors.mist),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: GrimColors.ash),
          if (label != null) ...[
            const SizedBox(height: 4),
            Text(
              label!,
              style: const TextStyle(color: GrimColors.ash, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
