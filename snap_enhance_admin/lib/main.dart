import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  SNAP ENHANCE â€” Admin Panel
//  Flutter single-file app
//  Screens: Login â†’ Dashboard â†’ Users â†’ API Keys â†’ Ad Manager
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

void main() => runApp(const SnapAdminApp());

// â”€â”€ CONFIG â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
const String kBaseUrl = 'https://bg-of-image-enhancement.onrender.com';

// â”€â”€ THEME â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
const Color kBlue = Color(0xFF2563EB);
const Color kBlue2 = Color(0xFF1D4ED8);
const Color kBluePale = Color(0xFFEFF6FF);
const Color kBlueMid = Color(0xFFDBEAFE);
const Color kText = Color(0xFF1E293B);
const Color kTextMid = Color(0xFF475569);
const Color kTextLight = Color(0xFF94A3B8);
const Color kBorder = Color(0x21254999);
const Color kGreen = Color(0xFF16A34A);
const Color kRed = Color(0xFFDC2626);

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  API SERVICE
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
class ApiService {
  final String adminSecret;
  ApiService(this.adminSecret);

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'X-Admin-Secret': adminSecret,
      };

  Future<Map<String, dynamic>> getOverview() async {
    final r = await http.get(Uri.parse('$kBaseUrl/admin/overview'), headers: _headers);
    if (r.statusCode == 200) return jsonDecode(r.body);
    throw Exception('Auth failed: ${r.statusCode}');
  }

  Future<Map<String, dynamic>> getStats() async {
    final r = await http.get(Uri.parse('$kBaseUrl/admin/stats'), headers: _headers);
    if (r.statusCode == 200) return jsonDecode(r.body);
    throw Exception('Failed: ${r.statusCode}');
  }

  Future<Map<String, dynamic>> getUsers() async {
    final r = await http.get(Uri.parse('$kBaseUrl/admin/users'), headers: _headers);
    if (r.statusCode == 200) return jsonDecode(r.body);
    throw Exception('Failed');
  }

  Future<void> blockIp(String ip) async {
    await http.post(Uri.parse('$kBaseUrl/admin/block/$ip'), headers: _headers);
  }

  Future<void> unblockIp(String ip) async {
    await http.delete(Uri.parse('$kBaseUrl/admin/block/$ip'), headers: _headers);
  }

  Future<Map<String, dynamic>> getApiKeys() async {
    final r = await http.get(Uri.parse('$kBaseUrl/admin/api-keys'), headers: _headers);
    if (r.statusCode == 200) return jsonDecode(r.body);
    throw Exception('Failed');
  }

  Future<Map<String, dynamic>> createApiKey(String name) async {
    final r = await http.post(
      Uri.parse('$kBaseUrl/admin/api-keys?name=${Uri.encodeComponent(name)}'),
      headers: _headers,
    );
    if (r.statusCode == 200) return jsonDecode(r.body);
    throw Exception('Failed');
  }

  Future<void> deactivateKey(String key) async {
    await http.delete(Uri.parse('$kBaseUrl/admin/api-keys/$key'), headers: _headers);
  }

  Future<void> activateKey(String key) async {
    await http.put(Uri.parse('$kBaseUrl/admin/api-keys/$key/activate'), headers: _headers);
  }

  Future<Map<String, dynamic>> updateAdConfig({
    required String type,
    required String src,
    required int duration,
    required String company,
  }) async {
    final url =
        '$kBaseUrl/admin/ad-config?ad_type=${Uri.encodeComponent(type)}&src=${Uri.encodeComponent(src)}&duration=$duration&company=${Uri.encodeComponent(company)}';
    final r = await http.put(Uri.parse(url), headers: _headers);
    if (r.statusCode == 200) return jsonDecode(r.body);
    throw Exception('Failed');
  }
}

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  APP
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
class SnapAdminApp extends StatelessWidget {
  const SnapAdminApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snap Enhance Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: kBlue),
        fontFamily: 'sans-serif',
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: kText,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: kText, fontWeight: FontWeight.w800, fontSize: 18,
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  LOGIN SCREEN
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _ctrl = TextEditingController();
  bool _loading = false;
  String? _err;

  Future<void> _login() async {
    final secret = _ctrl.text.trim();
    if (secret.isEmpty) return;
    setState(() { _loading = true; _err = null; });
    try {
      final api = ApiService(secret);
      await api.getOverview(); // Test auth
      if (!mounted) return;
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => MainScreen(api: api)));
    } catch (e) {
      setState(() { _err = 'Wrong admin secret. Try again.'; });
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFDBEAFE), Color(0xFFEFF6FF), Color(0xFFE0F2FE)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 380),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: kBlue.withOpacity(.12), blurRadius: 32, offset: const Offset(0, 8))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64, height: 64,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [kBlue2, kBlue]),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: kBlue.withOpacity(.3), blurRadius: 16)],
                    ),
                    child: const Center(child: Text('âœ¨', style: TextStyle(fontSize: 28))),
                  ),
                  const SizedBox(height: 16),
                  const Text('Snap Enhance',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22, color: kBlue)),
                  const SizedBox(height: 4),
                  const Text('Admin Panel',
                    style: TextStyle(color: kTextMid, fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 28),
                  TextField(
                    controller: _ctrl,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Admin Secret',
                      prefixIcon: const Icon(Icons.lock_outline, color: kBlue),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: kBlue, width: 2),
                      ),
                      errorText: _err,
                    ),
                    onSubmitted: (_) => _login(),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: _loading
                        ? const SizedBox(width: 20, height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                        : const Text('Login', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  MAIN SCREEN (Bottom Nav)
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
class MainScreen extends StatefulWidget {
  final ApiService api;
  const MainScreen({super.key, required this.api});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _idx = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardScreen(api: widget.api),
      UsersScreen(api: widget.api),
      ApiKeysScreen(api: widget.api),
      AdManagerScreen(api: widget.api),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _idx, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _idx,
        onDestinationSelected: (i) => setState(() => _idx = i),
        backgroundColor: Colors.white,
        elevation: 0,
        indicatorColor: kBluePale,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard, color: kBlue), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people, color: kBlue), label: 'Users'),
          NavigationDestination(icon: Icon(Icons.vpn_key_outlined), selectedIcon: Icon(Icons.vpn_key, color: kBlue), label: 'API Keys'),
          NavigationDestination(icon: Icon(Icons.play_circle_outline), selectedIcon: Icon(Icons.play_circle, color: kBlue), label: 'Ads'),
        ],
      ),
    );
  }
}

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  DASHBOARD SCREEN
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
class DashboardScreen extends StatefulWidget {
  final ApiService api;
  const DashboardScreen({super.key, required this.api});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? _data;
  bool _loading = true;
  String? _err;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() { _loading = true; _err = null; });
    try {
      final d = await widget.api.getOverview();
      setState(() { _data = d; });
    } catch (e) {
      setState(() { _err = e.toString(); });
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = _data?['today'] ?? {};
    final all = _data?['all_time'] ?? {};
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      body: _loading
        ? const Center(child: CircularProgressIndicator())
        : _err != null
          ? Center(child: Text(_err!, style: const TextStyle(color: kRed)))
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _sectionLabel("Today's Traffic"),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(child: _statCard('ðŸ”¥', 'Total Calls', '${today['total_calls'] ?? 0}', kBlue)),
                    const SizedBox(width: 12),
                    Expanded(child: _statCard('ðŸ‘¥', 'Unique Users', '${today['unique_users'] ?? 0}', kGreen)),
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: _statCard('ðŸ“¡', 'API Calls', '${today['api_calls'] ?? 0}', const Color(0xFF7C3AED))),
                    const SizedBox(width: 12),
                    Expanded(child: _statCard('ðŸ“…', 'Date', today['date'] ?? '-', kTextMid)),
                  ]),
                  const SizedBox(height: 20),
                  _sectionLabel('All-Time Stats'),
                  const SizedBox(height: 8),
                  _infoCard([
                    _infoRow('Total Calls', '${all['total_calls'] ?? 0}'),
                    _infoRow('Active Days', '${all['total_days'] ?? 0}'),
                    _infoRow('Total API Keys', '${all['total_api_keys'] ?? 0}'),
                    _infoRow('Active API Keys', '${all['active_api_keys'] ?? 0}', valueColor: kGreen),
                    _infoRow('Blocked IPs', '${all['blocked_ips'] ?? 0}', valueColor: kRed),
                  ]),
                  const SizedBox(height: 20),
                  _sectionLabel('Current Ad Config'),
                  const SizedBox(height: 8),
                  _infoCard([
                    _infoRow('Type', _data?['ad_config']?['type'] ?? 'none'),
                    _infoRow('Duration', '${_data?['ad_config']?['duration'] ?? 5}s'),
                    _infoRow('Company', _data?['ad_config']?['company'] ?? '-'),
                  ]),
                ],
              ),
            ),
    );
  }

  Widget _sectionLabel(String s) => Text(s,
    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12,
      color: kTextLight, letterSpacing: 0.8));

  Widget _statCard(String icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: color.withOpacity(.1), blurRadius: 16)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(icon, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24, color: color)),
        Text(label, style: const TextStyle(color: kTextLight, fontSize: 12, fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _infoCard(List<Widget> rows) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(children: rows),
    );
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(children: [
        Text(label, style: const TextStyle(color: kTextMid, fontWeight: FontWeight.w600, fontSize: 14)),
        const Spacer(),
        Text(value, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: valueColor ?? kText)),
      ]),
    );
  }
}

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  USERS SCREEN
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
class UsersScreen extends StatefulWidget {
  final ApiService api;
  const UsersScreen({super.key, required this.api});
  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  Map<String, dynamic>? _data;
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final d = await widget.api.getUsers();
      setState(() => _data = d);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _block(String ip) async {
    await widget.api.blockIp(ip);
    _showSnack('ðŸš« $ip blocked');
    _load();
  }

