#############################################################################
##
#W  morpheus.gi                GAP library                   Alexander Hulpke
##
#H  @(#)$Id$
##
#Y  Copyright (C)  1996,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
#Y  (C) 1998 School Math and Comp. Sci., University of St.  Andrews, Scotland
##
##  This  file  contains declarations for Morpheus
##
Revision.morpheus_gi:=
  "@(#)$Id$";

#############################################################################
##
#V  MORPHEUSELMS . . . .  limit up to which size to store element lists
##
MORPHEUSELMS := 50000;

#############################################################################
##
#M  AutomorphismDomain(<G>)
##
##  If <G> consists of automorphisms of <H>, this attribute returns <H>.
InstallMethod( AutomorphismDomain, "use source of one",true,
  [IsGroupOfAutomorphisms],0,
function(G)
  return Source(One(G));
end);

DeclareRepresentation("IsActionHomomorphismAutomGroup",
  IsActionHomomorphismByBase,["basepos"]);

#############################################################################
##
#M  IsGroupOfAutomorphisms(<G>)
##
InstallMethod( IsGroupOfAutomorphisms, "test generators and one",true,
  [IsGroup and HasGeneratorsOfGroup],0,
function(G)
local s;
  if IsGeneralMapping(One(G)) then
    s:=Source(One(G));
    if Range(One(G))=s and ForAll(GeneratorsOfGroup(G),
      g->IsGroupGeneralMapping(g) and IsSPGeneralMapping(g) and IsMapping(g)
         and IsInjective(g) and IsSurjective(g) and Source(g)=s
	 and Range(g)=s) then
      SetAutomorphismDomain(G,s);
      # imply finiteness
      if IsFinite(s) then
        SetIsFinite(G,true);
      fi;
      return true;
    fi;
  fi;
  return false;
end);

#############################################################################
##
#F  AssignNiceMonomorphismAutomorphismGroup(<autgrp>,<g>)
##
# try to find a small faithful action for an automorphism group
InstallGlobalFunction(AssignNiceMonomorphismAutomorphismGroup,function(au,g)
local c,	# classes
      aug,	# gens(aug)
      sel,osel, # class indices lists
      u,	# closure of classes
      i,j,p,	# index
      r,ri,	# rep and image
      cen,	# centralizer
      gens,	# generators list
      ran,	# image group,
      img,	# image of autom.
      hom;	# niceo.

  hom:=fail;

  # short cut 1: If the group has a trivial centre and no outer automorphisms,
  # take the group itself
  if Size(Centre(g))=1 
     and ForAll(GeneratorsOfGroup(au),IsConjugatorAutomorphism) then
    ran:= Group( List( GeneratorsOfGroup( au ),
                       ConjugatorOfConjugatorIsomorphism ),
                 One( g ) );
    Info(InfoMorph,1,"All automorphisms are conjugator");
    Size(ran); #enforce size calculation

    # if `ran' has a centralizing bit, we're still out of luck.
    # TODO: try whether there is a centralizer complement into which we
    # could go.

    if Size(Centralizer(ran,g))=1 then
      r:=ran; # the group of conjugating elements so far
      cen:=TrivialSubgroup(r);

      hom:=GroupHomomorphismByFunction(au,ran,
	function(auto)
	  if not IsConjugatorAutomorphism(auto) then
	    return fail;
	  fi;
	  img:= ConjugatorOfConjugatorIsomorphism( auto );
	  if not img in ran then
	    # There is still something centralizing left.
	    if not img in r then 
	      # get the cenralizing bit
	      r:=ClosureGroup(r,img);
	      cen:=Centralizer(r,g);
	    fi;
	    # get the right coset element
	    img:=First(List(Enumerator(cen),i->i*img),i->i in ran);
	  fi;
	  return img;
	end,
	function(elm)
	  return ConjugatorAutomorphismNC( g, elm );
	end);
      SetIsGroupHomomorphism(hom,true);
      SetRange( hom,ran );
      SetIsBijective(hom,true);
    fi;
  elif not IsFinite(g) then
    Error("can't do!");
  elif IsAbelian(g) then

    SetIsFinite(au,true);
    gens:=SmallGeneratingSet(g);
    c:=[];
    for i in gens do
      c:=Union(c,Orbit(au,i));
    od;
    hom:=NiceMonomorphismAutomGroup(au,c,gens);
    
  fi;

  if hom=fail then
    # general case: compute small domain
    u:=Centre(g); # a subgroup generated by the classes so far: If
    # this is the whole group the automorphisms must act faithful on the
    # closure. First try without central elements
    
    SetIsFinite(au,true);
    aug:=GeneratorsOfGroup(au);
    c:=ShallowCopy(ConjugacyClasses(g));
    Sort(c,function(a,b) return Size(a)<Size(b);end);

    # for `small' classes compute the elements list
    for i in c do
      if Size(i)<30 then AsSSortedList(i);fi;
    od;

    # try to find a smallish set with trivial kernels under inner actions

    sel:=[];
    i:=0;
    while Size(u)<Size(g) and i<Length(c) do
      i:=i+1;
      r:=Representative(c[i]);
      cen:=Centralizer(c[i]);
      if not r in u then 
	# otherwise we won't get anything new
	Add(sel,i); # we want this class
	# the subgroup we get when adding the whole class
	u:=NormalClosure(g,ClosureGroup(u,r)); 
      fi;
    od;
    # take the centre away again
    u:=NormalClosure(g,Subgroup(g,List(c{sel},Representative)));

    # TODO: now try whether we can do the same without some of them

    # do we need any central elements?
    i:=1;
    while Size(u)<Size(g) do
      if not Representative(c[i]) in u then
	Info(InfoMorph,3,"added central element");
	Add(sel,i);
	u:=ClosureGroup(u,Representative(c[i])); 
      fi;
      i:=i+1;
    od;

    Info(InfoMorph,2,"sz:",List(c{sel},Size));

    # now fuse under automorphism action, orbit algorithm on classes
    for i in sel do
      r:=Representative(c[i]);
      # candidates to fuse
      osel:=Filtered(Difference([1..Length(c)],sel),
	j->Size(c[j])=Size(c[i]) and Order(Representative(c[j]))=Order(r));
      if Length(osel)>0 then
	# map under all generators of au
	j:=1;
	while j<=Length(aug) do
	  ri:=Image(aug[j],r);
	  # is its image in one of the osel classes?
	  p:=1;
	  while p<=Length(osel) do
	    if ri in c[osel[p]] then
	      # it is, must add this class
	      Add(sel,osel[p]);
	      # break the loop (we grew anyhow)
	      p:=Length(osel);
	    fi;
	    p:=p+1;
	  od;
	  j:=j+1;
	od;
      fi;
    od;

    # now sel is a list of the class indices. Find a small generating set from
    # among them.

    gens:=[];
    u:=TrivialSubgroup(g);
    i:=0;
    # take generators in turn from each class until satisfied. (We don't
    # bother too much about their absolute number)
    while Size(u)<Size(g) do
      i:=i+1;
      if i>Length(sel) then
	i:=1;
      fi;
      Info(InfoMorph,4,"random ",i);
      r:=Random(c[sel[i]]);
      if not r in u then
	Add(gens,r);
	u:=ClosureGroup(u,r);
      fi;
    od;

    Info(InfoMorph,1,"Found generating set ",Length(gens),", classes: ",
	  List(c{sel},Size));
    hom:=NiceMonomorphismAutomGroup(au,Union(List(c{sel},AsList)),gens);
  fi;

  SetFilterObj(hom,IsNiceMonomorphism);
  SetNiceMonomorphism(au,hom);
  SetIsHandledByNiceMonomorphism(au,true);
end);

