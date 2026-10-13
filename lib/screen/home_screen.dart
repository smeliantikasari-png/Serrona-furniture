import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MainArScreen extends StatefulWidget {
  const MainArScreen({Key? key}) : super(key: key);

  @override
  State<MainArScreen> createState() => _MainArScreenState();
}

class _MainArScreenState extends State<MainArScreen> {
  // Simulasi data furnitur pilihan dari database (Modal Rp0)
  final List<Map<String, dynamic>> _katalogFurnitur = [
    {
      'nama': 'Sofa Minimalis 2 Seater',
      'harga': 'Rp 1.450.000',
      'model3d': 'assets/3d/sofa.glb',
      'link_affiliate': 'https://shopee.co.id', // Ganti link kamu
      'is_cod': true,
      'is_premium': false,
    },
    {
      'nama': 'Meja Kerja Kayu Estetik',
      'harga': 'Rp 650.000',
      'model3d': 'assets/3d/meja.glb',
      'link_affiliate': 'https://tokopedia.com', // Ganti link kamu
      'is_cod': true,
      'is_premium': false,
    },
    {
      'nama': 'Kasur Kamar Premium Set (Tema Japandi)',
      'harga': 'Premium Access Only',
      'model3d': 'assets/3d/kasur_premium.glb',
      'link_affiliate': '',
      'is_cod': false,
      'is_premium': true, // Terkunci fitur premium bertema
    },
  ];

  Map<String, dynamic>? _produkTerpilih;

  // Fungsi Taktis Deeplink untuk Beli COD via E-commerce
  Future<void> _bukaLinkBelanja(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuka e-commerce, periksa internet Anda.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. PANGGUNG UTAMA: Live Camera AR (Tembus Pandang)
          Container(
            color: Colors.blackdece, // Ilustrasi ruang kamera AR HP Anda
            width: double.infinity,
            height: double.infinity,
            child: const Center(
              child: Text(
                '[ Area Kamera AR Aktif ]\nDeteksi Permukaan Lantai...',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            ),
          ),

          // Watermark Minimalis Kredibilitas Perusahaan di Pojok Kiri Atas
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Powered by SR',
                style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w300),
              ),
            ),
          ),

          // 2. KARTU POP-UP INFO PRODUK (Muncul jika objek diklik)
          if (_produkTerpilih != null)
            Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0047AB).withOpacity(0.85), // Biru Tua Serrona Glassmorphism
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _produkTerpilih!['nama'],
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (_produkTerpilih!['is_cod'])
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
                            child: const Text('BISA COD 📦', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(_produkTerpilih!['harga'], style: const TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 12),
                    
                    // Tombol Aksi Utama Belanja Cuan (Oranye Kontras)
                    if (!_produkTerpilih!['is_premium'])
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6600), // Oranye Strip Kereta
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () => _bukaLinkBelanja(_produkTerpilih!['link_affiliate']),
                          child: const Text('BELI SEKARANG (COD VIA E-COMMERCE)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[800]),
                          onPressed: () {
                            // Trigger Google Play Billing Premium
                          },
                          child: const Text('BUKA TEMA PREMIUM (DANA/PLAY)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ],
                ),
              ),
            ),

          // 3. FLOATING DOCK KATALOG BAWAH (Menu Geser Kaca Buram)
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Container(
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15), // Efek Glassmorphic transparan
                border: const Border(top: BorderSide(color: Colors.white24)),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: _katalogFurnitur.length,
                itemBuilder: (context, index) {
                  final item = _katalogFurnitur[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _produkTerpilih = item;
                      });
                    },
                    child: Container(
                      width: 90,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0047AB), // Biru Tua Serrona untuk list item
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _produkTerpilih == item ? const Color(0xFFFF6600) : Colors.transparent, 
                          width: 2
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            item['nama'],
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
