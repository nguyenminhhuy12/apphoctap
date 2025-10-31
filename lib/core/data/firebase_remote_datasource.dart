import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRemoteDatasource<T> {
  final String collectionName;
  final T Function(DocumentSnapshot doc) fromFirestore;
  final Map<String, dynamic> Function(T item) toFirestore;

  FirebaseRemoteDatasource({
    required this.collectionName,
    required this.toFirestore,
    required this.fromFirestore
  });

  CollectionReference get _collection =>
  FirebaseFirestore.instance.collection(collectionName);
  
  Future<List<T>> getAll() async{
    print('📡 [FirebaseRemoteDS] Bắt đầu lấy dữ liệu từ collection "$collectionName"...');
    try{
      final snapshot = await _collection.get();
      print('fire store tra ve: ${snapshot.docs.length}');
      if(snapshot.docs.isEmpty){
        print('khong tim thay du lieu trong firestore');
      }
      for(var n in snapshot.docs){
        print('du lieu [FireBaseRemoteDataSource]: id:${n.id}, du lieu:${n.data()}');
      }
      final result = snapshot.docs.map((e)=>fromFirestore(e)).toList();
      print('du lieu tu firebase da chuyen doi thanh list: ${result.length} model');
      return result;
    }
    catch(e, stack){
      print('❌ [FirebaseRemoteDS] Lỗi khi lấy dữ liệu từ "$collectionName": $e');
    print(stack);
    return [];
    }
  }
  Future<T?> getById(String id) async {
    final getdata = await _collection.doc(id).get();
    if(!getdata.exists){
      final docid = await _collection.get();
      return fromFirestore(docid.docs.first);
    }
    return fromFirestore(getdata);
  }
  Future<String> add(T item) async{
    final docRef = await _collection.add(toFirestore(item));
    return docRef.id;
  }
  Future<void> update(String id,T item) async{
    await _collection.doc(id).update(toFirestore(item));
  }
  Future<void> delete(String id) async{
    await _collection.doc(id).delete();
  }
  Stream<List<T>> watchAll(){
    return _collection.snapshots().map(
      (snapshot)=> snapshot.docs.map((e) => fromFirestore(e)).toList());
  }
  Future<void> createEmptyCollection(String name) async {
    print('📁 [FirebaseRemoteDS] Tạo collection rỗng "$name"...');
    try {
      final collectionRef = FirebaseFirestore.instance.collection(name);
      final tempDocRef = collectionRef.doc('_temp_');

      // 1️⃣ Tạo document tạm để buộc Firestore tạo collection
      await tempDocRef.set({'createdAt': FieldValue.serverTimestamp()});

      // 2️⃣ Xóa document đó ngay sau khi tạo
      await tempDocRef.delete();

      // 3️⃣ Kiểm tra lại collection còn bao nhiêu document
      final check = await FirebaseFirestore.instance.collection(name).get();
      print('🔍 Số lượng doc trong "$name": ${check.docs.length}');

      print('✅ Collection "$name" đã được tạo và hiện đang trống.');
    } catch (e, stack) {
      print('❌ [FirebaseRemoteDS] Lỗi khi tạo collection "$name": $e');
      print(stack);
    }
  }
}