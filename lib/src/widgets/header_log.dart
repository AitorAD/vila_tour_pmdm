import 'package:flutter/material.dart';

class HeaderLog extends StatelessWidget {
  const HeaderLog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset("assets/logo.ico", scale: 2),
          const Text(
            'VILATOUR',
            style: TextStyle(
              fontFamily: 'PontanoSans',
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Image.asset("assets/logo.ico", scale: 2, color: Colors.white.withOpacity(0), colorBlendMode: BlendMode.srcIn,),
        ],
      ),
    );
  }
}