#############################################################################
##
#F  NiceMonomorphismAutomGroup
##
InstallGlobalFunction(NiceMonomorphismAutomGroup,
function(aut,elms,elmsgens)
local xset,fam,hom;
  One(aut); # to avoid infinite recursion once the niceo is set

  elmsgens:=Filtered(elmsgens,i->i in elms); # safety feature
  xset:=ExternalSet(aut,elms);
  SetBaseOfGroup(xset,elmsgens);
  fam := GeneralMappingsFamily( ElementsFamily( FamilyObj( aut ) ),
				PermutationsFamily );
  hom := rec(  );
  hom:=Objectify(NewType(fam,
		IsActionHomomorphismAutomGroup and IsSurjective ),hom);
  SetUnderlyingExternalSet( hom, xset );
  hom!.basepos:=List(elmsgens,i->Position(elms,i));
  SetRange( hom, Image( hom ) );
  SetIsInjective(hom,true);
  Setter(SurjectiveActionHomomorphismAttr)(xset,hom);
  Setter(IsomorphismPermGroup)(aut,ActionHomomorphism(xset,"surjective"));
  hom:=ActionHomomorphism(xset,"surjective");
  SetFilterObj(hom,IsNiceMonomorphism);
  return hom;

end);

#############################################################################
##
#M  PreImagesRepresentative   for OpHomAutomGrp
##
InstallMethod(PreImagesRepresentative,"AutomGroup Niceomorphism",
  FamRangeEqFamElm,[IsActionHomomorphismAutomGroup,IsPerm],0,
function(hom,elm)
local xset,g,imgs;
  xset:= UnderlyingExternalSet( hom );
  g:=Source(One(ActingDomain(xset)));
  imgs:=OnTuples(hom!.basepos,elm);
  imgs:=Enumerator(xset){imgs};
  elm:=GroupHomomorphismByImagesNC(g,g,BaseOfGroup(xset),imgs);
  SetIsBijective(elm,true);
  return elm;
end);


#############################################################################
##
#F  MorFroWords(<gens>) . . . . . . create some pseudo-random words in <gens>
##                                                featuring the MeatAxe's FRO
InstallGlobalFunction(MorFroWords,function(gens)
local list,a,b,ab,i;
  list:=[];
  ab:=gens[1];
  for i in [2..Length(gens)] do
    a:=ab;
    b:=gens[i];
    ab:=a*b;
    list:=Concatenation(list,
	 [ab,ab^2*b,ab^3*b,ab^4*b,ab^2*b*ab^3*b,ab^5*b,ab^2*b*ab^3*b*ab*b,
	 ab*(ab*b)^2*ab^3*b]);
  od;
  return list;
end);


#############################################################################
##
#F  MorRatClasses(<G>) . . . . . . . . . . . local rationalization of classes
##
InstallGlobalFunction(MorRatClasses,function(GR)
local r,c,u,j,i;
  Info(InfoMorph,2,"RationalizeClasses");
  r:=[];
  for c in RationalClasses(GR) do
    u:=Subgroup(GR,[Representative(c)]);
    j:=DecomposedRationalClass(c);
    Add(r,rec(representative:=u,
		class:=j[1],
		classes:=j,
		size:=Size(c)));
  od;

  for i in r do
    i.size:=Sum(i.classes,Size);
  od;
  return r;
end);

#############################################################################
##
#F  MorMaxFusClasses(<l>) . .  maximal possible morphism fusion of classlists
##
InstallGlobalFunction(MorMaxFusClasses,function(r)
local i,j,flag,cl;
  # cl is the maximal fusion among the rational classes.
  cl:=[]; 
  for i in r do
    j:=0;
    flag:=true;
    while flag and j<Length(cl) do
      j:=j+1;
      flag:=not(Size(i.class)=Size(cl[j][1].class) and
		  i.size=cl[j][1].size and
		  Size(i.representative)=Size(cl[j][1].representative));
    od;
    if flag then
      Add(cl,[i]);
    else
      Add(cl[j],i);
    fi;
  od;

  # sort classes by size
  Sort(cl,function(a,b) return
    Sum(a,i->i.size)
      <Sum(b,i->i.size);end);
  return cl;
end);

