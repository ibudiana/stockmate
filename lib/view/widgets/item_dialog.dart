part of 'widgets.dart';

class AddOrEditItemDialog extends StatefulWidget {
  final Item? item;

  const AddOrEditItemDialog({super.key, this.item});

  @override
  State<AddOrEditItemDialog> createState() => _AddOrEditItemDialogState();
}

class _AddOrEditItemDialogState extends State<AddOrEditItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final unitCtrl = TextEditingController();
  final stockCtrl = TextEditingController();
  final minStockCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      nameCtrl.text = widget.item!.name;
      unitCtrl.text = widget.item!.unit;
      stockCtrl.text = widget.item!.stock.toString();
      minStockCtrl.text = widget.item!.minStock?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<ItemViewModel>();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(
            widget.item == null
                ? Icons.add_box_rounded
                : Icons.edit_note_rounded,
            color: Colors.blueAccent,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            widget.item == null ? "Tambah Produk" : "Edit Produk",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- NAMA PRODUK ---
              CustomTextField(
                key: Key('nama_produk'),
                label: "Nama Produk",
                controller: nameCtrl,
                hint: "Contoh: Beras Premium",
                textCapitalization: TextCapitalization.sentences,
                validators: [
                  ValidatorHelper.requiredField,
                  ValidatorHelper.lettersOnly,
                  (value) => ValidatorHelper.minLength(
                    value,
                    5,
                    fieldName: "Nama Produk",
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- STOK & SATUAN (Sejajar) ---
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          key: Key('stok_awal'),
                          label: "Stok Awal",
                          controller: stockCtrl,
                          hint: "0",
                          keyboardType: TextInputType.number,
                          validators: [
                            ValidatorHelper.requiredField,
                            ValidatorHelper.number,
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          key: Key('satuan'),
                          label: "Satuan",
                          controller: unitCtrl,
                          hint: "Pcs/Kg",
                          validators: [
                            ValidatorHelper.requiredField,
                            ValidatorHelper.lettersOnly,
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- MINIMUM STOK ---
              CustomTextField(
                key: Key('min_stock'),
                label: "Batas Minimum Stok",
                controller: minStockCtrl,
                hint: "Contoh: 10",
                keyboardType: TextInputType.number,
                validators: [
                  ValidatorHelper.requiredField,
                  ValidatorHelper.number,
                ],
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      actions: [
        Row(
          children: [
            // Button Delete
            if (widget.item != null) ...[
              Expanded(
                child: CustomActionButton(
                  label: "Hapus",
                  icon: Icons.delete_outline,
                  color: Colors.red.shade700,
                  backgroundColor: Colors.red.shade50,
                  onTap: () {
                    _confirmDelete(context);
                  },
                ),
              ),
              const SizedBox(width: 8), // Jarak pemisah
            ],
            // TOMBOL BATAL (CustomActionButton)
            Expanded(
              child: CustomActionButton(
                label: "Batal",
                icon: Icons.close,
                color: Colors.grey.shade700,
                backgroundColor: Colors.grey.shade200,
                onTap: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(width: 12),

            // TOMBOL SIMPAN (CustomActionButton)
            Expanded(
              child: CustomActionButton(
                key: Key('simpan_button'),
                label: widget.item == null ? "Simpan" : "Update",
                icon: Icons.check_circle_outline,
                color: Colors.blue.shade800,
                backgroundColor: Colors.blue.shade50,
                onTap: () async {
                  // if (nameCtrl.text.isEmpty) return;
                  if (!_formKey.currentState!.validate()) return;

                  final newItem = Item(
                    id: widget.item?.id,
                    name: nameCtrl.text,
                    unit: unitCtrl.text,
                    stock: int.tryParse(stockCtrl.text) ?? 0,
                    minStock: int.tryParse(minStockCtrl.text),
                  );

                  if (widget.item == null) {
                    await vm.addItem(newItem);
                  } else {
                    await vm.updateItem(newItem);
                  }

                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Hapus Produk?"),
            content: Text(
              "Anda yakin ingin menghapus '${widget.item?.name}'? Data tidak dapat dikembalikan.",
            ),
            actions: [
              TextButton(
                onPressed:
                    () => Navigator.pop(ctx), // Close confirmation dialog
                child: const Text(
                  "Batal",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () async {
                  // 1. close confirmation dialog
                  Navigator.pop(ctx);
                  final vm = Provider.of<ItemViewModel>(context, listen: false);
                  await vm.deleteItem(widget.item!.id!);

                  // 3. close main Edit dialog
                  if (context.mounted) {
                    Navigator.pop(context);

                    // Opsional: notify user item deleted
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Produk berhasil dihapus")),
                    );
                  }
                },
                child: const Text(
                  "Hapus",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
