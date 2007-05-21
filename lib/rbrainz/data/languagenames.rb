# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

module MusicBrainz
  module Data

	LANGUAGE_NAMES = {
		'ART' => 'Artificial (Other)',
		'ROH' => 'Raeto-Romance',
		'SCO' => 'Scots',
		'SCN' => 'Sicilian',
		'ROM' => 'Romany',
		'RON' => 'Romanian',
		'OSS' => 'Ossetian; Ossetic',
		'ALE' => 'Aleut',
		'MNI' => 'Manipuri',
		'NWC' => 'Classical Newari; Old Newari; Classical Nepal Bhasa',
		'OSA' => 'Osage',
		'MNC' => 'Manch',
		'MWR' => 'Marwari',
		'VEN' => 'Venda',
		'MWL' => 'Mirandese',
		'FAS' => 'Persian',
		'FAT' => 'Fanti',
		'FAN' => 'Fang',
		'FAO' => 'Faroese',
		'DIN' => 'Dinka',
		'HYE' => 'Armenian',
		'DSB' => 'Lower Sorbian',
		'CAR' => 'Carib',
		'DIV' => 'Divehi',
		'TEL' => 'Telug',
		'TEM' => 'Timne',
		'NBL' => 'Ndebele, South; South Ndebele',
		'TER' => 'Tereno',
		'TET' => 'Tetum',
		'SUN' => 'Sundanese',
		'KUT' => 'Kutenai',
		'SUK' => 'Sukuma',
		'KUR' => 'Kurdish',
		'KUM' => 'Kumyk',
		'SUS' => 'Sus',
		'NEW' => 'Newari; Nepal Bhasa',
		'KUA' => 'Kuanyama; Kwanyama',
		'MEN' => 'Mende',
		'LEZ' => 'Lezghian',
		'GLA' => 'Gaelic; Scottish Gaelic',
		'BOS' => 'Bosnian',
		'GLE' => 'Irish',
		'EKA' => 'Ekajuk',
		'GLG' => 'Gallegan',
		'AKA' => 'Akan',
		'BOD' => 'Tibetan',
		'GLV' => 'Manx',
		'JRB' => 'Judeo-Arabic',
		'VIE' => 'Vietnamese',
		'IPK' => 'Inupiaq',
		'UZB' => 'Uzbek',
		'BRE' => 'Breton',
		'BRA' => 'Braj',
		'AYM' => 'Aymara',
		'CHA' => 'Chamorro',
		'CHB' => 'Chibcha',
		'CHE' => 'Chechen',
		'CHG' => 'Chagatai',
		'CHK' => 'Chuukese',
		'CHM' => 'Mari',
		'CHN' => 'Chinook jargon',
		'CHO' => 'Choctaw',
		'CHP' => 'Chipewyan',
		'CHR' => 'Cherokee',
		'CHU' => 'Church Slavic; Old Slavonic; Church Slavonic; Old Bulgarian; Old Church Slavonic',
		'CHV' => 'Chuvash',
		'CHY' => 'Cheyenne',
		'MSA' => 'Malay',
		'III' => 'Sichuan Yi',
		'ACE' => 'Achinese',
		'IBO' => 'Igbo',
		'IBA' => 'Iban',
		'XHO' => 'Xhosa',
		'DEU' => 'German',
		'CAT' => 'Catalan; Valencian',
		'DEL' => 'Delaware',
		'DEN' => 'Slave (Athapascan)',
		'CAD' => 'Caddo',
		'TAT' => 'Tatar',
		'RAJ' => 'Rajasthani',
		'SPA' => 'Spanish; Castilian',
		'TAM' => 'Tamil',
		'TAH' => 'Tahitian',
		'AFH' => 'Afrihili',
		'ENG' => 'English',
		'CSB' => 'Kashubian',
		'NYN' => 'Nyankole',
		'NYO' => 'Nyoro',
		'SID' => 'Sidamo',
		'NYA' => 'Chichewa; Chewa; Nyanja',
		'SIN' => 'Sinhala; Sinhalese',
		'AFR' => 'Afrikaans',
		'LAM' => 'Lamba',
		'SND' => 'Sindhi',
		'MAR' => 'Marathi',
		'LAH' => 'Lahnda',
		'NYM' => 'Nyamwezi',
		'SNA' => 'Shona',
		'LAD' => 'Ladino',
		'SNK' => 'Soninke',
		'MAD' => 'Madurese',
		'MAG' => 'Magahi',
		'MAI' => 'Maithili',
		'MAH' => 'Marshallese',
		'LAV' => 'Latvian',
		'MAL' => 'Malayalam',
		'MAN' => 'Mandingo',
		'ZND' => 'Zande',
		'ZEN' => 'Zenaga',
		'KBD' => 'Kabardian',
		'ITA' => 'Italian',
		'VAI' => 'Vai',
		'TSN' => 'Tswana',
		'TSO' => 'Tsonga',
		'TSI' => 'Tsimshian',
		'BYN' => 'Blin; Bilin',
		'FIJ' => 'Fijian',
		'FIN' => 'Finnish',
		'EUS' => 'Basque',
		'CEB' => 'Cebuano',
		'DAN' => 'Danish',
		'NOG' => 'Nogai',
		'NOB' => 'Norwegian Bokmål; Bokmål, Norwegian',
		'DAK' => 'Dakota',
		'CES' => 'Czech',
		'DAR' => 'Dargwa',
		'DAY' => 'Dayak',
		'NOR' => 'Norwegian',
		'KPE' => 'Kpelle',
		'GUJ' => 'Gujarati',
		'MDF' => 'Moksha',
		'MAS' => 'Masai',
		'LAO' => 'Lao',
		'MDR' => 'Mandar',
		'GON' => 'Gondi',
		'SMS' => 'Skolt Sami',
		'SMO' => 'Samoan',
		'SMN' => 'Inari Sami',
		'SMJ' => 'Lule Sami',
		'GOT' => 'Gothic',
		'SME' => 'Northern Sami',
		'BLA' => 'Siksika',
		'SMA' => 'Southern Sami',
		'GOR' => 'Gorontalo',
		'AST' => 'Asturian; Bable',
		'ORM' => 'Oromo',
		'QUE' => 'Quechua',
		'ORI' => 'Oriya',
		'CRH' => 'Crimean Tatar; Crimean Turkish',
		'ASM' => 'Assamese',
		'PUS' => 'Pushto',
		'DGR' => 'Dogrib',
		'LTZ' => 'Luxembourgish; Letzeburgesch',
		'NDO' => 'Ndonga',
		'GEZ' => 'Geez',
		'ISL' => 'Icelandic',
		'LAT' => 'Latin',
		'MAK' => 'Makasar',
		'ZAP' => 'Zapotec',
		'YID' => 'Yiddish',
		'KOK' => 'Konkani',
		'KOM' => 'Komi',
		'KON' => 'Kongo',
		'UKR' => 'Ukrainian',
		'TON' => 'Tonga (Tonga Islands)',
		'KOS' => 'Kosraean',
		'KOR' => 'Korean',
		'TOG' => 'Tonga (Nyasa)',
		'HUN' => 'Hungarian',
		'HUP' => 'Hupa',
		'CYM' => 'Welsh',
		'UDM' => 'Udmurt',
		'BEJ' => 'Beja',
		'BEN' => 'Bengali',
		'BEL' => 'Belarusian',
		'BEM' => 'Bemba',
		'AAR' => 'Afar',
		'NZI' => 'Nzima',
		'SAH' => 'Yakut',
		'SAN' => 'Sanskrit',
		'SAM' => 'Samaritan Aramaic',
		'SAG' => 'Sango',
		'SAD' => 'Sandawe',
		'RAR' => 'Rarotongan',
		'RAP' => 'Rapanui',
		'SAS' => 'Sasak',
		'SAT' => 'Santali',
		'MIN' => 'Minangkaba',
		'LIM' => 'Limburgan; Limburger; Limburgish',
		'LIN' => 'Lingala',
		'LIT' => 'Lithuanian',
		'EFI' => 'Efik',
		'BTK' => 'Batak (Indonesia)',
		'KAC' => 'Kachin',
		'KAB' => 'Kabyle',
		'KAA' => 'Kara-Kalpak',
		'KAN' => 'Kannada',
		'KAM' => 'Kamba',
		'KAL' => 'Kalaallisut; Greenlandic',
		'KAS' => 'Kashmiri',
		'KAR' => 'Karen',
		'KAU' => 'Kanuri',
		'KAT' => 'Georgian',
		'KAZ' => 'Kazakh',
		'TYV' => 'Tuvinian',
		'AWA' => 'Awadhi',
		'URD' => 'Urd',
		'DOI' => 'Dogri',
		'TPI' => 'Tok Pisin',
		'MRI' => 'Maori',
		'ABK' => 'Abkhazian',
		'TKL' => 'Tokela',
		'NLD' => 'Dutch; Flemish',
		'OJI' => 'Ojibwa',
		'OCI' => 'Occitan (post 1500); Provençal',
		'WOL' => 'Wolof',
		'JAV' => 'Javanese',
		'HRV' => 'Croatian',
		'DYU' => 'Dyula',
		'SSW' => 'Swati',
		'MUL' => 'Multiple languages',
		'HIL' => 'Hiligaynon',
		'HIM' => 'Himachali',
		'HIN' => 'Hindi',
		'BAS' => 'Basa',
		'GBA' => 'Gbaya',
		'WLN' => 'Walloon',
		'BAD' => 'Banda',
		'NEP' => 'Nepali',
		'CRE' => 'Cree',
		'BAN' => 'Balinese',
		'BAL' => 'Baluchi',
		'BAM' => 'Bambara',
		'BAK' => 'Bashkir',
		'SHN' => 'Shan',
		'ARP' => 'Arapaho',
		'ARW' => 'Arawak',
		'ARA' => 'Arabic',
		'ARC' => 'Aramaic',
		'ARG' => 'Aragonese',
		'SEL' => 'Selkup',
		'ARN' => 'Araucanian',
		'LUS' => 'Lushai',
		'MUS' => 'Creek',
		'LUA' => 'Luba-Lulua',
		'LUB' => 'Luba-Katanga',
		'LUG' => 'Ganda',
		'LUI' => 'Luiseno',
		'LUN' => 'Lunda',
		'LUO' => 'Luo (Kenya and Tanzania)',
		'IKU' => 'Inuktitut',
		'TUR' => 'Turkish',
		'TUK' => 'Turkmen',
		'TUM' => 'Tumbuka',
		'COP' => 'Coptic',
		'COS' => 'Corsican',
		'COR' => 'Cornish',
		'ILO' => 'Iloko',
		'GWI' => 'Gwich´in',
		'TLI' => 'Tlingit',
		'TLH' => 'Klingon; tlhIngan-Hol',
		'POR' => 'Portuguese',
		'PON' => 'Pohnpeian',
		'POL' => 'Polish',
		'TGK' => 'Tajik',
		'TGL' => 'Tagalog',
		'FRA' => 'French',
		'BHO' => 'Bhojpuri',
		'SWA' => 'Swahili',
		'DUA' => 'Duala',
		'SWE' => 'Swedish',
		'YAP' => 'Yapese',
		'TIV' => 'Tiv',
		'YAO' => 'Yao',
		'XAL' => 'Kalmyk',
		'FRY' => 'Frisian',
		'GAY' => 'Gayo',
		'OTA' => 'Turkish, Ottoman (1500-1928)',
		'HMN' => 'Hmong',
		'HMO' => 'Hiri Mot',
		'GAA' => 'Ga',
		'FUR' => 'Friulian',
		'MLG' => 'Malagasy',
		'SLV' => 'Slovenian',
		'FIL' => 'Filipino; Pilipino',
		'MLT' => 'Maltese',
		'SLK' => 'Slovak',
		'FUL' => 'Fulah',
		'JPN' => 'Japanese',
		'VOL' => 'Volapük',
		'VOT' => 'Votic',
		'IND' => 'Indonesian',
		'AVE' => 'Avestan',
		'JPR' => 'Judeo-Persian',
		'AVA' => 'Avaric',
		'PAP' => 'Papiamento',
		'EWO' => 'Ewondo',
		'PAU' => 'Palauan',
		'EWE' => 'Ewe',
		'PAG' => 'Pangasinan',
		'PAM' => 'Pampanga',
		'PAN' => 'Panjabi; Punjabi',
		'KIR' => 'Kirghiz',
		'NIA' => 'Nias',
		'KIK' => 'Kikuyu; Gikuy',
		'SYR' => 'Syriac',
		'KIN' => 'Kinyarwanda',
		'NIU' => 'Niuean',
		'EPO' => 'Esperanto',
		'JBO' => 'Lojban',
		'MIC' => 'Mi\'kmaq; Micmac',
		'THA' => 'Thai',
		'HAI' => 'Haida',
		'ELL' => 'Greek, Modern (1453-)',
		'ADY' => 'Adyghe; Adygei',
		'ELX' => 'Elamite',
		'ADA' => 'Adangme',
		'GRB' => 'Grebo',
		'HAT' => 'Haitian; Haitian Creole',
		'HAU' => 'Hausa',
		'HAW' => 'Hawaiian',
		'BIN' => 'Bini',
		'AMH' => 'Amharic',
		'BIK' => 'Bikol',
		'BIH' => 'Bihari',
		'MOS' => 'Mossi',
		'MOH' => 'Mohawk',
		'MON' => 'Mongolian',
		'MOL' => 'Moldavian',
		'BIS' => 'Bislama',
		'TVL' => 'Tuval',
		'IJO' => 'Ijo',
		'EST' => 'Estonian',
		'KMB' => 'Kimbund',
		'UMB' => 'Umbund',
		'TMH' => 'Tamashek',
		'FON' => 'Fon',
		'HSB' => 'Upper Sorbian',
		'RUN' => 'Rundi',
		'RUS' => 'Russian',
		'PLI' => 'Pali',
		'SRD' => 'Sardinian',
		'ACH' => 'Acoli',
		'NDE' => 'Ndebele, North; North Ndebele',
		'DZO' => 'Dzongkha',
		'KRU' => 'Kurukh',
		'SRR' => 'Serer',
		'IDO' => 'Ido',
		'SRP' => 'Serbian',
		'KRO' => 'Kr',
		'KRC' => 'Karachay-Balkar',
		'NDS' => 'Low German; Low Saxon; German, Low; Saxon, Low',
		'ZUN' => 'Zuni',
		'ZUL' => 'Zul',
		'TWI' => 'Twi',
		'NSO' => 'Northern Sotho, Pedi; Sepedi',
		'SOM' => 'Somali',
		'SON' => 'Songhai',
		'SOT' => 'Sotho, Southern',
		'MKD' => 'Macedonian',
		'HER' => 'Herero',
		'LOL' => 'Mongo',
		'HEB' => 'Hebrew',
		'LOZ' => 'Lozi',
		'GIL' => 'Gilbertese',
		'WAS' => 'Washo',
		'WAR' => 'Waray',
		'BUL' => 'Bulgarian',
		'WAL' => 'Walamo',
		'BUA' => 'Buriat',
		'BUG' => 'Buginese',
		'AZE' => 'Azerbaijani',
		'ZHA' => 'Zhuang; Chuang',
		'ZHO' => 'Chinese',
		'NNO' => 'Norwegian Nynorsk; Nynorsk, Norwegian',
		'UIG' => 'Uighur; Uyghur',
		'MYV' => 'Erzya',
		'INH' => 'Ingush',
		'KHM' => 'Khmer',
		'MYA' => 'Burmese',
		'KHA' => 'Khasi',
		'INA' => 'Interlingua (International Auxiliary Language Association)',
		'NAH' => 'Nahuatl',
		'TIR' => 'Tigrinya',
		'NAP' => 'Neapolitan',
		'NAV' => 'Navajo; Navaho',
		'NAU' => 'Naur',
		'GRN' => 'Guarani',
		'TIG' => 'Tigre',
		'YOR' => 'Yoruba',
		'ILE' => 'Interlingue',
		'SQI' => 'Albanian',
	}
  end
end