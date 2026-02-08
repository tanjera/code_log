import 'package:flutter/material.dart';

import '../models/drug.dart';

class Drugs {
  List<Drug> list = [
    Drug("Adenosine", null, null),
    Drug("Amiodarone", "IV Push", null),
    Drug("Amiodarone", "IV Bolus via Minibag", null),
    Drug("Amiodarone", "IV Infusion", null),
    Drug("Aspirin", null, null),
    Drug("Atropine", null, Colors.purple),
    Drug("Calcium Chloride", null, Colors.yellow),
    Drug("Calcium Gluconate", null, null),
    Drug("Cryoprecipitate", null, Colors.yellow),
    Drug("Dexamethasone", null, null),
    Drug("Dextrose 50%", null, Colors.blue),
    Drug("Diazepam", "IV", null),
    Drug("Diazepam", "PR", null),
    Drug("Diltiazem", null, null),
    Drug("Direct Oral Anticoagulant (DOAC)", null, null),
    Drug("Epinephrine", "IV", Colors.brown.shade400),
    Drug("Epinephrine", "Inhaled", null),
    Drug("Esmolol", null, null),
    Drug("Labetalol", null, null),
    Drug("Lactated Ringers", null, Colors.blue.shade100),
    Drug("Lidocaine", null, Colors.red.shade200),
    Drug("Lorazepam", "IV", null),
    Drug("Lorazepam", "Intramuscular", null),
    Drug("Mannitol", null, null),
    Drug("Magnesium Sulfate", null, null),
    Drug("Methylprednisolone", null, null),
    Drug("Metoprolol", null, null),
    Drug("Midazolam", "IV", null),
    Drug("Midazolam", "Intramuscular", null),
    Drug("Naloxone", "IV", null),
    Drug("Naloxone", "Intranasal", null),
    Drug("Nicardipine", null, null),
    Drug("Nifedipine", null, null),
    Drug("Nitroglycerin", null, null),
    Drug("Nitroprusside", null, null),
    Drug("Norepinephrine", null, null),
    Drug("Normal Saline", null, Colors.blue.shade100),
    Drug("Packed Red Blood Cells (PRBC)", null, Colors.red),
    Drug("Phenylephrine", null, null),
    Drug("Plasma, Fresh Frozen (FFP)", null, Colors.yellow),
    Drug("Platelets", null, Colors.yellow),
    Drug("Sodium Bicarbonate", null, Colors.yellow.shade800),
  ];

  Drugs() {
    // In case they are out of alphabetical order in the declaring list...
    list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }
}