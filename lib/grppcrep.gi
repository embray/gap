#############################################################################
##
#W  grppcrep.gd                 GAP library                      Bettina Eick
##
Revision.grppcrep_gi :=
    "@(#)$Id$";

#############################################################################
##
#F MappedVector( <exp>, <list> ). . . . . . . . . . . . . . . . . . . . local
##
MappedVector := function( exp, list )
    local elm, i;

    if Length( list ) = 0 then
        Error("cannot compute this\n");
    fi;
    elm := list[1]^exp[1];
    for i in [2..Length(list)] do
        elm := elm * list[i]^exp[i];
    od;
    return elm;
end;

#############################################################################
##
#F BlownUpModule( <modu>, <E>, <F> ) . . . . . . . blow up by field extension
##
BlownUpModule := function( modu, E, F )
    local K, mats;

    # the trivial case
    K := AsField( F, E );
    if Dimension( K ) = 1 then return modu; fi;
 
    mats := List( modu.generators, x -> BlownUpMat( x, K ) );
    return GModuleByMats( mats, F );
end;

#############################################################################
##
#F ConjugatedModule( <pcgsN>, <g>, <modu> ) . . . . . . . . conjugated module
##
ConjugatedModule := function( pcgsN, g, modu )
    local mats, i, exp, mat, j;

    mats := List(modu.generators, x -> false );
    for i in [1..Length(mats)] do
        exp := ExponentsOfPcElement( pcgsN, pcgsN[i]^g );
        mats[i] := MappedVector( exp, modu.generators );
    od;
    return GModuleByMats( mats, modu.field );
end;

#############################################################################
##
#F FpOfModules( <pcgs>, <list of reps> ) . . . . . . . . distinguish by chars
##
FpOfModules := function( pcgs, modus )
    local words, traces, trset, word, exp, new, i, newset, n;
   
    n      := Length( modus );
    words  := ShallowCopy( AsList( pcgs ) );
    traces := List( modus, x -> Concatenation( [x.dimension], 
                                List(x.generators, y -> TraceMat( y ))));
    trset  := Set( traces );
  
    # iterate computation of elements
    while Length( trset ) < Length( modus ) do
        word := Random( GroupOfPcgs( pcgs ) );
        if word <> OneOfPcgs( pcgs ) and not word in words then
            exp := ExponentsOfPcElement( pcgs, word );
            new := List( modus, x->TraceMat(MappedVector(exp, x.generators)));
            for i in [1..n] do
                new[i] := Concatenation( traces[i], [new[i]] );
            od;
            newset := Set( new );
            if Length( newset ) > Length( trset ) then
                Add( words, word );
                traces := ShallowCopy( new );
                trset  := ShallowCopy( newset );
            fi;
        fi;
    od;

    words := List( words, x -> ExponentsOfPcElement( pcgs, x ) );
    return rec( words  := words,
                traces := traces );
end;
        
#############################################################################
##
#F EquivalenceType( <fp>, <modu> ) . . . . . . . . . . use chars to find type
##
EquivalenceType := function( fp, modu )
    local trace;

    trace := List(fp.words, x -> TraceMat(MappedVector(x, modu.generators)));
    trace := Concatenation( [modu.dimension], trace );
    return Position( fp.traces, trace );
end;

#############################################################################
##
#F IsEquivalentByFp( <fp>, <x>, <y> ) . . . . . . . equivalence type by chars
##
IsEquivalentByFp := function( fp, x, y )

    # get the easy cases first
    if x.dimension <> y.dimension then
        return false;
    elif Dimension( x.field ) <> Dimension( y.field ) then
        return false;
    fi;

    # now it remains to check this really
    return EquivalenceType( fp, x ) = EquivalenceType( fp, y );
end;

#############################################################################
##
#F GaloisConjugates( <modu>, <F> ) . . . . . . . . . . .apply frobenius autom
##
GaloisConjugates := function( modu, F )
    local d, p, conj, k, mats, r, i, new;

    # set up
    d := Dimension( F );   
    p := Characteristic( F );
    conj := [ modu ];

    # conjugate
    for k in [1..d-1] do
        mats := List( modu.generators, x -> false );
        r    := RemInt( p^k, p^d-1 );
        for i in [1..Length(mats)] do
            mats[i] := List(modu.generators[i], x -> List(x, y -> y^r) );
        od;
        new := GModuleByMats( mats, F );
        Add( conj, new );
    od;
    return conj;
