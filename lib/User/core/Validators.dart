class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$");
    if (!emailRegex.hasMatch(value)) {
      return "Enter a valid email";
    }
    if(value.compareTo('admin@store.com') == 0) {
      return null;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters long";
    }
    if(value.compareTo('admin1') == 0) {
      return null;
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone is required";
    }
    if (value.length < 11 || value.length > 11) {
      return "Phone is 11 numbers start with 01";
    }
    return null;
  }

  static String? validateNotEmpty(String? value){
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }
    return null;
  }

}