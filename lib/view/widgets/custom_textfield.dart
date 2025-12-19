part of 'widgets.dart';

class CustomTextField extends StatelessWidget {
  final Key? fieldKey;
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final List<String? Function(String?)>? validators;
  final void Function(String)? onChanged;
  final bool isNumber;

  const CustomTextField({
    super.key,
    this.fieldKey,
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.isNumber = false,
    this.validators,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- LABEL DI ATAS ---
        Padding(
          padding: const EdgeInsets.only(bottom: 6, left: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ),

        // --- TEXT FIELD DENGAN STYLE ---
        TextFormField(
          key: fieldKey,
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          style: const TextStyle(color: Colors.black87),
          validator: (value) {
            if (validators != null && validators!.isNotEmpty) {
              return ValidatorHelper.combine(
                value,
                validators!,
                fieldName: label,
              );
            }
            if (isNumber) {
              return ValidatorHelper.number(value, fieldName: label);
            }
            return null;
          },
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
            ),
            isDense: true,
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
        ),
      ],
    );
  }
}
