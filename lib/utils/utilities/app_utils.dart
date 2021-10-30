import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as pp;
import '../constants/app_constants.dart';
import '../../ui/resources/app_strings.dart';

class AppUtils {
  const AppUtils._internal();

  static void showSnackBar({
    required BuildContext context,
    required String? content,
    int duration = 2,
    bool actionVisibility = false,
    String actionName = AppStrings.ok,
    VoidCallback? actionCallback,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content ?? ''),
        duration: Duration(seconds: duration),
        action: actionVisibility
            ? SnackBarAction(
                label: actionName.toUpperCase(),
                onPressed: () {
                  if (actionCallback != null) {
                    actionCallback();
                  }
                },
              )
            : null,
      ),
    );
  }

  static void removeCurrentFocus(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static Future<String> getAppVersion() async {
    PackageInfo package = await PackageInfo.fromPlatform();
    return '${package.version} (${package.buildNumber})';
  }

  static Future<String?> getFilePath(File? file) async {
    if (file == null) {
      return null;
    }
    final appDir = await pp.getApplicationDocumentsDirectory();
    final fileName = p.basename(file.path);
    final filePath = p.join(appDir.path, fileName);
    return filePath;
  }
}