#############################################################################
##
#F  MorClassLoop(<range>,<classes>,<params>,<action>)  loop over classes list
##     to find generating sets or Iso/Automorphisms up to inner automorphisms
##  
##  classes is a list of records like the ones returned from
##  MorMaxFusClasses.
##
##  params is a record containing optional components:
##  gens  generators that are to be mapped
##  from  preimage group (that contains gens)
##  to    image group (as it might be smaller than 'range')
##  free  free generators
##  rels  some relations that hold in from, given as list [word,order]
##  dom   a set of elements on which automorphisms act faithful
##  aut   Subgroup of already known automorphisms
##
##  action is a number whose bit-representation indicates the action to be
##  taken:
##  1     homomorphism
##  2     injective
##  4     surjective
##  8     find all (in contrast to one)
##
InstallGlobalFunction(MorClassLoop,function(range,clali,params,action)
local id,result,rig,dom,tall,tsur,tinj,thom,gens,free,rels,len,ind,cla,m,
      mp,cen,i,j,imgs,ok,size,l,hom,cenis,reps,repspows,sortrels,genums,wert,p,
      e,offset,pows,TestRels,pop;

  len:=Length(clali);
  if ForAny(clali,i->Length(i)=0) then
    return []; # trivial case: no images for generator
  fi;

  id:=One(range);
  if IsBound(params.aut) then
    result:=params.aut;
    rig:=true;
    if IsBound(params.dom) then
      dom:=params.dom;
    else
      dom:=false;
    fi;
  else
    result:=[];
    rig:=false;
  fi;

  tall:=action>7; # try all
  if tall then
    action:=action-8;
  fi;
  tsur:=action>3; # test surjective
  if tsur then
    size:=Size(params.to);
    action:=action-4;
  fi;
  tinj:=action>1; # test injective
  if tinj then
    action:=action-2;
  fi;
  thom:=action>0; # test homomorphism

  if IsBound(params.gens) then
    gens:=params.gens;
  fi;

  if IsBound(params.rels) then
    free:=params.free;
    rels:=params.rels;
    if Length(rels)=0 then
      rels:=false;
    fi;
  elif thom then
    free:=GeneratorsOfGroup(FreeGroup(Length(gens)));
    rels:=List(MorFroWords(free),i->[i,Order(MappedWord(i,free,gens))]);
  else
    rels:=false;
  fi;

  if rels<>false then
    # sort the relators according to the generators they contain
    genums:=List(free,i->GeneratorSyllable(i,1));
    genums:=List([1..Length(genums)],i->Position(genums,i));
    sortrels:=List([1..len],i->[]);
    pows:=List([1..len],i->[]);
    for i in rels do
      l:=len;
      wert:=0;
      m:=[];
      for j in [1..NrSyllables(i[1])] do
        p:=genums[GeneratorSyllable(i[1],j)];
        e:=ExponentSyllable(i[1],j);
	Append(m,[p,e]); # modified extrep
        AddSet(pows[p],e);
	if p<len then
	  wert:=wert+2; # conjugation: 2 extra images
	  l:=Minimum(l,p);
	fi;
	wert:=wert+AbsInt(e);
      od;
      Add(sortrels[l],[m,i[2],i[2]*wert,[1,3..Length(m)-1],i[1]]);
    od;
    # now sort by the length of the relators
    for i in [1..len] do
      Sort(sortrels[i],function(x,y) return x[3]<y[3];end);
    od;
    offset:=1-Minimum(List(pows,i->i[1])); # smallest occuring index

    # test the relators at level tlev and set imgs
    TestRels:=function(tlev)
    local rel,k,j,p,start,gn,ex;

      if Length(sortrels[tlev])=0 then
        return true;
      fi;

      if IsPermGroup(range) then
        # test by tracing points
        for rel in sortrels[tlev] do
	  start:=1;
	  p:=start;
	  k:=0;
	  repeat
	    for j in rel[4] do
	      gn:=rel[1][j];
	      ex:=rel[1][j+1];
	      if gn=len then
	        p:=p^repspows[gn][ex+offset];
	      else
		p:=p/m[gn][mp[gn]];
	        p:=p^repspows[gn][ex+offset];
		p:=p^m[gn][mp[gn]];
	      fi;
	    od;
	    k:=k+1;
	  # until we have the power or we detected a smaller potential order.
	  until k>=rel[2] or (p=start and IsInt(rel[2]/k));
	  if p<>start then
	    return false;
	  fi;
	od;
      fi;

      imgs:=List([tlev..len-1],i->reps[i]^(m[i][mp[i]]));
      imgs[Length(imgs)+1]:=reps[len];
      if tinj then
	return ForAll(sortrels[tlev],i->i[2]=Order(MappedWord(i[5],
	                              free{[tlev..len]}, imgs)));
      else
	return ForAll(sortrels[tlev],
	              i->IsInt(i[2]/Order(MappedWord(i[5],
		                          free{[tlev..len]}, imgs))));
      fi;
      
    end;
  else
    TestRels:=x->true; # to satisfy the code below.
  fi;

  # backtrack over all classes in clali
  l:=ListWithIdenticalEntries(len,1);
  ind:=len;
  while ind>0 do
    ind:=len;
    Info(InfoMorph,3,"step ",l);
    # test class combination indicated by l:
    cla:=List([1..len],i->clali[i][l[i]]); 
    reps:=List(cla,Representative);

    if rels<>false and IsPermGroup(range) then
      # and precompute the powers
      repspows:=List([1..len],i->[]);
      for i in [1..len] do
	for j in pows[i] do
	  repspows[i][j+offset]:=reps[i]^j;
	od;
      od;
    fi;

    cenis:=List(cla,i->Intersection(range,Centralizer(i)));

    # test, whether a gen.sys. can be taken from the classes in <cla>
    # candidates.  This is another backtrack
    m:=[];
    m[len]:=[id];
    # positions
    mp:=[];
    mp[len]:=1;
    mp[len+1]:=-1;
    # centralizers
    cen:=[];
    cen[len]:=cenis[len];
    cen[len+1]:=range; # just for the recursion
    i:=len-1;

    # set up the lists
    while i>0 do
      m[i]:=List(DoubleCosetRepsAndSizes(range,cenis[i],cen[i+1]),j->j[1]);
      mp[i]:=1;

      pop:=true;
      while pop and i<=len do
	pop:=false;
	while mp[i]<=Length(m[i]) and TestRels(i)=false do
	  mp[i]:=mp[i]+1; #increment because of relations
	  Info(InfoMorph,4,"early break ",i);
	od;
	if i<=len and mp[i]>Length(m[i]) then
	  Info(InfoMorph,3,"early pop");
	  pop:=true;
	  i:=i+1;
	  if i<=len then
	    mp[i]:=mp[i]+1; #increment because of pop
	  fi;
	fi;
      od;

      if pop then
        i:=-99; # to drop out of outer loop
      elif i>1 then
	cen[i]:=Centralizer(cen[i+1],reps[i]^(m[i][mp[i]]));
      fi;
      i:=i-1;
    od;

    if pop then
      Info(InfoMorph,3,"allpop");
      i:=len+2; # to avoid the following `while' loop
    else
      i:=1; 
      Info(InfoMorph,3,"loop");
    fi;

    while i<len do
      if rels=false or TestRels(1) then
	if rels=false then
	  # otherwise the images are set by `TestRels' as a side effect.
	  imgs:=List([1..len-1],i->reps[i]^(m[i][mp[i]]));
	  imgs[len]:=reps[len];
	fi;
	Info(InfoMorph,4,"orders: ",List(imgs,Order));

	# computing the size can be nasty. Thus try given relations first.
	ok:=true;

	if rels<>false then
	  if tinj then
	    ok:=ForAll(rels,i->i[2]=Order(MappedWord(i[1],free,imgs)));
	  else
	    ok:=ForAll(rels,i->IsInt(i[2]/Order(MappedWord(i[1],free,imgs))));
	  fi;
	fi;

	# check surjectivity
	if tsur and ok then
	  ok:= Size( SubgroupNC( range, imgs ) ) = size;
	fi;

	if ok and thom then
	  imgs:=GroupGeneralMappingByImages(params.from,range,gens,imgs);
	  SetIsTotal(imgs,true);
	  Info(InfoMorph,3,"testing");
	  ok:=IsSingleValued(imgs);
	  if ok and tinj then
	    ok:=IsInjective(imgs);
	  fi;
	fi;
	
	if ok then
	  Info(InfoMorph,2,"found");
	  # do we want one or all?
	  if tall then
	    if rig then
	      if not imgs in result then
		result:= GroupByGenerators( Concatenation(
			    GeneratorsOfGroup( result ), [ imgs ] ),
			    One( result ) );
		# note its niceo
		hom:=NiceMonomorphismAutomGroup(result,dom,gens);
		SetNiceMonomorphism(result,hom);
		SetIsHandledByNiceMonomorphism(result,true);

		Size(result);
		Info(InfoMorph,2,"new ",Size(result));
	      fi;
	    else
	      Add(result,imgs);
	    fi;
	  else
	    return imgs;
	  fi;
	fi;
      fi;

      mp[i]:=mp[i]+1;
      while i<=len and mp[i]>Length(m[i]) do
	mp[i]:=1;
	i:=i+1;
	if i<=len then
	  mp[i]:=mp[i]+1;
	fi;
      od;

      while i>1 and i<=len do
	while i<=len and TestRels(i)=false do
	  Info(InfoMorph,4,"intermediate break ",i);
	  mp[i]:=mp[i]+1;
	  while i<=len and mp[i]>Length(m[i]) do
	    Info(InfoMorph,3,"intermediate pop ",i);
	    i:=i+1;
	    if i<=len then
	      mp[i]:=mp[i]+1;
	    fi;
	  od;
	od;

	if i<=len then # i>len means we completely popped. This will then
	               # also pop us out of both `while' loops.
	  cen[i]:=Centralizer(cen[i+1],reps[i]^(m[i][mp[i]]));
	  i:=i-1;
	  m[i]:=List(DoubleCosetRepsAndSizes(range,cenis[i],cen[i+1]),
		      j->j[1]);
	  mp[i]:=1;

	else
	  Info(InfoMorph,3,"allpop2");
	fi;
      od;

    od;

    # 'free for increment'
    l[ind]:=l[ind]+1;
    while ind>0 and l[ind]>Length(clali[ind]) do
      l[ind]:=1;
      ind:=ind-1;
      if ind>0 then
	l[ind]:=l[ind]+1;
      fi;
    od;
  od;

  return result;
end);


