import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory_app/core/theme/app_theme.dart';
import 'package:inventory_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:inventory_app/features/authentication/presentation/bloc/auth_event.dart';
import 'package:inventory_app/features/authentication/presentation/pages/login_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _HomeTab(),
    const _InventoryTab(),
    const _ScanTab(),
    const _ReportsTab(),
    const _SettingsTab(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _signOut() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Sign Out'),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<AuthBloc>().add(const SignOutRequested());
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text('Sign Out'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner_outlined),
            activeIcon: Icon(Icons.qr_code_scanner),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting and summary
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome back!', style: AppTheme.headingMedium),
              SizedBox(height: 4.h),
              Text(
                'Here\'s an overview of your inventory',
                style: AppTheme.bodyMedium.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onBackground.withOpacity(0.7),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Stats cards
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.inventory_2,
                  title: 'Total Products',
                  value: '345',
                  color: AppTheme.primaryColor,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _StatCard(
                  icon: Icons.warning_amber,
                  title: 'Low Stock',
                  value: '12',
                  color: AppTheme.warningColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.location_on,
                  title: 'Locations',
                  value: '3',
                  color: AppTheme.secondaryColor,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _StatCard(
                  icon: Icons.sync,
                  title: 'Transfers',
                  value: '5',
                  color: AppTheme.infoColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Recent activity
          Text('Recent Activity', style: AppTheme.titleLarge),
          SizedBox(height: 16.h),
          _ActivityItem(
            icon: Icons.add_circle,
            title: 'Product Added',
            description: 'Wireless Keyboard - 10 units',
            time: '10 min ago',
            color: AppTheme.successColor,
          ),
          _ActivityItem(
            icon: Icons.remove_circle,
            title: 'Product Removed',
            description: 'USB-C Cable - 5 units',
            time: '1 hour ago',
            color: AppTheme.errorColor,
          ),
          _ActivityItem(
            icon: Icons.sync,
            title: 'Transfer Completed',
            description: 'From Warehouse to Store #2',
            time: '3 hours ago',
            color: AppTheme.infoColor,
          ),

          SizedBox(height: 24.h),

          // Quick actions
          Text('Quick Actions', style: AppTheme.titleLarge),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _QuickActionButton(
                icon: Icons.add_circle_outline,
                label: 'Add Product',
                onTap: () {},
              ),
              _QuickActionButton(
                icon: Icons.sync,
                label: 'Transfer',
                onTap: () {},
              ),
              _QuickActionButton(
                icon: Icons.qr_code_scanner_outlined,
                label: 'Scan',
                onTap: () {},
              ),
              _QuickActionButton(
                icon: Icons.search,
                label: 'Search',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28.sp),
            SizedBox(height: 12.h),
            Text(
              value,
              style: AppTheme.headingMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              style: AppTheme.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String time;
  final Color color;

  const _ActivityItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.time,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.titleSmall),
                SizedBox(height: 2.h),
                Text(description, style: AppTheme.bodyMedium),
              ],
            ),
          ),
          Text(
            time,
            style: AppTheme.bodySmall.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onBackground.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: AppTheme.primaryColor, size: 24.sp),
            ),
            SizedBox(height: 8.h),
            Text(label, style: AppTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _InventoryTab extends StatelessWidget {
  const _InventoryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80.sp,
            color: AppTheme.primaryColor.withOpacity(0.5),
          ),
          SizedBox(height: 16.h),
          Text('Inventory Management', style: AppTheme.headingSmall),
          SizedBox(height: 8.h),
          Text(
            'This is where you\'ll manage your inventory',
            style: AppTheme.bodyMedium.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onBackground.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('View Products'),
          ),
        ],
      ),
    );
  }
}

class _ScanTab extends StatelessWidget {
  const _ScanTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.qr_code_scanner_outlined,
            size: 80.sp,
            color: AppTheme.primaryColor.withOpacity(0.5),
          ),
          SizedBox(height: 16.h),
          Text('Barcode Scanner', style: AppTheme.headingSmall),
          SizedBox(height: 8.h),
          Text(
            'Scan product barcodes for quick actions',
            style: AppTheme.bodyMedium.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onBackground.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt),
            label: const Text('Start Scanning'),
          ),
        ],
      ),
    );
  }
}

class _ReportsTab extends StatelessWidget {
  const _ReportsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart_outlined,
            size: 80.sp,
            color: AppTheme.primaryColor.withOpacity(0.5),
          ),
          SizedBox(height: 16.h),
          Text('Reports & Analytics', style: AppTheme.headingSmall),
          SizedBox(height: 8.h),
          Text(
            'View reports and analytics about your inventory',
            style: AppTheme.bodyMedium.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onBackground.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.insights),
            label: const Text('View Reports'),
          ),
        ],
      ),
    );
  }
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.settings_outlined,
            size: 80.sp,
            color: AppTheme.primaryColor.withOpacity(0.5),
          ),
          SizedBox(height: 16.h),
          Text('Settings', style: AppTheme.headingSmall),
          SizedBox(height: 8.h),
          Text(
            'Configure your application settings',
            style: AppTheme.bodyMedium.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onBackground.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.tune),
            label: const Text('Manage Settings'),
          ),
        ],
      ),
    );
  }
}
