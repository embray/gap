#############################################################################
##
#W  oprtpcgs.gi                 GAP library                    Heiko Thei"sen
##
#H  @(#)$Id$
##
#Y  Copyright (C)  1997,  Lehrstuhl D fuer Mathematik,  RWTH Aachen, Germany
#Y  (C) 1998 School Math and Comp. Sci., University of St.  Andrews, Scotland
##
Revision.oprtpcgs_gi :=
    "@(#)$Id$";

InstallGlobalFunction(Pcs_OrbitStabilizer,function(pcgs,D,pnt,acts,act)
local   orb,             # orbit
	len,             # lengths of orbit before each extension
	d,		 # dictionary
	S, rel,   # stabilizer and induced pcgs
	img,  pos,       # image of <pnt> and its position in <orb>
	stb,             # stabilizing element, a word in <pcgs>
	i, ii, j, k;     # loop variables

  d:=NewDictionary(pnt,true,D);
  orb := [ pnt ];
  AddDictionary(d,pnt,1);
  len := ListWithIdenticalEntries( Length( pcgs ) + 1, 0 );
  len[ Length( len ) ] := 1;
  S := [  ];
  rel := [  ];
  for i  in Reversed( [ 1 .. Length( pcgs ) ] )  do
    img := act( pnt, acts[ i ] );
    pos := Position( orb, img );
    pos := LookupDictionary( d, img );
    if pos = fail  then

      # The current generator moves the orbit as a block.
      Add( orb, img );
      AddDictionary(d,img,Length(orb));

      for j  in [ 2 .. len[ i + 1 ] ]  do
	img := act( orb[ j ], acts[ i ] );
	Add( orb, img );
	AddDictionary(d,img,Length(orb));
      od;
      for k  in [ 3 .. RelativeOrders( pcgs )[ i ] ]  do
	for j  in Length( orb ) + [ 1 - len[ i + 1 ] .. 0 ]  do
	  img := act( orb[ j ], acts[ i ] );
	  Add( orb, img );
	  AddDictionary(d,img,Length(orb));
	od;
      od;

    else

      # The current generator leaves the orbit invariant.
      stb := ListWithIdenticalEntries( Length( pcgs ), 0 );
      stb[ i ] := 1;
      ii := i + 2;
      while pos <> 1  do
	while len[ ii ] >= pos  do
	  ii := ii + 1;
	od;
	stb[ ii - 1 ] := -QuoInt( pos - 1, len[ ii ] );
	pos := ( pos - 1 ) mod len[ ii ] + 1;
      od;
      Add( S, LinearCombinationPcgs( pcgs, stb ) );
      Add( rel, RelativeOrders( pcgs )[ i ] );
    fi;
    len[ i ] := Length( orb );

  od;
  return rec( orbit := orb, length := len, stabpcs := Reversed( S ),
	      relords := Reversed( rel ),dictionary:=d );
end);

InstallGlobalFunction(Pcgs_OrbitStabilizer,function(pcgs,D,pnt,acts,act)
  local pcs, new;    
  pcs := Pcs_OrbitStabilizer( pcgs, D,pnt, acts, act );
  new := InducedPcgsByPcSequenceNC( ParentPcgs(pcgs), pcs.stabpcs );
  SetRelativeOrders( new, pcs.relords );
  return rec( orbit := pcs.orbit, stabpcgs := new, lengths:=pcs.length,
              dictionary:=pcs.dictionary);
end);

