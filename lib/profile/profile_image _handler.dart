import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageHandler with ChangeNotifier {
  String? _profileImageUrl;
  bool _isLoading = false;
  String? _errorMessage;
  File? _selectedImage;
  bool _isDisposed = false;

  // Getters
  String? get profileImageUrl => _profileImageUrl;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  File? get selectedImage => _selectedImage;

  // Helper method to safely call notifyListeners
  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  // Fetch profile image URL from Firestore
  Future<void> fetchProfileImage() async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _errorMessage = 'No user logged in';
        _isLoading = false;
        _safeNotifyListeners();
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        _profileImageUrl = doc.data()?['profileImageUrl'] as String?;
      }

      _isLoading = false;
      _safeNotifyListeners();
    } catch (e) {
      _errorMessage = 'Error fetching profile image: $e';
      _isLoading = false;
      _safeNotifyListeners();
      print('Error fetching profile image: $e');
    }
  }

  // Pick image from gallery
  Future<bool> pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
        _safeNotifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Error picking image: $e';
      _safeNotifyListeners();
      print('Error picking image: $e');
      return false;
    }
  }

  // Upload or update image to Firebase Storage and Firestore
  Future<bool> uploadImage() async {
    if (_selectedImage == null) {
      _errorMessage = 'No image selected';
      _safeNotifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _errorMessage = 'No user logged in';
        _isLoading = false;
        _safeNotifyListeners();
        return false;
      }

      // Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('users/${user.uid}/profile_image.jpg');
      await storageRef.putFile(_selectedImage!);
      final downloadUrl = await storageRef.getDownloadURL();

      // Update Firestore with the download URL
      await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
        'profileImageUrl': downloadUrl,
      }, SetOptions(merge: true));

      _profileImageUrl = downloadUrl;
      _selectedImage = null; // Clear selected image after upload
      _isLoading = false;
      _safeNotifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error uploading image: $e';
      _isLoading = false;
      _safeNotifyListeners();
      print('Error uploading image: $e');
      return false;
    }
  }

  // Delete image from Firebase Storage and Firestore
  Future<bool> deleteImage() async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _errorMessage = 'No user logged in';
        _isLoading = false;
        _safeNotifyListeners();
        return false;
      }

      // Check if the image exists in Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('users/${user.uid}/profile_image.jpg');
      try {
        await storageRef.getDownloadURL(); // Check if object exists
        await storageRef.delete(); // Delete if it exists
      } catch (e) {
        if (e.toString().contains('object-not-found')) {
          // Image doesn't exist in Storage, proceed to clear Firestore
          print('No image found in Storage, proceeding to clear Firestore.');
        } else {
          throw e; // Rethrow other errors
        }
      }

      // Remove profileImageUrl from Firestore
      await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
        'profileImageUrl': null,
      }, SetOptions(merge: true));

      _profileImageUrl = null;
      _selectedImage = null;
      _isLoading = false;
      _safeNotifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error deleting image: $e';
      _isLoading = false;
      _safeNotifyListeners();
      print('Error deleting image: $e');
      return false;
    }
  }

  // Clear selected image (if user cancels before uploading)
  void clearSelectedImage() {
    _selectedImage = null;
    _safeNotifyListeners();
  }
}