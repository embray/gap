/****************************************************************************
**
**  This file is part of GAP, a system for computational discrete algebra.
**
**  Copyright of GAP belongs to its developers, whose names are too numerous
**  to list here. Please refer to the COPYRIGHT file for details.
**
**  SPDX-License-Identifier: GPL-2.0-or-later
**
**  This  file declares the functions  that mainly operate  on boolean lists.
**  Because boolean lists are  just a special case  of lists many  things are
**  done in the list package.
**
**  A *boolean list* is a list that has no holes and contains only 'true' and
**  'false'.  For  the full definition of  boolean list  see chapter "Boolean
**  Lists" in the {\GAP} Manual.  Read  also the section "More  about Boolean
**  Lists" about the different internal representations of such lists.
*/

#ifndef GAP_BLISTER_H
#define GAP_BLISTER_H

#include "bool.h"
#include "objects.h"

/****************************************************************************
**
*F  IS_BLIST_REP( <list> )  . . . . .  check if <list> is in boolean list rep
*/
EXPORT_INLINE Int IS_BLIST_REP(Obj list)
{
    return T_BLIST <= TNUM_OBJ(list) &&
           TNUM_OBJ(list) <= T_BLIST_SSORT + IMMUTABLE;
}


/****************************************************************************
**
*F  SIZE_PLEN_BLIST( <plen> ) . . size for a blist with given physical length
**
**  'SIZE_PLEN_BLIST' returns  the size  that a boolean list  with  room  for
**  <plen> elements must at least have.
**
*/
EXPORT_INLINE Int SIZE_PLEN_BLIST(Int plen)
{
    GAP_ASSERT(plen >= 0);
    return sizeof(Obj) + (plen + BIPEB - 1) / BIPEB * sizeof(UInt);
}

/****************************************************************************
**
*F  LEN_BLIST( <list> ) . . . . . . . . . . . . . .  length of a boolean list
**
**  'LEN_BLIST' returns the logical length of the boolean list <list>, as a C
**  integer.
**
*/
EXPORT_INLINE Int LEN_BLIST(Obj list)
{
    GAP_ASSERT(IS_BLIST_REP(list));
    return INT_INTOBJ(CONST_ADDR_OBJ(list)[0]);
}


/***************************************************************************
**
*F  NUMBER_BLOCKS_BLIST(<list>) . . . . . . . . number of UInt blocks in list
**
*/
EXPORT_INLINE Int NUMBER_BLOCKS_BLIST(Obj blist)
{
    GAP_ASSERT(IS_BLIST_REP(blist));
    return (LEN_BLIST(blist) + BIPEB - 1) / BIPEB;
}


/****************************************************************************
**
*F  SET_LEN_BLIST( <list>, <len> )  . . . .  set the length of a boolean list
**
**  'SET_LEN_BLIST' sets the  length of the boolean list  <list> to the value
**  <len>, which must be a positive C integer.
**
*/
EXPORT_INLINE void SET_LEN_BLIST(Obj list, Int len)
{
    GAP_ASSERT(IS_BLIST_REP(list));
    GAP_ASSERT(len >= 0);
    ADDR_OBJ(list)[0] = INTOBJ_INT(len);
}


/****************************************************************************
**
*F  BLOCKS_BLIST( <list> )  . . . . . . . . . . first block of a boolean list
**
**  returns a pointer to the start of the data of the Boolean list
**
*/
EXPORT_INLINE UInt * BLOCKS_BLIST(Obj list)
{
    return ((UInt *)(ADDR_OBJ(list) + 1));
}

EXPORT_INLINE const UInt * CONST_BLOCKS_BLIST(Obj list)
{
    return ((const UInt *)(CONST_ADDR_OBJ(list) + 1));
}

/****************************************************************************
**
*F  BLOCK_ELM_BLIST_PTR( <list>, <pos> ) . . ptr to a block of a boolean list
**
**  'BLOCK_ELM_BLIST_PTR' return a pointer to the block containing the
**  <pos>-th element of the boolean list <list>. <pos> must be a positive
**  integer less than or equal to the length of <list>.
*/
EXPORT_INLINE UInt * BLOCK_ELM_BLIST_PTR(Obj list, UInt pos)
{
    return BLOCKS_BLIST(list) + ((pos)-1) / BIPEB;
}