# this function now becomes obsolete with dictionaries.
#  InstallGlobalFunction(Pcgs_OrbitStabilizer_Blist,
#  function(pcgs,dom,blist,pnt,acts,act)
#  local   orb,             # orbit
#          orpos,		 # position in orbit
#  	bpos,		 # blist position
#  	len,             # lengths of orbit before each extension
#  	S, rel,   # stabilizer and induced pcgs
#  	img,  pos,       # image of <pnt> and its position in <orb>
#  	stb,             # stabilizing element, a word in <pcgs>
#  	new,		 # new induced pcgs
#  	i, ii, j, k;     # loop variables
#  
#    orb := [ pnt ];
#    bpos:=PositionCanonical(dom,pnt);
#    orpos:=[];
#    orpos[bpos]:=1;
#    blist[bpos]:=true;
#    len := ListWithIdenticalEntries( Length( pcgs ) + 1, 0 );
#    len[ Length( len ) ] := 1;
#    S := [  ];
#    rel := [  ];
#    for i  in Reversed( [ 1 .. Length( pcgs ) ] )  do
#      img := act( pnt, acts[ i ] );
#  
#      bpos:=PositionCanonical(dom,img);
#      if not blist[bpos] then
#        blist[bpos]:=true;
#        
#        # The current generator moves the orbit as a block.
#        Add( orb, img );
#        orpos[bpos]:=Length(orb);
#        for j  in [ 2 .. len[ i + 1 ] ]  do
#  	img := act( orb[ j ], acts[ i ] );
#  	Add( orb, img );
#  	bpos:=PositionCanonical(dom,img);
#  	blist[bpos]:=true;
#  	orpos[bpos]:=Length(orb);
#        od;
#        for k  in [ 3 .. RelativeOrders( pcgs )[ i ] ]  do
#  	for j  in Length( orb ) + [ 1 - len[ i + 1 ] .. 0 ]  do
#  	  img := act( orb[ j ], acts[ i ] );
#  	  Add( orb, img );
#  	  bpos:=PositionCanonical(dom,img);
#  	  blist[bpos]:=true;
#  	  orpos[bpos]:=Length(orb);
#  	od;
#        od;
#        
#      else
#        pos := orpos[bpos];
#        # The current generator leaves the orbit invariant.
#        stb := ListWithIdenticalEntries( Length( pcgs ), 0 );
#        stb[ i ] := 1;
#        ii := i + 2;
#        while pos <> 1  do
#  	while len[ ii ] >= pos  do
#  	  ii := ii + 1;
#  	od;
#  	stb[ ii - 1 ] := -QuoInt( pos - 1, len[ ii ] );
#  	pos := ( pos - 1 ) mod len[ ii ] + 1;
#        od;
#        Add( S, LinearCombinationPcgs( pcgs, stb ) );
#        Add( rel, RelativeOrders( pcgs )[ i ] );
#  
#      fi;
#      len[ i ] := Length( orb );
#    od;
#    new := InducedPcgsByPcSequenceNC( ParentPcgs(pcgs), Reversed(S) );
#    SetRelativeOrders( new, Reversed( rel ) );
#    return rec( orbit := orb, lengths := len, stabpcgs := new);
#  
#  end);


#############################################################################
##
#F  StabilizerPcgs( <pcgs>, <pnt> [,<acts>] [,<act>] ) . . . . . . . . . .
##
##  computes the stabilizer in the group generated by <pcgs> of the point
##  <pnt>. If given <acts> are elements by which <pcgs> acts, <act> is
##  the acting function. This function returns a pcgs for the stabilizer
##  which is induced by the `ParentPcgs' of <pcgs>, that is it is compatible
##  with <pcgs>.
InstallGlobalFunction(StabilizerPcgs,function(arg)
local acts,act;
  acts:=arg[1];
  act:=OnPoints;
  if Length(arg)=3 then
    if IsFunction(arg[3]) then
      act:=arg[3];
    else
      acts:=arg[3];
    fi;
  elif Length(arg)=4 then
    acts:=arg[3];
    act:=arg[4];
  fi;
  # catch the case of vectors and prepare for hashing.
  if IsRowVector(arg[2]) and Length(acts)>0 and IsMatrix(acts[1]) then
    return Pcgs_OrbitStabilizer(arg[1],NaturalActedSpace(acts,[arg[2]]),
                                arg[2],acts,act).stabpcgs;
  else
    return Pcgs_OrbitStabilizer(arg[1],false,arg[2],acts,act).stabpcgs;
  fi;
end);
        

# This function does the same as the following method, however it does dot
# create an immutable copy of the orbit (which could be expensive)
BindGlobal("Pcgs_MutableOrbitStabilizerOp",function( G, D,pnt, pcgs, acts, act )
local S,stab;
  S:=Pcgs_OrbitStabilizer(pcgs,D,pnt,acts,act);
  stab := SubgroupByPcgs( G, S.stabpcgs );
  # this setting is already done by `SubgroupByPcgs'.
  #SetInducedPcgs(ParentPcgs(pcgs),stab,S.stabpcgs);
  return rec( orbit := S.orbit, stabilizer := stab );
end);

#############################################################################
##
#M  OrbitStabilizerOp( <G>, <D>, <pnt>, <pcgs>, <acts>, <act> ) . . . by pcgs
##
InstallMethod( OrbitStabilizerOp,
        "G, D, pnt, pcgs, acts, act", true,
        [ IsGroup, IsList, IsObject, IsPrimeOrdersPcgs, IsList, IsFunction ],
        0,
function( G,D, pnt, pcgs, acts, act )
  return Immutable(Pcgs_MutableOrbitStabilizerOp(G,D,pnt,pcgs,acts,act));
end );