  Future<void> _unblock(String ip) async {
    await widget.api.unblockIp(ip);
    _showSnack('âœ… $ip unblocked');
    _load();
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) {
    final todayUsers = List<String>.from(_data?['today_users'] ?? []);
    final blockedIps = List<String>.from(_data?['blocked_ips'] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users & IPs'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _load)],
      ),
      body: _loading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _load,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _secHeader("Today's Users (${todayUsers.length})", Icons.people),
                const SizedBox(height: 8),
                if (todayUsers.isEmpty)
                  _emptyCard('No users today yet'),
                ...todayUsers.map((ip) {
                  final isBlocked = blockedIps.contains(ip);
                  return _ipCard(
                    ip: ip,
                    isBlocked: isBlocked,
                    onBlock: () => _block(ip),
                    onUnblock: () => _unblock(ip),
                  );
                }),
                const SizedBox(height: 20),
                _secHeader("Blocked IPs (${blockedIps.length})", Icons.block, color: kRed),
                const SizedBox(height: 8),
                if (blockedIps.isEmpty)
                  _emptyCard('No blocked IPs'),
                ...blockedIps.map((ip) => _ipCard(
                  ip: ip,
                  isBlocked: true,
                  onBlock: () {},
                  onUnblock: () => _unblock(ip),
                )),
              ],
            ),
          ),
    );
  }

  Widget _secHeader(String title, IconData icon, {Color? color}) {
    return Row(children: [
      Icon(icon, size: 16, color: color ?? kTextLight),
      const SizedBox(width: 6),
      Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12,
        color: color ?? kTextLight, letterSpacing: 0.8)),
    ]);
  }

  Widget _emptyCard(String msg) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Text(msg, style: const TextStyle(color: kTextLight, fontSize: 13)),
    );
  }

  Widget _ipCard({required String ip, required bool isBlocked, required VoidCallback onBlock, required VoidCallback onUnblock}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isBlocked ? Border.all(color: kRed.withOpacity(.3)) : null,
      ),
      child: Row(children: [
        Icon(isBlocked ? Icons.block : Icons.person_outline, color: isBlocked ? kRed : kBlue, size: 18),
        const SizedBox(width: 10),
        Expanded(child: Text(ip, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, fontFamily: 'monospace'))),
        if (isBlocked)
          TextButton(
            onPressed: onUnblock,
            style: TextButton.styleFrom(foregroundColor: kGreen, padding: const EdgeInsets.symmetric(horizontal: 10)),
            child: const Text('Unblock', style: TextStyle(fontSize: 12)),
          )
        else
          TextButton(
            onPressed: onBlock,
            style: TextButton.styleFrom(foregroundColor: kRed, padding: const EdgeInsets.symmetric(horizontal: 10)),
            child: const Text('Block', style: TextStyle(fontSize: 12)),
          ),
      ]),
    );
  }
}

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  API KEYS SCREEN
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
class ApiKeysScreen extends StatefulWidget {
  final ApiService api;
  const ApiKeysScreen({super.key, required this.api});
  @override
  State<ApiKeysScreen> createState() => _ApiKeysScreenState();
}

