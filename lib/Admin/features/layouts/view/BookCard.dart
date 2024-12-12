import 'package:book_store/Admin/features/layouts/view/EditBookPage.dart';
import 'package:book_store/constant.dart';
import 'package:flutter/material.dart';

import '../../../../User/features/data/models/BookModel.dart';

class BookCard extends StatelessWidget {
  final BookModel book;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const BookCard({
    Key? key,
    required this.book,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: book.thumbnail != null
                    ? Image.network(
                  book.thumbnail!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                    : Container(
                  height: 150,
                  color: Colors.grey[200],
                  child: const Center(child: Icon(Icons.image, size: 50)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title ?? 'Untitled',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.authors?.join(', ') ?? 'Unknown Author',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${book.price ?? 0}',
                      style: const TextStyle(
                        color: mainGreenColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.remove_circle_rounded, color: Colors.red),
              onPressed: onDelete,
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.edit, color: mainGreenColor),
              onPressed: onEdit,
            ),
          ),
        ],
      ),
    );
  }
}