#############################################################################
##
#F  MorFindGeneratingSystem(<G>,<cl>) . .  find generating system with an few 
##                      as possible generators from the first classes in <cl>
##
InstallGlobalFunction(MorFindGeneratingSystem,function(G,cl)
local lcl,len,comb,combc,com,a;
  Info(InfoMorph,1,"FindGenerators");
  # throw out the 1-Class
  cl:=Filtered(cl,i->Length(i)>1 or Size(i[1].representative)>1);

  #create just a list of ordinary classes.
  lcl:=List(cl,i->Concatenation(List(i,j->j.classes)));
  len:=1;
  len:=Maximum(1,Length(MinimalGeneratingSet(
		    Image(IsomorphismPcGroup((G/DerivedSubgroup(G))))))-1);
  while true do
    len:=len+1;
    Info(InfoMorph,2,"Trying length ",len);
    # now search for <len>-generating systems
    comb:=UnorderedTuples([1..Length(lcl)],len); 
    combc:=List(comb,i->List(i,j->lcl[j]));

    # test all <comb>inations
    com:=0;
    while com<Length(comb) do
      com:=com+1;
      a:=MorClassLoop(G,combc[com],rec(to:=G),4);
      if Length(a)>0 then
        return a;
      fi;
    od;
  od;
end);

