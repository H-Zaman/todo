import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:todo/controllers/auth_controller.dart';
import 'package:todo/model/todo.dart';

class TodoRepo{
  final CollectionReference _ref = FirebaseFirestore.instance.collection('todos');
  final _LocalDb _localDb = _LocalDb();

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
  Future<bool> addTodo(Todo todo) async{
    try{

      if(todo.isLocal){
        return await _localDb.addTodo(todo);
      }else{
        await _ref.doc(todo.id).set(todo.toJson());
      }

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
      if(todo.isLocal){
        return await _localDb.editTodo(todo);
      }else{
        await _ref.doc(todo.id).update(todo.toJson());
      }
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
      if(todo.isLocal){
        return await _localDb.editTodo(todo);
      }else{
        await _ref.doc(todo.id).update(todo.toJson());
      }
      return true;
    }catch(err){
      debugPrint(err.toString());
      return false;
    }
  }

  Future<List<Todo>> getLocalTodos() async => await _localDb.getTodos();

}

class _LocalDb{

  AndroidOptions get _androidOptions => AndroidOptions(
    encryptedSharedPreferences: true,
  );

  final FlutterSecureStorage _storage = FlutterSecureStorage();

  final String _key = '_todos_';

  Future<List<Todo>> getTodos() async{
    String? response = await _storage.read(
      key: _key,
      aOptions: _androidOptions
    );
    if(response == null) return [];

    List<dynamic> data = jsonDecode(response);
    final list = List<Todo>.from(data.map((e) => Todo.fromJson(e)));
    list.removeWhere((element) => element.state == TodoState.deleted);
    list.sort((b,a) => a.createdAt.compareTo(b.createdAt));
    return list;
  }

  Future<bool> addTodo(Todo todo) async{
    try{
      final todos = await getTodos();
      todos.add(todo);
      await _storage.write(
        key: _key,
        value: jsonEncode(List<Map<String, dynamic>>.from(todos.map((e) => e.toJson()))),
        aOptions: _androidOptions
      );
      return true;
    }catch(err){
      debugPrint(err.toString());
      return false;
    }
  }

  Future<bool> editTodo(Todo todo) async{
    try{
      final todos = await getTodos();
      final indexOfItem = todos.indexWhere((element) => element.id == todo.id);
      todos[indexOfItem] = todo;
      await _storage.write(
        key: _key,
        value: jsonEncode(List<Map<String, dynamic>>.from(todos.map((e) => e.toJson()))),
        aOptions: _androidOptions
      );
      return true;
    }catch(err){
      debugPrint(err.toString());
      return false;
    }
  }
}