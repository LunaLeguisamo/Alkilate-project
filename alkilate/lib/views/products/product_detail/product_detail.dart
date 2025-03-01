// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:alkilate/services/services.dart';
import 'package:alkilate/views/orders/orders.dart';
import 'package:alkilate/shared/shared.dart';

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
  bool isAdmin = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {});
    });
    _checkAdminStatus();
  }

  // Check if the current user is an admin
  Future<void> _checkAdminStatus() async {
    try {
      final user = AuthService().user;
      if (user != null) {
        // Get user document from Firestore to check admin status
        final userData = await FirestoreService().getUser(user.uid);
        setState(() {
          isAdmin = userData.isAdmin == true;
        });
      }
    } catch (e) {
      print('Error checking admin status: $e');
    }
  }

  // Approve the product and update its status
  Future<void> _approveProduct() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirestoreService()
          .approveProduct(widget.product.id, widget.product.owner);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product approved successfully!')),
      );
      // Navigate back to product list
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error approving product: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Show dialog to get rejection reason and then reject product
  Future<void> _showRejectDialog() async {
    final reasonController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reject Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Please provide a reason for rejection:'),
                SizedBox(height: 16),
                TextField(
                  controller: reasonController,
                  decoration: InputDecoration(
                    hintText: 'Enter rejection reason',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Submit', style: TextStyle(color: Colors.red)),
              onPressed: () {
                if (reasonController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a rejection reason')),
                  );
                  return;
                }
                Navigator.of(context).pop();
                _rejectProduct(reasonController.text);
              },
            ),
          ],
        );
      },
    );
  }

  // Handle product rejection
  Future<void> _rejectProduct(String reason) async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirestoreService()
          .rejectProduct(widget.product.id, reason, widget.product.owner);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product rejected successfully')),
      );
      // Navigate back to product list
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error rejecting product: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
    final bool showApprovalButton = isAdmin && !widget.product.approved;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(size: 30, color: Color(0xFF1B1B1B)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        // Show admin badge for admin users
        actions: isAdmin
            ? [
                Container(
                  margin: EdgeInsets.only(right: 16),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'ADMIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Image carousel with page indicator
                _buildImageCarousel(images),

                // Product content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      // Show approval status for admin
                      if (isAdmin)
                        Container(
                          margin: EdgeInsets.only(top: 4),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: widget.product.approved
                                ? Colors.green
                                : Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.product.approved
                                ? 'APPROVED'
                                : 'PENDING APPROVAL',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
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

                      // Show either approval button or rent button based on user role and product status
                      if (showApprovalButton)
                        _buildApproveButton()
                      else
                        _buildRentButton(),

                      const SizedBox(height: 26),
                      _buildDescription(),

                      // Only show comments section for regular users or approved products
                      if (!showApprovalButton) ...[
                        const SizedBox(height: 18.5),
                        _buildCommentsSection(),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Show loading overlay when approving product
          if (isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  // Build approval button for admins
  Widget _buildApproveButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Approve button
        Expanded(
          child: ElevatedButton(
            onPressed: _approveProduct,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 20),
                SizedBox(width: 8),
                const Text('Approve',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),

        SizedBox(width: 12),

        // Reject button
        Expanded(
          child: ElevatedButton(
            onPressed: _showRejectDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cancel_outlined, size: 20),
                SizedBox(width: 8),
                const Text('Reject',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Your existing methods remain the same...
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
          onPressed: _showAvailabilityCalendar,
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
            padding: const EdgeInsets.symmetric(horizontal: 146, vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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

  // Add this method to show the calendar popup
  void _showAvailabilityCalendar() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.all(16),
          child: Container(
            width: double.maxFinite,
            height:
                MediaQuery.of(context).size.height * 0.7, // Increased height
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Product Availability',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                SizedBox(height: 8), // Reduced vertical spacing
                // Legend for calendar colors
                Row(
                  children: [
                    _buildLegendItem(Colors.green[100]!, 'Available'),
                    SizedBox(width: 16),
                    _buildLegendItem(Colors.grey[300]!, 'Not Available'),
                  ],
                ),
                SizedBox(height: 8), // Reduced vertical spacing
                Divider(),
                // Using Expanded to ensure the calendar takes available space
                Expanded(
                  child: SingleChildScrollView(
                    // Add scrolling capability
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: AvailabilityCalendar(
                        startDay: widget.product.disponibleFrom,
                        endDay: widget.product.disponibleTo,
                        rentedDates: widget.product.rented,
                        // Making it non-interactive
                        onDateRangeSelected: null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper method for the legend items
  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
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
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            padding: EdgeInsets.symmetric(vertical: 26),
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
