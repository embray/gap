#############################################################################
##
#W  modulmat.gi                 GAP library                     Thomas Breuer
##
#H  @(#)$Id$
##
#Y  Copyright (C)  1997,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
#Y  (C) 1998 School Math and Comp. Sci., University of St.  Andrews, Scotland
##
##  This file contains methods for *matrix modules*, that is,
##  free left modules consisting of matrices.
##
##  Especially methods for *full matrix modules* $R^[m,n]$ are contained.
##
##  (See the file `modulrow.gi' for the methods for row modules.
##  Note that we do not need methods for enumerator and iterator of full
##  matrix modules because the standard delegation to full row modules
##  suffices.)
##
Revision.modulmat_gi :=
    "@(#)$Id$";


#############################################################################
##
#F  FullMatrixModule( <R>, <m>, <n> )
##
##  Let $E_{i,j}$ be the matrix with value 1 in row $i$ and $column $j$, and
##  zero otherwise.
##  Clearly the full matrix space is generated by all $E_{i,j}$, $i$ and
##  $j$ ranging from 1 to <m> and <n>, respectively.
##
##  `FullMatrixModule' returns a module of ordinary matrices
##  (not of Lie matrices, see~"IsOrdinaryMatrix").
##
InstallGlobalFunction( FullMatrixModule, function( R, m, n )

    local M;   # the free module record, result

    if not ( IsRing( R ) and IsInt( m ) and 0 <= m
                         and IsInt( n ) and 0 <= n ) then
      Error( "usage: FullMatrixModule( <R>, <m>, <n> ) for ring <R>" );
    elif m = n then
      return FullMatrixFLMLOR( R, m );
    fi;

    if IsDivisionRing( R ) then
      M:= Objectify( NewType( CollectionsFamily( CollectionsFamily(
                                                     FamilyObj( R ) ) ),
                                  IsFreeLeftModule
                              and IsGaussianSpace
                              and IsFullMatrixModule
                              and IsAttributeStoringRep ),
                     rec() );
    else
      M:= Objectify( NewType( CollectionsFamily( CollectionsFamily(
                                                     FamilyObj( R ) ) ),
                                  IsFreeLeftModule
                              and IsFullMatrixModule
                              and IsAttributeStoringRep ),
                     rec() );
    fi;
    SetLeftActingDomain( M, R );
    SetDimensionOfVectors( M, [ m, n ] );

    return M;
end );


#############################################################################
##
#M  \^( <M>, [ <m>, <n> ] ) . . . . . . . . .  full matrix module over a ring
##
InstallOtherMethod( \^,
    "for ring and list of integers (delegate to `FullMatrixModule')",
    true,
    [ IsRing, IsCyclotomicCollection and IsList ], 0,
    function( R, n )
    if     Length( n ) = 2
       and IsInt( n[1] ) and 0 <= n[1]
       and IsInt( n[2] ) and 0 <= n[2] then
      return FullMatrixModule( R, n[1], n[2] );
    fi;
    TryNextMethod();
    end );


#############################################################################
##
#M  IsMatrixModule( <M> )
##
InstallMethod( IsMatrixModule,
    "for a free left module",
    true,
    [ IsFreeLeftModule ], 0,
    function( M )
    local gens;
    gens:= GeneratorsOfLeftModule( M );
    return    ( IsEmpty( gens ) and IsMatrix( Zero( M ) ) )
           or ForAll( gens, IsMatrix );
    end );


#############################################################################
##
#M  IsFullMatrixModule( M )
##
InstallMethod( IsFullMatrixModule,
    "for matrix module",
    true,
    [ IsFreeLeftModule ], 0,
    M ->     IsMatrixModule( M )
         and Dimension( M ) = Product( DimensionOfVectors( M ) )
         and ForAll( GeneratorsOfLeftModule( M ),
                     v -> IsSubset( LeftActingDomain( M ), v ) ) );


#############################################################################
##
#M  Dimension( <M> )
##
InstallMethod( Dimension,
    "for full matrix module",
    true,
    [ IsFreeLeftModule and IsFullMatrixModule ], 0,
    M -> Product( DimensionOfVectors( M ) ) );


#############################################################################
##
#M  Random( <M> )
##
InstallMethod( Random,
    "for full matrix module",
    true,
    [ IsFreeLeftModule and IsFullMatrixModule ], 0,
    function( M )
    local random;
    random:= DimensionOfVectors( M );
    random:= RandomMat( random[1], random[2],
                        LeftActingDomain( M ) );
    if IsLieObjectCollection( M ) then
      random:= LieObject( random );
    fi;
    return random;
    end );