#############################################################################
##
#F  Morphium(<G>,<H>,<DoAuto>) . . . . . . . .Find isomorphisms between G and H
##       modulo inner automorphisms. DoAuto indicates whetehra all
## 	 automorphism are to be found
##       This function thus does the main combinatoric work for creating 
##       Iso- and Automorphisms.
##       It needs, that both groups are not cyclic.
##
InstallGlobalFunction(Morphium,function(G,H,DoAuto)
local 
      len,combi,Gr,Gcl,Ggc,Hr,Hcl,
      gens,i,c,hom,free,elms,price,result,rels,inns;

  gens:=SmallGeneratingSet(G);
  len:=Length(gens);
  Gr:=MorRatClasses(G);
  Gcl:=MorMaxFusClasses(Gr);

  Ggc:=List(gens,i->First(Gcl,j->ForAny(j,j->ForAny(j.classes,k->i in k))));
  combi:=List(Ggc,i->Concatenation(List(i,i->i.classes)));
  price:=Product(combi,i->Sum(i,Size));
  Info(InfoMorph,1,"generating system ",Sum(Flat(combi),Size),
       " of price:",price,"");

  if (not HasMinimalGeneratingSet(G) and price/Size(G)>10000)
     or Sum(Flat(combi),Size)>Size(G)/10 then
    if IsSolvableGroup(G) then
      gens:=IsomorphismPcGroup(G);
      gens:=List(MinimalGeneratingSet(Image(gens)),
                 i->PreImagesRepresentative(gens,i));
    else
      gens:=MorFindGeneratingSystem(G,Gcl);
    fi;

    Ggc:=List(gens,i->First(Gcl,j->ForAny(j,j->ForAny(j.classes,k->i in k))));
    combi:=List(Ggc,i->Concatenation(List(i,i->i.classes)));
    price:=Product(combi,i->Sum(i,Size));
    Info(InfoMorph,1,"generating system of price:",price,"");
  fi;

  if not DoAuto then
    Hr:=MorRatClasses(H);
    Hcl:=MorMaxFusClasses(Hr);
  fi;

  # now test, whether it is worth, to compute a finer congruence
  # then ALSO COMPUTE NEW GEN SYST!
  # [...]

  if not DoAuto then
    combi:=[];
    for i in Ggc do
      c:=Filtered(Hcl,
	   j->Set(List(j,k->k.size))=Set(List(i,k->k.size))
		and Length(j[1].classes)=Length(i[1].classes) 
		and Size(j[1].class)=Size(i[1].class)
		and Size(j[1].representative)=Size(i[1].representative)
      # This test assumes maximal fusion among the rat.classes. If better
      # congruences are used, they MUST be checked here also!
	);
      if Length(c)<>1 then
	# Both groups cannot be isomorphic, since they lead to different 
	# congruences!
	Info(InfoMorph,2,"different congruences");
	return fail;
      else
	Add(combi,c[1]);
      fi;
    od;
    combi:=List(combi,i->Concatenation(List(i,i->i.classes)));
  fi;

  # combi contains the classes, from which the
  # generators are taken.

  free:=GeneratorsOfGroup(FreeGroup(Length(gens)));
  rels:=MorFroWords(free);
  rels:=List(rels,i->[i,Order(MappedWord(i,free,gens))]);
  result:=rec(gens:=gens,from:=G,to:=H,free:=free,rels:=rels);

  if DoAuto then

    inns:=List(GeneratorsOfGroup(G),i->InnerAutomorphism(G,i));
    if Sum(Flat(combi),Size)<=MORPHEUSELMS then
      elms:=[];
      for i in Flat(combi) do
        if not ForAny(elms,j->Representative(i)=Representative(j)) then
	  # avoid duplicate classes
	  Add(elms,i);
	fi;
      od;
      elms:=Union(List(elms,AsList));
      Info(InfoMorph,1,"permrep on elements: ",Length(elms));

      Assert(2,ForAll(GeneratorsOfGroup(G),i->ForAll(elms,j->j^i in elms)));
      result.dom:=elms;
      inns:= GroupByGenerators( inns, IdentityMapping( G ) );

      hom:=NiceMonomorphismAutomGroup(inns,elms,gens);
      SetNiceMonomorphism(inns,hom);
      SetIsHandledByNiceMonomorphism(inns,true);

      result.aut:=inns;
    else
      elms:=false;
    fi;

    result:=rec(aut:=MorClassLoop(H,combi,result,15));

    if elms<>false then
      result.elms:=elms;
      result.elmsgens:=Filtered(gens,i->i<>One(G));
      inns:=SubgroupNC(result.aut,GeneratorsOfGroup(inns));
    fi;
    result.inner:=inns;
  else
    result:=MorClassLoop(H,combi,result,7);
  fi;

  return result;

end);

