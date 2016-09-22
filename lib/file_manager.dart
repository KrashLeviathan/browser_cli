library file_manager;

import 'dart:collection';

class FileManager {
  static Map<String, dynamic> directoryTree = new Map();

  static Queue<String> workingPath = new Queue();

  static initializeEmptyDirectory() {
    if (directoryTree.isNotEmpty || workingPath.isNotEmpty) {
      return;
    }
    directoryTree['~'] = new Map();
    workingPath.add('~');
  }

  static initializeWithData(data) {}
}
