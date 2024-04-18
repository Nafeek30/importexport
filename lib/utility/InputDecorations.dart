import 'package:flutter/material.dart';

/// Contains reusable code for outline borders for TextFormFields to add/edit inventory/orders.
class InputDecorations {

  /// Regular border decoration for when a TextFormField isn't focused/selected.
   regularBorderTextFormField() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Colors.black87,
        width: 1.0,
      ),
    );
  }

   /// Focused border decoration for when a TextFormField is in focus.
   focusedBorderTextFormField() {
     return OutlineInputBorder(
     borderRadius: BorderRadius.circular(8),
     borderSide: const BorderSide(
       color: Colors.teal,
       width: 1.0,
     ),
     );
   }
}