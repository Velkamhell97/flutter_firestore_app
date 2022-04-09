import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget? header;
  final Widget? postHeader;
  final Widget form;
  final Widget? preFooter;
  final Widget? footer;

  const AuthBackground({
    Key? key,
    this.header,
    this.postHeader,
    required this.form,
    this.preFooter,
    this.footer
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const _Background(),
        CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            /// Header
            SliverToBoxAdapter(
              child: header
            ),

            /// Post Header
            SliverToBoxAdapter(
              child: postHeader
            ),
          
            /// Form, Pre Footer, Footer
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  form,
                  if(preFooter != null) preFooter!,
                  if(footer != null) footer!,
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}

class _Background extends StatelessWidget {
  const _Background({Key? key}) : super(key: key);

  static const _headerDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color.fromRGBO(63, 63, 156, 1),
        Color.fromRGBO(90, 70, 178, 1)
      ]
    )
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return DecoratedBox(
      decoration: _headerDecoration,
      child: SizedBox(
        width: double.infinity,
        height: size.height * 0.4,
        child: Stack(
          children: const [
            Positioned(child: _Bubble(), top: 90, left: 30),
            Positioned(child: _Bubble(), top: -40, left: -30),
            Positioned(child: _Bubble(), top: -50, right: -20),
            Positioned(child: _Bubble(), bottom: -50, left: 10),
            Positioned(child: _Bubble(), bottom: 120, right: 20),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: const Color.fromRGBO(255, 255, 255, 0.05),
      ),
      child: const SizedBox(
        height: 100,
        width: 100,
      ),
    );
  }
}