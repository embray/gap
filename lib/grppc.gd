#############################################################################
##
#W  grppc.gd                    GAP Library                      Frank Celler
##
#H  @(#)$Id$
##
#Y  Copyright (C)  1996,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##
##  This file contains the operations for groups with a polycyclic collector.
##
##  IsPcgs
##    a polycyclic generating system, also behaves like a pc sequence
##
##  IsPcGroup
##    a poylcyclic group whose elements family is defined by a collector
##
##  IsPcgsComputable
##    a group that knows how to compute a pcgs relatively fast
##
##  HasDefiningPcgs
##    a group whose elements family is generated by a pcgs
##
##  HasHomePcgs
##    a group that knows a pcgs of a super group
##
Revision.grppc_gd :=
    "@(#)$Id$";


#############################################################################
##

#A  CanonicalPcgsWrtFamilyPcgs( <grp> )
##
CanonicalPcgsWrtFamilyPcgs := NewAttribute(
    "CanonicalPcgsWrtFamilyPcgs",
    IsGroup );

SetCanonicalPcgsWrtFamilyPcgs := Setter(CanonicalPcgsWrtFamilyPcgs);
HasCanonicalPcgsWrtFamilyPcgs := Tester(CanonicalPcgsWrtFamilyPcgs);


#############################################################################
##
#A  CanonicalPcgsWrtHomePcgs( <grp> )
##
CanonicalPcgsWrtHomePcgs := NewAttribute(
    "CanonicalPcgsWrtHomePcgs",
    IsGroup );

SetCanonicalPcgsWrtHomePcgs := Setter(CanonicalPcgsWrtHomePcgs);
HasCanonicalPcgsWrtHomePcgs := Tester(CanonicalPcgsWrtHomePcgs);


#############################################################################
##
#A  FamilyPcgs( <grp> )
##
FamilyPcgs := NewAttribute(
    "FamilyPcgs",
    IsGroup );

SetFamilyPcgs := Setter(FamilyPcgs);
HasFamilyPcgs := Tester(FamilyPcgs);


#############################################################################
##
#A  HomePcgs( <grp> )
##
HomePcgs := NewAttribute(
    "HomePcgs",
    IsGroup );

SetHomePcgs := Setter(HomePcgs);
HasHomePcgs := Tester(HomePcgs);


#############################################################################
##
#A  InducedPcgsWrtFamilyPcgs( <grp> )
##
InducedPcgsWrtFamilyPcgs := NewAttribute(
    "InducedPcgsWrtFamilyPcgs",
    IsGroup );

SetInducedPcgsWrtFamilyPcgs := Setter(InducedPcgsWrtFamilyPcgs);
HasInducedPcgsWrtFamilyPcgs := Tester(InducedPcgsWrtFamilyPcgs);


#############################################################################
##
#A  InducedPcgsWrtHomePcgs( <grp> )
##
InducedPcgsWrtHomePcgs := NewAttribute(
    "InducedPcgsWrtHomePcgs",
    IsGroup );

SetInducedPcgsWrtHomePcgs := Setter(InducedPcgsWrtHomePcgs);
HasInducedPcgsWrtHomePcgs := Tester(InducedPcgsWrtHomePcgs);


#############################################################################
##
#A  Pcgs( <grp> )
##
Pcgs := NewAttribute(
    "Pcgs",
    IsGroup );

SetPcgs := Setter( Pcgs );
HasPcgs := Tester( Pcgs );


#############################################################################
##

#P  IsPcgsComputable( <grp> )
##
IsPcgsComputable := NewProperty(
    "IsPcgsComputable",
    IsGroup );

SetIsPcgsComputable := Setter(IsPcgsComputable);
HasIsPcgsComputable := Tester(IsPcgsComputable);


#############################################################################
##
#M  IsPcgsComputable( <pcgrp> )
##
InstallTrueMethod(
    IsPcgsComputable,
    IsPcGroup );

InstallTrueMethod(
    IsPcgsComputable,
    HasPcgs );


#############################################################################
##

#O  AffineOperation( <gens>, <basisvectors>, <linear>, <transl> )
##
AffineOperation := NewOperation(
    "AffineOperation", 
    [ IsList, IsMatrix, IsObject, IsObject ] );


#############################################################################
##
#O  LinearOperation( <G>, <basisvectors>, <linear> )
##
LinearOperation := NewOperation(
    "LinearOperation",
    [ IsGroup, IsMatrix, IsObject ] );


#############################################################################
##


#M  IsSolvableGroup
##
InstallTrueMethod(
    IsSolvableGroup,
    IsPcGroup );


#############################################################################
##

#F  AffineOperationLayer( <Gpcgs>, <pcgs>, <transl> )
##
AffineOperationLayer := NewOperationArgs( "AffineOperationLayer" );


#############################################################################
##
#F  GeneratorsCentrePGroup( <G> )
##
GeneratorsCentrePGroup := NewOperationArgs( "GeneratorsCentrePGroup" );


#############################################################################
##
#F  LinearOperationLayer( <G>, <pcgs> )
##
LinearOperationLayer := NewOperationArgs( "LinearOperationLayer" );


#############################################################################
##
#F  VectorSpaceByPcgsOfElementaryAbelianGroup( <pcgs>, <fld> )
##
VectorSpaceByPcgsOfElementaryAbelianGroup := NewOperationArgs(
    "VectorSpaceByPcgsOfElementaryAbelianGroup" );

#############################################################################
##
#F  GapInputPcGroup( <grp>, <string> )
##
GapInputPcGroup := NewOperationArgs( "GapInputPcGroup" );

#############################################################################
##
#O  CanonicalSubgroupRepresentativePcGroup( <G>, <U> )
##
CanonicalSubgroupRepresentativePcGroup :=
  NewOperationArgs( "CanonicalSubgroupRepresentativePcGroup" );

#############################################################################
##

#E  grppc.gd  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
##