InstallOtherMethod( OrbitStabilizerOp,
        "G, pnt, pcgs, acts, act", true,
        [ IsGroup, IsObject, IsPrimeOrdersPcgs, IsList, IsFunction ], 0,
function( G, pnt, pcgs, acts, act )
  return Immutable(Pcgs_MutableOrbitStabilizerOp(G,false,pnt,pcgs,acts,act));
end );

InstallMethod( OrbitStabilizerAlgorithm,"for pcgs",true,
  [IsGroup,IsObject,IsObject,IsPcgs,
     IsList,IsRecord],0,
function(G,D,blist,pcgs,acts,pntact)
local S,stab,i,pnt,act;
  pnt:=pntact.pnt;
  if IsBound(pntact.act) then
    act:=pntact.act;
  else
    act:=pntact.opr;
  fi;

  S:=Pcgs_OrbitStabilizer(pcgs,D,pnt,acts,act);
  stab := SubgroupByPcgs( G, S.stabpcgs );

  # tick off if necessary
  if IsList(blist) then
    if IsPositionDictionary(S.dictionary) then
      UniteBlist(blist,S.dictionary!.blist);
    else
      for i in S.orbit do
	blist[PositionCanonical(D,i)]:=true;
      od;
    fi;
  fi;

  return rec( orbit := S.orbit, stabilizer := stab );

end);

#############################################################################
##
#F  SetCanonicalRepresentativeOfExternalOrbitByPcgs( <xset> ) . . . . . . . .
##
InstallGlobalFunction( SetCanonicalRepresentativeOfExternalOrbitByPcgs,
    function( xset )
    local   G,  D,  pnt,  pcgs,  acts,  act,
            orb,  bit,  # orbit, as list and bit-list
            len,        # lengths of orbit before each extension
            stab,  S,   # stabilizer and induced pcgs
            img,  pos,  # image of <pnt> and its position in <D> (or <orb>)
            min,  mpos, # minimal value of <pos>, position in <orb>
            stb,        # stabilizing element, a word in <pcgs>
            oper,       # operating element, a word in <pcgs>
            i, ii, j, k;# loop variables

    G    := ActingDomain( xset );
    D    := HomeEnumerator( xset );
    pnt  := Representative( xset );
    if IsExternalSetDefaultRep( xset )  then
        pcgs := Pcgs( G );
        acts := pcgs;
        act  := FunctionAction( xset );
    else
        pcgs := xset!.generators;
        acts := xset!.operators;
        act  := xset!.funcOperation;
    fi;
    
    orb := [ pnt ];
    len := ListWithIdenticalEntries( Length( pcgs ) + 1, 0 );
    len[ Length( len ) ] := 1;
    min := Position( D, pnt );  mpos := 1;
    bit := BlistList( [ 1 .. Length( D ) ], [ min ] );
    S := [  ];
    for i  in Reversed( [ 1 .. Length( pcgs ) ] )  do
        img := act( pnt, acts[ i ] );
        pos := PositionCanonical( D, img );
        if not bit[ pos ]  then
            
            # The current generator moves the orbit as a block.
            Add( orb, img );  bit[ pos ] := true;
            if pos < min  then
                min := pos;  mpos := Length( orb );
            fi;
            for j  in [ 2 .. len[ i + 1 ] ]  do
                img := act( orb[ j ], acts[ i ] );
                pos := PositionCanonical( D, img );
                Add( orb, img );  bit[ pos ] := true;
                if pos < min  then
                    min := pos;  mpos := Length( orb );
                fi;
            od;
            for k  in [ 3 .. RelativeOrders( pcgs )[ i ] ]  do
                for j  in Length( orb ) + [ 1 - len[ i + 1 ] .. 0 ]  do
                    img := act( orb[ j ], acts[ i ] );
                    pos := PositionCanonical( D, img );
                    Add( orb, img );  bit[ pos ] := true;
                    if pos < min  then
                        min := pos;  mpos := Length( orb );
                    fi;
                od;
            od;
            
        else
          
            # The current generator leaves the orbit invariant.
            pos := Position( orb, img );
            stb := ListWithIdenticalEntries( Length( pcgs ), 0 );
            stb[ i ] := 1;
            ii := i + 2;
            while pos <> 1  do
                while len[ ii ] >= pos  do
                    ii := ii + 1;
                od;
                stb[ ii - 1 ] := -QuoInt( pos - 1, len[ ii ] );
                pos := ( pos - 1 ) mod len[ ii ] + 1;
            od;
            Add( S, LinearCombinationPcgs( pcgs, stb ) );
            
        fi;
        len[ i ] := Length( orb );
    od;
    SetEnumerator( xset, orb );

    # Construct the operator for the minimal point at <mpos>.
    oper := ListWithIdenticalEntries( Length( pcgs ), 0 );
    ii := 2;
    while mpos <> 1  do
        while len[ ii ] >= mpos  do
            ii := ii + 1;
        od;
        mpos := mpos - 1;
        oper[ ii - 1 ] := -QuoInt( mpos, len[ ii ] );
        mpos := mpos mod len[ ii ] + 1;
    od;
    SetCanonicalRepresentativeOfExternalSet( xset, D[ min ] );
    if not HasActorOfExternalSet( xset )  then
        SetActorOfExternalSet( xset,
                LinearCombinationPcgs( pcgs, oper ) ^ -1 );
    fi;
            
    # <S> is a reversed IGS.
    if not HasStabilizerOfExternalSet( xset )  then
        S    := InducedPcgsByPcSequenceNC( ParentPcgs(pcgs), Reversed( S ) );
        stab := SubgroupByPcgs( G, S );
#        SetRelativeOrders( S, Reversed( rel ) );
#	SetInducedPcgs(ParentPcgs(pcgs),stab,S);
#        if ParentPcgs( pcgs ) = HomePcgs( stab )  then
#            SetInducedPcgsWrtHomePcgs( stab, S );
#        else
#            SetPcgs( stab, S );
#        fi;
        SetStabilizerOfExternalSet( xset, stab );
    fi;
    
end );

