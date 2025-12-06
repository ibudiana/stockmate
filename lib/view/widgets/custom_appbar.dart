part of 'widgets.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final ValueChanged<String> onSearch;
  final VoidCallback? onFilterTap;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onSearch,
    this.onFilterTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _isSearching = false;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      if (_isSearching) {
        _isSearching = false;
        _searchCtrl.clear();
        widget.onSearch('');
      } else {
        _isSearching = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,

      title:
          _isSearching
              ? TextField(
                controller: _searchCtrl,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Cari data...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(fontSize: 18),
                onChanged: widget.onSearch, // Kirim ketikan ke parent
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            onPressed: _toggleSearch,
            style: IconButton.styleFrom(
              backgroundColor:
                  _isSearching ? Colors.red.shade50 : Colors.grey.shade100,
              shape: const CircleBorder(),
            ),
            icon: Icon(
              _isSearching ? Icons.close : Icons.search_rounded,
              color: _isSearching ? Colors.red : Colors.black54,
            ),
          ),
        ),

        // filter button gone when searching
        if (!_isSearching)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: widget.onFilterTap ?? () {},
              style: IconButton.styleFrom(
                backgroundColor: Colors.blue.shade50,
                shape: const CircleBorder(),
              ),
              icon: const Icon(Icons.tune_rounded, color: Colors.blueAccent),
            ),
          ),
      ],

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: Colors.grey.shade200, height: 1.0),
      ),
    );
  }
}
