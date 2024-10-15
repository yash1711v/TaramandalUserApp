import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rashi_network/services/ad_service/get_ads.dart';
import 'package:rashi_network/ui/theme/container.dart';
import 'package:rashi_network/ui/theme/text.dart';
import 'package:rashi_network/utils/design_colors.dart';

class HealersProfile extends StatefulWidget {
  const HealersProfile({super.key, required this.index});
  final int index;
  @override
  State<HealersProfile> createState() => _HealersProfileState();
}

class _HealersProfileState extends State<HealersProfile> {
  @override
  void initState() {
    // TODO: implement initState
    GetAds.to.loadBannerAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.darkTeal2,
        title: const DesignText(
          'Astrologer Profile',
          color: Colors.white,
          fontSize: 20,
          fontWeight: 600,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 70,
        color: Colors.white,
        child: AdWidget(
          ad: GetAds.to.bannerAd,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          height: 48,
          width: double.infinity,
          child: FloatingActionButton.extended(
              backgroundColor: AppColors.darkTeal,
              onPressed: () {
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatHealersScreen(),
                  ),
                );*/
                // Get.to(() => ChatScreen(name: 'STATIC'));
              },
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              label: const DesignText(
                "Book Now",
                color: Colors.white,
                fontSize: 16,
                fontWeight: 700,
              )),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DesignContainer(
                color: AppColors.white,
                child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.green),
                            borderRadius: BorderRadius.circular(
                                60), // assuming height/width is 83
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.network(
                              'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?cs=srgb&dl=pexels-pixabay-220453.jpg&fm=jpg',
                              height: 83,
                              width: 83,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 20,
                          child: ListView.builder(
                            itemCount: 4,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => const Padding(
                              padding: EdgeInsets.only(right: 2),
                              child: DesignText(
                                '⭐',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          DesignText(
                            'Astro Kunal Khemu',
                            fontSize: 12,
                            fontWeight: 600,
                          ),
                          DesignText(
                            'Vaastu, Horoscope',
                            fontSize: 10,
                            fontWeight: 500,
                            color: AppColors.lightGrey1,
                          ),
                          DesignText(
                            'Hindi, English',
                            fontSize: 10,
                            fontWeight: 500,
                            color: AppColors.lightGrey1,
                          ),
                          DesignText(
                            '5 Years',
                            fontSize: 10,
                            fontWeight: 500,
                            color: AppColors.lightGrey1,
                          ),
                          DesignText(
                            'Rs.10/Min',
                            fontSize: 10,
                            fontWeight: 500,
                            color: AppColors.red,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const DesignText(
                'Skills',
                fontSize: 15,
                fontWeight: 700,
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 30,
                child: ListView.builder(
                  itemCount: 3,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return const Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: DesignContainer(
                        borderAllColor: AppColors.gold,
                        bordered: true,
                        allPadding: 6,
                        alignment: Alignment.center,
                        child: DesignText(
                          'Tarot',
                          fontSize: 12,
                          fontWeight: 500,
                          color: AppColors.gold,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const DesignText(
                'About me',
                fontSize: 16,
                fontWeight: 600,
              ),
              const SizedBox(height: 10),
              const DesignText(
                "In the world of gems and crystal healing lore, chrysoberyl cat's eye can be a stone of discipline and self-control, thought to increase concentration and learning ability, whilst enhancing the desire for excellence. Chrysoberyl cat's eye can also help increase self-confidence and bring peace of mind, as well as enhance creativity, imagination and intuition. ",
                fontSize: 11,
                fontWeight: 400,
              ),
              const SizedBox(height: 20),
              /* const DesignText(
                'Customer Reviews',
                fontSize: 16,
                fontWeight: 600,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 20,
                        child: ListView.builder(
                          itemCount: 3,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => const Padding(
                            padding: EdgeInsets.only(right: 6),
                            child: DesignText('⭐'),
                          ),
                        ),
                      ),
                      const DesignText(
                        'Good Stone',
                        fontSize: 11,
                        fontWeight: 400,
                      ),
                    ],
                  ),
                  const DesignText(
                    'Nov 2020',
                    fontSize: 10,
                    fontWeight: 500,
                    color: AppColors.lightGrey2,
                  ),
                ],
              ),*/
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
