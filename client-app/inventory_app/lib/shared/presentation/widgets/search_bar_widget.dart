import 'package:flutter/material.dart';

/// A reusable search bar widget with customizable appearance and behavior.
class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final String hintText;
  final bool autofocus;
  final bool showClearButton;
  final Color backgroundColor;
  final BorderRadius borderRadius;

  const SearchBarWidget({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.onClear,
    this.hintText = 'Search...',
    this.autofocus = false,
    this.showClearButton = true,
    this.backgroundColor = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateClearButtonVisibility);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateClearButtonVisibility);
    super.dispose();
  }

  void _updateClearButtonVisibility() {
    setState(() {
      _showClearButton = widget.controller.text.isNotEmpty;
    });
  }

  void _clearSearch() {
    widget.controller.clear();
    widget.onChanged('');
    if (widget.onClear != null) {
      widget.onClear!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        autofocus: widget.autofocus,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: const Icon(Icons.search),
          suffixIcon:
              _showClearButton && widget.showClearButton
                  ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  )
                  : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 16.0,
          ),
        ),
        textInputAction: TextInputAction.search,
      ),
    );
  }
}
