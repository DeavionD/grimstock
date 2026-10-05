import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/item_repository.dart';
import '../../data/listing_writer.dart';
import '../../theme/grim_theme.dart';

Future<void> showListingSheet(BuildContext context, ItemDetails details) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: GrimColors.tomb,
    builder: (context) => ListingSheet(details: details),
  );
}

/// Writes a listing title and description in the chosen platform's style,
/// ready to edit and copy into the selling app.
class ListingSheet extends StatefulWidget {
  const ListingSheet({super.key, required this.details});

  final ItemDetails details;

  @override
  State<ListingSheet> createState() => _ListingSheetState();
}

class _ListingSheetState extends State<ListingSheet> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  ListingStyle _style = ListingStyle.standard;

  @override
  void initState() {
    super.initState();
    _write();
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  void _write() {
    final listing = writeListing(widget.details, _style);
    _title.text = listing.title;
    _description.text = listing.description;
  }

  Future<void> _copy(String text, String what) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$what copied')));
  }

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.viewInsetsOf(context);
    return Padding(
      padding: EdgeInsets.only(bottom: insets.bottom),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        builder: (context, scroll) => ListView(
          controller: scroll,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: GrimColors.mist,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Write a listing',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final style in ListingStyle.values)
                  ChoiceChip(
                    label: Text(style.label),
                    selected: _style == style,
                    onSelected: (_) => setState(() {
                      _style = style;
                      _write();
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _title,
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'Title',
                helperText: 'Up to ${_style.titleLimit} characters',
                suffixIcon: IconButton(
                  tooltip: 'Copy title',
                  icon: const Icon(Icons.copy),
                  onPressed: () => _copy(_title.text, 'Title'),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _description,
              minLines: 6,
              maxLines: 12,
              decoration: const InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () =>
                  _copy('${_title.text}\n\n${_description.text}', 'Listing'),
              icon: const Icon(Icons.copy_all),
              label: const Text('Copy title and description'),
            ),
          ],
        ),
      ),
    );
  }
}
