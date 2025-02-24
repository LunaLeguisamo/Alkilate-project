import 'package:alkilate/services/services.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:alkilate/views/orders/orders.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  ProductDetailScreenState createState() => ProductDetailScreenState();
}

class ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController _pageController = PageController();
  final _commentTextController = TextEditingController();
  double rating = 3.0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images = widget.product.pictures;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text('Product Detail', style: TextStyle(fontSize: 24)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image carousel
            SizedBox(
              height: 351,
              child: PageView.builder(
                controller: _pageController,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  ClipRRect(
                    child: Image.network(
                      images[index],
                      fit: BoxFit.cover,
                    ),
                  );
                  return null;
                },
              ),
            ),

            // Page indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: images.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: Colors.black,
                  dotHeight: 10.0,
                  dotWidth: 10.0,
                ),
              ),
            ),

            // Product content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '\$${widget.product.price} / Hour',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 11),
                  // Rating bar
                  Row(
                    children: [
                      Text('${widget.product.rating} '),
                      RatingBar.builder(
                        initialRating: widget.product.rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 21.0,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.black,
                        ),
                        onRatingUpdate: (value) {
                          setState(() {
                            rating = value;
                          });
                        },
                      ),
                      Spacer(),
                      // Button
                      ElevatedButton.icon(
                        onPressed: () {
                          print('Button');
                        },
                        icon: SvgPicture.asset(
                          'assets/svg/calendar.svg',
                          width: 14.2,
                          height: 14.7,
                        ),
                        label: Text(
                          'See availability',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 13.6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(55),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 26),
                  // Rent button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              OrderScreen(product: widget.product),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2375D8),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                            vertical: 5.5, horizontal: 160.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        textStyle: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                    child: Text('Rent'),
                  ),
                  SizedBox(height: 26),
                  Text('Description:',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF1B1B1B))),
                  SizedBox(height: 11.8),
                  Text(
                    widget.product.description,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w200,
                        color: const Color.fromARGB(255, 0, 0, 0)),
                  ),

                  // Comments
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 18.5),
                      Text(
                        'Questions',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF1B1B1B),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: 12.5),
                      // Input box for adding a comment
                      SizedBox(
                        height: 80,
                        child: TextField(
                          controller: _commentTextController,
                          minLines: 3,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Write your question...',
                            hintStyle: TextStyle(
                              color: Color(0xFF808080),
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                            contentPadding: EdgeInsets.all(7.5),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF2375D8)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF2375D8)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Submit button
                      ElevatedButton(
                        onPressed: () {
                          if (_commentTextController.text.isNotEmpty) {
                            addComment(_commentTextController.text);
                            _commentTextController.clear();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2375D8),
                          foregroundColor: Colors.white,
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),
                          textStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          minimumSize: Size.fromHeight(27),
                        ),
                        child: Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Submit'),
                              SizedBox(width: 5),
                              Image.asset(
                                'assets/images/Vector.png',
                                width: 12,
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 27),
                  // Comments section
                  CommentsSection(productId: widget.product.id),
                  SizedBox(height: 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addComment(String text) {
    Comment comment = Comment(
      dateCreated: DateTime.now(),
      product: widget.product.id,
      text: text,
      user: AuthService().user?.displayName ?? '',
    );
    FirestoreService().addCommentToProduct(comment);
  }
}

class CommentsSection extends StatelessWidget {
  final String productId; // Pass the product ID to fetch comments

  const CommentsSection({required this.productId, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Comment>>(
      future: FirestoreService().getCommentsForProduct(productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Show a loader
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error loading comments')); // Show error message
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No comments yet')); // Show empty state
        } else {
          return SizedBox(
            height: 200, // Set a fixed height
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // Disable scrolling
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final Comment comment = snapshot.data![index];
                return ListTile(
                  title: Text(comment.user),
                  trailing: Text(
                    DateFormat('MMM dd, yyyy').format(comment.dateCreated),
                  ),
                  subtitle: Text(
                    comment.text,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff000000)),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}

// Widget to display each feature
class FeatureItem extends StatelessWidget {
  final String text;
  final IconData icon;
  const FeatureItem({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(children: [
          Icon(icon, color: Colors.black, size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ]));
  }
}
