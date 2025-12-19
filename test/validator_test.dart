import 'package:flutter_test/flutter_test.dart';
import 'package:inventory/shared/validator.dart';

void main() {
  group('ValidatorHelper Tests', () {
    // ---------- requiredField ----------
    test('requiredField returns error if empty', () {
      // Arrange
      final value = '';
      final fieldName = 'Nama';

      // Act
      final result = ValidatorHelper.requiredField(value, fieldName: fieldName);

      // Assert
      expect(result, '$fieldName harus diisi');
    });

    test('requiredField returns null if not empty', () {
      // Arrange
      final value = 'Hello';

      // Act
      final result = ValidatorHelper.requiredField(value);

      // Assert
      expect(result, null);
    });

    // ---------- number ----------
    test('number returns error if empty', () {
      // Arrange
      final value = '';

      // Act
      final result = ValidatorHelper.number(value, fieldName: 'Angka');

      // Assert
      expect(result, 'Angka harus diisi');
    });

    test('number returns error if not a number', () {
      // Arrange
      final value = 'abc';

      // Act
      final result = ValidatorHelper.number(value, fieldName: 'Angka');

      // Assert
      expect(result, 'Angka harus berupa angka');
    });

    test('number returns null if valid number', () {
      // Arrange
      final value = '123';

      // Act
      final result = ValidatorHelper.number(value);

      // Assert
      expect(result, null);
    });

    // ---------- lettersOnly ----------
    test('lettersOnly returns error if empty', () {
      // Arrange
      final value = '';

      // Act
      final result = ValidatorHelper.lettersOnly(value, fieldName: 'Huruf');

      // Assert
      expect(result, 'Huruf harus diisi');
    });

    test('lettersOnly returns error if contains numbers', () {
      // Arrange
      final value = 'abc123';

      // Act
      final result = ValidatorHelper.lettersOnly(value, fieldName: 'Huruf');

      // Assert
      expect(result, 'Huruf harus berupa huruf saja');
    });

    test('lettersOnly returns null if only letters', () {
      // Arrange
      final value = 'Flutter';

      // Act
      final result = ValidatorHelper.lettersOnly(value);

      // Assert
      expect(result, null);
    });

    // ---------- combine ----------
    test('combine returns first error encountered', () {
      // Arrange
      final value = '';
      final validators = [
        (v) => ValidatorHelper.requiredField(v, fieldName: 'Field1'),
        (v) => ValidatorHelper.number(v, fieldName: 'Field1'),
      ];

      // Act
      final result = ValidatorHelper.combine(value, validators);

      // Assert
      expect(result, 'Field1 harus diisi');
    });

    test('combine returns null if all validators pass', () {
      // Arrange
      final value = '123';
      final validators = [
        (v) => ValidatorHelper.requiredField(v),
        (v) => ValidatorHelper.number(v),
      ];

      // Act
      final result = ValidatorHelper.combine(value, validators);

      // Assert
      expect(result, null);
    });
  });
}
