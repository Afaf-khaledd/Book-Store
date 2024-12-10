import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../User/features/data/models/BookModel.dart';
import '../../data/repoistry/CloudinaryService.dart';
import '../manger/BooksCubit/books_admin_cubit.dart';
import '../manger/CategoryCubit/category_cubit.dart';

class EditBookPage extends StatefulWidget {
  const EditBookPage({super.key, this.book});
  final BookModel? book;
  @override
  State<EditBookPage> createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {

  final _formKey = GlobalKey<FormState>();

  // Controllers for book fields
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _availabilityController = TextEditingController();
  final _authorsController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _cloudinaryService = CloudinaryService();
  String? _thumbnailUrl;
  bool _isUploadingImage = false;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _titleController.text = widget.book!.title ?? '';
      _priceController.text = widget.book!.price?.toString() ?? '';
      _availabilityController.text = widget.book!.availability?.toString() ?? '';
      _authorsController.text = widget.book!.authors?.join(', ') ?? '';
      _descriptionController.text = widget.book!.description ?? '';
      _thumbnailUrl = widget.book!.thumbnail;
      _selectedCategoryId = widget.book!.category;
    }

    context.read<CategoryCubit>().fetchCategories();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _availabilityController.dispose();
    _authorsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _isUploadingImage = true;
      });

      final imageUrl = await _cloudinaryService.uploadImage(pickedFile.path);

      if (imageUrl != null) {
        setState(() {
          _thumbnailUrl = imageUrl;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image')),
        );
      }

      setState(() {
        _isUploadingImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book == null ? "Add Book" : "Edit Book"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_thumbnailUrl != null)
                Center(
                  child: Image.network(
                    _thumbnailUrl!,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              if (_isUploadingImage)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: CircularProgressIndicator(),
                ),
              if (!_isUploadingImage)
                TextButton.icon(
                  onPressed: _pickAndUploadImage,
                  icon: const Icon(Icons.upload),
                  label: const Text("Upload Cover Image"),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a title";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _authorsController,
                decoration: const InputDecoration(labelText: "Authors (comma-separated)"),
              ),
              const SizedBox(height: 16),
              BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is CategoryLoaded) {
                    final categories = state.categories;
                    return DropdownButtonFormField<String>(
                      value: _selectedCategoryId,
                      decoration: const InputDecoration(labelText: "Category"),
                      items: categories
                          .map((category) => DropdownMenuItem<String>(
                        value: category.id,
                        child: Text(category.name),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoryId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return "Please select a category";
                        }
                        return null;
                      },
                    );
                  } else {
                    return const Text("Failed to load categories");
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a price";
                  }
                  if (int.tryParse(value) == null) {
                    return "Please enter a valid number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _availabilityController,
                decoration: const InputDecoration(labelText: "Availability"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter availability";
                  }
                  if (int.tryParse(value) == null) {
                    return "Please enter a valid number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final cubit = context.read<BooksAdminCubit>();
                    final book = BookModel(
                      id: widget.book?.id,
                      title: _titleController.text,
                      authors: _authorsController.text.split(',').map((e) => e.trim()).toList(),
                      category: _selectedCategoryId,
                      price: int.tryParse(_priceController.text),
                      availability: int.tryParse(_availabilityController.text),
                      thumbnail: _thumbnailUrl,
                      description: _descriptionController.text,
                    );
                    if (widget.book == null) {
                      cubit.addBook(book);
                    } else {
                      cubit.updateBook(book);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.book == null ? "Add" : "Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}