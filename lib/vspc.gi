#############################################################################
##
#W  vspc.gi                     GAP library                     Thomas Breuer
##
#H  @(#)$Id$
##
#Y  Copyright (C)  1997,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
#Y  (C) 1998 School Math and Comp. Sci., University of St.  Andrews, Scotland
##
##  This file contains generic methods for vector spaces.
##
Revision.vspc_gi :=
    "@(#)$Id$";


#############################################################################
##
#M  SetLeftActingDomain( <extL>, <D> )
##
##  check whether the left acting domain <D> of the external left set <extL>
##  knows that it is a division ring.
##  This is used, e.g.,  to tell a free module over a division ring
##  that it is a vector space.
##
InstallOtherMethod( SetLeftActingDomain,
    "method to set also 'IsLeftActedOnByDivisionRing'",
    [ IsAttributeStoringRep and IsLeftActedOnByRing, IsObject ],0,
    function( extL, D )
    if HasIsDivisionRing( D ) and IsDivisionRing( D ) then
      SetIsLeftActedOnByDivisionRing( extL, true );
    fi;
    TryNextMethod();
    end );


#############################################################################
##
#M  IsLeftActedOnByDivisionRing( <M> )
##
InstallMethod( IsLeftActedOnByDivisionRing,
    "method for external left set that is left acted on by a ring",
    [ IsExtLSet and IsLeftActedOnByRing ],
    function( M )
    if IsIdenticalObj( M, LeftActingDomain( M ) ) then
      TryNextMethod();
    else
      return IsDivisionRing( LeftActingDomain( M ) );
    fi;
    end );


#############################################################################
##
#M  AsSubspace( <V>, <W> )  . . . . . . . . . . . . . . for two vector spaces
##
InstallMethod( AsSubspace,
    "method for two vector spaces",
    IsIdenticalObj,
    [ IsVectorSpace, IsVectorSpace ],
    function( V, W )
    local newW, feature;

    if not IsSubset( V, W ) then
      return fail;
    fi;

    newW:= LeftModuleByGenerators( LeftActingDomain( W ),
                            GeneratorsOfLeftModule( W ),
                            Zero( W ) );
    SetParent( newW, V );
    UseIsomorphismRelation( W, newW );
    UseSubsetRelation( W, newW );

    return newW;
    end );


#############################################################################
##
#M  AsLeftModule( <F>, <V> )  . . . . . .  for division ring and vector space
##
##  View the vector space <V> as a vector space over the division ring <F>.
##
InstallMethod( AsLeftModule,
    "method for a division ring and a vector space",
    [ IsDivisionRing, IsVectorSpace ],
    function( F, V )

    local W,        # the space, result
          base,     # basis vectors of field extension
          gen,      # loop over generators of 'V'
          b,        # loop over 'base'
          gens,     # generators of 'V'
          newgens;  # extended list of generators

    if Characteristic( F ) <> Characteristic( LeftActingDomain( V ) ) then

      # This is impossible.
      return fail;

    elif F = LeftActingDomain( V ) then

      # No change of the left acting domain is necessary.
      return V;

    elif IsSubset( F, LeftActingDomain( V ) ) then

      # Check whether 'V' is really a space over the bigger field,
      # that is, whether the set of elements does not change.
      base:= BasisVectors( Basis( AsField( LeftActingDomain( V ), F ) ) );
      for gen in GeneratorsOfLeftModule( V ) do
        for b in base do
          if not b * gen in V then

            # The field extension would change the set of elements.
            return fail;

          fi;
        od;
      od;

      # Construct the space.
      W:= LeftModuleByGenerators( F, GeneratorsOfLeftModule(V), Zero(V) );

    elif IsSubset( LeftActingDomain( V ), F ) then

      # View 'V' as a space over a smaller field.
      # For that, the list of generators must be extended.
      gens:= GeneratorsOfLeftModule( V );
      if IsEmpty( gens ) then
        W:= LeftModuleByGenerators( F, [], Zero( V ) );
      else

        base:= BasisVectors( Basis( AsField( F, LeftActingDomain( V ) ) ) );
        newgens:= [];
        for b in base do
          for gen in gens do
            Add( newgens, b * gen );
          od;
        od;
        W:= LeftModuleByGenerators( F, newgens );

      fi;

    else

      # View 'V' first as space over the intersection of fields,
      # and then over the desired field.
      return AsLeftModule( F,
                 AsLeftModule( Intersection( F,
                     LeftActingDomain( V ) ), V ) );

    fi;

    UseIsomorphismRelation( V, W );
    UseSubsetRelation( V, W );
    return W;
    end );


