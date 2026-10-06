import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDbService {
  final SupabaseClient _client;

  SupabaseDbService(this._client);

  // ═════════════════════════════════════════════
  // Auth (Phone OTP)
  // ═════════════════════════════════════════════

  User? get currentUser => _client.auth.currentUser;

  bool get isLoggedIn => _client.auth.currentSession != null;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// يبعت كود SMS للرقم (وينشئ الحساب لو جديد).
  /// الرقم لازم بصيغة دولية: +201012345678
  Future<void> sendOtp({required String phone}) async {
    await _client.auth.signInWithOtp(phone: phone);
  }

  /// يتحقق من الكود ويسجل الدخول.
  Future<AuthResponse> verifyOtp({
    required String phone,
    required String token,
  }) async {
    return _client.auth.verifyOTP(
      phone: phone,
      token: token,
      type: OtpType.sms,
    );
  }

  /// يحفظ الاسم في بيانات اليوزر وفي جدول profiles.
  Future<void> updateUserName({required String name}) async {
    await _client.auth.updateUser(UserAttributes(data: {'name': name}));

    final id = currentUser?.id;
    if (id != null) {
      await _client.from('profiles').update({'name': name}).eq('id', id);
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<void> callRpc({
    required String function,
    Map<String, dynamic>? params,
  }) async {
    await _client.rpc(function, params: params);
  }

  /// يجيب كل الصفوف من جدول، مع فلاتر وترتيب اختياريين
  Future<List<Map<String, dynamic>>> getCollection({
    required String path, // اسم الجدول (table)
    String columns = '*',
    List<QueryFilter>? filters,
    String? orderByField,
    bool descending = false,
    int? limit,
  }) async {
    dynamic query = _client.from(path).select(columns);

    if (filters != null) {
      for (final filter in filters) {
        query = filter.apply(query);
      }
    }

    if (orderByField != null) {
      query = query.order(orderByField, ascending: !descending);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    final response = await query as List<dynamic>;
    return response.cast<Map<String, dynamic>>();
  }

  /// يجيب صف واحد بالـ id
  Future<Map<String, dynamic>?> getDocument({
    required String path,
    required int id,
    String columns = '*', // جديد
  }) async {
    final response = await _client
        .from(path)
        .select(columns)
        .eq('id', id)
        .maybeSingle();
    return response;
  }

  /// يضيف صف جديد، بيرجع الـ id بتاعه
  Future<String> addDocument({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final response = await _client.from(path).insert(data).select().single();
    return response['id'].toString();
  }

  /// يعدل صف موجود
  Future<void> updateDocument({
    required String path,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    await _client.from(path).update(data).eq('id', id);
  }

  /// يمسح صف
  Future<void> deleteDocument({
    required String path,
    required String id,
  }) async {
    await _client.from(path).delete().eq('id', id);
  }

  /// stream لمتابعة تحديثات الجدول لحظيًا (Realtime)
  Stream<List<Map<String, dynamic>>> streamCollection({
    required String path,
    String? filterField,
    dynamic filterValue,
    String? orderByField,
    bool descending = false,
  }) {
    final baseStream = _client.from(path).stream(primaryKey: ['id']);

    final filteredStream = (filterField != null && filterValue != null)
        ? baseStream.eq(filterField, filterValue)
        : baseStream;

    final finalStream = orderByField != null
        ? filteredStream.order(orderByField, ascending: !descending)
        : filteredStream;

    return finalStream;
  }
}

/// يمثل شرط where واحد، بنفس شكل الفيرستور تمامًا
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

  dynamic apply(dynamic query) {
    if (isEqualTo != null) {
      query = query.eq(field, isEqualTo);
    }
    if (isGreaterThan != null) {
      query = query.gt(field, isGreaterThan);
    }
    if (isLessThan != null) {
      query = query.lt(field, isLessThan);
    }
    return query;
  }
}
