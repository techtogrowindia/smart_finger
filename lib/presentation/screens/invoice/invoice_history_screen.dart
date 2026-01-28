import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:smart_finger/core/colors.dart';
import 'package:smart_finger/data/models/invoice_history_model.dart';
import 'package:smart_finger/presentation/cubit/invoice/invoice_cubit.dart';
import 'package:smart_finger/presentation/cubit/invoice/invoice_state.dart';
import 'package:smart_finger/presentation/screens/home/home_screen.dart';
import 'package:smart_finger/presentation/screens/invoice/invoice_details_screen.dart';
import 'package:smart_finger/presentation/screens/invoice/invoice_status_tag.dart';

class InvoiceHistoryScreen extends StatefulWidget {
  const InvoiceHistoryScreen({super.key});

  @override
  State<InvoiceHistoryScreen> createState() => _InvoiceHistoryScreenState();
}

class _InvoiceHistoryScreenState extends State<InvoiceHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<InvoiceCubit>().loadInvoices();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF6F7FB),
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: const Text(
            "Invoice History",
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
          actions: [
            PopupMenuButton<InvoiceFilter>(
              icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
              onSelected: (f) => context.read<InvoiceCubit>().applyFilter(f),
              itemBuilder: (_) => const [
                PopupMenuItem(value: InvoiceFilter.all, child: Text("All")),
                PopupMenuItem(value: InvoiceFilter.paid, child: Text("Paid")),
                PopupMenuItem(
                  value: InvoiceFilter.unpaid,
                  child: Text("Unpaid"),
                ),
              ],
            ),
          ],
        ),
        body: BlocBuilder<InvoiceCubit, InvoiceState>(
          builder: (context, state) {
            if (state is InvoiceHistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is InvoiceHistoryError) {
              return Center(child: Text(state.message));
            }
            if (state is InvoiceHistoryLoaded) {
              if (state.invoices.isEmpty) {
                return const Center(
                  child: Text(
                    "No invoices available",
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                  vertical: 12,
                ),
                itemCount: state.invoices.length,
                itemBuilder: (_, i) {
                  final InvoiceHistoryModel inv = state.invoices[i];

                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => InvoiceDetailsScreen(invoice: inv),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.receipt_long,
                              color: Colors.blue,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Invoice #${inv.id}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Complaint #${inv.complaintId}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "₹ ${inv.total}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Status tag
                          InvoiceStatusTag(status: inv.paymentStatus),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            if (state is InvoiceError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
