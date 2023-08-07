import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductRatingDialog extends StatefulWidget {
  final String productName, productID;

  const ProductRatingDialog(
      {super.key, required this.productName, required this.productID});

  @override
  _ProductRatingDialogState createState() => _ProductRatingDialogState();
}

class _ProductRatingDialogState extends State<ProductRatingDialog> {
  double halfRating = 5.0;
  TextEditingController _feedbackController = new TextEditingController();

  void initSate() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Align(
        alignment: Alignment.center,
        child: Text('Đánh giá ${widget.productName}'),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sản phẩm này chất chứ ?'),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: RatingBar.builder(
                  initialRating: 5,
                  minRating: 1,
                  allowHalfRating: true,
                  unratedColor: Colors.grey,
                  itemCount: 5,
                  itemSize: 30.0,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  updateOnDrag: true,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (ratingvalue) {
                    setState(() {
                      halfRating = ratingvalue;
                    });
                  },
                ),
              ),
              Text('${halfRating}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          const SizedBox(
            height: 25,
          ),
          SizedBox(
            width: 260,
            height: 50,
            child: TextFormField(
              controller: _feedbackController,
              decoration: InputDecoration(
                labelText: 'Nhận xét',
                hintText: 'Cảm nhận của bạn',
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
              style: const TextStyle(fontSize: 16),
              cursorColor: Colors.blue,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('huỷ'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('Gửi'),
          onPressed: () async {
            // await FirebaseFirestore.instance.collection('ratings').add({
            //   'DishID': widget.productID,
            //   'UserID': user?.uid,
            //   'DateRecored': DateTime.now(),
            //   'Feedback': _feedbackController.text,
            //   'Score': halfRating,
            // });

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
