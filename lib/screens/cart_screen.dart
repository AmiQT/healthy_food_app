import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meal_provider.dart';
import '../providers/order_provider.dart';
import '../models/order_model.dart';
import '../utils/app_colors.dart';
import 'order_history_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _showAllOrders = false;

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);
    final cartMeals = mealProvider.getCartMealsWithQuantity();
    final totalQuantity = cartMeals.fold(0, (sum, e) => sum + e.value);
    final colors = AppColors.of(context);
    final isLoading = cartMeals.isEmpty && mealProvider.meals.isEmpty;
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        iconTheme: IconThemeData(color: colors.heading),
        title: Text('Cart', style: TextStyle(color: colors.heading)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Cart Items Section
                Expanded(
                  flex: 2,
                  child: cartMeals.isEmpty
                      ? Center(
                          child: Text(
                            'Your cart is empty.',
                            style: TextStyle(color: colors.bodyText),
                          ),
                        )
                      : ListView.builder(
                          itemCount: cartMeals.length,
                          itemBuilder: (context, index) {
                            final meal = cartMeals[index].key;
                            final qty = cartMeals[index].value;
                            return Card(
                              color: colors.card,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    meal.imageUrl.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: Image.network(
                                              meal.imageUrl,
                                              width: 56,
                                              height: 56,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Icon(
                                            Icons.fastfood,
                                            size: 40,
                                            color: colors.bodyText,
                                          ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            meal.name,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleLarge,
                                          ),
                                          Text(
                                            meal.category,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                          ),
                                          Text(
                                            'RM ${meal.price.toStringAsFixed(2)}',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.remove_circle,
                                            color: Colors.red,
                                          ),
                                          onPressed: () =>
                                              Provider.of<MealProvider>(
                                                context,
                                                listen: false,
                                              ).removeFromCart(meal.id),
                                        ),
                                        Text('$qty'),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.add_circle,
                                            color: Colors.green,
                                          ),
                                          onPressed: () =>
                                              Provider.of<MealProvider>(
                                                context,
                                                listen: false,
                                              ).addToCart(meal.id),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                // Order History Section
                if (orders.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.history),
                        label: const Text('View Order History'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.accent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const OrderHistoryScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                // Checkout and summary section (fixed at bottom)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Total items: $totalQuantity',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total: RM ${cartMeals.fold(0.0, (sum, e) => sum + e.key.price * e.value).toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: cartMeals.isEmpty
                            ? null
                            : () {
                                // --- PayPal integration (commented out for now) ---
                                /*
                                final total = cartMeals.fold(0.0, (sum, e) => sum + e.key.price * e.value);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => UsePaypal(
                                      sandboxMode: true,
                                      clientId: "YOUR-SANDBOX-CLIENT-ID",
                                      secretKey: "YOUR-SANDBOX-SECRET",
                                      returnURL: "https://samplesite.com/return",
                                      cancelURL: "https://samplesite.com/cancel",
                                      transactions: [
                                        {
                                          "amount": {
                                            "total": total.toStringAsFixed(2),
                                            "currency": "USD",
                                            "details": {
                                              "subtotal": total.toStringAsFixed(2),
                                              "shipping": '0',
                                              "shipping_discount": 0
                                            }
                                          },
                                          "description": "Healthy Food Order",
                                        }
                                      ],
                                      note: "Contact us for any questions on your order.",
                                      onSuccess: (Map params) async {
                                        // Place order on success
                                        final orderId = DateTime.now().millisecondsSinceEpoch.toString();
                                        final items = cartMeals
                                            .map((e) => OrderItem(meal: e.key, quantity: e.value))
                                            .toList();
                                        final order = Order(
                                          id: orderId,
                                          items: items,
                                          total: total,
                                          date: DateTime.now(),
                                        );
                                        Provider.of<OrderProvider>(context, listen: false).addOrder(order);
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Order Placed!'),
                                            content: const Text('Your order has been placed successfully.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                        );
                                        Provider.of<MealProvider>(context, listen: false).clearCart();
                                        Navigator.pop(context); // Close PayPal screen
                                      },
                                      onError: (error) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Payment Error'),
                                            content: Text('An error occurred: \n$error'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      onCancel: (params) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Payment Cancelled'),
                                            content: const Text('The payment was cancelled.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                                */
                                // --- End PayPal integration ---

                                // Original instant order placement logic:
                                final orderId = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString();
                                final items = cartMeals
                                    .map(
                                      (e) => OrderItem(
                                        meal: e.key,
                                        quantity: e.value,
                                      ),
                                    )
                                    .toList();
                                final total = cartMeals.fold(
                                  0.0,
                                  (sum, e) => sum + e.key.price * e.value,
                                );
                                final order = Order(
                                  id: orderId,
                                  items: items,
                                  total: total,
                                  date: DateTime.now(),
                                  status: 'Ordered',
                                );
                                Provider.of<OrderProvider>(
                                  context,
                                  listen: false,
                                ).addOrder(order);
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Order Placed!'),
                                    content: const Text(
                                      'Your order has been placed successfully.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                                Provider.of<MealProvider>(
                                  context,
                                  listen: false,
                                ).clearCart();
                              },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            colors.accent,
                          ),
                          foregroundColor: WidgetStateProperty.all<Color>(
                            Colors.white,
                          ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                          padding: WidgetStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 14,
                            ),
                          ),
                          elevation: WidgetStateProperty.all<double>(4),
                          shadowColor: WidgetStateProperty.all<Color?>(
                            colors.buttonShadow,
                          ),
                          overlayColor: WidgetStateProperty.resolveWith<Color?>(
                            (states) {
                              if (states.contains(WidgetState.hovered) ||
                                  states.contains(WidgetState.pressed)) {
                                return colors.buttonHover;
                              }
                              return null;
                            },
                          ),
                        ),
                        child: const Text('Checkout'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