end;

#############################################################################
##
#F TrivialModule( <n>, <F> ) . . . . . . . . . . . trivial module with n gens
##
TrivialModule := function( n, F )
    return rec( field := F,
                dimension := 1,
                generators := List( [1..n], x ->  IdentityMat( 1, F ) ),
                isMTXModule := true,
                basis := [[One(F)]] );
end;

#############################################################################
##
#F InducedModule( <pcgsS>, <modu> ) . . . . . . . . . . . . . .induced module
##
InducedModule := function( pcgsS, modu )
    local m, d, h, r, mat, i, j, mats, zero, id, exp, g;

    g := pcgsS[1];
    m := Length( pcgsS );
    d := modu.dimension;
    r := RelativeOrderOfPcElement( pcgsS, g );
    zero := NullMat( d, d, modu.field );
    id   := IdentityMat( d, modu.field );
   
    # the first matrix
    mat := List( [1..r], x -> List( [1..r], y -> zero ) );
    exp := ExponentsOfPcElement( pcgsS, g^r, [2..m] );
    mat[1][r] := MappedVector( exp, modu.generators );
    for j in [2..r] do
        mat[j][j-1] := id;
    od;
    mats := [FlatBlockMat( mat )];

    # the remaining ones
    for i in [2..m] do
        mat := List( [1..r], x -> List( [1..r], y -> zero ) );
        for j in [1..r] do
            h := pcgsS[i]^(g^(j-1));
            exp := ExponentsOfPcElement( pcgsS, h, [2..m] );
            mat[j][j] := MappedVector( exp, modu.generators ); 
        od;
        Add( mats, FlatBlockMat( mat ) );
    od;
    
    return GModuleByMats( mats, modu.field );
end; 

#############################################################################
##
#F InducedModuleByFieldReduction( <pcgsS>, <modu>, <conj>, <gal>, <s> ) . . .
##
## The conjugated module is also galoisconjugate to modu. Thus we may use
## a field extension to induce.
##
InducedModuleByFieldReduction := function( pcgsS, modu, conj, gal, s )
    local r, E, dE, p, l, K, EK, base, vecs, matsN, iso, nu, coeffs, id, ch,
          matg, mats, newm, exp, mat, e, k, q, c, m, gmat;

    # get extensions of underlying fields
    r := RelativeOrderOfPcElement( pcgsS, pcgsS[1] );
    E := modu.field;
    dE := Dimension( E );
    p := Characteristic( modu.field );
    l := QuoInt( dE, r );
    K := GF( p^l );
    EK := AsField( K, E );
    base := Basis( EK );
    vecs := BasisVectors( base );

    # blow up matrices in N
    matsN := List( modu.generators, x -> BlownUpMat( x, EK ) );

    # compute isomorphism
    MTX.IsIrreducible( conj );
    iso := MTX.Isomorphism( conj, gal );

    # compute inverse galois automorphism and corresponding matrix
    exp  := ExponentsOfPcElement( pcgsS, pcgsS[1]^r, [2..Length(pcgsS)] );
    gmat := MappedVector( exp, modu.generators );
    e := iso * gmat^-1;
    for k in [1..r-1] do
        q := RemInt( p^((s-1)*k), p^dE - 1);
        e := List( iso, x -> List( x, y -> y^q ) ) * e;
    od;
    e := e[1][1];
    c := PrimitiveRoot( E ) ^ QuoInt( LogFFE( e, PrimitiveRoot(E) ),
                         QuoInt( p^dE - 1, p^l - 1 ) );
    iso := c^-1 * iso;

    # compute base change
    m := p^(1-s) mod (p^dE - 1);
    coeffs := List( [1..r], j -> Coefficients( base, vecs[j]^m ) );
    id := IdentityMat( modu.dimension, K );
    ch := KroneckerProduct( id, TransposedMat( coeffs ) );

    # construct matrix
    matg := ch * BlownUpMat( iso, EK );

    # construct module and return
    mats := Concatenation( [matg], matsN );
    newm := GModuleByMats( mats, K ); 
    return newm;