#############################################################################
##
#M  Enumerator( <xorb> )  . . . . . . . . . . . . . . . . . . . . . . . . . .
##
InstallMethod( Enumerator, "<xorb by pcgs>", true,
        [ IsExternalOrbit and IsExternalSetByPcgs ], 0,
    function( xorb )
    local   orbstab;
    
    orbstab := OrbitStabilizer( xorb, Representative( xorb ) );
    SetStabilizerOfExternalSet( xorb, orbstab.stabilizer );
    return orbstab.orbit;
end );

#############################################################################
##
#M  CanonicalRepresentativeOfExternalSet( <xorb> )  . . . . . . . . . . . . .
##
InstallMethod( CanonicalRepresentativeOfExternalSet,
        "via `ActorOfExternalSet'", true,
        [ IsExternalOrbit and IsExternalSetByPcgs ], 0,
    function( xorb )
    local   oper;
    
    oper := ActorOfExternalSet( xorb );
    if HasCanonicalRepresentativeOfExternalSet( xorb )  then
        return CanonicalRepresentativeOfExternalSet( xorb );
    else
        return FunctionAction( xorb )( Representative( xorb ), oper );
    fi;
end );

#############################################################################
##
#M  ActorOfExternalSet( <xorb> ) . . . . . . . . . . . . . . . . . . . . .
##
InstallMethod( ActorOfExternalSet, true,
        [ IsExternalOrbit and IsExternalSetByPcgs ], 0,
    function( xorb )
    SetCanonicalRepresentativeOfExternalOrbitByPcgs( xorb );
    return ActorOfExternalSet( xorb );
end );

#############################################################################
##
#M  StabilizerOfExternalSet( <xorb> ) . . . . .  stabilizer of representative
##
InstallMethod( StabilizerOfExternalSet, true,
        [ IsExternalOrbit and IsExternalSetByPcgs ], 0,
    function( xorb )
    local   orbstab;

    orbstab := OrbitStabilizer( xorb, Representative( xorb ) );
    SetEnumerator( xorb, orbstab.orbit );
    return orbstab.stabilizer;
end );

#############################################################################
##
#M  OrbitOp( <G>, <D>, <pnt>, <pcgs>, <acts>, <act> ) . . . . . based on pcgs
##

BindGlobal("DoPcgsOrbitOp",function( G, D, pt, U, V, act )
local   orb,  v,  img,  len,  i,  j,  k,d,nimg;

  d:=NewDictionary(pt,false,D);
  orb := [ pt ];
  AddDictionary(d,pt);

  for i  in Reversed( [ 1 .. Length( V ) ] )  do
    v := V[ i ];
    img := act( pt, v );
    if not KnowsDictionary(d,img) then
      len := Length( orb );
      Add( orb, img );
      AddDictionary(d,img);
      for j  in [ 2 .. len ]  do
	nimg:=act( orb[ j ], v );
	Add( orb, nimg );
	AddDictionary(d,nimg);
      od;
      for k  in [ 3 .. RelativeOrders( U )[ i ] ]  do
	for j  in [ Length( orb ) - len + 1 .. Length( orb ) ]  do
	  nimg:=act( orb[ j ], v );
	  Add( orb, nimg );
	  AddDictionary(d,nimg);
	od;
      od;
    fi;
  od;
  return Immutable( orb );
end );