#############################################################################
##
#M  ViewObj( <V> )  . . . . . . . . . . . . . . . . . . . view a vector space
##
##  print left acting domain, if known also dimension or no. of generators
##
InstallMethod( ViewObj,
    "for vector space with known generators",
    [ IsVectorSpace and HasGeneratorsOfLeftModule ],
    function( V )
    Print( "<vector space over ", LeftActingDomain( V ), ", with ",
           Length( GeneratorsOfLeftModule( V ) ), " generators>" );
    end );

InstallMethod( ViewObj,
    "for vector space with known dimension",
    [ IsVectorSpace and HasDimension ],
    1, # override method for known generators
    function( V )
    Print( "<vector space of dimension ", Dimension( V ),
           " over ", LeftActingDomain( V ), ">" );
    end );

InstallMethod( ViewObj,
    "for vector space",
    [ IsVectorSpace ],
    function( V )
    Print( "<vector space over ", LeftActingDomain( V ), ">" );
    end );


#############################################################################
##
#M  PrintObj( <V> ) . . . . . . . . . . . . . . . . . . .  for a vector space
##
InstallMethod( PrintObj,
    "method for vector space with left module generators",
    [ IsVectorSpace and HasGeneratorsOfLeftModule ],
    function( V )
    Print( "VectorSpace( ", LeftActingDomain( V ), ", ",
           GeneratorsOfLeftModule( V ) );
    if IsEmpty( GeneratorsOfLeftModule( V ) ) and HasZero( V ) then
      Print( ", ", Zero( V ), " )" );
    else
      Print( " )" );
    fi;
    end );

InstallMethod( PrintObj,
    "method for vector space",
    [ IsVectorSpace ],
    function( V )
    Print( "VectorSpace( ", LeftActingDomain( V ), ", ... )" );
    end );


#############################################################################
##
#M  \/( <V>, <W> )  . . . . . . . . .  factor of a vector space by a subspace
#M  \/( <V>, <vectors> )  . . . . . .  factor of a vector space by a subspace
##
InstallOtherMethod( \/,
    "method for vector space and collection",
    IsIdenticalObj,
    [ IsVectorSpace, IsCollection ],
    function( V, vectors )
    if IsVectorSpace( vectors ) then
      TryNextMethod();
    else
      return V / Subspace( V, vectors );
    fi;
    end );

InstallOtherMethod( \/,
    "generic method for two vector spaces",
    IsIdenticalObj,
    [ IsVectorSpace, IsVectorSpace ],
    function( V, W )
    return ImagesSource( NaturalHomomorphismBySubspace( V, W ) );
    end );


#############################################################################
##
#M  Intersection2Spaces( <AsStruct>, <Substruct>, <Struct> )
##
InstallGlobalFunction( Intersection2Spaces,
    function( AsStructure, Substructure, Structure )
    return function( V, W )

    local inters,  # intersection, result
          F,       # coefficients field
          VW,      # sum of 'V' and 'W'
          B,       # basis of 'VW'
          AV,      # coefficient space of 'V'
          AW;      # coefficient space of 'W'

    if LeftActingDomain( V ) <> LeftActingDomain( W ) then

      # Compute the intersection as vector space over the intersection
      # of the coefficients fields.
      # (Note that the characteristic is the same.)
      F:= Intersection2( LeftActingDomain( V ), LeftActingDomain( W ) );
      return Intersection2( AsStructure( F, V ), AsStructure( F, W ) );

    elif IsFiniteDimensional( V ) and IsFiniteDimensional( W ) then

      # Compute the intersection of two spaces over the same field.
      # First compute a common coefficient space.
      VW:= LeftModuleByGenerators( LeftActingDomain( V ),
                            Concatenation( GeneratorsOfLeftModule( V ),
                                           GeneratorsOfLeftModule( W ) ) );
      B:= Basis( VW );

      # Construct the coefficient subspaces corresponding to 'V' and 'W'.
      AV:= List( GeneratorsOfLeftModule( V ), x -> Coefficients( B, x ) );
      AW:= List( GeneratorsOfLeftModule( W ), x -> Coefficients( B, x ) );

      # Construct the intersection of row spaces, and carry back to VW.
      inters:= List( SumIntersectionMat( AV, AW )[2],
                     x -> LinearCombination( B, x ) );

      # Construct the intersection space, if possible with a parent.
      if     HasParent( V ) and HasParent( W )
         and IsIdenticalObj( Parent( V ), Parent( W ) ) then
        inters:= Substructure( Parent( V ), inters, "basis" );
      elif IsEmpty( inters ) then
        inters:= TrivialSubspace( V );
      else
        inters:= Structure( LeftActingDomain( V ), inters, "basis" );
      fi;

      # Run implications by the subset relation.
      UseSubsetRelation( V, inters );
      UseSubsetRelation( W, inters );

      # Return the result.
      return inters;

    else
      TryNextMethod();
    fi;
    end;
end );


