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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF4F7ED),
      drawer: const BuyerDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Articles (2)', true),
                    const SizedBox(height: 12),
                    _buildCartItem(
                      imageUrl: 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=200&h=200&fit=crop',
                      title: 'Pommes de terre de Labé',
                      pricePerKg: '12,000 GNF / kg',
                      totalPrice: '36,000 GNF',
                      quantity: 3,
                    ),
                    const SizedBox(height: 12),
                    _buildCartItem(
                      imageUrl: 'https://images.unsplash.com/photo-1518977956812-cd3dbadaaf31?w=200&h=200&fit=crop',
                      title: 'Oignons de Timbi Madina',
                      pricePerKg: '8,500 GNF / kg',
                      totalPrice: '42,500 GNF',
                      quantity: 5,
                    ),
                    const SizedBox(height: 24),
                    _buildDeliveryDetails(),
                    const SizedBox(height: 24),
                    _buildPaymentMethods(),
                    const SizedBox(height: 24),
                    _buildSummary(),
                    const SizedBox(height: 100), // Space for bottom button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BuyerBottomNav(currentIndex: 3),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildCheckoutBottomSection(),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: const Icon(Icons.menu_rounded, color: Color(0xFF2A312A), size: 28),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Mon Panier',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF141A14)),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.mic_none_rounded, color: AppColors.primary, size: 26),
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
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF141A14)),
        ),
        if (showAudioAssist)
          Row(
            children: const [
              Icon(Icons.volume_up_rounded, color: AppColors.primary, size: 18),
              SizedBox(width: 4),
              Text(
                'Audio Assist',
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildCartItem({
    required String imageUrl,
    required String title,
    required String pricePerKg,
    required String totalPrice,
    required int quantity,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
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
                        title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF3B443B)),
                      ),
                    ),
                    const Icon(Icons.delete_outline_rounded, color: Color(0xFFB3261E), size: 22),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  pricePerKg,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF637060)),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      totalPrice,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFFA54B1A)),
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
                            onPressed: () {},
                            icon: const Icon(Icons.remove, size: 18, color: Color(0xFF4A554A)),
                          ),
                          Text(
                            '$quantity',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 36),
                            onPressed: () {},
                            icon: const CircleAvatar(
                              radius: 12,
                              backgroundColor: AppColors.primary,
                              child: Icon(Icons.add, size: 16, color: Colors.white),
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
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF637060), letterSpacing: 0.5),
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
                  const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quartier Koulidara, Labé',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF141A14)),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Près de la Grande Mosquée',
                          style: TextStyle(fontSize: 13, color: Color(0xFF4A554A)),
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Modifier l\'adresse',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
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
                  const Icon(Icons.access_time_rounded, color: Color(0xFFB1651B), size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Livraison estimée',
                          style: TextStyle(fontSize: 14, color: Color(0xFF4A554A)),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Aujourd\'hui, entre 14:00 - 17:00',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF98450F)),
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
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF637060), letterSpacing: 0.5),
        ),
        const SizedBox(height: 10),
        _buildPaymentOption('Orange Money', Icons.phone_android_rounded, const Color(0xFFFF6600)),
        const SizedBox(height: 10),
        _buildPaymentOption('Mobile Money', Icons.payments_rounded, const Color(0xFFFFCC00)),
        const SizedBox(height: 10),
        _buildPaymentOption('Paiement à la livraison', Icons.local_shipping_outlined, AppColors.primary),
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
          border: Border.all(color: isSelected ? AppColors.primary : const Color(0xFFDDE6D5), width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF141A14)),
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
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
            children: const [
              Text('Sous-total', style: TextStyle(fontSize: 14, color: Color(0xFF4A554A))),
              Text('78,500 GNF', style: TextStyle(fontSize: 14, color: Color(0xFF4A554A))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Frais de livraison (Labé)', style: TextStyle(fontSize: 14, color: Color(0xFF4A554A))),
              Text('5,000 GNF', style: TextStyle(fontSize: 14, color: Color(0xFF4A554A))),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(color: Color(0xFFDDE6D5), height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Total à payer', style: TextStyle(fontSize: 16, color: Color(0xFF2A312A))),
              Text('83,500 GNF', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: AppColors.primary)),
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
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Confirmer la commande', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                  SizedBox(width: 8),
                  Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.volume_up_rounded, color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                Text(
                  'Entendre le résumé de la commande\n(Pular)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
