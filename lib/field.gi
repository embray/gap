#############################################################################
##
#W  field.gi                    GAP library                  Martin Schoenert
##
#H  @(#)$Id$
##
#Y  Copyright (C)  1997,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
#Y  (C) 1998 School Math and Comp. Sci., University of St.  Andrews, Scotland
##
##  This file contains generic methods for division rings.
##
Revision.field_gi :=
    "@(#)$Id$";


#############################################################################
##
#M  DivisionRingByGenerators( <gens> )  . . . . . . . . . .  for a collection
#M  DivisionRingByGenerators( <F>, <gens> )   . . for div.ring and collection
##
InstallOtherMethod( DivisionRingByGenerators,
    "for a collection",
    [ IsCollection ],
    coll -> DivisionRingByGenerators(
        FieldOverItselfByGenerators( [ One( Representative( coll ) ) ] ),
        coll ) );

InstallMethod( DivisionRingByGenerators,
    "for a division ring, and a collection",
    IsIdenticalObj,
    [ IsDivisionRing, IsCollection ],
    function( F, gens )
    local D;
    D:= Objectify( NewType( FamilyObj( gens ),
                            IsField and IsAttributeStoringRep ),
                   rec() );
    SetLeftActingDomain( D, F );
    SetGeneratorsOfDivisionRing( D, AsList( gens ) );
    return D;
    end );


#############################################################################
##
#M  FieldOverItselfByGenerators( <gens> )
##
InstallMethod( FieldOverItselfByGenerators,
    "for a collection",
    [ IsCollection ],
    function( gens )
    local F;
    if IsEmpty( gens ) then
      Error( "need at least one element" );
    fi;
    F:= Objectify( NewType( FamilyObj( gens ),
                            IsField and IsAttributeStoringRep ),
                   rec() );
    SetLeftActingDomain( F, F );
    SetGeneratorsOfDivisionRing( F, gens );
    return F;
    end );


#############################################################################
##
#M  DefaultFieldByGenerators( <gens> )  . . . . . . . . . .  for a collection
##
InstallMethod( DefaultFieldByGenerators,
    "for a collection",
    [ IsCollection ],
    DivisionRingByGenerators );


#############################################################################
##
#F  Field( <z>, ... ) . . . . . . . . . field generated by a list of elements
#F  Field( [ <z>, ... ] )
#F  Field( <F>, [ <z>, ... ] )
##
InstallGlobalFunction( Field, function ( arg )
    local   F;          # field containing the elements of <arg>, result

    # special case for one square matrix
    if    Length(arg) = 1
        and IsMatrix( arg[1] ) and Length( arg[1] ) = Length( arg[1][1] )
    then
        F := FieldByGenerators( arg );

    # special case for list of elements
    elif Length(arg) = 1  and IsList(arg[1])  then
        F := FieldByGenerators( arg[1] );

    # special case for subfield and generators
    elif Length(arg) = 2  and IsField(arg[1])  then
        F := FieldByGenerators( arg[1], arg[2] );

    # other cases
    else
        F := FieldByGenerators( arg );
    fi;

    # return the field
    return F;
end );


#############################################################################
##
#F  DefaultField( <z>, ... )  . . . . . default field containing a collection
##
InstallGlobalFunction( DefaultField, function ( arg )
    local   F;          # field containing the elements of <arg>, result

    # special case for one square matrix
    if    Length(arg) = 1
        and IsMatrix( arg[1] ) and Length( arg[1] ) = Length( arg[1][1] )
    then
        F := DefaultFieldByGenerators( arg );

    # special case for list of elements
    elif Length(arg) = 1  and IsList(arg[1])  then
        F := DefaultFieldByGenerators( arg[1] );

    # other cases
    else
        F := DefaultFieldByGenerators( arg );
    fi;

    # return the default field
    return F;
end );


#############################################################################
##
#F  Subfield( <F>, <gens> ) . . . . . . . subfield of <F> generated by <gens>
#F  SubfieldNC( <F>, <gens> )
##
InstallGlobalFunction( Subfield, function( F, gens )
    local S;
    if IsEmpty( gens ) then
      return PrimeField( F );
    elif     IsHomogeneousList( gens )
         and IsIdenticalObj( FamilyObj( F ), FamilyObj( gens ) )
         and ForAll( gens, g -> g in F ) then
      S:= FieldByGenerators( LeftActingDomain( F ), gens );
      SetParent( S, F );
      return S;
    fi;
    Error( "<gens> must be a list of elements in <F>" );
end );

InstallGlobalFunction( SubfieldNC, function( F, gens )
    local S;
    if IsEmpty( gens ) then
      S:= Objectify( NewType( FamilyObj( F ),
                              IsDivisionRing and IsAttributeStoringRep ),
                     rec() );
      SetLeftActingDomain( S, F );
      SetGeneratorsOfDivisionRing( S, AsList( gens ) );
    else
      S:= DivisionRingByGenerators( LeftActingDomain( F ), gens );
    fi;
    SetParent( S, F );
    return S;
end );


