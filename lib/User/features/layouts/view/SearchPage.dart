import 'package:book_store/User/features/layouts/view/LoadingIndicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../../constant.dart';
import '../../data/models/BookModel.dart';
import 'BookDetailsPage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _startVoiceSearch() async {
    if (!_isListening) {
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        return;
      }

      bool available = await _speech.initialize(
        onError: (error) => print("Speech Recognition Error: $error"),
        onStatus: (status) => print("Speech Recognition Status: $status"),
      );

      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(onResult: (result) {
          setState(() {
            searchController.text = result.recognizedWords;
            searchQuery = result.recognizedWords.toLowerCase();
          });
        });
      } else {
        print("Speech recognition is not available");
      }
    } else {
      setState(() {
        _isListening = false;
      });
      await _speech.stop();
      print("Stopped listening");
    }
  }
  Future<void> _scanBarcode() async {
    try {
      String barcodeResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Cancel",
        true,
        ScanMode.BARCODE,
      );

      if (barcodeResult != "-1") {
        setState(() {
          searchController.text = barcodeResult;
          searchQuery = barcodeResult;
        });
      }
    } catch (e) {
      print("Barcode scanning failed: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 100,
        title: SizedBox(
          height: 65,
          child: TextField(
            controller: searchController,
            cursorColor: mainGreenColor,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded),
                labelText: "Search",labelStyle: const TextStyle(color: mainGreenColor,fontWeight: FontWeight.w400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: mainGreenColor, width: 2.0),
              ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: _startVoiceSearch,
                        icon: const Icon(Icons.keyboard_voice_rounded,color: mainGreenColor,)
                    ),
                    const VerticalDivider(indent: 15,endIndent: 15,color: mainGreenColor,),
                    IconButton(
                        onPressed: _scanBarcode,
                        icon: const Icon(Icons.qr_code_scanner_rounded,color: mainGreenColor,)
                    ),
                    const SizedBox(width: 5,)
                  ],
                ),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value.toLowerCase();
              });
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 11),
        child: Column(
          children: [
            const Divider(),
            Expanded(
              child: searchQuery.isEmpty
                  ?  Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.search,
                      size: 50.0,
                      color: mainGreenColor,
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      "Start typing to search for books",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Find your favorite books, authors, and more by typing in the search bar.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('books')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: NewLoadingIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 50.0,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 20.0),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "No books founded in database.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  final books = snapshot.data!.docs.where((doc) {
                    final title = doc['title'].toString().toLowerCase();
                    final img = doc['thumbnail'];
                    final authors =
                    doc['authors'].toString().toLowerCase();
                    final isbn = doc['isbn'].toString();
                    return title.contains(searchQuery) ||
                        authors.contains(searchQuery) ||
                        isbn.contains(searchQuery);
                  }).map((doc) => BookModel.fromJson(doc.data() as Map<String, dynamic>))
                      .toList();

                  if (books.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 50.0,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 20.0),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "No matched books founded.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      final title = book.title ?? 'Unknown Title';
                      final author = book.authors ?? 'Unknown Author';
                      final price = book.price ?? 'Free';
                      final img = book.thumbnail ?? '';

                      return InkWell(
                        onTap: (){
                        Navigator.push(context, MaterialPageRoute<void>(
                          builder: (BuildContext context) => BookDetailsPage(book: book),
                        ),);
                      },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: ListTile(
                              leading: SizedBox(
                                width: 60,
                                height: 90,
                                child: Image.network(
                                  img,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              title: Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "Author: $author",
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              trailing: Text(
                                "Price: $price",
                                style: const TextStyle(fontSize: 16,color: mainGreenColor),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