EXPORT_INLINE const UInt * CONST_BLOCK_ELM_BLIST_PTR(Obj list, UInt pos)
{
    return CONST_BLOCKS_BLIST(list) + ((pos)-1) / BIPEB;
}

/****************************************************************************
**
*F  MASK_POS_BLIST( <pos> )  . . . .  bit mask for position of a Boolean list
**
**  'MASK_POS_BLIST(<pos>)' returns a UInt with a single set bit in  position
**  '(<pos>-1) % BIPEB',
**  useful for accessing the <pos>-th element of a blist.
*/
EXPORT_INLINE UInt MASK_POS_BLIST(UInt pos)
{
    return ((UInt)1) << (pos - 1) % BIPEB;
}

/****************************************************************************
**
*F  TEST_BIT_BLIST( <list>, <pos> ) . . . . . .  test a bit of a boolean list
**
**  'TEST_BIT_BLIST' return a non-zero value if the <pos>-th element of the
**  boolean list <list> is 1, and otherwise 0. <pos> must be a positive
**  integer less than or equal to the length of <list>.
*/
EXPORT_INLINE Int TEST_BIT_BLIST(Obj list, UInt pos)
{
    return *CONST_BLOCK_ELM_BLIST_PTR(list, pos) & MASK_POS_BLIST(pos);
}

/****************************************************************************
**
*F  ELM_BLIST( <list>, <pos> ) . . . . . . . . . .  element of a boolean list
**
**  'ELM_BLIST' return the <pos>-th bit of the boolean list <list>, which is
**  either 'true' or 'false'.  <pos> must  be a positive integer less than or
**  equal to the length of <list>.
*/
EXPORT_INLINE Obj ELM_BLIST(Obj list, UInt pos)
{
    return TEST_BIT_BLIST(list, pos) ? True : False;
}

/****************************************************************************
**
*F  SET_BIT_BLIST( <list>, <pos> ) . . . . . . .  set a bit of a boolean list
*F  CLEAR_BIT_BLIST( <list>, <pos> ) . . . . . clears a bit of a boolean list
**
**  These function set the bit at position <pos> in the boolean list <list>
**  to 1 resp. 0.  <pos> must be a positive integer less than or equal to
**  the length of <list>.
*/
EXPORT_INLINE void SET_BIT_BLIST(Obj list, UInt pos)
{
    *BLOCK_ELM_BLIST_PTR(list, pos) |= MASK_POS_BLIST(pos);
}

EXPORT_INLINE void CLEAR_BIT_BLIST(Obj list, UInt pos)
{
    *BLOCK_ELM_BLIST_PTR(list, pos) &= ~MASK_POS_BLIST(pos);
}


/****************************************************************************
**
*F * * * * * * * * * * * * * * list functions * * * * * * * * * * * * * * * *
*/

/****************************************************************************
**
*F  AssBlist( <list>, <pos>, <val> )  . . . . . . .  assign to a boolean list
**
**  'AssBlist' assigns the   value <val> to  the  boolean list <list> at  the
**  position <pos>.   It is the responsibility  of the caller to  ensure that
**  <pos> is positive, and that <val> is not 0.
**
**  'AssBlist' is the function in 'AssListFuncs' for boolean lists.
**
**  If <pos> is less than or equal to the logical length  of the boolean list
**  and <val> is 'true' or   'false' the assignment  is  done by setting  the
**  corresponding bit.  If <pos>  is one more  than the logical length of the
**  boolean list  the assignment is  done by   resizing  the boolean list  if
**  necessary, setting the   corresponding bit and  incrementing  the logical
**  length  by one.  Otherwise  the boolean list is  converted to an ordinary
**  list and the assignment is performed the ordinary way.
*/
void AssBlist(Obj list, Int pos, Obj val);


/****************************************************************************
**
*F  ConvBlist( <list> ) . . . . . . . . .  convert a list into a boolean list
**
**  'ConvBlist' changes the representation of boolean  lists into the compact
**  representation of type 'T_BLIST' described above.
*/
void ConvBlist(Obj list);


/****************************************************************************
**
*F * * * * * * * * * * * * * initialize module * * * * * * * * * * * * * * *
*/

/****************************************************************************
**
*F  InitInfoBlist() . . . . . . . . . . . . . . . . . table of init functions
*/
StructInitInfo * InitInfoBlist ( void );


#endif // GAP_BLISTER_H