end;

#############################################################################
##
#F ExtensionsOfModule( <pcgsS>, <modu>, <conj>, <dim> ) . . .extended modules
##
## <dim> is restriction on field extensions.
##
ExtensionsOfModule := function( pcgsS, modu, conj, dim ) 
    local r, new, E, p, dE, exp, gmat, iso, e, c, mats, newm, f, d, b, 
          L, j, w, g, k;

    # set up
    g    := pcgsS[1];
    r    := RelativeOrderOfPcElement( pcgsS, g );
    new  := [];

    # set up fields
    E  := modu.field;
    p  := Characteristic( E );
    dE := Dimension( E ); 

    # compute matrix to g^r in N
    exp  := ExponentsOfPcElement( pcgsS, g^r, [2..Length(pcgsS)] );
    gmat := MappedVector( exp, modu.generators );

    # we know that conj and modu are equivalent - compute e
    MTX.IsIrreducible( conj );
    iso := MTX.Isomorphism( modu, conj );
    e   := (gmat * iso^(-r));
    e   := e[1][1];

    if (p^dE - 1) mod r <> 0 then

        # compute rth root c of e in E
        c := e ^ (r^(-1) mod (p^dE - 1));

        # this yields a unique extension of modu over E
        mats := Concatenation( [c * iso], modu.generators );
        newm := GModuleByMats( mats, E );
        Add( new, newm );

        # if we have roots of unity in an extension of E
        if r <> p then
            f := Factors( PolynomialRing( E ),
                          UnivariatePolynomialByCoefficients( 
                          FamilyObj(One(E)), 
                          List( [1..r], x -> One( E )), 1));
            d := DegreeOfUnivariateLaurentPolynomial( f[1] );

            b := dE * d;
            if b * modu.dimension <= dim then
                L := GF(p^b);
                for j in [1..Length(f)] do
                    w := PrimitiveRoot( L ) ^ ((p^b - 1)/r);
                    while Value( f[j], w ) <> Zero( E ) do
                        w := w * PrimitiveRoot( L )^ ((p^b - 1)/r);
                    od;
                    mats := Concatenation( [w*c*iso], modu.generators );
                    newm := GModuleByMats( mats, L );
                    Add( new, newm );
                od;
            fi;
        fi;
        return new;
    fi;

    # now we know that p^dE - 1 mod r = 0
    k := 0;
    while (p^dE - 1) mod r^(k+1) = 0 do
        k := k + 1;
    od;

    # if we have r distinct rth roots of e in E
    if Order( e ) mod r^k <> 0 then
        c := PrimitiveRoot( E ) ^ QuoInt( LogFFE( e, PrimitiveRoot(E) ), r );
        for j in [1..r] do
            mats := Concatenation( [c*iso], modu.generators );
            newm := GModuleByMats( mats, E );
            Add( new, newm );
            c := c * PrimitiveRoot( E ) ^ QuoInt( p^dE-1, r ); 
        od;
        return new;
    fi;

    # if we have we do not have any root in E, go over to extension
    if dE * r * modu.dimension <= dim then
        L := GF( p^(dE * r) );
        c := PrimitiveRoot( L ) ^ QuoInt( LogFFE( e, PrimitiveRoot( L ) ), r );
        mats := Concatenation( [c*iso], modu.generators );
        newm := GModuleByMats( mats, L );
        Add( new, newm );
    fi;
    return new;
end;