#############################################################################
##
#M  ClosureDivisionRing( <D>, <d> ) . . . . . . . . . closure with an element
##
InstallMethod( ClosureDivisionRing,
    "for a division ring and a scalar",
    IsCollsElms,
    [ IsDivisionRing, IsScalar ],
    function( D, d )

    # if possible test if the element lies in the division ring already,
    if     HasGeneratorsOfDivisionRing( D )
       and d in GeneratorsOfDivisionRing( D ) then
      return D;

    # otherwise make a new division ring
    else
      return DivisionRingByGenerators( LeftActingDomain( D ),
                 Concatenation( GeneratorsOfDivisionRing( D ), [ d ] ) );
    fi;
    end );


InstallMethod( ClosureDivisionRing,
    "for a division ring containing the whole family, and a scalar",
    IsCollsElms,
    [ IsDivisionRing and IsWholeFamily, IsScalar ],
    SUM_FLAGS, # we can't be better than this
    function( D, d )
    return D;
    end );


#############################################################################
##
#M  ClosureDivisionRing( <D>, <C> ) . . . . . . . .  closure of division ring
##
InstallMethod( ClosureDivisionRing,
    "for division ring and collection of elements",
    IsIdenticalObj,
    [ IsDivisionRing, IsCollection ],
    function( D, C )
    local   d;          # one generator

    if IsDivisionRing( C ) then
      if not IsSubset( LeftActingDomain( D ), LeftActingDomain( C ) ) then
        C:= AsDivisionRing( Intersection( LeftActingDomain( C ),
                                          LeftActingDomain( D ) ), C );
      fi;
      C:= GeneratorsOfDivisionRing( C );
    elif not IsList( C ) then
      TryNextMethod();
    fi;

    for d in C do
      D:= ClosureDivisionRing( D, d );
    od;

    return D;
    end );


#############################################################################
##
#M  ViewObj( <F> )  . . . . . . . . . . . . . . . . . . . . . .  view a field
##
InstallMethod( ViewObj,
    "for a field",
    [ IsField ],
    function( F )
    if HasSize( F ) and IsInt( Size( F ) ) then
      Print( "<field of size ", Size( F ), ">" );
    else
      Print( "<field in characteristic ", Characteristic( F ), ">" );
    fi;
    end );


#############################################################################
##
#M  PrintObj( <F> ) . . . . . . . . . . . . . . . . . . . . . . print a field
##
InstallMethod( PrintObj,
    "for a field with known generators",
    [ IsField and HasGeneratorsOfField ],
    function( F )
    if IsPrimeField( LeftActingDomain( F ) ) then
      Print( "Field( ", GeneratorsOfField( F ), " )" );
    elif F = LeftActingDomain( F ) then
      Print( "FieldOverItselfByGenerators( ",
             GeneratorsOfField( F ), " )" );
    else
      Print( "AsField( ", LeftActingDomain( F ),
             ", Field( ", GeneratorsOfField( F ), " ) )" );
    fi;
    end );

InstallMethod( PrintObj,
    "for a field",
    [ IsField ],
    function( F )
    if IsPrimeField( LeftActingDomain( F ) ) then
      Print( "Field( ... )" );
    elif F = LeftActingDomain( F ) then
      Print( "AsField( ~, ... )" );
    else
      Print( "AsField( ", LeftActingDomain( F ), ", ... )" );
    fi;
    end );


#############################################################################
##
#M  IsTrivial( <F> )  . . . . . . . . . . . . . . . . . . for a division ring
##
InstallMethod( IsTrivial,
    "for a division ring",
    [ IsDivisionRing ],
    ReturnFalse );


#############################################################################
##
#M  PrimeField( <F> ) . . . . . . . . . . . . . . . . . . for a division ring
##
InstallMethod( PrimeField,
    "for a division ring",
    [ IsDivisionRing ],
    function( F )
    local P;
    P:= Field( One( F ) );
    UseSubsetRelation( F, P );
    SetIsPrimeField( P, true );
    return P;
    end );

InstallMethod( PrimeField,
    "for a prime field",
    [ IsField and IsPrimeField ],
    IdFunc );


#############################################################################
##
#M  IsPrimeField( <F> ) . . . . . . . . . . . . . . . . . for a division ring
##
InstallMethod( IsPrimeField,
    "for a division ring",
    [ IsDivisionRing ],
    F -> DegreeOverPrimeField( F ) = 1 );


#############################################################################
##
#M  IsNumberField( <F> )  . . . . . . . . . . . . . . . . . . . . for a field
##
InstallMethod( IsNumberField,
    "for a field",
    [ IsField ],
    F -> Characteristic( F ) = 0 and IsInt( DegreeOverPrimeField( F ) ) );