#############################################################################
##
#F  AutomorphismGroupAbelianGroup(<G>)
##
InstallGlobalFunction(AutomorphismGroupAbelianGroup,function(G)
local i,j,k,l,m,o,nl,nj,max,r,e,au,p,gens,offs;

  # trivial case
  if Size(G)=1 then
    au:= GroupByGenerators( [], IdentityMapping( G ) );
    i:=NiceMonomorphismAutomGroup(au,[One(G)],[One(G)]);
    SetNiceMonomorphism(au,i);
    SetIsHandledByNiceMonomorphism(au,true);
    SetIsAutomorphismGroup( au, true );
    SetIsFinite(au,true);
    return au;
  fi;

  # get standard generating system
  if not IsPermGroup(G) then
    p:=IsomorphismPermGroup(G);
    gens:=IndependentGeneratorsOfAbelianGroup(Image(p));
    gens:=List(gens,i->PreImagesRepresentative(p,i));
  else
    gens:=IndependentGeneratorsOfAbelianGroup(G);
  fi;

  au:=[];
  # run by primes
  p:=Set(Factors(Size(G)));
  for i in p do
    l:=Filtered(gens,j->IsInt(Order(j)/i));
    nl:=Filtered(gens,i->not i in l);

    #sort by exponents
    o:=List(l,j->LogInt(Order(j),i));
    e:=[];
    for j in Set(o) do
      Add(e,[j,l{Filtered([1..Length(o)],k->o[k]=j)}]);
    od;

    # construct automorphisms by components
    for j in e do
      nj:=Concatenation(List(Filtered(e,i->i[1]<>j[1]),i->i[2]));
      r:=Length(j[2]);

      # the permutations and addition
      if r>1 then
	Add(au,GroupHomomorphismByImagesNC(G,G,Concatenation(nl,nj,j[2]),
	    #(1,2)
	    Concatenation(nl,nj,j[2]{[2]},j[2]{[1]},j[2]{[3..Length(j[2])]})));
	Add(au,GroupHomomorphismByImagesNC(G,G,Concatenation(nl,nj,j[2]),
	    #(1,..,n)
	    Concatenation(nl,nj,j[2]{[2..Length(j[2])]},j[2]{[1]})));
	#for k in [0..j[1]-1] do
        k:=0;
	  Add(au,GroupHomomorphismByImagesNC(G,G,Concatenation(nl,nj,j[2]),
	      #1->1+i^k*2
	      Concatenation(nl,nj,[j[2][1]*j[2][2]^(i^k)],
	                          j[2]{[2..Length(j[2])]})));
        #od;
      fi;
  
      # multiplications

      for k in List( Flat( GeneratorsPrimeResidues(i^j[1])!.generators ),
              Int )  do

	Add(au,GroupHomomorphismByImagesNC(G,G,Concatenation(nl,nj,j[2]),
	    #1->1^k
	    Concatenation(nl,nj,[j[2][1]^k],j[2]{[2..Length(j[2])]})));
      od;

    od;
    
    # the mixing ones
    for j in [1..Length(e)] do
      for k in [1..Length(e)] do
	if k<>j then
	  nj:=Concatenation(List(e{Difference([1..Length(e)],[j,k])},i->i[2]));
	  offs:=Maximum(0,e[k][1]-e[j][1]);
	  if Length(e[j][2])=1 and Length(e[k][2])=1 then
	    max:=Minimum(e[j][1],e[k][1])-1;
	  else
	    max:=0;
	  fi;
	  for m in [0..max] do
	    Add(au,GroupHomomorphismByImagesNC(G,G,
	       Concatenation(nl,nj,e[j][2],e[k][2]),
	       Concatenation(nl,nj,[e[j][2][1]*e[k][2][1]^(i^(offs+m))],
				    e[j][2]{[2..Length(e[j][2])]},e[k][2])));
	  od;
	fi;
      od;
    od;
  od;

  for i in au do
    SetIsBijective(i,true);
    if i!.generators<>i!.genimages then
      SetIsInnerAutomorphism(i,false);
    fi;
    SetFilterObj(i,IsMultiplicativeElementWithInverse);
  od;

  au:= GroupByGenerators( au, IdentityMapping( G ) );
  SetIsAutomorphismGroup( au, true );

  SetInnerAutomorphismsAutomorphismGroup(au,TrivialSubgroup(au));

  if IsFinite(G) then
    SetIsFinite(au,true);
  fi;

  return au;
end);

#############################################################################
##
#F  IsomorphismAbelianGroups(<G>)
##
InstallGlobalFunction(IsomorphismAbelianGroups,function(G,H)
local o,p,gens,hens;

  # get standard generating system
  if not IsPermGroup(G) then
    p:=IsomorphismPermGroup(G);
    gens:=IndependentGeneratorsOfAbelianGroup(Image(p));
    gens:=List(gens,i->PreImagesRepresentative(p,i));
  else
    gens:=IndependentGeneratorsOfAbelianGroup(G);
  fi;
  gens:=ShallowCopy(gens);

  # get standard generating system
  if not IsPermGroup(H) then
    p:=IsomorphismPermGroup(H);
    hens:=IndependentGeneratorsOfAbelianGroup(Image(p));
    hens:=List(hens,i->PreImagesRepresentative(p,i));
  else
    hens:=IndependentGeneratorsOfAbelianGroup(H);
  fi;
  hens:=ShallowCopy(hens);

  o:=List(gens,i->Order(i));
  p:=List(hens,i->Order(i));

  SortParallel(o,gens);
  SortParallel(p,hens);

  if o<>p then
    return fail;
  fi;

  o:=GroupHomomorphismByImagesNC(G,H,gens,hens);
  SetIsBijective(o,true);

  return o;
end);

