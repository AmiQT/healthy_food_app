import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../models/order_model.dart';
import '../utils/app_colors.dart';
import '../widgets/shimmer_loader.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        iconTheme: IconThemeData(color: colors.heading),
        title: Text('Order History', style: TextStyle(color: colors.heading)),
      ),
      body: orders.isEmpty
          ? Center(
              child: Text(
                'No order history yet.',
                style: TextStyle(color: colors.bodyText),
              ),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, idx) {
                final order = orders[idx];
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
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order #${order.id.substring(order.id.length - 5)}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            if (order.status == 'Completed')
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                          ],
                        ),
                        Text(
                          'Date: ${order.date.toLocal().toString().split(".")[0]}',
                        ),
                        Text('Total: RM ${order.total.toStringAsFixed(2)}'),
                        Text('Status: ${order.status}'),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                          child: SizedBox(
                            height: 48,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                          radius: i == Order.statuses.length - 1
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
                                                ? Icons.delivery_dining
                                                : Icons.check_circle,
                                            size: i == Order.statuses.length - 1
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
                                                Order.statuses.indexOf(
                                                      order.status,
                                                    ) >=
                                                    i
                                                ? Colors.green[800]
                                                : Colors.grey,
                                            fontWeight:
                                                Order.statuses.indexOf(
                                                      order.status,
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
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (order.status != 'Completed')
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                orderProvider.advanceOrderStatus(order.id);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.accent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                              child: Text('Advance to: ${order.nextStatus}'),
                            ),
                          ),
                        // Map for the first meal in the order
                        if (order.items.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              bottom: 8.0,
                            ),
                            child: LocationMapWidget(
                              latitude: order.items.first.meal.latitude,
                              longitude: order.items.first.meal.longitude,
                              height: 150,
                              title: 'Restaurant Location',
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
