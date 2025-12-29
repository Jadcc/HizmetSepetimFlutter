import 'package:flutter/material.dart';
import '../appData/api_service.dart';
import '../theme/colors.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final ApiService api = ApiService();
  final TextEditingController promoCodeController = TextEditingController();

  double balance = 0.0;
  List<WalletTransaction> transactions = [];
  bool loading = true;
  bool redeeming = false;
  String? errorText;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      loading = true;
      errorText = null;
    });

    try {
      final balanceResult = await api.getWalletBalance();
      final transactionsResult = await api.getWalletTransactions();

      if (!mounted) return;
      setState(() {
        balance = balanceResult;
        transactions = transactionsResult;
        loading = false;
      });
    } catch (e) {
      debugPrint("WALLET LOAD ERROR => $e");

      if (!mounted) return;
      setState(() {
        loading = false;
        errorText = "Veriler alınamadı. Lütfen tekrar deneyin.";
      });
    }
  }

  Future<void> _redeemCode() async {
    final code = promoCodeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Lütfen bir kod girin")));
      return;
    }

    setState(() {
      redeeming = true;
    });

    try {
      final result = await api.redeemPromoCode(code);
      promoCodeController.clear();

      if (!mounted) return;

      if (result != null && result["success"] == true) {
        final addedBalance = result["added_balance"] ?? 0.0;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Kod başarıyla kullanıldı! +₺$addedBalance"),
            backgroundColor: Colors.green,
          ),
        );
        _loadData();
      } else {
        final message = result?["message"] ?? "Kod kullanılamadı";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      debugPrint("REDEEM ERROR => $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Bir hata oluştu"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          redeeming = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator(color: primary));
    }

    if (errorText != null) {
      return Material(
        color: bg,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 44, color: primary),
                const SizedBox(height: 10),
                Text(
                  errorText!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: textSoft, fontSize: 14),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _loadData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Yeniden Dene",
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Material(
      color: bg,
      child: RefreshIndicator(
        onRefresh: _loadData,
        color: primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 150),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _balanceCard(),
              const SizedBox(height: 20),
              _promoCodeSection(),
              const SizedBox(height: 20),
              _transactionsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _balanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [primary, Color(0xFF3FB7A5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Cüzdan Bakiyeniz",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "₺${balance.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _promoCodeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Promosyon Kodu",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: textDark,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: promoCodeController,
                  decoration: InputDecoration(
                    hintText: "Kod girin",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: redeeming ? null : _redeemCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  child: redeeming
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Kullan",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _transactionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "İşlem Geçmişi",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: textDark,
          ),
        ),
        const SizedBox(height: 12),
        if (transactions.isEmpty)
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: textSoft.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text("Henüz işlem yok", style: TextStyle(color: textSoft)),
                ],
              ),
            ),
          )
        else
          ...transactions.map((transaction) => _transactionCard(transaction)),
      ],
    );
  }

  Widget _transactionCard(WalletTransaction transaction) {
    final isPositive = transaction.amount > 0;
    final icon = isPositive ? Icons.add_circle : Icons.remove_circle;
    final color = isPositive ? Colors.green : Colors.redAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(transaction.createdAt),
                  style: TextStyle(fontSize: 12, color: textSoft),
                ),
              ],
            ),
          ),
          Text(
            "${isPositive ? '+' : ''}₺${transaction.amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final day = dateTime.day.toString().padLeft(2, '0');
      final month = dateTime.month.toString().padLeft(2, '0');
      final year = dateTime.year;
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');

      return "$day.$month.$year $hour:$minute";
    } catch (e) {
      return dateTimeString;
    }
  }

  @override
  void dispose() {
    promoCodeController.dispose();
    super.dispose();
  }
}