#############################################################################
##
#M  AutomorphismGroup(<G>) . . group of automorphisms, given as Homomorphisms
##
InstallMethod(AutomorphismGroup,"for groups",true,[IsGroup and IsFinite],0,
function(G)
local a,b,c,p;
  if IsAbelian(G) then
    a:=AutomorphismGroupAbelianGroup(G);
    if HasIsFinite(G) and IsFinite(G) then
      SetIsFinite(a,true);
    fi;
    return a;
  fi;
  a:=Morphium(G,G,true);
  if IsList(a.aut) then
    a.aut:= GroupByGenerators( Concatenation( a.aut, a.inner ),
                               IdentityMapping( G ) );
    a.inner:=SubgroupNC(a.aut,a.inner);
  else
    # test whether we really want to keep the stored nice monomorphism
    b:=Range(NiceMonomorphism(a.aut));
    p:=LargestMovedPoint(b); # degree of the nice rep.

    # first class sizes for non central generators. Their sum is what we
    # admit as domain size
    c:=Filtered(List(ConjugacyClasses(G),Size),i->i>1);
    Sort(c);
    c:=c{[1..Minimum(Length(c),Length(GeneratorsOfGroup(G)))]};

    if p>100 and ((not IsPermGroup(G)) or (p>4*LargestMovedPoint(G) 
      and (p>1000 or p>Sum(c) 
           or ForAll(GeneratorsOfGroup(a.aut),IsConjugatorAutomorphism)
	   or Size(a.aut)/Size(G)<p/10*LargestMovedPoint(G)))) then
      # the degree looks rather big. Can we do better?
      Info(InfoMorph,2,"test automorphism domain ",p);
      c:=GroupByGenerators(GeneratorsOfGroup(a.aut),One(a.aut));
      AssignNiceMonomorphismAutomorphismGroup(c,G); 
      if LargestMovedPoint(Range(NiceMonomorphism(c)))<p then
        Info(InfoMorph,1,"improved domain ",
	     LargestMovedPoint(Range(NiceMonomorphism(c))));
	a.aut:=c;
	a.inner:=SubgroupNC(a.aut,GeneratorsOfGroup(a.inner));
      fi;
    fi;
  fi;
  SetInnerAutomorphismsAutomorphismGroup(a.aut,a.inner);
  SetIsAutomorphismGroup( a.aut, true );
  if HasIsFinite(G) and IsFinite(G) then
    SetIsFinite(a.aut,true);
  fi;
  return a.aut;
end);

RedispatchOnCondition(AutomorphismGroup,true,[IsGroup],
    [IsGroup and IsFinite],0);

#############################################################################
##
#M AutomorphismGroup( G )
##
InstallMethod( AutomorphismGroup, 
               "finite abelian groups",
               true,
               [IsGroup and IsFinite and IsAbelian],
               0,
AutomorphismGroupAbelianGroup);


#############################################################################
##
#M NiceMonomorphism 
##
InstallMethod(NiceMonomorphism,"for automorphism groups",true,
              [IsGroupOfAutomorphisms and IsFinite],0,
function( A )
local G;

    G  := Source( Identity(A) );

    # this stores the niceo
    AssignNiceMonomorphismAutomorphismGroup(A,G); 

    # as `AssignNice...' will have stored an attribute value this cannot cause
    # an infinite recursion:
    return NiceMonomorphism(A);
end);

#############################################################################
##
#M  IsomorphismPermGroup 
##
InstallMethod(IsomorphismPermGroup,"for automorphism groups",true,
               [IsGroupOfAutomorphisms and IsFinite],0,
function(A)
local nice;
  nice:=NiceMonomorphism(A);
  if IsPermGroup(Range(nice)) then
    return nice;
  else
    return CompositionMapping(IsomorphismPermGroup(Image(nice)),nice);
  fi;
end);


#############################################################################
##
#M  InnerAutomorphismsAutomorphismGroup( <A> ) 
##
InstallMethod( InnerAutomorphismsAutomorphismGroup,
    "for automorphism groups",
    true,
    [ IsAutomorphismGroup and IsFinite ], 0,
    function( A )
    local G, gens;
    G:= Source( Identity( A ) );
    gens:= GeneratorsOfGroup( G );
    # get the non-central generators
    gens:= Filtered( gens, i -> not ForAll( gens, j -> i*j = j*i ) );
    return SubgroupNC( A, List( gens, i -> InnerAutomorphism( G, i ) ) );
    end );


#############################################################################
##
#F  IsomorphismGroups(<G>,<H>) . . . . . . . . . .  isomorphism from G onto H
##
InstallGlobalFunction(IsomorphismGroups,function(G,H)
local m;

  #AH: Spezielle Methoden ?
  if Size(G)=1 then
    if Size(H)<>1 then
      return fail;
    else
      return GroupHomomorphismByImagesNC(G,H,[],[]);
    fi;
  fi;
  if IsAbelian(G) then
    if not IsAbelian(H) then
      return fail;
    else
      return IsomorphismAbelianGroups(G,H);
    fi;
  fi;

  if Size(G)<>Size(H) then
    return fail;
  elif ID_AVAILABLE(Size(G)) <> fail then
    if IdGroup(G)<>IdGroup(H) then
      return fail;
    elif IsSolvableGroup(G) and Size(G) <= 2000 then
      return IsomorphismSolvableSmallGroups(G,H);
    fi;
  elif Length(ConjugacyClasses(G))<>Length(ConjugacyClasses(H)) then
    return fail;
  fi;

  m:=Morphium(G,H,false);
  if IsList(m) and Length(m)=0 then
    return fail;
  else
    return m;
  fi;

end);