#############################################################################
##
#M  IsAbelianNumberField( <F> ) . . . . . . . . . . . . . . . . . for a field
##
InstallMethod( IsAbelianNumberField,
    "for a field",
    [ IsField ],
    F -> IsNumberField( F ) and IsCommutative( GaloisGroup(
                                         AsField( PrimeField( F ), F ) ) ) );


#############################################################################
##
#M  IsCyclotomicField( <F> )  . . . . . . . . . . . . . . . . . . for a field
##
InstallMethod( IsCyclotomicField,
    "for a field",
    [ IsField ],
    F ->     IsAbelianNumberField( F )
         and Conductor( F ) = DegreeOverPrimeField( F ) );


#############################################################################
##
#M  IsNormalBasis( <B> )  . . . . . . . . . . . . .  for a basis (of a field)
##
InstallMethod( IsNormalBasis,
    "for a basis of a field",
    [ IsBasis ],
    function( B )
    local vectors;
    if not IsField( UnderlyingLeftModule( B ) ) then
      Error( "<B> must be a basis of a field" );
    fi;
    vectors:= BasisVectors( B );
    return Set( vectors )
           = Set( Conjugates( UnderlyingLeftModule( B ), vectors[1] ) );
    end );


#############################################################################
##
#M  GeneratorsOfDivisionRing( <F> ) . . . . . . . . . . . . for a prime field
##
InstallMethod( GeneratorsOfDivisionRing,
    "for a prime field",
    [ IsField and IsPrimeField ],
    F -> [ One( F ) ] );


#############################################################################
##
#M  DegreeOverPrimeField( <F> ) . . . . . . . . . . . . . . for a prime field
##
InstallImmediateMethod( DegreeOverPrimeField, IsPrimeField, 20, F -> 1 );


#############################################################################
##
#M  NormalBase( <F> ) . . . . . . . . . .  for a field in characteristic zero
#M  NormalBase( <F>, <elm> )  . . . . . .  for a field in characteristic zero
##
##  For fields in characteristic zero, a normal basis is computed
##  as described on p.~65~f.~in~\cite{Art68}.
##  Let $\Phi$ denote the polynomial of the field extension $L/L^{\prime}$,
##  $\Phi^{\prime}$ its derivative and $\alpha$ one of its roots;
##  then for all except finitely many elements $z \in L^{\prime}$,
##  the conjugates of $\frac{\Phi(z)}{(z-\alpha)\cdot\Phi^{\prime}(\alpha)}$
##  form a normal basis of $L/L^{\prime}$.
##
##  When `NormalBase' is called for a field <F> in characteristic zero and
##  an element <elm>,
##  $z$ is chosen as <elm>, $<elm> + 1$, $<elm> + 2$, \ldots,
##  until a normal basis is found.
##  The default of <elm> is the identity of <F>.
##
InstallMethod( NormalBase,
    "for a field (in characteristic zero)",
    [ IsField ],
    F -> NormalBase( F, One( F ) ) );

InstallMethod( NormalBase,
    "for a field (in characteristic zero), and a scalar",
    [ IsField, IsScalar ],
    function( F, z )

    local alpha, poly, i, val, normal;

    # Check the arguments.
    if Characteristic( F ) <> 0 then
      TryNextMethod();
    elif not z in F then
      Error( "<z> must be an element in <F>" );
    fi;

    # Get a primitive element `alpha'.
    alpha:= PrimitiveElement( F );

    # Construct the polynomial
    # $\prod_{\sigma\in `Gal( alpha )'\setminus \{1\} } (x-\sigma(`alpha') )
    # for the primitive element `alpha'.
    poly:= [ 1 ];
    for i in Difference( Conjugates( F, alpha ), [ alpha ] ) do
      poly:= ProductCoeffs( poly, [ -i, 1 ] );
#T ?
    od;

    # For the denominator, evaluate `poly' at `a'.
    val:= Inverse( ValuePol( poly, alpha ) );

    # There are only finitely many values `x' in the subfield
    # for which `poly(x) * val' is not an element of a normal basis.
    repeat
      normal:= Conjugates( F, ValuePol( poly, z ) * val );
      z:= z + 1;
    until RankMat( List( normal, COEFFS_CYC ) ) = Dimension( F );

    # Return the result.
    return normal;
    end );


#############################################################################
##
#M  PrimitiveElement( <D> ) . . . . . . . . . . . . . . . for a division ring
##
InstallMethod( PrimitiveElement,
    "for a division ring",
    [ IsDivisionRing ],
    function( D )
    D:= GeneratorsOfDivisionRing( D );
    if Length( D ) = 1 then
      return D[1];
    else
      TryNextMethod();
    fi;
    end );


