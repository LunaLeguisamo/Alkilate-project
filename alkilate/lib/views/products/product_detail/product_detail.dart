import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:alkilate/services/services.dart';
import 'package:alkilate/views/orders/orders.dart';

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
    _commentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images = widget.product.pictures;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(size: 30, color: Color(0xFF1B1B1B)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image carousel with page indicator
            _buildImageCarousel(images),
            // Product content
            _buildProductContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel(List<String> images) {
    return SizedBox(
      height: 351,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: images[index],
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 10,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: images.length,
                effect: const WormEffect(
                  activeDotColor: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '\$${widget.product.price} / Hour',
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 11),
          _buildRatingBar(),
          const SizedBox(height: 26),
          _buildRentButton(),
          const SizedBox(height: 26),
          _buildDescription(),
          const SizedBox(height: 18.5),
          _buildCommentsSection(),
        ],
      ),
    );
  }

  Widget _buildRatingBar() {
    return Row(
      children: [
        Text('${widget.product.rating} '),
        RatingBar.builder(
          initialRating: widget.product.rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 21.0,
          itemBuilder: (context, index) => const Icon(
            Icons.star,
            color: Colors.black,
          ),
          onRatingUpdate: (value) {
            setState(() {
              rating = value;
            });
          },
        ),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: () {
            print('Button');
          },
          icon: SvgPicture.asset(
            'assets/svg/calendar.svg',
            width: 14.2,
            height: 14.7,
          ),
          label: const Text(
            'See availability',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 13.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(55),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRentButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) =>
                OrderScreen(product: widget.product),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2375D8),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 5.5, horizontal: 160.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
          textStyle:
              const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      child: const Text('Rent'),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w300,
            color: Color(0xFF1B1B1B),
          ),
        ),
        const SizedBox(height: 11.8),
        Text(
          widget.product.description,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w200,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Questions',
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFF1B1B1B),
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 12.5),
        SizedBox(
          child: TextField(
            controller: _commentTextController,
            minLines: 3,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Write your question...',
              hintStyle: const TextStyle(
                color: Color(0xFF808080),
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
              contentPadding: const EdgeInsets.all(7.5),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF2375D8)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF2375D8)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            if (_commentTextController.text.isNotEmpty) {
              addComment(_commentTextController.text);
              _commentTextController.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Comment submitted successfully!'),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2375D8),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Submit'),
              SizedBox(width: 5),
              Image(
                image: AssetImage('assets/images/Vector.png'),
                width: 12,
                height: 12,
              ),
            ],
          ),
        ),
        CommentsSection(productId: widget.product.id),
      ],
    );
  }

  void addComment(String text) {
    final comment = Comment(
      dateCreated: DateTime.now(),
      product: widget.product.id,
      text: text,
      user: AuthService().user?.displayName ?? '',
    );
    FirestoreService().addCommentToProduct(comment);
  }
}

class CommentsSection extends StatelessWidget {
  final String productId;

  const CommentsSection({required this.productId, super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Comment>>(
      stream: FirestoreService().getCommentsForProduct(productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error loading comments: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No comments yet'));
        } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final comment = snapshot.data![index];
              return ListTile(
                title: Text(comment.user),
                trailing: Text(
                  DateFormat('MMM dd, yyyy').format(comment.dateCreated),
                ),
                subtitle: Text(
                  comment.text,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
