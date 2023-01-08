import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../domain/respository/local_storage_repo_impl.dart';
import '../resources/json_retriever.dart';
import 'counter_add_button.dart';
import 'cubit/cart_place_order_cubit.dart';
import 'models/category_model.dart';

class MyCartScreen extends StatefulWidget {
  const MyCartScreen({super.key, required this.title});

  final String title;

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  late CartPlaceOrderCubit cubit;

  @override
  void initState() {
    cubit = CartPlaceOrderCubit(
      jsonDataRetriever: const JsonDataRetriever(),
      localStorageRepository: LocalStorageRepoImpl(),
    );
    cubit.fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 5.0),
        child: RawMaterialButton(
          fillColor: Colors.orangeAccent,
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          constraints: const BoxConstraints(
            minHeight: 56.0,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 10.0),
              Text(
                'Place Order',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              BlocBuilder(
                  bloc: cubit,
                  builder: (context, state) {
                    String? price = '0';
                    if (state is CartOnAddProductSuccessState) {
                      price = state.totalPrice;
                    }
                    return Text(
                      price,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    );
                  }),
            ],
          ),
          onPressed: () async {
            await cubit.placeOrder();
          },
        ),
      ),
      body: SafeArea(
        child: BlocConsumer(
          listener: (context, state) {
            if (state is CartPlaceOrderPlaceOrderSuccessState) {
              if (state.isFromOrders) {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                      content: Container(
                        height: 35.h,
                        width: 70.w,
                        padding: const EdgeInsets.only(
                            left: 24, right: 12, top: 0, bottom: 16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.cancel,
                                  size: 24,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                iconSize: 12,
                              ),
                            ),
                            const Expanded(
                              child: Icon(
                                Icons.check_circle_rounded,
                                size: 50,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Expanded(
                              child: Text(
                                'Order Placed Successfully',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(color: Colors.orange),
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.ltr,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            } else if (state is OnEmptyCartState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.black,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(milliseconds: 500),
                  margin:
                      const EdgeInsets.only(bottom: 20, left: 15, right: 15),
                ),
              );
            }
          },
          bloc: cubit,
          buildWhen: (previous, current) {
            return previous != CartOnAddProductSuccessState;
          },
          builder: (context, state) {
            if (state is CartPlaceOrderLoadingState) {
              return SizedBox(
                height: 100.h,
                width: 100.w,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (state is CartPlaceOrderFailedState) {
              return SizedBox(
                height: 100.h,
                width: 100.w,
                child: Center(
                  child: Text(
                    'Oopps! Our Servers are down. Please try again later',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.orangeAccent),
                  ),
                ),
              );
            }

            return ListView.separated(
              itemCount: cubit.displayList.length,
              separatorBuilder: (context, index) => const Divider(),
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                String key = cubit.displayList.entries.elementAt(index).key;
                List<CategoryModel>? myList = cubit.displayList[key];
                return ExpandableNotifier(
                  key: const ValueKey('expandable'),
                  initialExpanded: key == 'Popular Items',
                  child: ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapHeaderToExpand: true,
                      iconPadding: EdgeInsets.all(15),
                      iconSize: 16,
                      hasIcon: true,
                      expandIcon: Icons.arrow_forward_ios,
                    ),
                    header: Container(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      height: 56,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(key,
                              key: const ValueKey('category_title'),
                              style: Theme.of(context).textTheme.bodyMedium),
                          const Spacer(),
                          Text(myList!.length.toString(),
                              key: const ValueKey('category_length'),
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    collapsed: const SizedBox(),
                    expanded: Container(
                      key: const ValueKey('products_container'),
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        addAutomaticKeepAlives: false,
                        key: const ValueKey('products_list'),
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: myList.length,
                        itemBuilder: (BuildContext context, int i) {
                          final data = myList[i];
                          return ListTile(
                            tileColor: const Color(0xF5F5FAFC),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(data.name ?? ''),
                                    const SizedBox(width: 5),
                                    if (data.isBestSeller ?? false)
                                      Container(
                                        height: 20,
                                        width: 90,
                                        decoration: BoxDecoration(
                                            color: Colors.pink,
                                            border: Border.all(
                                                color: Colors.pinkAccent),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20))),
                                        child: Center(
                                          child: Text(
                                            'BestSeller',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(color: Colors.white),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  '﹩' "${data.price}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.grey),
                                ),
                              ],
                            ),
                            trailing: CounterButton(
                              model: data,
                              cubit: cubit,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
