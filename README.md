# ShelfWise — E-commerce Bookstore (Flutter)

**ShelfWise** is a cross-platform Flutter bookstore app (Customer & Admin) built with clean architecture (MVVM) and Cubit/Bloc for state management. It supports searching (text, voice, barcode), browsing, ordering, admin management, and real-time updates using Firebase.

---

## 🚀 Features

**Customer**
- Browse books by category, author, and filters  
- Search: text search, voice search, and barcode scan  
- Book detail pages with ratings & reviews  
- Cart management (add / edit / remove)  
- Place orders, track order status, and cancel orders  
- Profile management and persistent sessions (Remember Me)  
- Responsive UI and offline-friendly caching for some features

**Admin**
- Secure admin authentication  
- Add / edit / delete books and categories  
- Manage orders and view sales statistics / charts  
- View low quantity items

**Shared / Backend**
- Firebase Authentication (customer & admin roles)  
- Firestore for real-time data & orders  
- Cloudinary Storage for book images/media  
- Integration with Google Books API for metadata
- Clean MVVM + Repository pattern, dependency injection (get_it)

---

## 🧩 Tech Stack

- Flutter & Dart  
- State management: **Cubit** (MVVM-style architecture)  
- Backend: **Firebase** (Auth, Firestore, Cloud Storage)  
- HTTP: **Dio** for API requests (Google Books, backend endpoints)  
- Barcode scanning: `flutter_barcode_scanner`  
- Image upload: Cloud Storage
- DI: `get_it`  
- Local storage: `shared_preferences`
- Version control: Git & GitHub

---

## 🤝 Contributions

This project was developed as a team college project. We welcome feedback, suggestions, and contributions — feel free to fork the repo or open a pull request for improvements and bug fixes.
