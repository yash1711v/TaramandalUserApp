import 'package:flutter/material.dart';
import 'package:rashi_network/utils/design_colors.dart';
import 'package:rashi_network/ui/theme/buttons/buttons.dart';
import 'package:rashi_network/ui/theme/container.dart';
import 'package:rashi_network/ui/theme/text.dart';
import 'package:rashi_network/views/reikhi_healing/healers.dart';

class ReikhihealingDetails extends StatefulWidget {
  const ReikhihealingDetails({super.key});

  @override
  State<ReikhihealingDetails> createState() => _ReikhihealingDetailsState();
}

class _ReikhihealingDetailsState extends State<ReikhihealingDetails> {
  final PageController _controller = PageController(viewportFraction: 0.95);
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.darkTeal2,
        title: const DesignText(
          'Product Detail',
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 152,
                    child: PageView.builder(
                        controller: _controller,
                        onPageChanged: (value) {
                          setState(() {
                            currentPage = value;
                          });
                        },
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 5, left: 5),
                                child: Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      width: 1,
                                      color: AppColors.lightGrey,
                                    ),
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Image.network(
                                      'https://thumbs.dreamstime.com/b/top-view-office-work-desk-laptop-diary-white-background-116998554.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      4,
                      (index) => buildDot(index: index),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const DesignText(
                          '7 Ratti Cat’s Eye',
                          fontSize: 16,
                          fontWeight: 500,
                        ),
                        // const DesignText(
                        //   'Represents Generosity     Weight :100 gram',
                        //   fontSize: 13,
                        //   fontWeight: 500,
                        //   color: AppColors.lightGrey1,
                        // ),
                        const SizedBox(height: 6),
                        Row(
                          children: const [
                            DesignText(
                              'Starting From Rs. 1800',
                              fontSize: 18,
                              fontWeight: 600,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const DesignText(
                          '*Inclusive of all the taxes',
                          fontSize: 10,
                          fontWeight: 500,
                        ),
                        /* const SizedBox(height: 10),
                        SizedBox(
                          height: 48,
                          child: ListView.builder(
                            itemCount: 3,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: DesignContainer(
                                  width: 66,
                                  borderAllColor: 1 == 1
                                      ? AppColors.darkTeal
                                      : AppColors.lightGrey,
                                  bordered: true,
                                  allPadding: 0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      DesignText(
                                        'Rs.2500',
                                        fontSize: 10,
                                        fontWeight: 700,
                                        color:
                                            1 == 1 ? AppColors.darkTeal : null,
                                      ),
                                      DesignText(
                                        'Pack of 2',
                                        fontSize: 8,
                                        fontWeight: 500,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),*/
                        const SizedBox(height: 20),
                        const DesignText(
                          'Items Details',
                          fontSize: 16,
                          fontWeight: 600,
                        ),
                        const SizedBox(height: 10),
                        const DesignText(
                          "In the world of gems and crystal healing lore, chrysoberyl cat's eye can be a stone of discipline and self-control, thought to increase concentration and learning ability, whilst enhancing the desire for excellence. Chrysoberyl cat's eye can also help increase self-confidence and bring peace of mind, as well as enhance creativity, imagination and intuition. ",
                          fontSize: 11,
                          fontWeight: 400,
                        ),
                       /* const SizedBox(height: 20),
                        const DesignText(
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
                                    itemBuilder: (context, index) =>
                                        const Padding(
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
                        const DesignText(
                          'FAQ',
                          fontSize: 16,
                          fontWeight: 600,
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          itemCount: 3,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                DesignText(
                                  'What is the exchange Policy?',
                                  fontSize: 14,
                                  fontWeight: 500,
                                ),
                                DesignText(
                                  'We have a 7 days return Policy and replacement policy',
                                  fontSize: 11,
                                  fontWeight: 400,
                                ),
                                SizedBox(height: 8),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: SizedBox(
              height: 48,
              width: double.infinity,
              child: DesignButtons(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HealersChatList(),
                    ),
                  );
                },
                textLabel: 'Buy now',
                isTappedNotifier: ValueNotifier(false),
                colorText: Colors.white,
                fontSize: 16,
                fontWeight: 600,
                color: AppColors.darkTeal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      height: 6,
      width: currentPage == index ? 18 : 8,
      decoration: BoxDecoration(
        color: currentPage == index
            ? const Color(0xFF999999)
            : const Color(0xFFE6E6E6),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
