//library file_manager;
//
//import 'dart:collection';
//
//// TODO: FileManager will be part of v2.0.0
//
//
//class FileManager {
//  static Map<String, dynamic> directoryTree = new Map();
//
//  static Queue<String> workingPath = new Queue();
//
//  static initializeEmptyDirectory() {
//    if (directoryTree.isNotEmpty || workingPath.isNotEmpty) {
//      return;
//    }
//    directoryTree['~'] = new Map();
//    workingPath.add('~');
//  }
//
//  static initializeWithData(data) {}
//}
