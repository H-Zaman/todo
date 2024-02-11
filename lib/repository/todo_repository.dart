import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:todo/controllers/auth_controller.dart';
import 'package:todo/model/todo.dart';

class TodoRepo{
  final CollectionReference _ref = FirebaseFirestore.instance.collection('todos');

  /// return all todos
  Stream<QuerySnapshot<Object?>> todosStream() {
    return _ref
      .where(
        /// when we delete a document
        /// we do not actually delete it
        /// we just change its state to deleted
        /// so fetching all documents which are not delete
        'state', isNotEqualTo: TodoState.deleted.name,
      )
      .where(
        /// fetch the todos where the notes belong to current user
        'user_id', isEqualTo: Get.find<AuthController>().user.uid
      ).snapshots();
  }

  /// add a document
  /// returns success
  Future<bool> addTodo(String string) async{
    try{
      final todo = Todo.fresh(string);
      await _ref.doc(todo.id).set(todo.toJson());
      return true;
    }catch(err){
      debugPrint(err.toString());
      return false;
    }
  }

  /// update a document
  /// returns success
  Future<bool> editTodo(Todo todo) async{
    try{
      await _ref.doc(todo.id).update(todo.toJson());
      return true;
    }catch(err){
      debugPrint(err.toString());
      return false;
    }
  }

  /// changes document status to [TodoState.deleted]
  /// returns success
  Future<bool> deleteTodo(Todo todo) async{
    try{
      /// change state to deleted instead of actually deleting the document
      /// who knows maybe one day will implement recover document
      todo.state = TodoState.deleted;
      await _ref.doc(todo.id).update(todo.toJson());
      return true;
    }catch(err){
      debugPrint(err.toString());
      return false;
    }
  }
}