#############################################################################
##
#F  StandardGeneratorsOfFullMatrixModule( <M> )
##
InstallGlobalFunction( StandardGeneratorsOfFullMatrixModule, function( M )
    local R, one, dims, m, n, zeromat, gens, i, j, gen;
    R:= LeftActingDomain( M );
    one:= One( R );
    dims:= DimensionOfVectors( M );
    m:= dims[1];
    n:= dims[2];
    zeromat:= NullMat( m, n, R );
    gens:= [];
    for i in [ 1 .. m ] do
      for j in [ 1 .. n ] do
        gen:= List( zeromat, ShallowCopy );
        gen[i][j]:= one;
        Add( gens, gen );
      od;
    od;

    if IsLieObjectCollection( M ) then
      gens:= List( gens, LieObject );
    fi;

    return gens;
end );


#############################################################################
##
#M  GeneratorsOfLeftModule( <V> )
##
InstallMethod( GeneratorsOfLeftModule,
    "for full matrix module",
    true,
    [ IsFreeLeftModule and IsFullMatrixModule ], 0,
    StandardGeneratorsOfFullMatrixModule );


#############################################################################
##
#M  ViewObj( <M> )
##
InstallMethod( ViewObj,
    "for full matrix module",
    true,
    [ IsFreeLeftModule and IsFullMatrixModule ], 0,
    function( M )
    if IsLieObjectCollection( M ) then
      TryNextMethod();
    fi;
    Print( "( " );
    View( LeftActingDomain( M ) );
    Print( "^", DimensionOfVectors( M ), " )" );
    end );


#############################################################################
##
#M  PrintObj( <M> )
##
InstallMethod( PrintObj,
    "for full matrix module",
    true,
    [ IsFreeLeftModule and IsFullMatrixModule ], 0,
    function( M )
    if IsLieObjectCollection( M ) then
      TryNextMethod();
    fi;
    Print( "( ", LeftActingDomain( M ), "^", DimensionOfVectors( M ), " )" );
    end );


#############################################################################
##
#M  \in( <v>, <V> )
##
InstallMethod( \in,
    "for full matrix module",
    IsElmsColls,
    [ IsObject,
      IsFreeLeftModule and IsFullMatrixModule ], 0,
    function( mat, M )
    return     IsMatrix( mat )
           and DimensionsMat( mat ) = DimensionOfVectors( M )
           and ForAll( mat, row -> IsSubset( LeftActingDomain( M ), row ) );
    end );


#############################################################################
##
#M  BasisVectors( <B> ) . . . . for a canonical basis of a full matrix module
##
InstallMethod( BasisVectors,
    "for canonical basis of a full matrix module",
    true,
    [ IsBasis and IsCanonicalBasis and IsCanonicalBasisFullMatrixModule ], 0,
    B -> StandardGeneratorsOfFullMatrixModule( UnderlyingLeftModule( B ) ) );


#############################################################################
##
#M  CanonicalBasis( <V> )
##
InstallMethod( CanonicalBasis, true,
    [ IsFreeLeftModule and IsFullMatrixModule ], 0,
    function( V )
    local B;
    B:= Objectify( NewType( FamilyObj( V ),
                                IsBasis
                            and IsCanonicalBasis
                            and IsCanonicalBasisFullMatrixModule
                            and IsAttributeStoringRep ),
                   rec() );
    SetUnderlyingLeftModule( B, V );
    return B;
    end );


#############################################################################
##
#M  Coefficients( <B>, <m> )  . for a canonical basis of a full matrix module
##
InstallMethod( Coefficients,
    "for canonical basis of a full matrix module",
    IsCollsElms,
    [ IsBasis and IsCanonicalBasisFullMatrixModule, IsMatrix ], 0,
    function( B, mat )
    local V, R;
    V:= UnderlyingLeftModule( B );
    R:= LeftActingDomain( V );
    if     DimensionsMat( mat ) = DimensionOfVectors( V )
       and ForAll( mat, row -> IsSubset( R, row ) ) then
      return Concatenation( mat );
    else
      return fail;
    fi;
    end );


#############################################################################
##
#M  Basis( <M> )  . . . . . . . . . . . . . . . . . .  for full matrix module
##
InstallMethod( Basis,
    "for full matrix module",
    true,
    [ IsFreeLeftModule and IsFullMatrixModule ],
    SUM_FLAGS,
    CanonicalBasis );


#############################################################################
##
#M  IsCanonicalBasisFullMatrixModule( <B> ) . . . . . . . . . . . for a basis
##
InstallMethod( IsCanonicalBasisFullMatrixModule,
    "for a basis",
    true,
    [ IsBasis ], 0,
    B ->     IsFullMatrixModule( UnderlyingLeftModule( B ) )
         and IsCanonicalBasis( B ) );


#############################################################################
##
#E

