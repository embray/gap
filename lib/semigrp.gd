#############################################################################
##
#W  semigrp.gd                  GAP library                     Thomas Breuer
##
#H  @(#)$Id$
##
#Y  Copyright (C)  1996,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##
##  This file contains the declaration of operations for semigroups.
##
Revision.semigrp_gd :=
    "@(#)$Id$";


#############################################################################
##
#P  IsSemigroup( <D> )
##
##  A semigroup is a magma with associative multiplication.
##
IsSemigroup := IsMagma and IsAssociative;
SetIsSemigroup := Setter( IsSemigroup );
HasIsSemigroup := Tester( IsSemigroup );


#############################################################################
##
#A  AsSemigroup( <D> )  . . . . . . . . . . . . domain <D> viewed as semigroup
##
AsSemigroup := NewAttribute( "AsSemigroup", IsMagma );
SetAsSemigroup := Setter( AsSemigroup );
HasAsSemigroup := Tester( AsSemigroup );


#############################################################################
##
#A  GeneratorsOfSemigroup( <D> ) . . . . . semigroup generators of domain <D>
##
##  Semigroup generators of a domain are the same as magma generators.
##
GeneratorsOfSemigroup    := GeneratorsOfMagma;
SetGeneratorsOfSemigroup := SetGeneratorsOfMagma;
HasGeneratorsOfSemigroup := HasGeneratorsOfMagma;


#############################################################################
##
#O  SemigroupByGenerators( <gens> ) . . . . . . semigroup generated by <gens>
##
SemigroupByGenerators := NewOperation( "SemigroupByGenerators",
    [ IsCollection ] );
#T 1997/01/16 fceller was old 'NewConstructor'


#############################################################################
##
#F  Semigroup( <gen>, ... ) . . . . . . . . semigroup generated by collection
#F  Semigroup( <gens> ) . . . . . . . . . . semigroup generated by collection
##
##  'Semigroup( <gen>, ... )' is the semigroup generated by the arguments
##  <gen>, ...
##
##  If the only argument <obj> is a list that is not a matrix then
##  'Semigroup( <obj> )' is the semigroup generated by the elements
##  of that list.
##
##  It is *not* checked whether the underlying multiplication is associative.
##
Semigroup := NewOperationArgs( "Semigroup" );


#############################################################################
##
#F  Subsemigroup( <S>, <gens> ) . . .  subsemigroup of <S> generated by <gens>
#F  SubsemigroupNC( <S>, <gens> ) . .  subsemigroup of <S> generated by <gens>
##
Subsemigroup := Submagma;

SubsemigroupNC := SubmagmaNC;


#############################################################################
##
#F  FreeSemigroup( <rank> ) . . . . . . . . . .  free semigroup of given rank
#F  FreeSemigroup( <names> )
##
FreeSemigroup := NewOperationArgs( "FreeSemigroup" );


#############################################################################
##
#E  semigrp.gd  . . . . . . . . . . . . . . . . . . . . . . . . . . ends here