#############################################################################
##
#M  Representative( <D> ) . . . . . for a division ring with known generators
##
InstallMethod( Representative,
    "for a division ring with known generators",
    [ IsDivisionRing and HasGeneratorsOfDivisionRing ],
    RepresentativeFromGenerators( GeneratorsOfDivisionRing ) );


#############################################################################
##
#M  GeneratorsOfRing( <F> ) . . . . . . .  ring generators of a division ring
##
InstallMethod( GeneratorsOfRing,
    "for a division ring with known generators",
    [ IsDivisionRing and HasGeneratorsOfDivisionRing ],
    F -> Concatenation( GeneratorsOfDivisionRing( F ),
                        [ One( F ) ],
                        List( GeneratorsOfDivisionRing( F ), Inverse ) ) );


#############################################################################
##
#M  GeneratorsOfRingWithOne( <F> )  . . . . . . . . . . . for a division ring
##
InstallMethod( GeneratorsOfRingWithOne,
    "for a division ring with known generators",
    [ IsDivisionRing and HasGeneratorsOfDivisionRing ],
    F -> Concatenation( GeneratorsOfDivisionRing( F ),
                        List( GeneratorsOfDivisionRing( F ), Inverse ) ) );


#############################################################################
##
#M  Enumerator( <F> ) . . . . . . . . . .  elements of a (finite) prime field
#M  EnumeratorSorted( <F> ) . . . . . . .  elements of a (finite) prime field
##
##  We install a special method only for prime fields,
##  since the other cases are handled by the vector space methods.
##
EnumeratorOfPrimeField := function( F )
    local one;
    if not IsFinite( F ) then
      Error( "sorry, cannot compute elements list of infinite field <F>" );
    fi;
    one:= One( F );
    return AsSSortedListList( List( [ 0 .. Size( F ) - 1 ], i -> i * one ) );
end;

InstallMethod( Enumerator,
    "for a prime field",
    [ IsField and IsPrimeField ],
    EnumeratorOfPrimeField );

InstallMethod( AsList,
    "for a prime field",
    [ IsField and IsPrimeField ],
    EnumeratorOfPrimeField );


#T InstallMethod( EnumeratorSorted, [ IsField and IsPrimeField ],
#T     EnumeratorOfPrimeField );
#T 
#T InstallMethod( AsSSortedList, [ IsField and IsPrimeField ],
#T     EnumeratorOfPrimeField );


#############################################################################
##
#M  IsSubset( <D>, <F> )  . . . . . . . . . . . . . .  for two division rings
##
##  We have to be careful not to run into an infinite recursion in the case
##  that <F> is equal to its left acting domain.
##  Also we must be aware of situations where the left acting domains are
##  in a family different from that of the fields themselves,
##  for example <D> could be given as a field over a field that is really
##  a subset of <D>, whereas the left acting domain of <F> is not a subset
##  of <F>.
##
BindGlobal( "DivisionRing_IsSubset", function( D, F )

    local CF;

    CF:= LeftActingDomain( F );

    if not IsSubset( D, GeneratorsOfDivisionRing( F ) ) then
      return false;
    elif IsSubset( LeftActingDomain( D ), CF ) or IsPrimeField( CF ) then
      return true;
    elif FamilyObj( F ) = FamilyObj( CF ) then
      return IsSubset( D, CF );
    else
      CF:= AsDivisionRing( PrimeField( CF ), CF );
      return IsSubset( D, List( GeneratorsOfDivisionRing( CF ),
                                x -> x * One( F ) ) );
    fi;
end );

InstallMethod( IsSubset,
    "for two division rings",
    IsIdenticalObj,
    [ IsDivisionRing, IsDivisionRing ],
    DivisionRing_IsSubset );


#############################################################################
##
#M  \=( <D>, <F> )  . . . . . . . . . . . . . . . . .  for two division rings
##
InstallMethod( \=,
    "for two division rings",
    IsIdenticalObj,
    [ IsDivisionRing, IsDivisionRing ],
    function( D, F )
    return DivisionRing_IsSubset( D, F ) and DivisionRing_IsSubset( F, D );
    end );


#############################################################################
##
#M  AsDivisionRing( <C> ) . . . . . . . . . . . . . . . . .  for a collection
##
InstallMethod( AsDivisionRing,
    "for a collection",
    [ IsCollection ],
    function( C )

    local one, F;

    # A division ring contains at least two elements.
    if IsEmpty( C ) or IsTrivial( C ) then
      return fail;
    fi;

    # Construct the prime field.
    one:= One( Representative( C ) );
    if one = fail then
      return fail;
    fi;
    F:= FieldOverItselfByGenerators( [ one ] );

    # Delegate to the two-argument version.
    return AsDivisionRing( F, C );
    end );


