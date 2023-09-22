import 'package:bible_app/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class UserController {
  final TextEditingController nameController = TextEditingController();
  Future<void> submitForm(BuildContext context, Box box) async {
    final String name = nameController.text.trim();
    final progress = ProgressHUD.of(context);
    progress?.show();

    if (name.isEmpty) {
      progress?.dismiss();
      OverlayState? state = Overlay.of(context);
      showTopSnackBar(
        state,
        const CustomSnackBar.error(
          message: "Please name is required",
        ),
      );
    } else {
      box.put('name', name);
      progress?.dismiss();
      int isViewed = 0;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('onBoard', isViewed);
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    }
  }

  Future<String?> userData(Box box) async {
    var name = box.get('name');
    return name;
  }
}
