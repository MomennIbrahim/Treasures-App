import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService(this._firestore);

  /// يجيب كل المستندات في collection، مع فلاتر وترتيب اختياريين
  Future<List<Map<String, dynamic>>> getCollection({
    required String path,
    List<QueryFilter>? filters,
    String? orderByField,
    bool descending = false,
    int? limit,
  }) async {
    Query<Map<String, dynamic>> query = _firestore.collection(path);

    if (filters != null) {
      for (final filter in filters) {
        query = filter.apply(query);
      }
    }

    if (orderByField != null) {
      query = query.orderBy(orderByField, descending: descending);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data()})
        .toList();
  }

  /// يجيب مستند واحد بالـ id
  Future<Map<String, dynamic>?> getDocument({
    required String path,
    required String id,
  }) async {
    final doc = await _firestore.collection(path).doc(id).get();
    if (!doc.exists) return null;
    return {'id': doc.id, ...?doc.data()};
  }

  /// يضيف مستند جديد، بيرجع الـ id بتاعه
  Future<String> addDocument({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final ref = await _firestore.collection(path).add(data);
    return ref.id;
  }

  /// يعدل مستند موجود
  Future<void> updateDocument({
    required String path,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(path).doc(id).update(data);
  }

  /// يمسح مستند
  Future<void> deleteDocument({
    required String path,
    required String id,
  }) async {
    await _firestore.collection(path).doc(id).delete();
  }

  /// stream لمتابعة تحديثات collection لحظيًا (مفيد للسلة أو الإشعارات)
  Stream<List<Map<String, dynamic>>> streamCollection({
    required String path,
    List<QueryFilter>? filters,
    String? orderByField,
    bool descending = false,
  }) {
    Query<Map<String, dynamic>> query = _firestore.collection(path);

    if (filters != null) {
      for (final filter in filters) {
        query = filter.apply(query);
      }
    }

    if (orderByField != null) {
      query = query.orderBy(orderByField, descending: descending);
    }

    return query.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data()})
              .toList(),
        );
  }
}

/// يمثل شرط where واحد، عشان نقدر نمرر أكتر من شرط بسهولة
class QueryFilter {
  final String field;
  final dynamic isEqualTo;
  final dynamic isGreaterThan;
  final dynamic isLessThan;

  const QueryFilter({
    required this.field,
    this.isEqualTo,
    this.isGreaterThan,
    this.isLessThan,
  });

  Query<Map<String, dynamic>> apply(Query<Map<String, dynamic>> query) {
    if (isEqualTo != null) {
      query = query.where(field, isEqualTo: isEqualTo);
    }
    if (isGreaterThan != null) {
      query = query.where(field, isGreaterThan: isGreaterThan);
    }
    if (isLessThan != null) {
      query = query.where(field, isLessThan: isLessThan);
    }
    return query;
  }
}