#############################################################################
##
#M  AsDivisionRing( <F>, <C> )  . . . . for a division ring, and a collection
##
InstallMethod( AsDivisionRing,
    "for a division ring, and a collection",
    IsIdenticalObj,
    [ IsDivisionRing, IsCollection ],
    function( F, C )

    local D;

    if not IsSubset( C, F ) then
      return fail;
    fi;

    D:= DivisionRingByGenerators( F, C );
    if D <> C then
      return fail;
    fi;

    return D;
    end );


#############################################################################
##
#M  AsDivisionRing( <F>, <D> )  . . . . . . . . . . .  for two division rings
##
InstallMethod( AsDivisionRing,
    "for two division rings",
    IsIdenticalObj,
    [ IsDivisionRing, IsDivisionRing ],
    function( F, D )
    local E;

    if   F = LeftActingDomain( D ) then
      return D;
    elif not IsSubset( D, F ) then
      return fail;
    fi;

    E:= DivisionRingByGenerators( F, GeneratorsOfDivisionRing( D ) );

    UseIsomorphismRelation( D, E );
    UseSubsetRelation( D, E );

    return E;
    end );


#############################################################################
##
#M  AsLeftModule( <F1>, <F2> )  . . . . . . . . . . .  for two division rings
##
##  View the division ring <F2> as vector space over the division ring <F1>.
##
InstallMethod( AsLeftModule,
    "for two division rings",
    IsIdenticalObj,
    [ IsDivisionRing, IsDivisionRing ],
    AsDivisionRing );


#############################################################################
##
#M  Conjugates( <F>, <z> )  . . . . . . . . . . conjugates of a field element
#M  Conjugates( <z> ) . . . . . . . . . . . . . conjugates of a field element
##
InstallMethod( Conjugates,
    "for a scalar (delegate to version with default field)",
    [ IsScalar ],
    z -> Conjugates( DefaultField( z ), z ) );

InstallMethod( Conjugates,
    "for a field and a scalar (delegate to version with two fields)",
    IsCollsElms,
    [ IsField, IsScalar ],
    function( F, z )
    return Conjugates( F, LeftActingDomain( F ), z );
    end );


#############################################################################
##
#M  Conjugates( <L>, <K>, <z> ) . .  for a field elm. (use `TracePolynomial')
##
InstallMethod( Conjugates,
    "for two fields and a scalar (call `TracePolynomial')",
    IsCollsXElms,
    [ IsField, IsField, IsScalar ],
    function( L, K, z )

    local pol, lin, conj, mult, i;

    # Check whether `Conjugates' is allowed to call `MinimalPolynomial'.
    if IsFieldControlledByGaloisGroup( L ) then
      TryNextMethod();
    fi;

    # Compute the roots in `L' of the minimal polynomial of `z' over `K'.
    pol:= MinimalPolynomial( K, z );
    lin:= List( Filtered( Factors( L, pol ),
                          x -> DegreeOfLaurentPolynomial( x ) = 1 ),
                CoefficientsOfUnivariatePolynomial );
    lin:= List( lin, x -> AdditiveInverse( lin[1] / lin[2] ) );

    # Take the roots with the appropriate multiplicity.
    conj:= [];
    mult:= DegreeOverPrimeField( L ) / DegreeOverPrimeField( K );
    mult:= mult / DegreeOfLaurentPolynomial( pol );
    for i in [ 1 .. mult ] do
      Append( conj, lin );
    od;

    return conj;
    end );


#############################################################################
##
#M  Conjugates( <L>, <K>, <z> ) . . . for a field element (use `GaloisGroup')
##
InstallMethod( Conjugates,
    "for two fields and a scalar (call `GaloisGroup')",
    IsCollsXElms,
    [ IsFieldControlledByGaloisGroup, IsField, IsScalar ],
    function( L, K, z )
    local   cnjs,       # conjugates of <z> in <F>, result
            aut;        # automorphism of <F>

    # Check the arguments.
    if not z in L then
      Error( "<z> must lie in <L>" );
    fi;

    # Compute the conjugates simply by applying all the automorphisms.
    cnjs:= [];
    for aut in GaloisGroup( AsField( L, K ) ) do
      Add( cnjs, z ^ aut );
    od;

    # Return the conjugates.
    return cnjs;
    end );


#############################################################################
##
#M  Norm( <F>, <z> )  . . . . . . . . . . . . . . . . norm of a field element
#M  Norm( <z> ) . . . . . . . . . . . . . . . . . . . norm of a field element
##
InstallMethod( Norm,
    "for a scalar (delegate to version with default field)",
    [ IsScalar ],
    z -> Norm( DefaultField( z ), z ) );

InstallMethod( Norm,
    "for a field and a scalar (delegate to version with two fields)",
    IsCollsElms,
    [ IsField, IsScalar ],
    function( F, z )
    return Norm( F, LeftActingDomain( F ), z );
    end );


