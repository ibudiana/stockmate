import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory/data/response/data_response.dart';
import 'package:inventory/model/model.dart';
import 'package:inventory/view/pages/pages.dart';
import 'package:inventory/view/widgets/widgets.dart';
import 'package:inventory/viewmodel/item_viewmodel.dart';
import 'package:provider/provider.dart';

class FakeItemViewModel extends ChangeNotifier implements ItemViewModel {
  @override
  DataResponse<List<Item>> items = DataResponse.loading();

  @override
  late DataResponse<Item?> selectedItem;

  @override
  Future<void> searchItems(String query) async {}

  @override
  Future<void> addItem(Item item) async {}

  @override
  Future<void> deleteItem(int id) async {}

  @override
  Future<void> fetchItems() async {}

  @override
  Future<void> updateItem(Item item) async {}
}

void main() {
  Widget buildTestable(Widget child, ItemViewModel vm) {
    return ChangeNotifierProvider<ItemViewModel>.value(
      value: vm,
      child: MaterialApp(home: child),
    );
  }

  // Group TextWidget no validation tests
  group("No Validator Helper", () {
    testWidgets('Menampilkan loading saat status loading', (tester) async {
      // --- Arrange ---
      final vm = FakeItemViewModel()..items = DataResponse.loading();

      // --- Act ---
      await tester.pumpWidget(buildTestable(const ItemPage(), vm));

      // --- Assert ---
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Menampilkan pesan error saat status error', (tester) async {
      // --- Arrange ---
      final vm =
          FakeItemViewModel()..items = DataResponse.error('Gagal load data');

      // --- Act ---
      await tester.pumpWidget(buildTestable(const ItemPage(), vm));

      // --- Assert ---
      expect(find.text('Gagal load data'), findsOneWidget);
    });

    testWidgets('Menampilkan empty state saat data kosong', (tester) async {
      // --- Arrange ---
      final vm = FakeItemViewModel()..items = DataResponse.success([]);

      // --- Act ---
      await tester.pumpWidget(buildTestable(const ItemPage(), vm));

      // --- Assert ---
      expect(find.text('No items yet.'), findsOneWidget);
    });

    testWidgets('Menampilkan list item saat data tersedia', (tester) async {
      // --- Arrange ---
      final vm =
          FakeItemViewModel()
            ..items = DataResponse.success([
              Item(id: 1, name: 'Pensil', unit: 'Pcs', stock: 5, minStock: 10),
            ]);

      // --- Act ---
      await tester.pumpWidget(buildTestable(const ItemPage(), vm));

      // --- Assert ---
      expect(find.text('Pensil'), findsOneWidget);
      expect(find.text('Satuan: Pcs'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('Min. 10'), findsOneWidget);
    });
  });

  testWidgets('Klik Tambah Barang membuka dialog', (tester) async {
    // --- Arrange ---
    final vm = FakeItemViewModel()..items = DataResponse.success([]);

    await tester.pumpWidget(buildTestable(const ItemPage(), vm));
    await tester.pumpAndSettle();

    // --- Act ---
    await tester.tap(find.text('Tambah Barang'));
    await tester.pumpAndSettle();

    // --- Assert ---
    expect(find.byType(AddOrEditItemDialog), findsOneWidget);
  });

  // Group TextWidget validation tests
  group('ValidatorHelper Tests', () {
    testWidgets('Field kosong menampilkan error', (tester) async {
      // --- Arrange ---
      final vm = FakeItemViewModel();

      await tester.pumpWidget(buildTestable(const AddOrEditItemDialog(), vm));
      await tester.pumpAndSettle();

      // --- Act ---
      await tester.tap(find.byKey(const Key('simpan_button')));
      await tester.pumpAndSettle();

      // --- Assert ---
      expect(find.text('Nama Produk harus diisi'), findsOneWidget);
      expect(find.text('Stok Awal harus diisi'), findsOneWidget);
      expect(find.text('Satuan harus diisi'), findsOneWidget);
      expect(find.text('Batas Minimum Stok harus diisi'), findsOneWidget);
    });

    testWidgets('Validator: Nama Produk dan Satuan harus huruf', (
      tester,
    ) async {
      // --- Arrange ---
      final vm = FakeItemViewModel();

      await tester.pumpWidget(buildTestable(const AddOrEditItemDialog(), vm));
      await tester.pumpAndSettle();

      // --- Act ---
      // test field with valid input
      await tester.enterText(find.byKey(const Key('nama_produk')), '123456');
      await tester.enterText(find.byKey(const Key('satuan')), '123');

      // test field with invalid input
      await tester.enterText(find.byKey(const Key('stok_awal')), '100');
      await tester.enterText(find.byKey(const Key('min_stock')), '10');

      await tester.tap(find.byKey(const Key('simpan_button')));
      await tester.pumpAndSettle();

      // --- Assert ---
      expect(find.text('Nama Produk harus berupa huruf saja'), findsOneWidget);
      expect(find.text('Satuan harus berupa huruf saja'), findsOneWidget);
    });

    testWidgets('Validator: stok dan minStock harus angka', (tester) async {
      // --- Arrange ---
      final vm = FakeItemViewModel();

      await tester.pumpWidget(buildTestable(const AddOrEditItemDialog(), vm));
      await tester.pumpAndSettle();

      // --- Act ---
      // test field with valid input
      await tester.enterText(
        find.byKey(const Key('nama_produk')),
        'Beras Premium',
      );
      await tester.enterText(find.byKey(const Key('satuan')), 'Kg');

      // test field with invalid input
      await tester.enterText(find.byKey(const Key('stok_awal')), 'abc');
      await tester.enterText(find.byKey(const Key('min_stock')), 'xyz');

      await tester.tap(find.byKey(const Key('simpan_button')));
      await tester.pumpAndSettle();

      // --- Assert ---
      expect(find.text('Stok Awal harus berupa angka'), findsOneWidget);
      expect(
        find.text('Batas Minimum Stok harus berupa angka'),
        findsOneWidget,
      );
    });

    testWidgets('Validator: input valid tidak menampilkan error', (
      tester,
    ) async {
      // --- Arrange ---
      final vm = FakeItemViewModel();
      await tester.pumpWidget(buildTestable(AddOrEditItemDialog(), vm));

      // --- Act ---
      await tester.enterText(
        find.byKey(const Key('nama_produk')),
        'Beras Premium',
      );
      await tester.enterText(find.byKey(const Key('satuan')), 'Kg');
      await tester.enterText(find.byKey(const Key('stok_awal')), '101');
      await tester.enterText(find.byKey(const Key('min_stock')), '10');

      await tester.tap(find.byKey(const Key('simpan_button')));
      await tester.pumpAndSettle();

      // --- Assert ---
      // --- Assert ---
      expect(find.text('Nama Produk harus diisi'), findsNothing);
      expect(find.text('Stok Awal harus diisi'), findsNothing);
      expect(find.text('Satuan harus diisi'), findsNothing);
      expect(find.text('Batas Minimum Stok harus diisi'), findsNothing);

      expect(find.text('Stok Awal harus berupa angka'), findsNothing);
      expect(find.text('Batas Minimum Stok harus berupa angka'), findsNothing);
    });
  });
}