#############################################################################
##
#F InitAbsAndIrredModules( <r>, <F>, <dim> )  . . . . . . . . . . . . . local
##
InitAbsAndIrredModules := function( r, F, dim )
    local new, mats, modu, f, l, E, w, S, j, matsn, d, p, b, irr, i;

    # set up
    new := [];
    p   := Characteristic( F );
    d   := Dimension(F);

    # restrict dimension
    if d > dim then return []; fi;

    if ( (p^d-1) mod r ) <> 0 then
        mats := [ IdentityMat( 1, F ) ];
        modu := GModuleByMats( mats, F );
        Add( new, modu );

        if r <> p then
            f := Factors( PolynomialRing( F ),
                          UnivariatePolynomialByCoefficients( 
                          FamilyObj(One(F)), 
                          List( [1..r], x -> One( F )), 1));
            l := DegreeOfUnivariateLaurentPolynomial( f[1] );
            b := l * d;
            if b <= dim then
                E := GF( p^b );
                for j in [ 1..Length( f ) ] do
                    w := PrimitiveRoot(E)^QuoInt( p^b-1, r );
                    while Value( f[j], w ) <> Zero( F ) do
	                w := w * PrimitiveRoot(E)^QuoInt( p^b-1, r );
	            od;
                    modu := GModuleByMats( [[[w]]], E );
                    Add( new, modu );
                od;
            fi;
        fi;
    else
        w := PrimitiveRoot( F )^QuoInt( p^d - 1, r );
        for j in [ 1..r ] do
            mats := [ [[w]] ];
            modu := GModuleByMats( mats, F );
            Add( new, modu );
            w := w * PrimitiveRoot( F )^QuoInt( p^d - 1, r );
        od;
    fi;

    # blow modules up
    for i in [1..Length(new)] do
        irr := BlownUpModule( new[i], new[i].field, F );
        new[i] := rec( irred := irr,
                       absirr := new[i] );
    od;

    # return
    return new;
end;

#############################################################################
##
#F LiftAbsAndIrredModules( <pcgsS>, <pcgsN>, <modrec>, <dim> ). . . . . local
##
LiftAbsAndIrredModules := function( pcgsS, pcgsN, modrec, dim )
    local todo, fp, new, i, modu, E, conj, type, s, gal, types, r, un, j, 
          g, galfp, smalls, small, sconj, irred, absirr, n, F, irr, d;

    # split modules into parts
    irred  := List( modrec, x -> x.irred );
    absirr := List( modrec, x -> x.absirr );
    n      := Length( modrec );
    F      := irred[1].field;
    d      := Dimension( F );

    # set up
    todo := [1..n];
    fp   := FpOfModules( pcgsN, irred );
    g    := pcgsS[1];
    r    := RelativeOrderOfPcElement( pcgsS, g );
    new  := [];

    # until we have all modules lifted
    while Length( todo ) > 0 do

        # choose a module
        i := todo[Length( todo )];  
        Unbind( todo[Length(todo)] );
        modu  := absirr[i];
        E     := modu.field;
        small := irred[i];

        # compute its conjugate
        sconj := ConjugatedModule( pcgsN, g, small );
        type  := EquivalenceType( fp, sconj );

        # if the are equivalent
        if type <> i then
            if r * small.dimension * d <= dim then
                Add( new, InducedModule( pcgsS, modu ) );
            fi;
            
            # filter out the modules also inducing to the new one
            un := [type];
            for j in [1..r-2] do
                sconj := ConjugatedModule( pcgsN, g, sconj );
                type := EquivalenceType( fp, sconj );
                AddSet( un, type );
            od;
            todo := Difference( todo, un );
        else

            # compute galois conjugates and try to find equivalent one
            conj  := ConjugatedModule( pcgsN, g, modu );
            gal   := GaloisConjugates( modu, AsField( F, E ) );
            galfp := FpOfModules( pcgsN, gal );
            s     := EquivalenceType( galfp, conj );

            if s = 1 then
                Append( new, ExtensionsOfModule( pcgsS, modu, conj, dim ) );
            else 
                Add( new, 
                InducedModuleByFieldReduction(pcgsS, modu, conj, gal[s], s));
            fi;
        fi;
    od;

    # now it remains to blow the modules up
    for i in [1..Length(new)] do
        E := new[i].field;
        irr := BlownUpModule( new[i], E, F );
        new[i] := rec( irred := irr, 
                       absirr := new[i] );
    od;    

    # return
    return new;
end;
             
