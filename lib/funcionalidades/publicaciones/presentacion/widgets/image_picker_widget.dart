import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:exif/exif.dart';
import '../bloc/publicacion_bloc.dart';
import '../bloc/publicacion_evento.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _pickImage(ImageSource source) async {
    try {
      // Bottom sheet is closed by onTap, don't close here
      
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('La cámara tardó demasiado en responder');
        },
      );
      
      if (pickedFile == null || !mounted) return;
      
      setState(() {
        _image = pickedFile;
      });
      
      // Process image in background to avoid blocking UI
      await _processImageWithLocation(pickedFile);
      
    } catch (e) {
      print('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al seleccionar imagen: $e')),
        );
      }
    }
  }

  Future<void> _processImageWithLocation(XFile pickedFile) async {
    try {
      final bytes = await File(pickedFile.path).readAsBytes();
      final base64 = base64Encode(bytes);

      double? lat, long;
      
      // Try to get GPS from EXIF
      try {
        final fileBytes = await File(pickedFile.path).readAsBytes();
        final data = await readExifFromBytes(fileBytes);
        print('EXIF data keys: ${data.keys}');
        
        if (data.containsKey('GPS GPSLatitude') && data.containsKey('GPS GPSLongitude')) {
          final latRef = data['GPS GPSLatitudeRef']?.printable ?? 'N';
          final lonRef = data['GPS GPSLongitudeRef']?.printable ?? 'E';
          final latValues = data['GPS GPSLatitude']?.values as List?;
          final lonValues = data['GPS GPSLongitude']?.values as List?;
          print('Lat values: $latValues, Lon values: $lonValues');
          
          if (latValues != null && lonValues != null && latValues.length >= 3 && lonValues.length >= 3) {
            lat = _convertToDecimal(latValues, latRef);
            long = _convertToDecimal(lonValues, lonRef);
            print('GPS from EXIF: lat=$lat, long=$long');
          }
        } else {
          print('No GPS in EXIF data found');
        }
      } catch (e) {
        print('Error reading EXIF (non-critical): $e');
        // Continue to try getting current location
      }

      // If no GPS from EXIF, try to get current location
      if (lat == null || long == null) {
        print('Trying to get current location as fallback...');
        try {
          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
          }
          
          if (permission == LocationPermission.whileInUse || 
              permission == LocationPermission.always) {
            Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
            ).timeout(
              const Duration(seconds: 10),
              onTimeout: () {
                throw TimeoutException('Timeout getting location');
              },
            );
            lat = position.latitude;
            long = position.longitude;
            print('Current location obtained: lat=$lat, long=$long');
          } else {
            print('Location permission not granted');
          }
        } catch (e) {
          print('Error getting location (non-critical): $e');
          // Continue without location
        }
      }

      print('Final coordinates: lat=$lat, long=$long');

      if (mounted) {
        context.read<PublicacionBloc>().add(
          ImagenSeleccionada(base64, longitud: long, latitud: lat),
        );
      }
    } catch (e) {
      print('Error processing image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error procesando imagen: $e')),
        );
      }
    }
  }

  double? _convertToDecimal(List values, String ref) {
    if (values.length < 3) return null;
    final degrees = (values[0] as Ratio).numerator / (values[0] as Ratio).denominator;
    final minutes = (values[1] as Ratio).numerator / (values[1] as Ratio).denominator;
    final seconds = (values[2] as Ratio).numerator / (values[2] as Ratio).denominator;
    double decimal = degrees + (minutes / 60) + (seconds / 3600);
    if (ref == 'S' || ref == 'W') decimal = -decimal;
    return decimal;
  }

  void _showPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galería'),
              onTap: () {
                _pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            if (!kIsWeb && (Platform.isAndroid || Platform.isIOS))
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Cámara'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_image != null)
          Image.file(
            File(_image!.path),
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          )
        else
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey[300],
            child: const Icon(Icons.image, size: 50),
          ),
        ElevatedButton(
          onPressed: _showPicker,
          child: const Text('Seleccionar Imagen'),
        ),
      ],
    );
  }
}