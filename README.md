# UNDP SSC Mapping and data explorer

Based on a subset of data from http://open.undp.org, presents and maps additional attributes specific to South-South Cooperation.

## Contents

* [Basic information](#user-manual) about using the application
* [Managing data](docs/manage.md) for administrators
* [Application structure](docs/app.md) for developers and administrators
* [Data and fields](docs/data.md) for developers and administrators
* [Admin scripts](admin_scripts/admin_scripts.md) used for initial data processing (not intended for regular or production use)

## User manual

The application is designed to be used without requiring a manual. This document is to help administrators and managers point users in the right direction, and also to outline the application's functionality.

### Switching views (map, statistics, list)

![Switching views](https://www.dropbox.com/s/pwniekd73et08rr/Screenshot%202015-05-07%2009.50.08.png?dl=1)

### Filtering

### Searching

### Sharing links


### Downloading

The [`projects.csv` file](http://www.undp-ssc-mapping.org/api/projects.csv) contains all data about all SSC projects. To simplify data storage, as well as to make it easier to use the data in further analysis outside the SSC site, many of the columns/fields are encoded. These should be easy to understand, but for reference a series of abbreviation tables are included [below](#filter-abbreviations)

## Filter abbreviations

#### Partner
Short | Full 
---|---
`academia` | Academia
`cso` | CSO
`international_cooperation_development_agencies` | International cooperation / development agencies
`national_governments` | National governments
`private_sector` | Private sector
`regional_inter_governmental_organizations` | Regional / Inter-governmental organizations
`sub_national_governments` | Sub-national governments

#### Region
Short | Full 
---|---
`africa` | Africa
`arab_states` | Arab States
`asia_pacific` | Asia & Pacific
`europe_cis` | Europe & CIS
`lac` | Latin America & Caribbean

#### Thematic focus
Short | Full 
---|---
`inclusive_and_effective_democratic_governance` | Inclusive and effective democratic governance
`resilience_building` | Resilience building
`sustainable_development_pathways` | Sustainable development pathways

#### UNDP Role
Short | Full 
---|---
`builder_of_capacities` | Builder of capacities
`facilitator_of_partnerships` | Facilitator of partnerships
`knowledge_broker` | Knowledge broker

#### Territorial focus
Short | Full 
---|---
`fragile_states` | Fragile States
`hic` | High Income Countries
`ldc` | Least Developed Countries
`mic` | Middle Income Countries
`sids` | Small Island Developing States

#### Scale
Short | Full 
---|---
`global` | Global
`national` | National
`regional` | Regional



#### Countries
Full | ISO3 | Coordinates (centre)  
---|---|---
Afghanistan | AFG | 33.838806, 66.026471
Albania | ALB | 41.142285, 20.068385
Algeria | DZA | 28.163239, 2.632388
American Samoa | ASM | -14.304407, -170.707832
Andorra | AND | 42.548653, 1.576765
Angola | AGO | -12.295285, 17.544676
Anguilla | AIA | 18.222877, -63.060077
Antarctica | ATA | -80.446037, 21.297686
Antigua and Barbuda | ATG | 17.279818, -61.791237
Argentina | ARG | -31.486376, -63.839414
Armenia | ARM | 40.28662, 44.946824
Aruba | ABW | 12.515627, -69.975641
Australia | AUS | -25.734968, 134.489562
Austria | AUT | 47.592903, 14.140193
Azerbaijan | AZE | 40.292173, 47.532767
Bahamas | BHS | 24.201126, -76.546622
Bahrain | BHR | 26.02241, 50.559643
Bangladesh | BGD | 23.843232, 90.268498
Barbados | BRB | 13.178715, -59.561955
Belarus | BLR | 53.539998, 28.046788
Belgium | BEL | 50.642851, 4.663989
Belize | BLZ | 17.217666, -88.684767
Benin | BEN | 10.501237, 2.461735
Bermuda | BMU | 32.316086, -64.739605
Bhutan | BTN | 27.415414, 90.429435
Bolivia (Plurinational State of) | BOL | -16.71461, -64.670932
Bosnia and Herzegovina | BIH | 44.168115, 17.786531
Botswana | BWA | -22.182004, 23.815028
Bouvet Island | BVT | -54.421903, 3.412522
Brazil | BRA | -10.773109, -53.08982
British Indian Ocean Territory | IOT | -7.334266, 72.434027
British Virgin Islands | VGB | 18.444589, -64.530423
Brunei Darussalam | BRN | 4.521445, 114.761099
Bulgaria | BGR | 42.761377, 25.231506
Burkina Faso | BFA | 12.27793, -1.740141
Burundi | BDI | -3.356175, 29.887145
Cambodia | KHM | 12.716432, 104.923981
Cameroon | CMR | 5.685952, 12.743594
Canada | CAN | 61.392017, -98.265329
Cape Verde | CPV | 15.978973, -23.967785
Cayman Islands | CYM | 19.308663, -81.238453
Central African Republic | CAF | 6.571232, 20.482967
Chad | TCD | 15.361167, 18.66448
Chile | CHL | -33.82011, -70.947023
China | CHN | 36.567909, 103.904056
Christmas Island | CXR | -10.444115, 105.703697
Cocos Islands | CCK | -12.17125, 96.836882
Colombia | COL | 3.901156, -73.073369
Comoros | COM | -11.892755, 43.67592
Cook Islands | COK | -20.934038, -158.908883
Costa Rica | CRI | 9.970203, -84.187942
Croatia | HRV | 45.251162, 16.411778
Cuba | CUB | 21.929528, -78.870313
Cyprus | CYP | 35.045883, 33.221763
Czech Republic | CZE | 49.742859, 15.338412
Côte d'Ivoire | CIV | 8.461729, -5.5319
Democratic Republic of Congo | COD | -2.686476, 23.275488
Denmark | DNK | 55.963398, 10.046298
Djibouti | DJI | 11.749676, 42.577765
Dominica | DMA | 15.435595, -61.355757
Dominican Republic | DOM | 18.965607, -70.223715
Ecuador | ECU | -1.142781, -78.340114
Egypt | EGY | 26.55378, 29.790197
El Salvador | SLV | 13.736897, -88.866512
Equatorial Guinea | GNQ | 1.712339, 10.341982
Eritrea | ERI | 15.373203, 38.841286
Estonia | EST | 58.674136, 25.527616
Ethiopia | ETH | 8.633291, 39.616176
Falkland Islands (Malvinas) | FLK | -51.737117, -59.363298
Faroe Islands | FRO | 62.031067, -6.88411
Fiji | FJI | -17.45353, 171.983227
Finland | FIN | 63.741386, 26.693329
France | FRA | 46.564502, 2.551955
French Guiana | GUF | 3.54517, -53.217504
French Polynesia | PYF | -14.854976, -146.418584
French Southern and Antarctic Territories | ATF | -49.191795, 68.861925
Gabon | GAB | -0.590944, 11.797236
Gambia | GMB | 13.452649, -15.386643
Georgia | GEO | 42.176312, 43.517446
Germany | DEU | 51.106592, 10.393662
Ghana | GHA | 7.177092, -1.207301
Gibraltar | GIB | 36.138215, -5.344895
Greece | GRC | 39.068537, 22.959746
Greenland | GRL | 74.720918, -41.389501
Grenada | GRD | 12.112925, -61.67938
Guadeloupe | GLP | 16.203461, -61.536743
Guam | GUM | 13.443566, 144.775596
Guatemala | GTM | 15.702135, -90.356242
Guinea | GIN | 10.81773, -11.226411
Guinea-Bissau | GNB | 12.030308, -14.965217
Guyana | GUY | 5.883132, -59.1171
Haiti | HTI | 18.870449, -72.762477
Heard Island and McDonald Islands | HMD | -53.091333, 73.498374
Holy See | VAT | 41.903365, 12.452254
Honduras | HND | 14.819222, -86.619146
Hong Kong, China (SAR) | HKG | 22.377362, 114.110058
Hungary | HUN | 47.166502, 19.413448
Iceland | ISL | 64.997588, -18.605467
India | IND | 22.326122, 79.386009
Indonesia | IDN | -2.230214, 117.300428
Iran (Islamic Republic of) | IRN | 32.565771, 54.301402
Iraq | IRQ | 33.048024, 43.772135
Ireland | IRL | 53.176382, -8.150579
Isle of Man | IMY | 54.229082, -4.525849
Israel | ISR | 30.801039, 34.888721
Italy | ITA | 42.795782, 12.071743
Jamaica | JAM | 18.151419, -77.319011
Japan | JPN | 37.562162, 137.990745
Jordan | JOR | 31.312616, 36.288613
Kazakhstan | KAZ | 48.160272, 67.302857
Kenya | KEN | 0.529562, 37.858021
Kiribati | KIR | 1.834562, -154.458271
Korea (Republic of) | KOR | 36.375089, 127.834772
Korea, Democratic People's Republic of | PRK | 40.143064, 127.181957
Kosovo (SCR 1244) | KOS | 42.571, 20.872
Kuwait | KWT | 29.340791, 47.590876
Kyrgyz Republic | KGZ | 41.465055, 74.555597
Lao People's Democratic Republic | LAO | 18.502744, 103.763291
Latvia | LVA | 56.857534, 24.929424
Lebanon | LBN | 33.920267, 35.888027
Lesotho | LSO | -29.581, 28.243011
Liberia | LBR | 6.448092, -9.307914
Libya | LBY | 27.043954, 18.023287
Liechtenstein | LIE | 47.151849, 9.554268
Lithuania | LTU | 55.33567, 23.898123
Luxembourg | LUX | 49.77063, 6.087814
Macao | MAC | 22.18332, 113.550125
Madagascar | MDG | -19.373383, 46.706039
Malawi | MWI | -13.216022, 34.307155
Malaysia | MYS | 3.792367, 109.708194
Maldives | MDV | 3.216335, 73.252227
Mali | MLI | 17.682358, -2.717947
Malta | MLT | 35.890522, 14.441923
Marshall Islands | MHL | 7.643273, 168.626921
Martinique | MTQ | 14.65255, -61.021288
Mauritania | MRT | 20.259851, -10.332298
Mauritius | MUS | -20.251869, 57.870737
Mayotte | MYT | -12.81871, 45.1387
Mexico | MEX | 23.950464, -102.532885
Micronesia (Federated States of) | FSM | 6.49238, 159.404221
Monaco | MCO | 43.747983, 7.412822
Mongolia | MNG | 46.835291, 103.083218
Montenegro | MNE | 42.791593, 19.250305
Montserrat | MSR | 16.735366, -62.186936
Morocco | MAR | 32.310583, -6.270405
Mozambique | MOZ | -17.638842, 35.788621
Myanmar | MMR | 21.154319, 96.506921
Namibia | NAM | -22.133246, 17.218278
Nauru | NRU | -0.528742, 166.92313
Nepal | NPL | 28.253007, 83.938548
Netherlands | NLD | 52.249263, 5.603418
Netherlands Antilles | ANT | 12.187805, -68.693669
New Caledonia | NCL | -21.316337, 165.715488
New Zealand | NZL | -41.767715, 172.989641
Nicaragua | NIC | 12.839906, -85.034783
Niger | NER | 17.426149, 9.397648
Nigeria | NGA | 9.59396, 8.105306
Niue | NIU | -19.05231, -169.868781
Norfolk Island | NFK | -29.037658, 167.952597
Northern Mariana Islands | MNP | 15.08852, 145.67922
Norway | NOR | 61.317147, 9.245945
Oman | OMN | 20.099577, 56.609501
Pakistan | PAK | 29.357903, 68.790144
Palau | PLW | 7.501882, 134.568687
Panama | PAN | 8.507186, -80.102662
Papua New Guinea | PNG | -6.478768, 145.241217
Paraguay | PRY | -23.236211, -58.296144
Peru | PER | -10.017675, -75.229543
Philippines | PHL | 11.741833, 122.878708
Pitcairn Island | PCN | -24.476532, -128.593232
Poland | POL | 52.12461, 19.400884
Portugal | PRT | 39.69191, -8.151946
Puerto Rico | PRI | 18.221329, -66.462342
Qatar | QAT | 25.297876, 51.188069
Republic of Congo | COG | -0.176075, 15.84101
Republic of Macedonia | MKD | 41.599682, 21.697476
Republic of Moldova | MDA | 47.193869, 28.473931
Reunion | REU | -21.12166, 55.53818
Romania | ROU | 45.843615, 24.969259
Russian Federation | RUS | 61.991755, 96.682513
Rwanda | RWA | -1.997892, 29.917652
Saint Kitts and Nevis | KNA | 17.326191, -62.75352
Saint Lucia | LCA | 13.897866, -60.968711
Saint Vincent and the Grenadines | VCT | 13.254811, -61.193766
Samoa | WSM | -13.758364, -172.159464
San Marino | SMR | 43.94364, 12.458633
Sao Tome and Principe | STP | 0.456979, 6.736586
Saudi Arabia | SAU | 24.122888, 44.545719
Senegal | SEN | 14.366966, -14.467654
Serbia | SRB | 44.031498, 20.805272
Seychelles | SYC | -6.35437, 52.229899
Sierra Leone | SLE | 8.560285, -11.791922
Singapore | SGP | 1.351615, 103.808051
Slovak Republic | SVK | 48.7, 19.59
Slovenia | SVN | 46.123564, 14.826537
Solomon Islands | SLB | -8.918214, 159.634315
Somalia | SOM | 6.016284, 47.570422
South Africa | ZAF | -28.329047, 24.70926
South Sudan | SSD | 7.37, 30.34
Spain | ESP | 40.22683, -3.649565
Sri Lanka | LKA | 7.608086, 80.704727
Sudan | SDN | 15.99, 29.99
Suriname | SUR | 4.458473, -55.959266
Svalbard and Jan Mayen Islands | SJM | 78.828632, 18.363468
Swaziland | SWZ | -26.562642, 31.497528
Sweden | SWE | 64.877246, 17.54623
Switzerland | CHE | 46.802569, 8.234429
Syrian Arab Republic | SYR | 35.013134, 38.505132
Taiwan | TWN | 23.754013, 120.950798
Tajikistan | TJK | 38.860256, 71.350363
Tanzania (United Republic of) | TZA | -6.270354, 34.823454
Thailand | THA | 15.127036, 101.017361
Timor-Leste | TLS | -8.822976, 125.853675
Togo | TGO | 8.748439, 1.023161
Tokelau | TKL | -9.195175, -171.85266
Tonga | TON | -20.40292, -174.836286
Trinidad and Tobago | TTO | 10.468641, -61.253177
Tunisia | TUN | 33.9211, 8.944619
Turkey | TUR | 39.060595, 35.179672
Turkmenistan | TKM | 39.122335, 59.383984
Turks and Caicos Islands | TCA | 21.836682, -71.812947
Tuvalu | TUV | -7.827722, 178.557551
Uganda | UGA | 1.279963, 32.386218
Ukraine | UKR | 49.396606, 31.387115
United Arab Emirates | ARE | 23.903193, 54.340734
United Kingdom | GBR | 54.15535, -2.895585
United States | USA | 40.382491, -100.347172
United States Virgin Island | VIR | 17.905107, -64.807034
Uruguay | URY | -32.799645, -56.012396
Uzbekistan | UZB | 41.750444, 63.169364
Vanuatu | VUT | -16.255053, 167.718146
Venezuela (Bolivarian Republic of) | VEN | 7.786605, -65.647727
Viet Nam | VNM | 14.287268, 108.341384
Western Sahara | ESH | 24.803991, -13.421179
Yemen | YEM | 15.905517, 47.599591
Zambia | ZMB | -13.927416, 27.466171
Zimbabwe | ZWE | -19.379617, 29.729518

