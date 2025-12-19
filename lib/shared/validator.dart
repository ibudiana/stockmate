class ValidatorHelper {
  // Validasi field wajib diisi
  static String? requiredField(String? value, {String? fieldName}) {
    final name = fieldName ?? 'Field';
    if (value == null || value.isEmpty) return '$name harus diisi';
    return null;
  }

  // Validasi angka
  static String? number(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.isEmpty) return '$fieldName harus diisi';
    if (int.tryParse(value) == null) return '$fieldName harus berupa angka';
    return null;
  }

  // Validasi huruf saja
  static String? lettersOnly(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.isEmpty) return '$fieldName harus diisi';
    final regex = RegExp(r'^[a-zA-Z ]+$');
    if (!regex.hasMatch(value)) return '$fieldName harus berupa huruf saja';
    return null;
  }

  // Validasi email
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email harus diisi';
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) return 'Format email tidak valid';
    return null;
  }

  // Validasi panjang minimal
  static String? minLength(
    String? value,
    int length, {
    String fieldName = 'Field',
  }) {
    if (value == null || value.isEmpty) return '$fieldName harus diisi';
    if (value.length < length) return '$fieldName minimal $length karakter';
    return null;
  }

  // Validasi panjang maksimal
  static String? maxLength(
    String? value,
    int length, {
    String fieldName = 'Field',
  }) {
    if (value != null && value.length > length) {
      return '$fieldName maksimal $length karakter';
    }
    return null;
  }

  // Gabungkan beberapa validator
  static String? combine(
    String? value,
    List<String? Function(String?)> validators, {
    String? fieldName,
  }) {
    for (var validator in validators) {
      final result = validator(value);
      if (result != null) {
        if (fieldName != null) {
          return result.replaceAll('Field', fieldName);
        }
        return result;
      }
    }
    return null;
  }
}