#############################################################################
##
#M  Norm( <L>, <K>, <z> ) . . . .  norm of a field element (use `Conjugates')
##
InstallMethod( Norm,
    "for two fields and a scalar (use `Conjugates')",
    IsCollsXElms,
    [ IsFieldControlledByGaloisGroup, IsField, IsScalar ],
    function( L, K, z )
    return Product( Conjugates( L, K, z ) );
    end );


#############################################################################
##
#M  Norm( <L>, <K>, <z> ) . . .  norm of a field element (use the trace pol.)
##
InstallMethod( Norm,
    "for two fields and a scalar (use the trace pol.)",
    IsCollsXElms,
    [ IsField, IsField, IsScalar ],
    function( L, K, z )
    local coeffs;
    coeffs:= CoefficientsOfUnivariatePolynomial(
                 TracePolynomial( L, K, z, 1 ) );
    return (-1)^(Length( coeffs )-1) * coeffs[1];
    end );


#############################################################################
##
#M  Trace( <z> )  . . . . . . . . . . . . . . . . .  trace of a field element
#M  Trace( <F>, <z> ) . . . . . . . . . . . . . . .  trace of a field element
##
InstallMethod( Trace,
    "for a scalar (delegate to version with default field)",
    [ IsScalar ],
    z -> Trace( DefaultField( z ), z ) );

InstallMethod( Trace,
    "for a field and a scalar (delegate to version with two fields)",
    IsCollsElms,
    [ IsField, IsScalar ],
    function( F, z )
    return Trace( F, LeftActingDomain( F ), z );
    end );


#############################################################################
##
#M  Trace( <L>, <K>, <z> )  . . . trace of a field element (use `Conjugates')
##
InstallMethod( Trace,
    "for two fields and a scalar (use `Conjugates')",
    IsCollsXElms,
    [ IsFieldControlledByGaloisGroup, IsField, IsScalar ],
    function( L, K, z )
    return Sum( Conjugates( L, K, z ) );
    end );


#############################################################################
##
#M  Trace( <L>, <K>, <z> )  . . trace of a field element (use the trace pol.)
##
InstallMethod( Trace,
    "for two fields and a scalar (use the trace pol.)",
    IsCollsXElms,
    [ IsField, IsField, IsScalar ],
    function( L, K, z )
    local coeffs;
    coeffs:= CoefficientsOfUnivariatePolynomial(
                 TracePolynomial( L, K, z, 1 ) );
    return AdditiveInverse( coeffs[ Length( coeffs ) - 1 ] );
    end );


#############################################################################
##
#M  MinimalPolynomial( <F>, <z>, <nr> )
##
##  If the default field of <z> knows how to get the Galois group then
##  we compute the conjugates and from them the minimal polynomial.
##  Otherwise we solve an equation system.
##
##  Note that the family predicate `IsCollsElmsX' expresses that <z> may lie
##  in an extension field of <F>;
##  this guarantees that the method is *not* applicable for the case that <z>
##  is a matrix.
##
InstallMethod( MinimalPolynomial,
    "for field, scalar, and indet. number",
    IsCollsElmsX,
    [ IsField, IsScalar,IsPosInt ],
    function( F, z, ind )

    local L, coe, deg, zero, con, i, B, pow, mat, MB;

    # Construct a basis of a field in which the computations happen.
    # (This need not be the smallest such field.)
    L:= DefaultField( z );

    if IsFieldControlledByGaloisGroup( L ) then

      # We may call `Conjugates'.

      coe:= [ One( F ) ];
      deg:= 0;
      zero:= Zero( F );
      for con in Conjugates( Field( F, [ z ] ), z ) do
        coe[deg+2]:= coe[deg+1];
        for i in [ deg+1, deg .. 2 ] do
          coe[i]:= coe[i-1] - con * coe[i];
        od;
        coe[1]:= zero - con * coe[1];
        deg:= deg + 1;
      od;

    else

      # Solve an equation system.

      B:= Basis( L );

      # Compute coefficients of the powers of `z' until
      # the rows are linearly dependent.
      pow:= One( F );
      coe:= Coefficients( B, pow );
      mat:= [ coe ];
      MB:= MutableBasis( F, [ coe ] );
      repeat
        CloseMutableBasis( MB, coe );
        pow:= pow * z;
        coe:= Coefficients( B, pow );
        Add( mat, coe );
      until IsContainedInSpan( MB, coe );

      # The coefficients of the minimal polynomial
      # are given by the linear relation.
      coe:= NullspaceMat( mat )[1];
      coe:= Inverse( coe[ Length( coe ) ] ) * coe;

    fi;

    # Construct the polynomial.
    return UnivariatePolynomial( F, coe, ind );
    end );