#############################################################################
##
#M  Intersection2( <V>, <W> ) . . . . . . . . . . . . . for two vector spaces
##
InstallMethod( Intersection2,
    "method for two vector spaces",
    IsIdenticalObj,
    [ IsVectorSpace, IsVectorSpace ],
    Intersection2Spaces( AsLeftModule, SubspaceNC, VectorSpace ) );


#############################################################################
##
#M  ClosureLeftModule( <V>, <a> ) . . . . . . . . . closure of a vector space
##
InstallMethod( ClosureLeftModule,
    "method for a vector space with basis, and a vector",
    IsCollsElms,
    [ IsVectorSpace and HasBasis, IsVector ],
    function( V, w )
    local   B; # basis of 'V'

    # We can test membership easily.
    B:= Basis( V );
#T why easily?
    if Coefficients( B, w ) = fail then

      # In the case of a vector space, we know a basis of the closure.
      B:= Concatenation( BasisVectors( B ), [ w ] );
      V:= LeftModuleByGenerators( LeftActingDomain( V ), B );
      UseBasis( V, B );

    fi;
    return V;
    end );


#############################################################################
##
##  Methods for collections of subspaces of a vector space
##


#############################################################################
##
#R  IsSubspacesVectorSpaceDefaultRep( <D> )
##
##  is the representation of domains of subspaces of a vector space <V>,
##  with the components 'structure' (with value <V>) and 'dimension'
##  (with value either the dimension of the subspaces in the domain
##  or the string '\"all\"', which means that the domain contains all
##  subspaces of <V>).
##
DeclareRepresentation(
    "IsSubspacesVectorSpaceDefaultRep",
    IsComponentObjectRep,
    [ "dimension", "structure" ] );
#T not IsAttributeStoringRep?


#############################################################################
##
#M  PrintObj( <D> )  . . . . . . . . . . . . . . . . . for a subspaces domain
##
InstallMethod( PrintObj,
    "method for a subspaces domain",
    [ IsSubspacesVectorSpace and IsSubspacesVectorSpaceDefaultRep ],
    function( D )
    if IsInt( D!.dimension ) then
      Print( "Subspaces( ", D!.structure, ", ", D!.dimension, " )" );
    else
      Print( "Subspaces( ", D!.structure, " )" );
    fi;
    end );


#############################################################################
##
#M  Size( <D> ) . . . . . . . . . . . . . . . . . . .  for a subspaces domain
##
##  The number of $k$-dimensional subspaces in a $n$-dimensional space over
##  the field with $q$ elements is
##  $$
##  a(n,k) = \prod_{i=0}^{k-1} \frac{q^n-q^i}{q^k-q^i} =
##           \prod_{i=0}^{k-1} \frac{q^{n-i}-1}{q^{k-i}-1}.
##  $$
##  We have the recursion
##  $$
##  a(n,k+1) = a(n,k) \frac{q^{n-i}-1}{q^{i+1}-1}.
##  $$
##
##  (The number of all subspaces is $\sum_{k=0}^n a(n,k)$.)
##
InstallMethod( Size,
    "method for a subspaces domain",
    [ IsSubspacesVectorSpace and IsSubspacesVectorSpaceDefaultRep ],
    function( D )

    local k,
          n,
          q,
          size,
          qn,
          qd,
          ank,
          i;

    if D!.dimension = "all" then

      # all subspaces of the space
      n:= Dimension( D!.structure );

      q:= Size( LeftActingDomain( D!.structure ) );
      size:= 1;
      qn:= q^n;
      qd:= q;

      # $a(n,0)$
      ank:= 1;

      for k in [ 1 .. Int( (n-1)/2 ) ] do

        # Compute $a(n,k)$.
        ank:= ank * ( qn - 1 ) / ( qd - 1 );
        qn:= qn / q;
        qd:= qd * q;

        size:= size + ank;

      od;

      size:= 2 * size;

      if n mod 2 = 0 then

        # Add the number of spaces of dimension $n/2$.
        size:= size + ank * ( qn - 1 ) / ( qd - 1 );
      fi;

    else

      # number of spaces of dimension 'k' only
      n:= Dimension( D!.structure );
      if   D!.dimension < 0 or
           n < D!.dimension then
        return 0;
      elif n / 2 < D!.dimension then
        k:= n - D!.dimension;
      else
        k:= D!.dimension;
      fi;

      q:= Size( LeftActingDomain( D!.structure ) );
      size:= 1;

      qn:= q^n;
      qd:= q;
      for i in [ 1 .. k ] do
        size:= size * ( qn - 1 ) / ( qd - 1 );
        qn:= qn / q;
        qd:= qd * q;
      od;

    fi;

    # Return the result.
    return size;
    end );