class _ApiKeysScreenState extends State<ApiKeysScreen> {
  Map<String, dynamic> _keys = {};
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final d = await widget.api.getApiKeys();
      setState(() => _keys = d);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _create() async {
    final ctrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Create API Key', style: TextStyle(fontWeight: FontWeight.w800)),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Client/App Name', hintText: 'e.g. My Website'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (ctrl.text.trim().isEmpty) return;
              Navigator.pop(context);
              try {
                final k = await widget.api.createApiKey(ctrl.text.trim());
                _showKeyDialog(k['key'] ?? '');
                _load();
              } catch (e) {
                _snack('Error: $e');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: kBlue, foregroundColor: Colors.white),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showKeyDialog(String key) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('ðŸŽ‰ API Key Created', style: TextStyle(fontWeight: FontWeight.w800)),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Copy this key now â€” it won\'t be shown again.', style: TextStyle(color: kTextMid, fontSize: 13)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: kBluePale, borderRadius: BorderRadius.circular(8)),
            child: SelectableText(key, style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: kBlue2, fontWeight: FontWeight.w700)),
          ),
        ]),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Done'))],
      ),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Keys'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
          IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: _create, color: kBlue),
        ],
      ),
      body: _loading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _load,
            child: _keys.isEmpty
              ? const Center(child: Text('No API keys yet.\nTap + to create one.', textAlign: TextAlign.center, style: TextStyle(color: kTextLight)))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _keys.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final key = _keys.keys.elementAt(i);
                    final data = _keys[key] as Map<String, dynamic>;
                    final active = data['active'] == true;
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: active ? null : Border.all(color: kRed.withOpacity(.3)),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Expanded(child: Text(data['name'] ?? 'Unnamed', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: active ? kGreen.withOpacity(.1) : kRed.withOpacity(.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(active ? 'Active' : 'Inactive',
                              style: TextStyle(color: active ? kGreen : kRed, fontSize: 11, fontWeight: FontWeight.w700)),
                          ),
                        ]),
                        const SizedBox(height: 6),
                        Text(key, style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: kTextLight)),
                        const SizedBox(height: 4),
                        Row(children: [
                          Text('Calls: ${data['calls'] ?? 0}', style: const TextStyle(color: kTextMid, fontSize: 12, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 12),
                          if (data['last_used'] != null)
                            Text('Last: ${data['last_used'].toString().substring(0, 10)}',
                              style: const TextStyle(color: kTextLight, fontSize: 12)),
                        ]),
                        const SizedBox(height: 8),
                        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                          if (active)
                            TextButton(
                              onPressed: () async {
                                await widget.api.deactivateKey(key);
                                _snack('Key deactivated');
                                _load();
                              },
                              style: TextButton.styleFrom(foregroundColor: kRed, padding: const EdgeInsets.symmetric(horizontal: 10)),
                              child: const Text('Deactivate', style: TextStyle(fontSize: 12)),
                            )
                          else
                            TextButton(
                              onPressed: () async {
                                await widget.api.activateKey(key);
                                _snack('Key activated');
                                _load();
                              },
                              style: TextButton.styleFrom(foregroundColor: kGreen, padding: const EdgeInsets.symmetric(horizontal: 10)),
                              child: const Text('Activate', style: TextStyle(fontSize: 12)),
                            ),
                        ]),
                      ]),
                    );
                  },
                ),
          ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _create,
        backgroundColor: kBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('New Key', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  AD MANAGER SCREEN
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
class AdManagerScreen extends StatefulWidget {
  final ApiService api;
  const AdManagerScreen({super.key, required this.api});
  @override
  State<AdManagerScreen> createState() => _AdManagerScreenState();
}

class _AdManagerScreenState extends State<AdManagerScreen> {
  String _type = 'none';
  final _srcCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  double _duration = 5;
  bool _saving = false;
  String? _msg;

  final List<Map<String, String>> _types = [
    {'value': 'none', 'label': 'ðŸš« No Ad', 'desc': 'Ad modal skip kar ke seedha download'},
    {'value': 'video', 'label': 'ðŸŽ¬ Video Ad', 'desc': 'Direct MP4/video URL play hogi'},
    {'value': 'iframe', 'label': 'ðŸ–¥ï¸ Iframe/Embed', 'desc': 'YouTube ya koi bhi embed URL'},
  ];

  Future<void> _save() async {
    setState(() { _saving = true; _msg = null; });
    try {
      await widget.api.updateAdConfig(
        type: _type,
        src: _srcCtrl.text.trim(),
        duration: _duration.round(),
        company: _companyCtrl.text.trim(),
      );
      setState(() => _msg = 'âœ… Ad config saved!');
    } catch (e) {
      setState(() => _msg = 'âŒ Error: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ad Manager')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Info card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: kBluePale,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kBlueMid),
            ),
            child: const Row(children: [
              Text('â„¹ï¸', style: TextStyle(fontSize: 18)),
              SizedBox(width: 10),
              Expanded(child: Text(
                '4K download click karne par user ko ye ad dikhegi. Free 2K download me koi ad nahi.',
                style: TextStyle(color: kBlue2, fontSize: 13, fontWeight: FontWeight.w600),
              )),
            ]),
          ),
          const SizedBox(height: 20),

          // Ad type selector
          const Text('Ad Type', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: kTextLight, letterSpacing: 0.8)),
          const SizedBox(height: 8),
          ..._types.map((t) => GestureDetector(
            onTap: () => setState(() => _type = t['value']!),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _type == t['value'] ? kBlue : kBorder,
                  width: _type == t['value'] ? 2 : 1,
                ),
              ),
              child: Row(children: [
                Radio<String>(
                  value: t['value']!,
                  groupValue: _type,
                  onChanged: (v) => setState(() => _type = v!),
                  activeColor: kBlue,
                ),
                const SizedBox(width: 4),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(t['label']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  Text(t['desc']!, style: const TextStyle(color: kTextMid, fontSize: 12)),
                ])),
              ]),
            ),
          )),

          const SizedBox(height: 16),

          if (_type != 'none') ...[
            const Text('Ad URL / Embed Link', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: kTextLight, letterSpacing: 0.8)),
            const SizedBox(height: 8),
            TextField(
              controller: _srcCtrl,
              decoration: InputDecoration(
                hintText: _type == 'video'
                  ? 'https://example.com/ad.mp4'
                  : 'https://www.youtube.com/embed/VIDEO_ID',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: kBlue, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          const Text('Company / Advertiser Name', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: kTextLight, letterSpacing: 0.8)),
          const SizedBox(height: 8),
          TextField(
            controller: _companyCtrl,
            decoration: InputDecoration(
              hintText: 'e.g. Nike, AdSense, etc.',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kBlue, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text('Ad Duration: ${_duration.round()} seconds',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: kTextLight, letterSpacing: 0.8)),
          Slider(
            value: _duration,
            min: 3, max: 30,
            divisions: 27,
            label: '${_duration.round()}s',
            activeColor: kBlue,
            onChanged: (v) => setState(() => _duration = v),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('3s (min)', style: TextStyle(color: kTextLight, fontSize: 11)),
            const Text('30s (max)', style: TextStyle(color: kTextLight, fontSize: 11)),
          ]),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: kBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: _saving
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                : const Text('Save Ad Config', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ),
          ),

          if (_msg != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _msg!.startsWith('âœ…') ? kGreen.withOpacity(.1) : kRed.withOpacity(.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(_msg!, style: TextStyle(
                color: _msg!.startsWith('âœ…') ? kGreen : kRed,
                fontWeight: FontWeight.w700,
              )),
            ),
          ],

          const SizedBox(height: 40),
          // How to integrate real ads note
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFED7AA)),
            ),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('ðŸ’¡ Real Ad Networks', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF92400E), fontSize: 14)),
              SizedBox(height: 8),
              Text(
                'â€¢ Google AdSense: Tag Manager se script add karo aur iframe URL set karo\n'
                'â€¢ Direct Video Ad: MP4 URL directly paste karo\n'
                'â€¢ YouTube Ad: youtube.com/embed/VIDEO_ID?autoplay=1 format use karo\n'
                'â€¢ Company Ad: Apni khud ki video ya page embed kar sakte ho',
                style: TextStyle(color: Color(0xFF78350F), fontSize: 12, height: 1.6),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