#############################################################################
##
#M  TracePolynomial( <L>, <K>, <z> )
#M  TracePolynomial( <L>, <K>, <z>, <ind> )
##
InstallMethod( TracePolynomial,
    "using minimal polynomial",
    IsCollsXElmsX,
    [ IsField, IsField, IsScalar, IsPosInt ],
    function( L, K, z, ind )

    local minpol, mult;

    minpol:= MinimalPolynomial( K, z, ind );
    mult:= DegreeOverPrimeField( L ) / DegreeOverPrimeField( K );
    mult:= mult / DegreeOfLaurentPolynomial( minpol );

    return minpol ^ mult;
    end );

InstallMethod( TracePolynomial,
    "add default indet. 1",
    IsCollsXElms,
    [ IsField, IsField, IsScalar ],
    function( L, K, z )
    return TracePolynomial( L, K, z, 1 );
    end );


#############################################################################
##
#M  CharacteristicPolynomial( <L>, <K>, <z> )
#M  CharacteristicPolynomial( <L>, <K>, <z>, <ind> )
##
InstallOtherMethod( CharacteristicPolynomial,
    "call `TracePolynomial'",
    IsCollsXElms,
    [ IsField, IsField, IsScalar ],
    function( L, K, z )
    return TracePolynomial( L, K, z, 1 );
    end );

InstallOtherMethod( CharacteristicPolynomial,
    "call `TracePolynomial'",
    IsCollsXElmsX,
    [ IsField, IsField, IsScalar, IsPosInt ],
    TracePolynomial );


#############################################################################
##
#M  NiceFreeLeftModuleInfo( <V> )
#M  NiceVector( <V>, <v> )
#M  UglyVector( <V>, <r> )
##
InstallHandlingByNiceBasis( "IsFieldElementsSpace", rec(
    detect := function( F, gens, V, zero )
      return     IsScalarCollection( V )
             and IsIdenticalObj( FamilyObj( F ), FamilyObj( V ) )
             and IsDivisionRing( F );
      end,

    NiceFreeLeftModuleInfo := function( V )
      local lad, gens;

      # Compute the default field of the vector space generators,
      # a basis of this field (over the left acting domain of `V'),
      lad:= LeftActingDomain( V );
      if not IsIdenticalObj( FamilyObj( V ), FamilyObj( lad ) ) then
        TryNextMethod();
      fi;
      gens:= GeneratorsOfLeftModule( V );

      if IsEmpty( gens ) then
        return Basis( AsField( lad, lad ) );
      else
        return Basis( AsField( lad, DefaultField( gens ) ) );
      fi;
      end,

    NiceVector := function( V, v )
      return Coefficients( NiceFreeLeftModuleInfo( V ), v );
      end,

    UglyVector := function( V, r )
      local B;
      B:= NiceFreeLeftModuleInfo( V );
      if Length( r ) <> Length( B ) then
        return fail;
      fi;
      return LinearCombination( B, r );
      end ) );


#############################################################################
##
#M  Quotient( <F>, <r>, <s> ) . . . . . . . . quotient of elements in a field
##
InstallMethod( Quotient,
    "for field, and two ring elements",
    IsCollsElmsElms,
    [ IsField, IsRingElement, IsRingElement ],
    function ( F, r, s )
    return r/s;
    end );


#############################################################################
##
#M  IsUnit( <F>, <r> )  . . . . . . . . . . check for being a unit in a field
##
InstallMethod( IsUnit,
    "for field, and ring element",
    IsCollsElms,
    [ IsField, IsRingElement ],
    function ( F, r )
    return not IsZero( r ) and r in F;
    end );


#############################################################################
##
#M  Units( <F> )
##
InstallMethod( Units,
    "for a division ring",
    [ IsDivisionRing ],
    function( D )
    if IsFinite( D ) then
      return Difference( AsList( D ), [ Zero( D ) ] );
    else
      TryNextMethod();
    fi;
    end );


#############################################################################
##
#M  PrimitiveRoot( <F> )  . . . . . . . . . . . .  for finite prime field <F>
##
##  For a fields of prime order $p$, the multiplicative group corresponds to
##  the group of residues modulo $p$, via `Int'.
##  A primitive root is obtained as `PrimitiveRootMod( $p$ )' times the
##  identity of <F>.
##
InstallMethod( PrimitiveRoot,
    "for a finite prime field",
    [ IsField and IsFinite ],
    function( F )
    if not IsPrimeField( F ) then
      TryNextMethod();
    fi;
    return PrimitiveRootMod( Size( F ) ) * One( F );
    end );


#############################################################################
##
#M  IsAssociated( <F>, <r>, <s> ) . . . . . . check associatedness in a field
##
InstallMethod( IsAssociated,
    "for field, and two ring elements",
    IsCollsElmsElms,
    [ IsField, IsRingElement, IsRingElement ],
    function ( F, r, s )
    return (r = Zero( F ) ) = (s = Zero( F ) );
    end );