#############################################################################
##
#F AbsAndIrredModules( <G>, <F>, <dim> ) . . . . . . . . . . . . . . . .local
##
AbsAndIrredModules := function( G, F, dim )
    local pcgs, m, modrec, i, pcgsS, pcgsN, r, irr;

    # set up 
    pcgs  := Pcgs( G );
    m     := Length( pcgs );

    if m = 0 and Dimension( F ) <= dim then return [TrivialModule( 0, F )]; 
    elif m = 0 then return []; fi;
    if dim = 0 then dim := 2^16-1; fi;

    # the first step is separated - too many problems with empty lists
    r     := RelativeOrderOfPcElement( pcgs, pcgs[m] );
    modrec := InitAbsAndIrredModules( r, F, dim );

    # step up pc series
    for i in Reversed( [1..m-1] ) do
        pcgsS := InducedPcgsByPcSequence( pcgs, pcgs{[i..m]} );
        pcgsN := InducedPcgsByPcSequence( pcgs, pcgs{[i+1..m]} );
        modrec := LiftAbsAndIrredModules( pcgsS, pcgsN, modrec, dim );
    od;
  
    # return 
    return modrec;
end;

#############################################################################
##
#M AbsolutIrreducibleModules( <G>, <F>, <dim> ). . . . . . .up to equivalence
##
## <dim> is restriction on Dimension( F ) * Dimension( module ).
##
InstallMethod( AbsolutIrreducibleModules,
    "generic method for groups with pcgs",
    true, 
    [ IsGroup and IsPcgsComputable, IsField and IsFinite, IsInt ],
    0,

function( G, F, dim )
    local modus;
    modus := AbsAndIrredModules( G, F, dim );
    return List( modus, x -> x.absirr );
end );

#############################################################################
##
#M IrreducibleModules( <G>, <F>, <dim> ) . . . . . . . . . .up to equivalence
##
## <dim> is restriction on Dimension( F ) * Dimension( module ).
##
InstallMethod( IrreducibleModules,
    "generic method for groups with pcgs",
    true, 
    [ IsGroup and IsPcgsComputable, IsField and IsFinite, IsInt ],
    0,

function( G, F, dim )
    local modus, i, tmp;
    if dim = 0 then dim := 2^16-1; fi;
    modus := AbsAndIrredModules( G, F, dim );
    for i in [1..Length(modus)] do
        tmp := modus[i].irred;
        tmp.absolutelyIrreducible := modus[i].absirr;
        modus[i] := tmp;
    od;
    return modus;
end );

#############################################################################
##
#M RegularModule( <G>, <F> ) . . . . . . . . . . .right regular F-module of G
##
InstallMethod( RegularModule,
    "generic method for groups with pcgs",
    true, 
    [ IsGroup and IsPcgsComputable, IsField ],
    0,

function( G, F )
    local pcgs, mats, elms, d, zero, i, mat, j, o;

    pcgs := Pcgs(G);
    mats := List( pcgs, x -> false );
    elms := AsList( G );
    d    := Length(elms);
    zero := NullMat( d, d, F );
    for i in [1..Length( pcgs )] do
        mat := DeepCopy( zero ); 
        for j in [1..d] do
            o := Position( elms, elms[j]*pcgs[i] );
            mat[j][o] := One( F );
        od;
        mats[i] := mat;
    od;
    return GModuleByMats( mats, F );
end );

#############################################################################
##
#F IrreducibleModules2( <G>, <F> ) . . . . . . constituents of regular module
##
IrreducibleModules2 := function( G, F )
    local modu;
    modu := RegularModule( G, F );
    return List( MTX.CollectedFactors( modu ), x -> x[1] );
end;

CheckMod := function( pcgsS, irr )
    local n, gens, i, j, c, t, w, k;

    n := Length( pcgsS );
    gens := irr.generators;
    for i in [1..n] do
        for j in [i+1..n] do
            c := Comm( gens[j], gens[i] );
            t := ExponentsOfPcElement( pcgsS, Comm(pcgsS[j], pcgsS[i]) );
            w := IdentityMat( irr.dimension, irr.field );
            for k in [1..n] do
                w := w * gens[k]^t[k];
            od;
            if c <> w then Error("mod check\n"); fi;
        od;
        c := gens[i]^RelativeOrders( pcgsS )[i];
        t := ExponentsOfPcElement( pcgsS, 
                                   pcgsS[i]^RelativeOrders( pcgsS)[i] );
        w := IdentityMat( irr.dimension, irr.field );
        for k in [1..n] do
            w := w * gens[k]^t[k];
        od;
        if c <> w then Error("mod check\n"); fi;
    od;
end;       
