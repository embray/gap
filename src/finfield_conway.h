/****************************************************************************
**
**  This file is part of GAP, a system for computational discrete algebra.
**
**  Copyright of GAP belongs to its developers, whose names are too numerous
**  to list here. Please refer to the COPYRIGHT file for details.
**
**  SPDX-License-Identifier: GPL-2.0-or-later
*/

#ifndef GAP_FINFIELD_CONWAY_H
#define GAP_FINFIELD_CONWAY_H

/****************************************************************************
**
*V  PolsFF  . . . . . . . . . .  list of Conway polynomials for finite fields
**
**  'PolsFF' is a  list of  Conway  polynomials for finite fields.   The even
**  entries are the  proper prime powers,  odd entries are the  corresponding
**  conway polynomials.
*/
unsigned long PolsFF[] = {
       4, 1+2,
       8, 1+2,
      16, 1+2,
      32, 1  +4,
      64, 1+2  +8+16,
     128, 1+2,
     256, 1  +4+8+16,
     512, 1      +16,
    1024, 1+2+4+8   +32+64,
    2048, 1  +4,
    4096, 1+2  +8   +32+64+128,
    8192, 1+2  +8+16,
   16384, 1    +8   +32   +128,
   32768, 1  +4  +16+32,
   65536, 1  +4+8   +32,
       9,  2 +2*3,
      27,  1 +2*3,
      81,  2           +2*27,
     243,  1 +2*3,
     729,  2 +2*3 +1*9       +2*81,
    2187,  1      +2*9,
    6561,  2 +2*3 +2*9       +1*81 +2*243,
   19683,  1 +1*3 +2*9 +2*27,
   59049,  2 +1*3            +2*81 +2*243 +2*729,
      25,  2 +4*5,
     125,  3 +3*5,
     625,  2 +4*5 +4*25,
    3125,  3 +4*5,
   15625,  2      +1*25 +4*125 +1*625,
      49,  3 +6*7,
     343,  4      +6*49,
    2401,  3 +4*7 +5*49,
   16807,  4 +1*7,
     121,  2 + 7*11,
    1331,  9 + 2*11,
   14641,  2 +10*11 +8*121,
     169,  2 +12*13,
    2197, 11 + 2*13,
   28561,  2 +12*13 +3*169,
     289,  3 +16*17,
    4913, 14 + 1*17,
     361,  2 +18*19,
    6859, 17 + 4*19,
     529,  5 +21*23,
   12167, 18 + 2*23,
     841,  2 +24*29,
   24389, 27 + 2*29,
     961,  3 +29*31,
   29791, 28 + 1*31,
    1369,  2 +33*37,
   50653, 35 + 6*37,
    1681,  6 + 38* 41,
    1849,  3 + 42* 43,
    2209,  5 + 45* 47,
    2809,  2 + 49* 53,
    3481,  2 + 58* 59,
    3721,  2 + 60* 61,
    4489,  2 + 63* 67,
    5041,  7 + 69* 71,
    5329,  5 + 70* 73,
    6241,  3 + 78* 79,
    6889,  2 + 82* 83,
    7921,  3 + 82* 89,
    9409,  5 + 96* 97,
   10201,  2 + 97*101,
   10609,  5 +102*103,
   11449,  2 +103*107,
   11881,  6 +108*109,
   12769,  3 +101*113,
   16129,  3 +126*127,
   17161,  2 +127*131,
   18769,  3 +131*137,
   19321,  2 +138*139,
   22201,  2 +145*149,
   22801,  6 +149*151,
   24649,  5 +152*157,
   26569,  2 +159*163,
   27889,  5 +166*167,
   29929,  2 +169*173,
   32041,  2 +172*179,
   32761,  2 +177*181,
   36481, 19 +190*191,
   37249,  5 +192*193,
   38809,  2 +192*197,
   39601,  3 +193*199,
   44521,  2 +207*211,
   49729,  3 +221*223,
   51529,  2 +220*227,
   52441,  6 +228*229,
   54289,  3 +232*233,
   57121,  7 +237*239,
   58081,  7 +238*241,
   63001,  6 +242*251,
};


#endif // GAP_FINFIELD_CONWAY_H
