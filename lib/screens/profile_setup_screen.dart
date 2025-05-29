// lib/screens/profile_setup_screen.dart
import 'dart:io'; // For File type
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For NumberTextInputFormatter
import 'package:image_picker/image_picker.dart'; // We'll add this dependency

// Placeholder for PreferencesScreen, we'll create it in the next step
// import 'package:homies/screens/preferences_screen.dart';
// Placeholder for AuthService and DatabaseService
// import 'package:homies/services/auth_service.dart';
// import 'package:homies/services/database_service.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  // final AuthService _authService = AuthService(); // Will uncomment later
  // final DatabaseService _databaseService = DatabaseService(); // Will uncomment later

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  File? _profileImage;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _professionController.dispose();
    super.dispose();
  }
final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage() async {
    // Show a dialog to choose between camera and gallery
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Profile Picture'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, ImageSource.camera);
              },
              child: const ListTile(
                  leading: Icon(Icons.camera_alt), title: Text('Camera')),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, ImageSource.gallery);
              },
              child: const ListTile(
                  leading: Icon(Icons.photo_library), title: Text('Gallery')),
            ),
          ],
        );
      },
    );

    if (source != null) {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
          imageQuality: 50, // Compress image to save space (0-100)
          maxWidth: 800,    // Optionally resize
        );

        if (pickedFile != null) {
          setState(() {
            _profileImage = File(pickedFile.path);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No image selected.")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to pick image: $e")),
        );
      }
    }
  }

  Future<void> _submitProfile() async {
    if (_formKey.currentState!.validate()) {
      // Validation passed
      setState(() {
        _isLoading = true;
      });

      // TODO:
      // 1. Upload profile image to Firebase Storage (in Step 9)
      // 2. Get the download URL.
      // 3. Save name, age, profession, and image URL to Firestore (in Step 9)

      // For now, simulate a delay and navigate to a placeholder
      await Future.delayed(const Duration(seconds: 2));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile data (simulated) saved!")),
      );

      // After saving, navigate to PreferencesScreen (we'll create this in Step 8)
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (context) => const PreferencesScreen()),
      // );

      // For now, let's just pop or show a success message
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Next: Preferences Screen (Step 8)")),
        );
        // Or navigate back if this screen was pushed on top
        // Navigator.of(context).pop();
      }


      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Set Up Your Profile"),
        automaticallyImplyLeading: false, // Don't show back button initially
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage:
                            _profileImage != null ? FileImage(_profileImage!) : null,
                        child: _profileImage == null
                            ? Icon(Icons.person, size: 60, color: Colors.grey.shade700)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, color: Colors.white),
                            onPressed: _pickImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your name";
                    }
                    if (value.length < 2) {
                      return "Name must be at least 2 characters long";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Age Field
                TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    labelText: "Age",
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your age";
                    }
                    final age = int.tryParse(value);
                    if (age == null || age < 18) {
                      return "You must be at least 18 years old";
                    }
                    if (age > 99) {
                      return "Please enter a valid age";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Profession Field
                TextFormField(
                  controller: _professionController,
                  decoration: InputDecoration(
                    labelText: "Profession",
                    prefixIcon: const Icon(Icons.work_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your profession";
                    }
                     if (value.length < 3) {
                      return "Profession must be at least 3 characters long";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _submitProfile,
                        child: const Text("SAVE & CONTINUE"),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}