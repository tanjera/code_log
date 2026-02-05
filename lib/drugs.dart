import 'package:flutter/material.dart';

class Drug {
  late String name;
  late Color color;

  Drug(this.name, this.color);
}

class Drugs {
  final List<Drug> list = [
    Drug("Adenosine", Colors.grey),
    Drug("Amiodarone", Colors.grey),
    Drug("Aspirin", Colors.grey),
    Drug("Atropine", Colors.purple),
    Drug("Calcium Chloride", Colors.grey),
    Drug("Calcium Gluconate", Colors.grey),
    Drug("Dexamethasone", Colors.grey),
    Drug("Dextrose 50%", Colors.grey),
    Drug("Diltiazem", Colors.grey),
    Drug("Direct Oral Anticoagulant (DOAC)", Colors.grey),
    Drug("Epinephrine", Colors.brown.shade400),
    Drug("Esmolol", Colors.grey),
    Drug("Labetalol", Colors.grey),
    Drug("Lidocaine", Colors.grey),
    Drug("Magnesium Sulfate", Colors.grey),
    Drug("Methylprednisolone", Colors.grey),
    Drug("Metoprolol", Colors.grey),
    Drug("Naloxone", Colors.grey),
    Drug("Nicardipine", Colors.grey),
    Drug("Nifedipine", Colors.grey),
    Drug("Nitroglycerin", Colors.grey),
    Drug("Nitroprusside", Colors.grey),
    Drug("Norepinephrine", Colors.grey),
    Drug("Phenylephrine", Colors.grey),
    Drug("Sodium Bicarbonate", Colors.grey),
  ];
}