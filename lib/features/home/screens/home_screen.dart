import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qmed_employee/core/const/color_styles.dart';
import 'package:qmed_employee/core/get_it/injection_container.dart';
import 'package:qmed_employee/features/home/logic/bloc/home_bloc.dart';
import 'package:qmed_employee/features/notification/screens/notification_screen.dart';
import 'package:qmed_employee/features/about_patient/screens/about_patient_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Color _zoneColor(String? zone) {
    switch (zone) {
      case 'green': return Colors.green;
      case 'yellow': return Colors.yellow;
      case 'red': return Colors.red;
      default: return ColorStyles.whiteColor;
    }
  }

  Color _textOnZone(String? zone) {
    switch (zone) {
      case 'green':
        return ColorStyles.whiteColor;
      case 'yellow':
        return ColorStyles.blackColor;
      case 'red':
        return ColorStyles.whiteColor;
      default:
        return ColorStyles.blackColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorStyles.primaryColor,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationScreen()),
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.notifications_none, color: Colors.white, size: 23),
            ),
          )
        ],
        title: Text(
          'Главная',
          style: GoogleFonts.montserrat(
            fontSize: 17,
            color: ColorStyles.whiteColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => sl<HomeBloc>()..add(GetPatients('')),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is HomeFailure) {
                return Center(
                  child: Text('Ошибка загрузки', style: GoogleFonts.montserrat(fontSize: 14)),
                );
              }
              if (state is HomeSuccess) {
                final items = state.response; // accumulated, paged list
                final itemCount = items.length + (state.isLoadingMore ? 1 : 0);

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CupertinoSearchTextField(
                        controller: _controller,
                        backgroundColor: const Color.fromARGB(255, 239, 237, 237),
                        style: GoogleFonts.montserrat(fontSize: 13),
                        placeholder: "Search...",
                        onSubmitted: (_) {
                          _scrollController.jumpTo(0);
                          context.read<HomeBloc>().add(GetPatients(_controller.text.trim()));
                        },
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (n) {
                            // Trigger next page when little content remains below
                            if (n.metrics.extentAfter < 300) {
                              final s = context.read<HomeBloc>().state;
                              if (s is HomeSuccess && s.hasMore && !s.isLoadingMore) {
                                context.read<HomeBloc>().add(GetNextPatients());
                              }
                            }
                            return false;
                          },
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: itemCount,
                            itemBuilder: (context, index) {
                              if (index >= items.length) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }

                              final p = items[index];
                              final zone = p.zone; // 'green' | 'yellow' | 'red' | null
                              final bg = _zoneColor(zone);
                              final textColor = _textOnZone(zone);
                              final isDefault = (zone != 'green' && zone != 'yellow' && zone != 'red');
                              
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AboutPatientScreen(userId: p.userId ?? 0),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: bg,
                                      borderRadius: BorderRadius.circular(12),
                                      border: isDefault ? Border.all(color: const Color(0xFFE5E5E5)) : null,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${p.lastName ?? ''} ${p.firstName ?? ''}',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 14, color: textColor, fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text('ИИН: ',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 11,
                                                color: textColor.withOpacity(0.9),
                                                fontWeight: FontWeight.w400,
                                              )),
                                            Text(p.iin ?? '',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 11,
                                                color: textColor.withOpacity(0.9),
                                                fontWeight: FontWeight.w400,
                                              )),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('Заболевания: ',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 11,
                                                color: textColor.withOpacity(0.9),
                                                fontWeight: FontWeight.w400,
                                              )),
                                            Expanded(
                                              child: Text(
                                                (p.diseases ?? [])
                                                    .map((d) => d.name ?? '')
                                                    .where((s) => s.isNotEmpty)
                                                    .join(', '),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 11, color: textColor, fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
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
              return const Offstage();
            },
          ),
        ),
      ),
    );
  }
}