#############################################################################
##
#M  StandardAssociate( <F>, <x> ) . . . . . . . standard associate in a field
##
InstallMethod( StandardAssociate,
    "for field and ring element",
    IsCollsElms,
    [ IsField, IsScalar ],
    function ( R, r )
    if r = Zero( R ) then
        return Zero( R );
    else
        return One( R );
    fi;
    end );


#############################################################################
##
##  Field homomorphisms
##

#############################################################################
##
#M  IsFieldHomomorphism( <map> )
##
InstallMethod( IsFieldHomomorphism,
    [ IsGeneralMapping ],
    map -> IsRingHomomorphism( map ) and IsField( Source( map ) ) );


#############################################################################
##
#M  KernelOfAdditiveGeneralMapping( <fldhom> )  . .  for a field homomorphism
##
InstallMethod( KernelOfAdditiveGeneralMapping,
    "for a field homomorphism",
    [ IsFieldHomomorphism ],
#T higher rank?
#T (is this method ever used?)
    function ( hom )
    if ForAll( GeneratorsOfDivisionRing( Source( hom ) ),
               x -> IsZero( ImagesRepresentative( hom, x ) ) ) then
      return Source( hom );
    else
      return TrivialSubadditiveMagmaWithZero( Source( hom ) );
    fi;
    end );


#############################################################################
##
#M  IsInjective( <fldhom> ) . . . . . . . . . . . .  for a field homomorphism
##
InstallMethod( IsInjective,
    "for a field homomorphism",
    [ IsFieldHomomorphism ],
    hom -> Size( KernelOfAdditiveGeneralMapping( hom ) ) = 1 );


#############################################################################
##
#M  IsSurjective( <fldhom> )  . . . . . . . . . . .  for a field homomorphism
##
InstallMethod( IsSurjective,
    "for a field homomorphism",
    [ IsFieldHomomorphism ],
    function ( hom )
    if IsFinite( Range( hom ) ) then
      return Size( Range( hom ) ) = Size( Image( hom ) );
    else
      TryNextMethod();
    fi;
    end );


#############################################################################
##
#M  \=( <hom1>, <hom2> )  . . . . . . . . . comparison of field homomorphisms
##
InstallMethod( \=,
    "for two field homomorphisms",
    IsIdenticalObj,
    [ IsFieldHomomorphism, IsFieldHomomorphism ],
    function ( hom1, hom2 )

    # maybe the properties we already know determine the result
    if ( HasIsInjective( hom1 ) and HasIsInjective( hom2 )
         and IsInjective( hom1 ) <> IsInjective( hom2 ) )
    or ( HasIsSurjective( hom1 ) and HasIsSurjective( hom2 )
         and IsSurjective( hom1 ) <> IsSurjective( hom2 ) ) then
        return false;

    # otherwise we must really test the equality
    else
        return Source( hom1 ) = Source( hom2 )
            and Range( hom1 ) = Range( hom2 )
            and ForAll( GeneratorsOfField( Source( hom1 ) ),
                   elm -> Image(hom1,elm) = Image(hom2,elm) );
    fi;
    end );


#############################################################################
##
#M  ImagesSet( <hom>, <elms> ) . . images of a set under a field homomorphism
##
InstallMethod( ImagesSet,
    "for field homomorphism and field",
    CollFamSourceEqFamElms,
    [ IsFieldHomomorphism, IsField ],
    function ( hom, elms )
    elms:= FieldByGenerators( List( GeneratorsOfField( elms ),
               gen -> ImagesRepresentative( hom, gen ) ) );
    UseSubsetRelation( Range( hom ), elms );
    return elms;
    end );


#############################################################################
##
#M  PreImagesElm( <hom>, <elm> )  . . . . . . . . . . . .  preimage of an elm
##
InstallMethod( PreImagesElm,
    "for field homomorphism and element",
    FamRangeEqFamElm,
    [ IsFieldHomomorphism, IsObject ],
    function ( hom, elm )
    if IsInjective( hom ) = 1 then
      return [ PreImagesRepresentative( hom, elm ) ];
    elif IsZero( elm ) then
      return Source( hom );
    else
      return [];
    fi;
    end );


#############################################################################
##
#M  PreImagesSet( <hom>, <elm> )  . . . . . . . . . . . . . preimage of a set
##
InstallMethod( PreImagesSet,
    "for field homomorphism and field",
    CollFamRangeEqFamElms,
    [ IsFieldHomomorphism, IsField ],
    function ( hom, elms )
    elms:= FieldByGenerators( List( GeneratorsOfField( elms ),
               gen -> PreImagesRepresentative( hom, gen ) ) );
    UseSubsetRelation( Source( hom ), elms );
    return elms;
    end );


#############################################################################
##
#E

