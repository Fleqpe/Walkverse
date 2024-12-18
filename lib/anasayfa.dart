import 'package:flutter/material.dart';
import 'package:walkverse/chart.dart';
import 'package:walkverse/container.dart';
import 'package:walkverse/renkler.dart';

class Anasayfa extends StatelessWidget
{
  const Anasayfa({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 40)),
        Center(
          child: Container(
              width: 400,
              height: 90,
              decoration: createDecoration(accentColor),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      "Images/Character.png",
                      width: 50,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        createText("Barış Kurt", 16),
                        createText("Lv. 9", 16)
                      ],
                    ),
                  )
                ],
              )),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Container(
              width: 400,
              height: 90,
              decoration: createDecoration(accent3Color),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        createText("BUGÜN ATILAN ADIM SAYISI", 20),
                        createText("10/100", 18),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 40),
                    child: createText("%100", 30),
                  )
                ],
              ),
            ),
          ),
        ),
        Center(
            child: Padding(
          padding: const EdgeInsets.only(top: 25, right: 10, left: 10),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 175,
                  height: 90,
                  decoration: createDecoration(accentColor),
                  child: Padding(
                      padding: const EdgeInsets.only(),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            createText("HAFTALIK HEDEF", 18),
                            createText("3655", 30)
                          ],
                        ),
                      )),
                ),
                Container(
                    width: 175,
                    height: 90,
                    decoration: createDecoration(accentColor),
                    child: Padding(
                        padding: const EdgeInsets.only(),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              createText("AYLIK HEDEF", 18),
                              createText("3655", 30)
                            ],
                          ),
                        )))
              ],
            ),
          ),
        )),
        Center(
            child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Container(
            width: 400,
            height: 175,
            decoration: createDecoration(accentColor),
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.all(10)),
                Text(
                  "RAPOR",
                  style: TextStyle(
                      color: textColor, fontFamily: font2, fontSize: 25),
                ),
                const SizedBox(
                  height: 115,
                  child: ChartWidget(),
                )
              ],
            ),
          ),
        )),
      ],
    );
  }
}