InstallMethod( OrbitOp,
        "via prime order pcgs, with domain", true,
        [ IsGroup, IsList, IsObject, IsPrimeOrdersPcgs, IsList, IsFunction ],
        0,DoPcgsOrbitOp);

InstallOtherMethod( OrbitOp,
        "action via prime order pcgs", true,
        [ IsGroup, IsObject, IsPrimeOrdersPcgs, IsList, IsFunction ], 0,
function( G, pt, U, V, act )
  return DoPcgsOrbitOp(G,false,pt,U,V,act);
end);

#############################################################################
##
#M  RepresentativeActionOp( <G>, <D>, <d>, <e>, <pcgs>, <acts>, <act> )  .
##
InstallOtherMethod( RepresentativeActionOp, true,
        [ IsGroup, IsList, IsObject, IsObject, IsPrimeOrdersPcgs,
          IsList, IsFunction ], 0,
    function( G, D, d, e, pcgs, acts, act )
    local   dset,  eset;
    
    dset := ExternalOrbit( G, D, d, pcgs, acts, act );
    eset := ExternalOrbit( G, D, e, pcgs, acts, act );
    return ActorOfExternalSet( dset ) /
           ActorOfExternalSet( eset );
end );

#############################################################################
##
#M  StabilizerOp( <G>, <D>, <pt>, <U>, <V>, <op> )  . . . . . . based on pcgs
##
InstallMethod( StabilizerOp,
  "G, D, pnt, pcgs, acts, act, calling `Pcgs_MutableOrbitStabilizerOp'", true,
    [ IsGroup, IsList, IsObject, IsPrimeOrdersPcgs,
      IsList, IsFunction ], 0,
    function( G, D, pt, U, V, op )
    return Pcgs_MutableOrbitStabilizerOp( G, D,pt, U, V, op ).stabilizer;
end );

InstallOtherMethod( StabilizerOp,
    "G, pnt, pcgs, acts, act, calling `Pcgs_MutableOrbitStabilizerOp'", true,
        [ IsGroup, IsObject, IsPrimeOrdersPcgs,
          IsList, IsFunction ], 0,
  function( G, pt, U, V, op )
    return Pcgs_MutableOrbitStabilizerOp( G, false,pt, U, V, op ).stabilizer;
end );

InstallOtherMethod( StabilizerOp,
        "G (solv.), pnt, gens, gens, act", true,
        [ IsGroup and CanEasilyComputePcgs, IsObject,
          IsList,
          IsList,
          IsFunction ], 0,
function( G, pt, gens, acts, op )
  if gens = acts  then
    return Pcgs_MutableOrbitStabilizerOp(G,false,pt,
                                       Pcgs(G),Pcgs(G),op).stabilizer;
  else
    TryNextMethod();
  fi;
end );

InstallMethod( StabilizerOp,
        "G (solv.), D,pnt, gens, gens, act", true,
        OrbitishReq, 0,
function( G,D, pt, gens, acts, op )
  if gens = acts  then
    return Pcgs_MutableOrbitStabilizerOp(G,D,pt,Pcgs(G),Pcgs(G),op).stabilizer;
  else
    TryNextMethod();
  fi;
end );

InstallOtherMethod( StabilizerOp,
        "G (solv.), pnt, gens, gens, act", true,
        [ IsGroup and CanEasilyComputePcgs, IsObject,
          IsPrimeOrdersPcgs,
          IsList,
          IsFunction ], 0,
function( G, pt, gens, acts, op )
  return Pcgs_MutableOrbitStabilizerOp(G,false,pt,gens,acts,op).stabilizer;
end );

InstallOtherMethod( StabilizerOp,
        "G (solv.), D,pnt, gens, gens, act", true,
        [ IsGroup and CanEasilyComputePcgs, IsObject,
	  IsObject,
          IsPrimeOrdersPcgs,
          IsList,
          IsFunction ], 0,
function( G,D, pt, gens, acts, op )
  return Pcgs_MutableOrbitStabilizerOp(G,D,pt,gens,acts,op).stabilizer;
end );


#############################################################################
