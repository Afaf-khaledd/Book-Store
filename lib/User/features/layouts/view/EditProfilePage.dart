import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../constant.dart';
import '../../../../core/Validators.dart';
import '../../data/models/UserModel.dart';
import '../manger/AuthCubit/auth_cubit.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _birthdayController;
  late TextEditingController _passwordController;

  bool _isPasswordHidden = true;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _addressController = TextEditingController(text: widget.user.address);
    _birthdayController = TextEditingController(text: widget.user.birthday);
    _passwordController = TextEditingController();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Update Profile'),
          content: const Text('Are you sure you want to save these changes?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel',style: TextStyle(color: Colors.black),),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _updateProfile();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: mainGreenColor,
              ),
              child: const Text('Save',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400)),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _updateProfile() async {
    final updatedUser = UserModel(
      uid: widget.user.uid,
      email: widget.user.email,
      username: _usernameController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      birthday: _birthdayController.text,
    );

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .update(updatedUser.toMap());

      if (_passwordController.text.isNotEmpty && _passwordController.text.length >= 7) {
        await BlocProvider.of<AuthCubit>(context)
            .changePassword(_passwordController.text);
      }
      Fluttertoast.showToast(msg: "Data Updated!",backgroundColor: Colors.green);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error updating profile: $e',backgroundColor: Colors.redAccent);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _birthdayController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 25,color: mainGreenColor),),
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                cursorColor: mainGreenColor,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  labelStyle: TextStyle(color: mainGreenColor),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: mainGreenColor,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
                validator: Validators.validateNotEmpty,
              ),
              const SizedBox(height: 10,),
              TextFormField(
                controller: _emailController,
                cursorColor: mainGreenColor,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  labelStyle: TextStyle(color: mainGreenColor),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: mainGreenColor,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),

              TextFormField(
                controller: _phoneController,
                cursorColor: mainGreenColor,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  prefixIcon: Icon(Icons.phone),
                  labelStyle: TextStyle(color: mainGreenColor),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: mainGreenColor,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
                validator: Validators.validatePhone,
              ),
              const SizedBox(height: 10,),

              TextFormField(
                controller: _addressController,
                cursorColor: mainGreenColor,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.home),
                  labelStyle: TextStyle(color: mainGreenColor),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: mainGreenColor,
                      width: 2.0, // Thickness of the line
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
                validator: Validators.validateNotEmpty,
              ),
              const SizedBox(height: 10,),

              TextFormField(
                controller: _birthdayController,
                readOnly: true,
                cursorColor: mainGreenColor,
                decoration: InputDecoration(
                  labelText: 'Birthday',
                  prefixIcon: const Icon(Icons.calendar_month),
                  labelStyle: const TextStyle(color: mainGreenColor),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: mainGreenColor,
                      width: 2.0, // Thickness of the line
                    ),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {
                      _selectDate(context);
                    },
                  ),
                ),
                validator: Validators.validateNotEmpty,
              ),
              const SizedBox(height: 10,),

              TextFormField(
                controller: _passwordController,
                obscureText: _isPasswordHidden,
                cursorColor: mainGreenColor,
                decoration: InputDecoration(
                  labelText: 'New Password (optional)',
                  prefixIcon: const Icon(Icons.lock),
                  labelStyle: const TextStyle(color: mainGreenColor),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: mainGreenColor,
                      width: 2.0, // Thickness of the line
                    ),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordHidden = !_isPasswordHidden;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainGreenColor,
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _selectDate(BuildContext context) async {
    final List<DateTime?>? selectedDates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        selectedDayHighlightColor: mainGreenColor,
        calendarType: CalendarDatePicker2Type.single,
      ),
      dialogSize: const Size(325, 400),
      value: _birthdayController.text.isNotEmpty
          ? [DateTime.tryParse(_birthdayController.text)]
          : [],
    );

    if (selectedDates != null && selectedDates.isNotEmpty && selectedDates[0] != null) {
      final DateTime selectedDate = selectedDates[0]!;
      final String formattedDate =
          "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

      setState(() {
        _birthdayController.text = formattedDate;
      });
    }
  }
}
