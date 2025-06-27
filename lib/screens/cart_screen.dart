import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meal_provider.dart';
import '../providers/order_provider.dart';
import '../models/order_model.dart';
import '../utils/app_colors.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

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
    int totalQuantity = cartMeals.fold(0, (sum, e) => sum + e.value);
    final colors = AppColors.of(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;
    final ordersToShow = _showAllOrders
        ? orders
        : (orders.isNotEmpty ? [orders.first] : []);
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        iconTheme: IconThemeData(color: colors.heading),
        title: Text('Cart', style: TextStyle(color: colors.heading)),
      ),
      body: Column(
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
                                      borderRadius: BorderRadius.circular(12),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      'RM ' + meal.price.toStringAsFixed(2),
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
                                        mealProvider.removeFromCart(meal.id),
                                  ),
                                  Text('$qty'),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_circle,
                                      color: Colors.green,
                                    ),
                                    onPressed: () =>
                                        mealProvider.addToCart(meal.id),
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
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order History:',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (orders.length > 1)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _showAllOrders = !_showAllOrders;
                              });
                            },
                            child: Text(_showAllOrders ? 'Hide' : 'Show All'),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: ordersToShow.length,
                      itemBuilder: (context, idx) {
                        final order = ordersToShow[idx];
                        return Card(
                          color: colors.card,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(color: colors.border, width: 1.2),
                          ),
                          child: ListTile(
                            title: Text(
                              'Order #${order.id.substring(order.id.length - 5)}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date: ${order.date.toLocal().toString().split(".")[0]}',
                                ),
                                Text(
                                  'Total: RM ${order.total.toStringAsFixed(2)}',
                                ),
                                Text('Status: ${order.status}'),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8.0,
                                    bottom: 4.0,
                                  ),
                                  child: SizedBox(
                                    height: 48,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            for (
                                              int i = 0;
                                              i < Order.statuses.length;
                                              i++
                                            ) ...[
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CircleAvatar(
                                                    radius:
                                                        i ==
                                                            Order
                                                                    .statuses
                                                                    .length -
                                                                1
                                                        ? 13
                                                        : 10,
                                                    backgroundColor:
                                                        Order.statuses.indexOf(
                                                              order.status,
                                                            ) >=
                                                            i
                                                        ? Colors.green
                                                        : Colors.grey[300],
                                                    child: Icon(
                                                      i == 0
                                                          ? Icons.receipt
                                                          : i == 1
                                                          ? Icons.kitchen
                                                          : i == 2
                                                          ? Icons
                                                                .delivery_dining
                                                          : Icons.check_circle,
                                                      size:
                                                          i ==
                                                              Order
                                                                      .statuses
                                                                      .length -
                                                                  1
                                                          ? 18
                                                          : 14,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(height: 2),
                                                  Text(
                                                    Order.statuses[i],
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color:
                                                          Order.statuses
                                                                  .indexOf(
                                                                    order
                                                                        .status,
                                                                  ) >=
                                                              i
                                                          ? Colors.green[800]
                                                          : Colors.grey,
                                                      fontWeight:
                                                          Order.statuses
                                                                  .indexOf(
                                                                    order
                                                                        .status,
                                                                  ) ==
                                                              i
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (i < Order.statuses.length - 1)
                                                Container(
                                                  width: 24,
                                                  height: 2,
                                                  color:
                                                      Order.statuses.indexOf(
                                                            order.status,
                                                          ) >
                                                          i
                                                      ? Colors.green
                                                      : Colors.grey[300],
                                                ),
                                            ],
                                            if (order.status == 'Completed')
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                ),
                                                child: Icon(
                                                  Icons.verified,
                                                  color: Colors.green,
                                                  size: 22,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (order.status != 'Completed')
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        orderProvider.advanceOrderStatus(
                                          order.id,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: colors.accent,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                      ),
                                      child: Text(
                                        'Advance to: ${order.nextStatus}',
                                      ),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8.0,
                                    bottom: 8.0,
                                  ),
                                  child: SizedBox(
                                    height: 120,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: FlutterMap(
                                        options: MapOptions(
                                          center: LatLng(
                                            3.139,
                                            101.6869,
                                          ), // Example: Kuala Lumpur
                                          zoom: 13,
                                          interactiveFlags:
                                              InteractiveFlag.pinchZoom |
                                              InteractiveFlag.drag,
                                        ),
                                        children: [
                                          TileLayer(
                                            urlTemplate:
                                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                            userAgentPackageName:
                                                'com.example.healthy_food_app',
                                          ),
                                          MarkerLayer(
                                            markers: [
                                              Marker(
                                                width: 40,
                                                height: 40,
                                                point: LatLng(3.139, 101.6869),
                                                child: Icon(
                                                  Icons.location_on,
                                                  color: Colors.red,
                                                  size: 36,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            trailing: order.status == 'Completed'
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
                  'Total: RM ' +
                      cartMeals
                          .fold(0.0, (sum, e) => sum + e.key.price * e.value)
                          .toStringAsFixed(2),
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: cartMeals.isEmpty
                      ? null
                      : () async {
                          final total = cartMeals.fold(
                            0.0,
                            (sum, e) => sum + e.key.price * e.value,
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => UsePaypal(
                                sandboxMode: true,
                                clientId:
                                    "Ae69mgVugxo27MW84Ch66CrNRK_42LF7-sv_TzkdGp7UvXUU65kBpV2ugtdOKMDdf-nsqXo2TnYNioqb",
                                secretKey:
                                    "EG9oLYve7X4U6Wa6DZiQ4qSCcljc5v0iXbur_-K_k6s4iAIyIaHD0-5gG-QqBfMdmgre7gB15il1N7JE",
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
                                        "shipping_discount": 0,
                                      },
                                    },
                                    "description": "Healthy Food Order",
                                  },
                                ],
                                note:
                                    "Contact us for any questions on your order.",
                                onSuccess: (Map params) async {
                                  // Place order on success
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
                                  final order = Order(
                                    id: orderId,
                                    items: items,
                                    total: total,
                                    date: DateTime.now(),
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
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                  Provider.of<MealProvider>(
                                    context,
                                    listen: false,
                                  ).clearCart();
                                  Navigator.pop(context); // Close PayPal screen
                                },
                                onError: (error) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Payment Error'),
                                      content: Text(
                                        'An error occurred: \n$error',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
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
                                      content: const Text(
                                        'The payment was cancelled.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      colors.accent,
                    ),
                    foregroundColor: WidgetStateProperty.all<Color>(
                      Colors.white,
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    padding: WidgetStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    ),
                    elevation: WidgetStateProperty.all<double>(4),
                    shadowColor: WidgetStateProperty.all<Color?>(
                      colors.buttonShadow,
                    ),
                    overlayColor: WidgetStateProperty.resolveWith<Color?>((
                      states,
                    ) {
                      if (states.contains(WidgetState.hovered) ||
                          states.contains(WidgetState.pressed)) {
                        return colors.buttonHover;
                      }
                      return null;
                    }),
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
