/// A state's sales tax: the state rate and the average combined state plus
/// local rate. Local rates vary by city and county, so the app suggests the
/// average and lets the user change it.
class StateSalesTax {
  const StateSalesTax(
    this.code,
    this.name, {
    required this.stateBasisPoints,
    required this.averageBasisPoints,
  });

  final String code;
  final String name;
  final int stateBasisPoints;
  final int averageBasisPoints;

  /// Tax on [priceCents] at [basisPoints], rounded to the cent.
  static int taxOn(int priceCents, int basisPoints) =>
      (priceCents * basisPoints / 10000).round();
}

/// Settings key for the state the user buys in, remembered between items.
const homeStateSettingKey = 'home_state';

/// US sales tax rates as of July 1, 2026, from the Tax Foundation's
/// "State and Local Sales Tax Rates, Midyear 2026"
/// (https://taxfoundation.org/data/all/state/2026-sales-tax-rates-midyear/).
const stateSalesTaxes = <StateSalesTax>[
  StateSalesTax(
    'AL',
    'Alabama',
    stateBasisPoints: 400,
    averageBasisPoints: 946,
  ),
  StateSalesTax('AK', 'Alaska', stateBasisPoints: 0, averageBasisPoints: 182),
  StateSalesTax(
    'AZ',
    'Arizona',
    stateBasisPoints: 560,
    averageBasisPoints: 854,
  ),
  StateSalesTax(
    'AR',
    'Arkansas',
    stateBasisPoints: 650,
    averageBasisPoints: 948,
  ),
  StateSalesTax(
    'CA',
    'California',
    stateBasisPoints: 725,
    averageBasisPoints: 903,
  ),
  StateSalesTax(
    'CO',
    'Colorado',
    stateBasisPoints: 290,
    averageBasisPoints: 789,
  ),
  StateSalesTax(
    'CT',
    'Connecticut',
    stateBasisPoints: 635,
    averageBasisPoints: 635,
  ),
  StateSalesTax('DE', 'Delaware', stateBasisPoints: 0, averageBasisPoints: 0),
  StateSalesTax(
    'DC',
    'District of Columbia',
    stateBasisPoints: 600,
    averageBasisPoints: 600,
  ),
  StateSalesTax(
    'FL',
    'Florida',
    stateBasisPoints: 600,
    averageBasisPoints: 698,
  ),
  StateSalesTax(
    'GA',
    'Georgia',
    stateBasisPoints: 400,
    averageBasisPoints: 756,
  ),
  StateSalesTax('HI', 'Hawaii', stateBasisPoints: 400, averageBasisPoints: 450),
  StateSalesTax('ID', 'Idaho', stateBasisPoints: 600, averageBasisPoints: 603),
  StateSalesTax(
    'IL',
    'Illinois',
    stateBasisPoints: 625,
    averageBasisPoints: 898,
  ),
  StateSalesTax(
    'IN',
    'Indiana',
    stateBasisPoints: 700,
    averageBasisPoints: 700,
  ),
  StateSalesTax('IA', 'Iowa', stateBasisPoints: 600, averageBasisPoints: 694),
  StateSalesTax('KS', 'Kansas', stateBasisPoints: 650, averageBasisPoints: 871),
  StateSalesTax(
    'KY',
    'Kentucky',
    stateBasisPoints: 600,
    averageBasisPoints: 600,
  ),
  StateSalesTax(
    'LA',
    'Louisiana',
    stateBasisPoints: 500,
    averageBasisPoints: 1013,
  ),
  StateSalesTax('ME', 'Maine', stateBasisPoints: 550, averageBasisPoints: 550),
  StateSalesTax(
    'MD',
    'Maryland',
    stateBasisPoints: 600,
    averageBasisPoints: 600,
  ),
  StateSalesTax(
    'MA',
    'Massachusetts',
    stateBasisPoints: 625,
    averageBasisPoints: 625,
  ),
  StateSalesTax(
    'MI',
    'Michigan',
    stateBasisPoints: 600,
    averageBasisPoints: 600,
  ),
  StateSalesTax(
    'MN',
    'Minnesota',
    stateBasisPoints: 688,
    averageBasisPoints: 814,
  ),
  StateSalesTax(
    'MS',
    'Mississippi',
    stateBasisPoints: 700,
    averageBasisPoints: 706,
  ),
  StateSalesTax(
    'MO',
    'Missouri',
    stateBasisPoints: 423,
    averageBasisPoints: 844,
  ),
  StateSalesTax('MT', 'Montana', stateBasisPoints: 0, averageBasisPoints: 0),
  StateSalesTax(
    'NE',
    'Nebraska',
    stateBasisPoints: 550,
    averageBasisPoints: 698,
  ),
  StateSalesTax('NV', 'Nevada', stateBasisPoints: 685, averageBasisPoints: 824),
  StateSalesTax(
    'NH',
    'New Hampshire',
    stateBasisPoints: 0,
    averageBasisPoints: 0,
  ),
  StateSalesTax(
    'NJ',
    'New Jersey',
    stateBasisPoints: 663,
    averageBasisPoints: 660,
  ),
  StateSalesTax(
    'NM',
    'New Mexico',
    stateBasisPoints: 488,
    averageBasisPoints: 768,
  ),
  StateSalesTax(
    'NY',
    'New York',
    stateBasisPoints: 400,
    averageBasisPoints: 854,
  ),
  StateSalesTax(
    'NC',
    'North Carolina',
    stateBasisPoints: 475,
    averageBasisPoints: 710,
  ),
  StateSalesTax(
    'ND',
    'North Dakota',
    stateBasisPoints: 500,
    averageBasisPoints: 709,
  ),
  StateSalesTax('OH', 'Ohio', stateBasisPoints: 575, averageBasisPoints: 729),
  StateSalesTax(
    'OK',
    'Oklahoma',
    stateBasisPoints: 450,
    averageBasisPoints: 906,
  ),
  StateSalesTax('OR', 'Oregon', stateBasisPoints: 0, averageBasisPoints: 0),
  StateSalesTax(
    'PA',
    'Pennsylvania',
    stateBasisPoints: 600,
    averageBasisPoints: 634,
  ),
  StateSalesTax(
    'RI',
    'Rhode Island',
    stateBasisPoints: 700,
    averageBasisPoints: 700,
  ),
  StateSalesTax(
    'SC',
    'South Carolina',
    stateBasisPoints: 600,
    averageBasisPoints: 749,
  ),
  StateSalesTax(
    'SD',
    'South Dakota',
    stateBasisPoints: 420,
    averageBasisPoints: 611,
  ),
  StateSalesTax(
    'TN',
    'Tennessee',
    stateBasisPoints: 700,
    averageBasisPoints: 961,
  ),
  StateSalesTax('TX', 'Texas', stateBasisPoints: 625, averageBasisPoints: 820),
  StateSalesTax('UT', 'Utah', stateBasisPoints: 610, averageBasisPoints: 742),
  StateSalesTax(
    'VT',
    'Vermont',
    stateBasisPoints: 600,
    averageBasisPoints: 643,
  ),
  StateSalesTax(
    'VA',
    'Virginia',
    stateBasisPoints: 530,
    averageBasisPoints: 577,
  ),
  StateSalesTax(
    'WA',
    'Washington',
    stateBasisPoints: 650,
    averageBasisPoints: 957,
  ),
  StateSalesTax(
    'WV',
    'West Virginia',
    stateBasisPoints: 600,
    averageBasisPoints: 660,
  ),
  StateSalesTax(
    'WI',
    'Wisconsin',
    stateBasisPoints: 500,
    averageBasisPoints: 572,
  ),
  StateSalesTax(
    'WY',
    'Wyoming',
    stateBasisPoints: 400,
    averageBasisPoints: 539,
  ),
];

StateSalesTax? stateSalesTax(String? code) =>
    stateSalesTaxes.where((s) => s.code == code).firstOrNull;
