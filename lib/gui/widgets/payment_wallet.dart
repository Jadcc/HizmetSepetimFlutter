import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class PaymentWallet extends StatelessWidget {
  final double balance;
  final bool enabled;
  final bool useWallet;
  final void Function(bool) onChanged;

  const PaymentWallet({
    super.key,
    required this.balance,
    required this.enabled,
    required this.useWallet,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _box(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Cüzdan",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Bakiye"),
              Text(
                "₺${balance.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Opacity(
            opacity: enabled ? 1 : 0.5,
            child: SwitchListTile(
              value: useWallet,
              onChanged: enabled ? onChanged : null,
              title: const Text("Cüzdan bakiyesi kullan"),
            ),
          ),
          if (!enabled)
            const Text(
              "Cüzdan ile ödeme yakında aktif",
              style: TextStyle(fontSize: 12, color: textSoft),
            ),
        ],
      ),
    );
  }

  BoxDecoration _box() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 14,
        offset: const Offset(0, 6),
      ),
    ],
  );
}
