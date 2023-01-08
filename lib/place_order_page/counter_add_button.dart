import 'package:assignmenttbn/place_order_page/cubit/cart_place_order_cubit.dart';
import 'package:assignmenttbn/place_order_page/models/category_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CounterButton extends StatefulWidget {
  const CounterButton({super.key, required this.model, required this.cubit});
  final CategoryModel model;
  final CartPlaceOrderCubit cubit;

  @override
  State<CounterButton> createState() => _CounterButtonState();
}

class _CounterButtonState extends State<CounterButton> {
  int _counterValue = 0;
  @override
  void initState() {
    _counterValue = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _counterValue == 0
          ? () {
              _counterValue = 1;
              widget.model.quantity = _counterValue;
              widget.cubit.onAddProduct(widget.model);
              setState(() {});
            }
          : null,
      child: Container(
        height: 30,
        width: kIsWeb ? 15.w : 30.w,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.orangeAccent),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Row(
          mainAxisAlignment: _counterValue > 0
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_counterValue > 0)
              Expanded(
                child: IconButton(
                  icon: const Icon(
                    Icons.remove,
                    size: 16,
                  ),
                  color: Colors.deepOrange,
                  iconSize: 12,
                  onPressed: () {
                    if (_counterValue > 0) {
                      _counterValue--;
                    }
                    if (widget.model.quantity != null) {
                      widget.model.quantity = _counterValue;
                    }
                    widget.cubit.onAddProduct(widget.model);
                    setState(() {});
                  },
                ),
              ),
            Container(
              height: _counterValue > 0 ? 30 : null,
              width: _counterValue > 0 ? 30 : null,
              decoration: _counterValue > 0
                  ? const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.deepOrange,
                    )
                  : null,
              child: Center(
                child: Text(
                  _counterValue == 0 ? 'Add' : '$_counterValue',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _counterValue == 0
                          ? Colors.deepOrange
                          : Colors.white),
                ),
              ),
            ),
            if (_counterValue > 0)
              Expanded(
                child: IconButton(
                  icon: const Icon(
                    Icons.add,
                    size: 16,
                    color: Colors.deepOrange,
                  ),
                  iconSize: 12,
                  onPressed: () {
                    _counterValue++;
                    if (widget.model.quantity != null) {
                      widget.model.quantity = _counterValue;
                      widget.cubit.onAddProduct(widget.model);
                    }
                    setState(() {});
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