#############################################################################
##
#M  Enumerator( <D> ) . . . . . . . . . . . . . . . .  for a subspaces domain
##
##  Use the iterator to compute the elements list.
#T This is not allowed!
##
InstallMethod( Enumerator,
    "method for a subspaces domain",
    [ IsSubspacesVectorSpace and IsSubspacesVectorSpaceDefaultRep ],
    function( D )
    local iter,    # iterator for 'D'
          elms;    # elements list, result

    iter:= Iterator( D );
    elms:= [];
    while not IsDoneIterator( iter ) do
      Add( elms, NextIterator( iter ) );
    od;
    return elms;
    end );
#T necessary?


#############################################################################
##
#R  IsSubspacesSpaceIteratorRep( <D> )
##
##  uses the subspaces iterator for full row spaces and the mechanism of
##  associated row spaces.
##
DeclareRepresentation( "IsSubspacesSpaceIteratorRep",
    IsComponentObjectRep,
    [ "structure", "basis", "associatedIterator" ] );


#############################################################################
##
#M  Iterator( <D> ) . . . . . . . . . . . . . . . . .  for a subspaces domain
##
InstallMethod( IsDoneIterator,
    "for an iterator of a subspaces domain",
    [ IsIterator and IsSubspacesSpaceIteratorRep ],
    iter -> IsDoneIterator( iter!.associatedIterator ) );

InstallMethod( NextIterator,
    "for a mutable iterator of a subspaces domain",
    [ IsIterator and IsMutable and IsSubspacesSpaceIteratorRep ],
    function( iter )
    local next;
    next:= NextIterator( iter!.associatedIterator );
    next:= List( GeneratorsOfLeftModule( next ),
                 x -> LinearCombination( iter!.basis, x ) );
    return Subspace( iter!.structure, next, "basis" );
    end );

InstallMethod( Iterator,
    "for a subspaces domain",
    [ IsSubspacesVectorSpace and IsSubspacesVectorSpaceDefaultRep ],
    function( D )
    local V;      # the vector space

    V:= D!.structure;
    return Objectify( NewType( IteratorsFamily,
                                   IsIterator
                               and IsMutable
                               and IsSubspacesSpaceIteratorRep ),
                      rec(
                           structure          := V,
                           basis              := Basis( V ),
                           associatedIterator := Iterator(
                      Subspaces( FullRowSpace( LeftActingDomain( V ),
                                               Dimension( V ) ),
                                 D!.dimension ) )
                          ) );
    end );

InstallMethod( ShallowCopy,
    "for an iterator of a subspaces domain",
    [ IsIterator and IsSubspacesSpaceIteratorRep ],
    iter -> Objectify( Subtype( TypeObj( iter ), IsMutable ),
                rec(
                     structure          := iter!.structure,
                     basis              := iter!.basis,
                     associatedIterator := ShallowCopy(
                                               iter!.associatedIterator )
                    ) ) );


#############################################################################
##
#M  Subspaces( <V>, <dim> )
##
InstallMethod( Subspaces,
    "for a vector space, and an integer",
    [ IsVectorSpace, IsInt ],
    function( V, dim )
    if IsFinite( V ) then
      return Objectify( NewType( CollectionsFamily( FamilyObj( V ) ),
                                     IsSubspacesVectorSpace
                                 and IsSubspacesVectorSpaceDefaultRep ),
                        rec(
                             structure  := V,
                             dimension  := dim
                           )
                      );
    else
      TryNextMethod();
    fi;
    end );


#############################################################################
##
#M  Subspaces( <V> )
##
InstallMethod( Subspaces,
    "for a vector space",
    [ IsVectorSpace ],
    function( V )
    if IsFinite( V ) then
      return Objectify( NewType( CollectionsFamily( FamilyObj( V ) ),
                                     IsSubspacesVectorSpace
                                 and IsSubspacesVectorSpaceDefaultRep ),
                        rec(
                             structure  := V,
                             dimension  := "all"
                           )
                      );
    else
      TryNextMethod();
    fi;
    end );


#############################################################################
##
#F  IsSubspace( <V>, <U> ) . . . . . . . . . . . . . . . . . check <U> <= <V>
##
InstallGlobalFunction( IsSubspace, function( V, U )
    return IsVectorSpace( U ) and IsSubset( V, U );
end );


#############################################################################
##
#M  IsVectorSpaceHomomorphism( <map> )
##
InstallMethod( IsVectorSpaceHomomorphism,
    [ IsGeneralMapping ],
    function( map )
    local S, R, F;
    S:= Source( map );
    if not IsVectorSpace( S ) then
      return false;
    fi;
    R:= Range( map );
    if not IsVectorSpace( R ) then
      return false;
    fi;
    F:= LeftActingDomain( S );
    return ( F = LeftActingDomain( R ) ) and IsLinearMapping( F, map );
    end );


#############################################################################
##
#E

