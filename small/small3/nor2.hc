#############################################################################
##
#W  nor2.hc                GAP library of groups           Hans Ulrich Besche
##                                               Bettina Eick, Eamonn O'Brien
##
Revision.nor2_hc :=
    "@(#)$Id$";

SMALL_GROUP_LIB[ 8 ][ 3 ] :=
rec( pos := [ 1, -22, 39, -63, 87, -200, 316, -381, 443, -458, 497, -502, 531
, -532, 537, -538, 546, -593, 826, -829, 835, -837, 841, -842, 847, -848, 853
, -854, 859, -861, 869, -870, 877, -880, 893, -896, 905, -906, 911, -912, 919
, -920, 1119, -1121, 1125, -1126, 1131, -1134, 1136, 1138, -1139, 1144, 1147,
1150, -1151, 1156, -1159, 1172, -1173, 1178, -1179, 1186, -1189, 1247, -1250,
1252, 1254, 1256, 1259, -1260, 1263, 1268, -1269, 1272, -1273, 1280, 1282,
1286, -1291, 1298, -1300, 1304, 1306, -1307, 1310, -1312, 1545, -1548, 1551,
-1554, 1583, -1585, 1589, -1590, 1592, -1593, 1686, -1689, 1694, -1696, 1718,
-1719, 1722, -1723, 1768, -1769, 1772, -1774, 1788, -1789, 1793, -1796, 1817,
-1819, 1823, -1824, 1827, -1828, 1831, -1834, 1839, 1925, -1928, 1933, -1936,
1941, -1942, 1945, -1948, 1953, -1954, 2059, -2062, 2067, -2070, 2075, -2078,
2083, -2084, 2087, -2090, 2095, -2096, 2521, -2524, 2529, -2532, 2537, -2538,
2541, -2544, 2581, -2584, 2589, -2591, 2595, -2596, 2625, -2630, 2637, -2639,
2643, -2648, 2655, -2657, 2661, -2663, 2852, -2854, 2858, -2861, 2866, -2868,
3680, 3683, 3700, 3702, 3783, 3785, 3820, 3822, 3862, 3864, 3909, 3952, 4030,
4135, 4190, 4243, 4286, 4310, 4334, 4368, 4384, -4400, 4405, -4486, 4569,
-4632, 4983, -5006, 5025, -5056, 5525, -5527, 5531, -5542, 5578, -5582, 5586,
-5592, 5598, -5603, 5640, -5644, 5649, -5653, 5667, -5674, 5771, -5780, 5832,
-5839, 5867, -5872, 5882, -5889, 5900, -5906, 5964, -5977, 6092, -6094, 6108,
-6113, 6147, -6152, 6177, -6185, 6251, -6256, 6534, -6546, 6614, -6618, 6627,
-6636, 6647, -6648, 6723, -6725, 10298, -10304, 10331, -10341, 10419, -10427,
10771, -10777, 10830, -10846, 13313, 13320, 13349, 13359, 13368, 13411, 13420
, 13449, 13459, 13471, 13503, 13511, 13521, 13531, 13543, 13557, 13565, 13612
, 13668, 13702, 13738, 13758, 13765, 13777, 13796, 13820, 13881, 14006, 14032
, 14089, 14129, 14173, 14252, 14286, 14327, 14337, 14361, 14418, 14426, 14473
, 14548, 14583, 14618, 14652, 14660, 14668, 14699, 14726, 14774, 14806, 14835
, 14890, 14900, 14910, 14918, 14939, 14960, 14984, 14996, 15006, 15016, 15051
, 15086, 15121, 15156, 15196, 15226, 15248, 15275, 15287, 15295, 15305, 15317
, 15329, 15345, 15361, 15373, 15385, 15457, 15496, 15518, 15540, 15577, 15587
, 15613, 15620, 15627, 15634, 15684, 15708, 15722, 15736, 15773, 15783, 15809
, 15816, 15823, 15830, 15888, 15940, 15973, 16038, 16071, 16104, 16137, 16161
, 16192, 16225, 16235, 16241, 16251, 16257, 16266, 16282, 16294, 16302, 16314
, 16324, 16334, 16343, 16351, 16357, 16363, 26308, -26314, 26318, -26328,
26382, -26389, 26403, -26411, 26417, -26431, 26460, -26497, 26959, -26962,
53038, 53047, 53082, 53102, 53118, 53173, 53184, 53208, 53230, 53243, 53264,
53291, 53317, 55608, -55612, 56059 ], val := [ 1, 128, 129, -3, -2, -2, -2,
-2, [ 57 ], -9, -9, -9, -1, -1, -1, -2, -2, -2, -2, -2, -2, -2, -1, -3,
[ 1, -3, 49 ], 2176, -42, -42, -42, -42, -42, -42, -42, -42, -42, -42, -2, -2
, -42, -42, -42, -42, -42, -42, -42, -42, -42, [ 8, -3, 12, -3 ], -42, -42,
-42, -2, -2, -42, -42, -2, -2, -42, -2, -2, -2, -2, -42, -42, -2, -2, -42,
-42, -2, -2, -2, -2, -42, -42, -2, -2, -42, [ 8, -3 ], -117, -2, -2, -42,
-117, -117, -3, -3, -3, -3, [ 1, 8, 57 ], -128, 8320, -130, -130, -130, -130,
-130, -130, -130, -130, -130, -130, -130, -2, -2, -2, -2, -2, -2, -130, -130,
-130, [ 41, 57 ], -151, -151, -151, -151, -151, -151, -151, -9, -9, -9, -9,
-9, -9, -9, -9, -151, -151, -151, -151, -130, -130, -130, -130, -130, -130,
-130, -130, -130, -130, -130, -130, -130, -130, -2, -2, -151, -151, -151,
-151, -9, -9, -9, -9, -151, -151, -151, -151, -151, -151, 8321, -316,
[ 1, -3, 8, 14 ], [ 1, 33, 49 ], -41, [ 1, -5, -3, -7 ], -42, -42, -42, -42,
-42, -42, -2, -2, -2, -2, -2, -2, -2, -2, -117, -117, -117, -117, -2, -2, -2,
-2, -42, -42, -117, -117, -117, -117, -42, -42, -42, -42, -117, -2, -117, -2,
-2, -2, -2, -42, -2, -2, -2, -2, -2, -42, -42, -42, -42, -2, -2, -2, -2, -42,
-42, -87, -117, -117, -42, -42, -42, -42, [ 8, -5, -3, -7 ], -42, -42, -2, -2
, -42, -117, -117, 10368, -453, -453, -453, -453, -453, -453, -453,
[ 8, 12, 14, -3 ], -42, -42, -42, -42, -42, -42, -42, [ 64 ], -546, -546,
-546, -546, -546, -546, [ 70 ], -553, -553, -553, -553, -553, -553, -546,
-546, -546, -546, -546, -546, -546, -546, -546, -546, -553, -553, -553, -553,
-553, -553, -553, -553, -553, -553, -546, -546, -546, -546, -546, -546, -546,
-553, -553, -553, -553, -553, -553, -553, -2, -2, -2, -2, -546, -2, -2, -546,
-553, -546, -553, -546, -546, -546, -546, -546, [ 456 ], -869, -869, -869,
-869, -869, -546, -546, -553, -553, -546, -553, -869, -869, -869, -869, -546,
-2, -2, -546, -553, [ 8, 321 ], -2, [ 321 ], -2, -1133, [ 8, 398 ], -1138,
-1138, -1133, -1133, -1133, -2, -2, -2, -2, -2, -2, -1133, -1133, -1133,
-1133, -1133, -1133, -1131, -2, -1133, -2, -1133, -2, -2, -2, -2, -2, -1133,
-1133, -1133, -1133, -1133, -1133, -546, -546, -546, -553, -553, -553, -546,
-546, -546, -546, -546, -546, -546, -546, -546, -546, -546, [ 112 ], -1547,
-546, -546, -546, -546, -546, -546, -546, -546, -1547, -546, -546, -546, -546
, -1547, -1547, -546, -546, -546, -546, -553, -546, -546, -546, -553, -546,
-546, -546, -546, -1547, -546, -546, -546, -546, [ 328 ], -1817, -1817, -1817
, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817
, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817
, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817
, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817
, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817
, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817
, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817
, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817
, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -1817, -546,
[ 449 ], -546, -869, -546, -869, -546, -869, -2, -1133, -1133, -546, -546,
-546, -546, -546, -546, -546, -546, -546, [ 8, 64, 68 ], -4384, -4384,
[ 8, 64, 68, 456 ], [ 8, 12, 392, 396 ], -42, -42, -117, -2, -2, -2, -4388,
-4388, -4388, -4388, -4388, -42, [ 64, 68, 96 ], -4405, [ 64, 68, 100 ],
-4405, -4405, -4407, -546, -546, -546, -546, -546, -546, -546, -546, -546,
-546, -546, -546, -4405, -4407, -4405, -4407, -4405, -4405, -4407, [ 64, 68 ]
, -4430, -4407, -546, -546, -546, -546, -546, -546, -546, -546, -546, -546,
-4405, -4407, -4430, -4430, [ 64, 68, 96, 100 ], -4447, -4447, [ 64, 96 ],
-4450, -4447, [ 66, 70, 98, 102 ], -4453, -4453, [ 70, 102 ], -4456, -4453,
-553, -553, -553, -553, -553, -553, -553, -553, -553, -553, -553, -553, -4456
, -4456, -4453, -4453, [ 66, 70, 98 ], -4475, [ 66, 70, 102 ], -4477, -4477,
-4475, -4475, -4475, -4477, [ 66, 70 ], -4484, -4475, -4405, -4407, -4405,
-4407, -4405, -4407, -4405, -4407, -546, -546, -546, -546, -546, -546, -546,
-546, -546, -546, -546, -546, -4405, -4407, -4405, -4407, -4405, -4407, -4405
, -4407, -4405, -4407, -4405, -4407, -4447, -4447, -4447, -4447, -4447, -4447
, -4447, -4447, -4447, -4447, -4447, -4447, -4447, -4447, -4447, -4447, -4405
, -4407, -4405, -4407, -4405, -4407, -4405, -4407, -4405, -4407, -4405, -4407
, -4405, -4407, -4405, -4407, -4405, -4407, -4430, [ 64, -3 ], -546, -546,
[ 64, -3, 68 ], -546, -4405, -4407, -4430, -546, -546, -546, -546, -4405,
-546, -4447, -4447, -4430, -4405, -4405, -4407, -4407, [ 65, 321, 353 ],
[ 65, 97, 321, 353 ], [ 65, 97, 321 ], -1133, -1133, -1133, -1133, -1133,
-1133, -5025, -5027, -5026, -5026, -5026, -5026, -5025, -5026, -5027, -5026,
-5026, -5026, -5026, -5025, -5026, -5027, -5025, -5026, -5027, [ 321, -3 ],
-5053, -5053, [ 65, -3, 97, -3, 321, -3 ], [ 64, 70 ], [ 64, 70, 112 ],
[ 64, 112 ], [ 64, 68, 112 ], -5531, -5531, -5527, -5527, [ 64, 112, 116 ],
-5527, -5531, -5531, [ 64, 68, 112, 116 ], -5531, -5531, -5531, -5527, -5527,
-546, -546, [ 8, 264, 398 ], -5586, -5586, -5586, -5586, -5586, -5586,
[ 65, 321, 369 ], -5598, -5598, [ 113, 321, 369 ], -5601, -5601, -5586, -5586
, -1138, [ 8, 142, 398 ], -1138, -5598, -5598, -5598, -5598, -5598, -4450,
[ 64, 100 ], -4405, -4407, -4405, -546, -4430, -4405, -4447, -4430, -4430,
-4430, -4447, -4450, -546, -546, -546, -4450, -4405, -4450, -4450, -4450,
-4405, -546, -546, -4450, [ 64, 96, 100 ], -546, -546, -546, -4450, -546,
-4450, -546, -546, -546, -4450, -546, -4405, -546, [ 72, 328, 332 ],
[ 76, 328, 332 ], -5900, -1817, [ 328, 332 ], [ 72, 76, 328, 332 ],
[ 72, 328 ], -5905, -5905, -5905, -5906, -5905, -5906, -5905, -5906, -5906,
-5905, -5905, -5906, -5905, -5906, -5905, -5905, -5905, -5905, -5905, -5905,
-5906, -5906, -5906, -5900, -5900, -5904, -5904, -5900, -5904, -5900, -5901,
-5900, -5901, -5900, -5900, -5901, -5900, -5901, -5900, -5901, -5900, -5904,
-5904, -5900, [ 64, 68, 96, 112 ], -6534, [ 64, 68, 96, 100, 112 ], -6534,
[ 64, 68, 96, 112, -3, 116 ], -6534, -4405, -4405, -4405, -4405, -4405, -4405
, -4405, -4405, -4405, -4405, -4405, -4405, -4447, -4447, -4447, -4447, -4447
, -5025, -5026, -5025, -5025, -5025, [ 65, 321 ], -5025, -4430, -4405, -4450,
-546, -546, -546, -546, -546, -546, -546, [ 512 ], -10331, -10331, [ 560 ],
-10334, -10334, -10334, -10331, -10331, -10331, -10331, -10331, -10331,
-10331, -10331, -10331, -10331, -10331, -10331, -10331, -10331, -10331,
-10331, -10331, -10331, -10331, -10331, [ 2568 ], -10830, -10830, -10830,
-10830, -10830, -10830, -10830, -10830, -10830, -10830, -10830, -10830,
-10830, -10830, -10830, -10830, -10331, -10331, -10331, -546, -10830, -546,
-10830, -546, -10830, [ 2561 ], -13471, -10331, -10331, [ 3648 ], -10830,
-10830, -10331, -10331, -10331, -10331, -10331, -10331, -10331, -10331,
-10331, [ 2624 ], -13820, -13820, -13820, -13820, -13820, -13820, -13820,
-13820, -13820, -13820, -13820, -13820, -13471, -13471, -13471, -13471,
-13471, -13471, -13471, -13471, -13471, -10331, -10331, -10331, -10331,
-10331, -10331, -10331, -10331, -10331, -10331, -10331, -10331, -10331,
-13820, -13820, -13820, -13820, -13820, -13820, -13820, -13820, -13820,
-13820, -13820, -13820, -13820, -13820, -13820, -13820, -13820, -10331,
-10331, -10331, -10331, -10331, -10331, -10331, -10331, -10331, -10331,
-10331, -10331, -10331, -10331, -10331, -10331, -10331, -10331, -10331,
-10331, -13820, -13820, -13820, -13820, -13820, -13820, -13820, -13820,
-13820, -13820, -13820, -13820, -13820, -13820, -13820, -13820, -13820,
-10331, -10331, -10331, -10331, -10331, -10331, -10331, -10331, -10331,
[ 512, 516, 896 ], [ 512, 544, 896 ], [ 512, 516, 544, 896 ], -26310, -26310,
[ 512, 548, 896 ], -26313, [ 512, 544, 768 ], [ 512, 516, 544, 768 ],
[ 512, 516, 544, 800 ], -26320, [ 512, 548, 768, 804 ], -26318, -26320,
-26322, -26318, -26319, [ 512, 768 ], -26318, -26320, [ 512, 516, 544 ],
-26384, -26322, -26318, [ 512, 516 ], -26328, [ 512, 516, 544, 768, 800 ],
-26403, [ 512, 516, 768 ], [ 512, 516, 768, 772 ], -26405, [ 512, 516, 772 ],
-26408, [ 512, 516, 548, 768, 772, 804 ], -26410, [ 520, 2568, 2572, 2824 ],
[ 520, 776, 2568, 2572, 2824 ], [ 520, 776, 2568, 2572 ],
[ 524, 2568, 2572, 2824 ], -26420, [ 524, 2568, 2572, 2828 ],
[ 524, 780, 2568, 2572 ], [ 524, 780, 2568, 2572, 2824, 2828 ],
[ 520, 524, 2568, 2572, 2824, 2828 ], [ 520, 524, 2568, 2572, 2828 ], -26417,
-26419, [ 2568, 2824 ], -26429, [ 520, 524, 2568, 2572, 2824 ],
[ 520, 2568, 2572 ], -26417, [ 2568, 2572, 2828 ], -26462,
[ 524, 2568, 2572, 2824, 2828 ], [ 520, 524, 2568, 2572 ],
[ 520, 2568, 2572, 2828 ], [ 520, 780, 2568, 2572, 2824, 2828 ],
[ 524, 776, 2568, 2572, 2824, 2828 ], -26467, -26468, -26467, -26425,
[ 524, 776, 2568, 2572 ], [ 512, 516, 768, 800 ], -26403,
[ 512, 516, 548, 768, 772, 800 ], -26474, [ 512, 516, 544, 548, 772, 804 ],
[ 512, 516, 544, 772 ], -26479, [ 512, 516, 772, 804 ], -26481,
[ 512, 516, 768, 772, 804 ], -26405, -26319, [ 512, 516, 548, 800 ],
[ 512, 516, 544, 548, 772 ], [ 512, 516, 548 ], -26488,
[ 512, 516, 768, 804 ], [ 512, 516, 544, 768, 772, 804 ], -26476,
[ 512, 516, 772, 800 ], [ 512, 516, 544, 548, 772, 800 ], -26494,
[ 512, 516, 544, 548, 768, 804 ], -26496, -26388, -26318, -26405, -26405,
[ 4096 ], -53038, -53038, -53038, [ 20544 ], -53118, -53118, -53038, -53038,
-53038, -53038, [ 20481 ], -53291, [ 4096, 4100 ], [ 4096, 4352, 6144 ],
[ 4096, 4128, 6400 ], [ 4096, 4100, 4128, 6400 ], [ 4096, 4384 ], [ 32768 ] ]
);
SMALL_GROUP_LIB[ 8 ][ 4 ] :=
rec( pos := [ 1, 39, -45, 50, -52, 56, -59, 87, -90, 106, 116, 124, 130, 133,
136, 139, 151, 155, 171, 183, 187, 197, 316, -317, 319, -320, 322, -325, 350,
-353, 367, -370, 380, -381, 443, -444, 446, -447, 453, -458, 497, -502, 531,
-532, 537, -538, 4384, 4388, 4395, 4398, 4405, 4427, 4447, 4453, 4475, 4481,
4569, 4593, 4601, 4609, 4617, 4625, 4983, 4991, 5000, 5003, 5025, 5036, 5040,
5043, 5047, 5050, 5525, 5531, 5578, 5586, 5598, 5640, 5649, 5667, 5771, 5832,
5867, 5882, 5886, 5900, 5964, 6092, 6108, 6147, 6177, 6251, 6534, -6537, 6540
, -6546, 6614, -6618, 6627, -6629, 6632, -6636, 6647, -6648, 6723, -6725,
26308, 26318, 26382, 26403, 26417, 26460, 26466, 26474, 26484, 26490, 26959,
-26962, 55608 ], val := [ 1, -1, -1, [ 1, -3 ], 32768, -42, -42, -42, -42,
-42, -42, -42, -42, -42, -42, [ 16, -3 ], -42, -42, -42, -42, -42, -42, -42,
-42, -42, -42, [ 209 ], -151, -42, -42, -151, -151, 536903680, -316,
[ 1, 193 ], -41, 8421376, -322, -322, -322, -322, -42, -322, -42, -322, -322,
-322, -322, -322, -322, -322, -87, -322, -322, 134250496, -453, -453, -453,
-453, -453, 142639104, -497, [ 16, 24, 28, -3 ], -322, -322, -322, -322, -322
, -322, -322, [ 256 ], -42, -42, -42, -4384, -4384, -4384, [ 266 ], -4453,
-4453, -4384, -4384, -4384, -4384, -4384, -4384, -4384, -4384, -4384, -4384,
[ 2305 ], -5025, -5025, -5025, -5025, -5025, -4384, -4384, -4384, -42, -5025,
-42, -5025, -4384, -4384, -4384, -4384, -4384, -4384, [ 2320 ], -5900, -5900,
-5900, -5900, -5900, -5900, [ 256, 264, 448 ], -6534, -6534, -6534,
[ 256, 264, 384 ], -6540, [ 256, 264, 392 ], -6540, -6542, -6540, -6540,
-6540, -6542, [ 256, 264 ], -6540, -4384, [ 256, 264, 384, 392 ], -6627,
[ 256, 384 ], [ 257, 2305, 2433 ], [ 257, 385, 2305, 2433 ],
[ 257, 385, 2305 ], -6632, -6634, [ 257, 2305 ], -6632, -6616, -6540, -6629,
[ 4096 ], -26308, -26308, -26308, [ 36880 ], -26417, -26417, -26308, -26308,
-26308, [ 4096, 4104 ], [ 4096, 4224, 6144 ], [ 4096, 4104, 6272 ], -26961,
[ 65536 ] ] );
SMALL_GROUP_LIB[ 8 ][ 5 ] :=
rec( pos := [ 1, 316, 319, 322, 350, 367, 380, 443, 446, 453, 497, -498, 500,
-502, 531, -532, 537, -538, 6534, 6540, 6614, 6627, 6632, 6647, 6723, -6725,
26959 ], val := [ 1, [ 32 ], -1, -316, -316, -316, -316, -316, -316, -316,
[ 32, 56 ], -497, [ 32, 48 ], -500, -500, -500, -500, -500, -500, [ 1024 ],
-6534, -6534, -6534, [ 17409 ], -6632, [ 1024, 1040 ], [ 1024, 1040, 1536 ],
[ 1024, 1552 ], [ 32768 ] ] );
SMALL_GROUP_LIB[ 8 ][ 6 ] :=
rec( pos := [ 1, 497, 500, 531, 537, -538, 6723 ], val := [ 1, [ 64 ], -497,
-497, [ 64, 96 ], -537, [ 4096 ] ] );
SMALL_GROUP_LIB[ 8 ][ 7 ] :=
rec( pos := [ 1, 537 ], val := [ 1, [ 128 ] ] );
SMALL_GROUP_LIB[ 8 ][ 8 ] :=
[ 1 ]; 
