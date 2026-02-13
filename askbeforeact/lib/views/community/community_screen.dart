import 'package:flutter/material.dart';

/// Community screen for sharing experiences
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Community',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 28),
            onPressed: () {
              // TODO: Show create post dialog
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 900),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', true),
                      const SizedBox(width: 12),
                      _buildFilterChip('Phishing', false),
                      const SizedBox(width: 12),
                      _buildFilterChip('Romance', false),
                      const SizedBox(width: 12),
                      _buildFilterChip('Payment', false),
                      const SizedBox(width: 12),
                      _buildFilterChip('Job', false),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Posts List
                Expanded(
                  child: ListView(
                    children: [
                      _buildPostCard(
                        'John D.',
                        '2 hours ago',
                        'Phishing',
                        'Received an email claiming to be from my bank asking me to verify my account. The URL looked suspicious so I checked it here first. Turned out to be a scam!',
                        45,
                      ),
                      const SizedBox(height: 16),
                      _buildPostCard(
                        'Sarah M.',
                        '5 hours ago',
                        'Romance',
                        'Met someone online who quickly professed love and asked for money for an emergency. Thanks to this app, I realized it was a romance scam.',
                        32,
                      ),
                      const SizedBox(height: 16),
                      _buildPostCard(
                        'Mike R.',
                        '1 day ago',
                        'Job',
                        'Got a job offer that seemed too good to be true. They wanted me to pay for training materials upfront. Glad I checked it first!',
                        28,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF3B82F6) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFE2E8F0),
          width: 2,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.white : const Color(0xFF64748B),
        ),
      ),
    );
  }

  Widget _buildPostCard(
    String author,
    String time,
    String category,
    String content,
    int upvotes,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF3B82F6),
                child: Text(
                  author[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3B82F6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF334155),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.thumb_up_outlined,
                size: 20,
                color: const Color(0xFF64748B),
              ),
              const SizedBox(width: 8),
              Text(
                '$upvotes helpful',
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF64748B),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.thumb_up_outlined, size: 20),
                label: const Text('Helpful'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF3B82F6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