#############################################################################
##
#F  GQuotients(<F>,<G>)  . . . . . epimorphisms from F onto G up to conjugacy
##
InstallMethod(GQuotients,"for groups which can compute element orders",true,
  [IsGroup,IsGroup and IsFinite],
  # override `IsFinitelyPresentedGroup' filter.
  1,
function (F,G)
local Fgens,	# generators of F
      cl,	# classes of G
      u,	# trial generating set's group
      pimgs,	# possible images
      val,	# its value
      best,	# best generating set
      bestval,	# its value
      sz,	# |class|
      i,	# loop
      h,	# epis
      len,	# nr. gens tried
      fak,	# multiplication factor
      cnt;	# countdown for finish

  # if we have a pontentially infinite fp group we cannot be clever
  if IsSubgroupFpGroup(F) and
    (not HasSize(F) or Size(F)=infinity) then
    TryNextMethod();
  fi;

  Fgens:=GeneratorsOfGroup(F);
  if IsAbelian(G) and not IsAbelian(F) then
    Info(InfoMorph,1,"abelian quotients vi F/F'");
    # for abelian factors go via the commutator factor group
    fak:=CommutatorFactorGroup(F);
    h:=NaturalHomomorphismByNormalSubgroup(F,DerivedSubgroup(F));
    fak:=Image(h,F);
    u:=GQuotients(fak,G);
    cl:=[];
    for i in u do
      i:=GroupHomomorphismByImagesNC(F,G,Fgens,
	     List(Fgens,j->Image(i,Image(h,j))));
      Add(cl,i);
    od;
    return cl;
  fi;

  if Size(G)=1 then
    return [GroupHomomorphismByImagesNC(F,G,Fgens,
			  List(Fgens,i->One(G)))];
  elif IsCyclic(F) then
    Info(InfoMorph,1,"Cyclic group: only one quotient possible");
    # a cyclic group has at most one quotient
    if not IsCyclic(G) or not IsInt(Size(F)/Size(G)) then
      return [];
    else
      # get the cyclic gens
      u:=First(AsList(F),i->Order(i)=Size(F));
      h:=First(AsList(G),i->Order(i)=Size(G));
      # just map them
      return [GroupHomomorphismByImagesNC(F,G,[u],[h])];
    fi;
  fi;

  if IsAbelian(G) then
    fak:=5;
  else
    fak:=50;
  fi;

  cl:=ConjugacyClasses(G);

  # first try to find a short generating system
  best:=false;
  bestval:=infinity;
  if Size(F)<10000000 and Length(Fgens)>2 then
    len:=Maximum(2,Length(SmallGeneratingSet(
                 Image(NaturalHomomorphismByNormalSubgroup(F,
		   DerivedSubgroup(F))))));
  else
    len:=2;
  fi;
  cnt:=0;
  repeat
    u:=List([1..len],i->Random(F));
    if Index(F,Subgroup(F,u))=1 then

      # find potential images
      pimgs:=[];
      for i in u do
        sz:=Index(F,Centralizer(F,i));
	Add(pimgs,Filtered(cl,j->IsInt(Order(i)/Order(Representative(j)))
			     and IsInt(sz/Size(j))));
      od;

      # sort u in descending order -> large reductions when centralizing
      SortParallel(pimgs,u,function(a,b)
			     return Sum(a,Size)>Sum(b,Size);
                           end);

      val:=Product(pimgs,i->Sum(i,Size));
      if val<bestval then
	Info(InfoMorph,2,"better value: ",List(u,i->Order(i)),
	      "->",val);
	best:=[u,pimgs];
	bestval:=val;
      fi;

    fi;
    cnt:=cnt+1;
    if cnt=len*fak and best=false then
      cnt:=0;
      Info(InfoMorph,1,"trying one generator more");
      len:=len+1;
    fi;
  until best<>false and (cnt>len*fak or bestval<3*cnt);

  h:=MorClassLoop(G,best[2],rec(gens:=best[1],to:=G,from:=F),13);
  cl:=[];
  u:=[];
  for i in h do
    if not KernelOfMultiplicativeGeneralMapping(i) in u then
      Add(u,KernelOfMultiplicativeGeneralMapping(i));
      Add(cl,i);
    fi;
  od;

  Info(InfoMorph,1,Length(h)," found -> ",Length(cl)," homs");
  return cl;
end);

#############################################################################
##
#F  IsomorphicSubgroups(<G>,<H>)
##
InstallMethod(IsomorphicSubgroups,
  "for groups which can compute element orders",true,
  [IsGroup and IsFinite,IsGroup and IsFinite],
  # override `IsFinitelyPresentedGroup' filter.
  1,
function(G,H)
local cl,cnt,bg,bw,bo,bi,k,gens,go,imgs,params,emb,clg;

  if not IsInt(Size(G)/Size(H)) then
    Info(InfoMorph,1,"sizes do not permit embedding");
    return [];
  fi;

  cl:=ConjugacyClasses(G);
  # test whether there is a chance to embed
  cnt:=0;
  while cnt<20 do
    bg:=Order(Random(H));
    if not ForAny(cl,i->Order(Representative(i))=bg) then
      return [];
    fi;
    cnt:=cnt+1;
  od;

  # find a suitable generating system
  bw:=infinity;
  bo:=[0,0];
  cnt:=0;
  repeat
    if cnt=0 then
      # first the small gen syst.
      gens:=SmallGeneratingSet(H);
    else
      # then something random
      repeat
	if Length(gens)>2 and Random([1,2])=1 then
	  # try to get down to 2 gens
	  gens:=List([1,2],i->Random(H));
	else
	  gens:=List(gens,i->Random(H));
	fi;
	# try to get small orders
	for k in [1..Length(gens)] do
	  go:=Order(gens[k]);
	  # try a p-element
	  if Random([1..2*Length(gens)])=1 then
	    gens[k]:=gens[k]^(go/(Random(Factors(go))));
	  fi;
	od;

      until Index(H,SubgroupNC(H,gens))=1;
    fi;

    go:=List(gens,Order);
    imgs:=List(go,i->Filtered(cl,j->Order(Representative(j))=i));
    Info(InfoMorph,3,go,":",Product(imgs,i->Sum(i,Size)));
    if Product(imgs,i->Sum(i,Size))<bw then
      bg:=gens;
      bo:=go;
      bi:=imgs;
      bw:=Product(imgs,i->Sum(i,Size));
    elif Set(go)=Set(bo) then
      # we hit the orders again -> sign that we can't be
      # completely off track
      cnt:=cnt+Int(bw/Size(G)*3);
    fi;
    cnt:=cnt+1;
  until bw/Size(G)*6<cnt;

  if bw=0 then
    return [];
  fi;

  Info(InfoMorph,2,"find ",bw," from ",cnt);
  # find all embeddings
  params:=rec(gens:=bg,from:=H);
  emb:=MorClassLoop(G,bi,params,
    # all injective homs = 1+2+8
    11); 
  Info(InfoMorph,2,Length(emb)," embeddings");
  cl:=[];
  clg:=[];
  for k in emb do
    bg:=Image(k,H);
    if not ForAny(clg,i->RepresentativeAction(G,i,bg)<>fail) then
      Add(cl,k);
      Add(clg,bg);
    fi;
  od;
  Info(InfoMorph,1,Length(emb)," found -> ",Length(cl)," homs");
  return cl;
end);


#############################################################################
##
#E

