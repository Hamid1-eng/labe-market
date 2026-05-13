import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../widgets/buyer_bottom_nav.dart';
import '../../widgets/buyer_drawer.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedPaymentMethod = 'Orange Money';
  String _address = 'Quartier Koulidara, Labé';

  // Simple in-memory cart entries for this screen
  final List<_CartEntry> _cart = [
    _CartEntry(
      id: 'local-3',
      imageUrl:
          'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=400&h=300&fit=crop',
      title: 'Pommes de terre de Labé',
      pricePerUnit: 12000,
      unitLabel: 'kg',
      quantity: 3,
    ),
    _CartEntry(
      id: 'local-4',
      imageUrl:
          'https://images.unsplash.com/photo-1599599810694-b5ac4dd64b73?w=400&h=300&fit=crop',
      title: 'Oignons de Timbi Madina',
      pricePerUnit: 8500,
      unitLabel: 'kg',
      quantity: 5,
    ),
  ];

  int get _subtotal => _cart.fold(0, (s, e) => s + e.pricePerUnit * e.quantity);
  int get _deliveryFee => _cart.isEmpty ? 0 : 5000;
  int get _total => _subtotal + _deliveryFee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF4F7ED),
      drawer: const BuyerDrawer(),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('Articles (${_cart.length})', true),
                        const SizedBox(height: 12),
                        ..._cart.map(
                          (e) => Column(
                            children: [
                              _buildCartItem(entry: e),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildDeliveryDetails(),
                        const SizedBox(height: 24),
                        _buildPaymentMethods(),
                        const SizedBox(height: 24),
                        _buildSummary(),
                        const SizedBox(height: 180), // Space for bottom button
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildCheckoutBottomSection(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BuyerBottomNav(currentIndex: 3),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: const Icon(
              Icons.menu_rounded,
              color: Color(0xFF2A312A),
              size: 28,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Mon Panier',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF141A14),
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.primary,
              size: 26,
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.mic_none_rounded,
              color: AppColors.primary,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, [bool showAudioAssist = false]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF141A14),
          ),
        ),
        if (showAudioAssist)
          Row(
            children: const [
              Icon(Icons.volume_up_rounded, color: AppColors.primary, size: 18),
              SizedBox(width: 4),
              Text(
                'Audio Assist',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildCartItem({required _CartEntry entry}) {
    final e = entry;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              e.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        e.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF3B443B),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => _removeItem(e.id),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: Color(0xFFB3261E),
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${e.pricePerUnit} GNF / ${e.unitLabel}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF637060),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${e.pricePerUnit * e.quantity} GNF',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFA54B1A),
                      ),
                    ),
                    Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F4EC),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFCDE0C4)),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 36),
                            onPressed: () => _decrement(e.id),
                            icon: const Icon(
                              Icons.remove,
                              size: 18,
                              color: Color(0xFF4A554A),
                            ),
                          ),
                          Text(
                            '${e.quantity}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 36),
                            onPressed: () => _increment(e.id),
                            icon: const CircleAvatar(
                              radius: 12,
                              backgroundColor: AppColors.primary,
                              child: Icon(
                                Icons.add,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DÉTAILS DE LIVRAISON',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF637060),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEFEFEE),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFDFE6D9)),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _address,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF141A14),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Près de la Grande Mosquée',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF4A554A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: _editAddress,
                          child: const Text(
                            'Modifier l\'adresse',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: Color(0xFFD3DBCB), height: 1),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    color: Color(0xFFB1651B),
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Livraison estimée',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4A554A),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Aujourd\'hui, entre 14:00 - 17:00',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF98450F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'MODE DE PAIEMENT',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF637060),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        _buildPaymentOption(
          'Orange Money',
          Icons.phone_android_rounded,
          const Color(0xFFFF6600),
        ),
        const SizedBox(height: 10),
        _buildPaymentOption(
          'Mobile Money',
          Icons.payments_rounded,
          const Color(0xFFFFCC00),
        ),
        const SizedBox(height: 10),
        _buildPaymentOption(
          'Paiement à la livraison',
          Icons.local_shipping_outlined,
          AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildPaymentOption(String title, IconData icon, Color iconColor) {
    final isSelected = _selectedPaymentMethod == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3F7ED) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFDDE6D5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF141A14),
                ),
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.primary : const Color(0xFFB5BFAD),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDE6D5)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sous-total',
                style: TextStyle(fontSize: 14, color: Color(0xFF4A554A)),
              ),
              Text(
                '$_subtotal GNF',
                style: const TextStyle(fontSize: 14, color: Color(0xFF4A554A)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Frais de livraison (Labé)',
                style: TextStyle(fontSize: 14, color: Color(0xFF4A554A)),
              ),
              Text(
                '$_deliveryFee GNF',
                style: const TextStyle(fontSize: 14, color: Color(0xFF4A554A)),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(color: Color(0xFFDDE6D5), height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total à payer',
                style: TextStyle(fontSize: 16, color: Color(0xFF2A312A)),
              ),
              Text(
                '$_total GNF',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutBottomSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: _cart.isEmpty ? null : _confirmOrder,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Confirmer la commande',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _playSummary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.volume_up_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Entendre le résumé de la commande\n(Pular)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _increment(String id) {
    setState(() {
      final i = _cart.indexWhere((c) => c.id == id);
      if (i != -1) _cart[i].quantity++;
    });
  }

  void _decrement(String id) {
    setState(() {
      final i = _cart.indexWhere((c) => c.id == id);
      if (i != -1) {
        if (_cart[i].quantity > 1) {
          _cart[i].quantity--;
        } else {
          _cart.removeAt(i);
        }
      }
    });
  }

  void _removeItem(String id) {
    setState(() {
      _cart.removeWhere((c) => c.id == id);
    });
  }

  void _editAddress() async {
    final ctl = TextEditingController(text: _address);
    final res = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Modifier l\'adresse'),
        content: TextField(
          controller: ctl,
          decoration: const InputDecoration(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(ctl.text),
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
    if (res != null && res.trim().isNotEmpty) {
      setState(() => _address = res.trim());
    }
  }

  void _confirmOrder() {
    // Simulate order confirmation
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmer la commande'),
        content: Text(
          'Total à payer: $_total GNF\nMode: $_selectedPaymentMethod',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _cart.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Commande confirmée')),
              );
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  void _playSummary() {
    if (_cart.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Le panier est vide')));
      return;
    }
    final buffer = StringBuffer();
    buffer.writeln('Résumé de la commande:');
    for (final e in _cart) {
      buffer.writeln('- ${e.title}, ${e.quantity} x ${e.pricePerUnit} GNF');
    }
    buffer.writeln('Total: $_total GNF');
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Résumé'),
        content: Text(buffer.toString()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}

class _CartEntry {
  final String id;
  final String imageUrl;
  final String title;
  final int pricePerUnit;
  final String unitLabel;
  int quantity;

  _CartEntry({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.pricePerUnit,
    required this.unitLabel,
    this.quantity = 1,
  });
}
