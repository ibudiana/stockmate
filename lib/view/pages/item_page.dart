part of 'pages.dart';

class ItemPage extends StatelessWidget {
  const ItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ItemViewModel>();

    return Scaffold(
      appBar: CustomAppBar(
        title: "Daftar Stok",
        subtitle: "Gudang Utama • ${vm.items.data?.length ?? 0} Barang",
        onSearch: (query) {
          vm.searchItems(query);
        },
        onFilterTap: () {
          // filter logic (opsional)
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Material(
        elevation: 5,
        shadowColor: Colors.blueAccent.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 40, maxWidth: 200),
          child: CustomActionButton(
            label: "Tambah Barang",
            icon: Icons.add_rounded,
            color: Colors.white,
            backgroundColor: Colors.blueAccent,
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => const AddOrEditItemDialog(),
              );
            },
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          final state = vm.items;

          switch (state.status) {
            case Status.loading:
              return const Center(child: CircularProgressIndicator());

            case Status.error:
              return Center(child: Text(state.message ?? "Error"));

            case Status.success:
              final items = state.data!;
              if (items.isEmpty) {
                return const Center(child: Text("No items yet."));
              }

              return ListView.builder(
                itemCount: items.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (_, i) {
                  final item = items[i];
                  final isLowStock =
                      item.minStock != null && item.stock <= item.minStock!;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // blue accent line on the left
                            Container(width: 6, color: Colors.blueAccent),
                            // main content
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // top section (Product Info & Stock)
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Left: Name & Unit
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.name,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "Satuan: ${item.unit}",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Right: Stock
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "Sisa Stok",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            Text(
                                              item.stock.toString(),
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            if (item.minStock != null)
                                              Text(
                                                "Min. ${item.minStock}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      isLowStock
                                                          ? Colors.red
                                                          : Colors.grey[600],
                                                  fontWeight:
                                                      isLowStock
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 16),
                                    const Divider(
                                      height: 1,
                                      thickness: 0.5,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 16),

                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomActionButton(
                                            label: "Stok Keluar",
                                            icon: Icons.keyboard_arrow_down,
                                            color: Colors.red,
                                            backgroundColor: Colors.red.shade50,
                                            onTap: () {
                                              // TODO: Add logic for stock out
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: CustomActionButton(
                                            label: "Stok Masuk",
                                            icon: Icons.keyboard_arrow_up,
                                            color: Colors.green,
                                            backgroundColor:
                                                Colors.green.shade50,
                                            onTap: () {
                                              // TODO: Add logic for stock in
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: CustomActionButton(
                                            label: "Edit",
                                            icon: Icons.edit_outlined,
                                            color: Colors.blueGrey,
                                            backgroundColor:
                                                Colors.grey.shade100,
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (_) => AddOrEditItemDialog(
                                                      item: item,
                                                    ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );

            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
