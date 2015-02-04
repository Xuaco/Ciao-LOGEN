:- module(homeomorphic,[homeomorphic_embedded_call/2,
                        homeomorphic_embedded/2, %strict_instance_of/2, instance_of/2,
                       homeomorphic_embedded_conjunction/2]).
                    %   ,term_nesting_level/3]).

/* --------------------------------------------- */
/* (C) COPYRIGHT MICHAEL LEUSCHEL 1995,1996,1997 */
/* --------------------------------------------- */


/* file: homemorphic.pro */

/* ===================================================== */

%:- use_module(tools,'tools/tools.pl',[]).
%:- use_module(self_check,'tools/self_check.pl',[assert_must_succeed/1,assert_must_fail/1]).
%:- use_module('ciao_tools.pl').

/* ===================================================== */

dynamic_term(X) :- var(X),!,fail.
dynamic_term(X) :-
	functor(X,F,Arity),
	\+(static_functor(F,Arity)).

% Is now generated by the cogen
%:- dynamic static_functor/2.
%static_functor(_X,_Y).      /* everything considered static for the moment ! */

/* ===================================================== */

/* ----------------------------------- */
/* homeomorphic_embedded_conjunction/2 */
/* ----------------------------------- */

%:- assert_must_fail(homeomorphic:homeomorphic_embedded_conjunction([a,q(X,Y)],[s,q(Y,f(X)),p,f(a),q(a,b)])).
%:- assert_must_succeed(homeomorphic:homeomorphic_embedded_conjunction([q(X,Y)],[q(Y,f(X))])).
%:- assert_must_succeed(homeomorphic:homeomorphic_embedded_conjunction([a,q(X,_Y)],[s,f(a),q(_Y,f(X)),p])).
%:- assert_must_succeed(homeomorphic:homeomorphic_embedded_conjunction([q(1,2),q(X,Y)],[q(1,2),q(2,3),q(f(1),f(2)),f(a),q(Y,f(X)),p])).
%:- assert_must_succeed(homeomorphic:homeomorphic_embedded_conjunction([],[s,f(a),q(_Y,f(_X)),p])).
%:- assert_must_succeed(homeomorphic:homeomorphic_embedded_conjunction([q(X,Y)],[q(X,Y)])).
%:- assert_must_succeed(homeomorphic:homeomorphic_embedded_conjunction([q(a,Y)],[q(b,Y),q(c,Y),q(a,Y)])).
%:- assert_must_succeed(homeomorphic:homeomorphic_embedded_conjunction([q(a,Y)],[q(b,Y),q(a,Y),q(c,Y)])).

homeomorphic_embedded_conjunction([],_).
homeomorphic_embedded_conjunction([PA|PAs],[A|As]) :-
  homeomorphic_embedded(PA,A),
  !, /* added by leuschel: 29/4/05 */
  homeomorphic_embedded_conjunction(PAs,As).
homeomorphic_embedded_conjunction([PA|PAs],[_|As]) :-
  homeomorphic_embedded_conjunction([PA|PAs],As).


homeomorphic_embedded_call(A,B) :-
   nonvar(A),nonvar(B),!,
   functor(A,F,N), functor(B,F,N),
   homeomorphic_embedded(A,B).
homeomorphic_embedded_call(A,B) :- homeomorphic_embedded(A,B).

/* ------------------------------ */
/* not_more_general_conjunction/2 */
/* ------------------------------ */

not_more_general_conjunction([],_).
not_more_general_conjunction([PA|PAs],[A|As]) :-
  atoms_have_same_predicate(PA,A),
  \+(strict_instance_of(PA,A)),
  mixtus_term_size_embedded(PA,A),
  not_more_general_conjunction(PAs,As).
not_more_general_conjunction([PA|PAs],[_|As]) :-
  not_more_general_conjunction([PA|PAs],As).

atoms_have_same_predicate(P,Q) :-
  functor(P,F,N),functor(Q,F,N).
  
mixtus_term_size_embedded(PA,A) :-
  mixtus_term_size(PA,PSize),
  mixtus_term_size(A,ASize),
  PSize =< ASize.

/* ------------------ */
/* mixtus_term_size/2 */
/* ------------------ */

mixtus_term_size(X,1) :- var(X),!.
mixtus_term_size(X,1) :- atomic(X),!.
mixtus_term_size(X,Size) :- 
	X =..[_Pred|Args],
	l_mixtus_term_size(Args,1,Size).

l_mixtus_term_size([],S,S).
l_mixtus_term_size([H|T],InS,OutS) :-
	mixtus_term_size(H,HS),
	IntS is InS + HS,
	l_mixtus_term_size(T,IntS,OutS).



/* ----------------------- */
/* homeomorphic_embedded/2 */
/* ----------------------- */

%:- assert_must_fail(homeomorphic:homeomorphic_embedded(p(f(a)),p(a))).
%:- assert_must_fail(homeomorphic:homeomorphic_embedded(p(a),p(_X))).
%:- assert_must_fail(homeomorphic:homeomorphic_embedded(p(a),p(p(f(g(b,c)))))).
%:- assert_must_fail(homeomorphic:homeomorphic_embedded(f(a,b),f(g(a,b),c))).
%:- assert_must_succeed(homeomorphic:homeomorphic_embedded(a,f(a))).
%:- assert_must_succeed(homeomorphic:homeomorphic_embedded(f(X),f(X))).
%:- assert_must_succeed(homeomorphic:homeomorphic_embedded(f(X,Y),f(Y,X))).
%:- assert_must_succeed(homeomorphic:homeomorphic_embedded(f(X,Y),f(Y,s(X)))).
%:- assert_must_succeed(homeomorphic:homeomorphic_embedded(f(a,_Y),f([c,b,a],s(_X)))).
%:- assert_must_succeed(homeomorphic:homeomorphic_embedded(f(f(a)),f(f(a)))).
%:- assert_must_succeed(homeomorphic:homeomorphic_embedded(q(b),q(1,2,q(f(1,f(b,2,3),3))))).
%:- assert_must_succeed(homeomorphic:homeomorphic_embedded(q(b),q(1,q(b),b))).
%:- assert_must_succeed(homeomorphic:homeomorphic_embedded(q(X),f(a,q(s(X))))).
%:- assert_must_succeed(homeomorphic:homeomorphic_embedded(p(1,2,f(3)),p(1,p(s(a,1),f(f(2)),g(a,b,f(3))),3))).
%:- assert_must_succeed(homeomorphic:homeomorphic_embedded(q(_X,Y),q(Y,f(_X)))).

/* homeomorphic_embedded(X,Y) :- print(homeomorphic_embedded(X,Y)),nl,fail. */

/* homeomorphic_embedded(X,Y) :- var(X),!,
 (nonvar(Y) -> (print(h(X,Y)),nl) ; true). */
homeomorphic_embedded(X,Y) :- var(X),var(Y),!.
homeomorphic_embedded(_X,Y) :-
	var(Y),!,fail.
homeomorphic_embedded(X,Y) :-
	nonvar(X),dynamic_term(X),
	nonvar(Y),dynamic_term(Y),!.
homeomorphic_embedded(X,Y) :-
	strict_instance_of(X,Y),!,%print('$*'),print('$'(X,Y)),
	fail.
homeomorphic_embedded(X,Y) :- /* coupling for unary constructors */
	nonvar(X),nonvar(Y),
	X=..[Func,XArg],
	Y=..[Func,YArg],
	!, /* do not try diving for unary matching constructors */
	homeomorphic_embedded(XArg,YArg),!.
homeomorphic_embedded(X,Y) :- /* coupling */
	nonvar(X),nonvar(Y),
	X=..[Func|XArgs],
	Y=..[Func|YArgs],
	l_homeomorphic_embedded(XArgs,YArgs),!.
homeomorphic_embedded(X,Y) :- /* diving */
	nonvar(Y),
	term_nesting_level(X,NX,SumX),
	sub_term(Y,Sub),
	term_nesting_level(Sub,NSub,SumSub),
	NSub>=NX,
	SumSub>=SumX,
	/*print(sub_term(Y,Sub)),nl,*/
	homeomorphic_embedded(X,Sub),!.

/* l_homeomorphic_embedded(X,Y) :- 
	print(l_homeomorphic_embedded(X,Y)),nl,fail. */
l_homeomorphic_embedded([],[]).
l_homeomorphic_embedded([X|TX],[Y|TY]) :-
	homeomorphic_embedded(X,Y),!,
	l_homeomorphic_embedded(TX,TY).



sub_term(X,Sub) :-
	nonvar(X),
	X=..[_F|Args],
	member(Sub,Args).


/* CHECK WHETHER THIS IS REALLY USEFUL */
/* term_nesting_level(_,0,0) :- !. */
%:- assert_must_succeed(homeomorphic:term_nesting_level(f(a,f(b)),4,5)).

term_nesting_level(X,0,0) :- var(X),!.
term_nesting_level(X,1,1) :- atomic(X),!.
term_nesting_level(X,N,S) :- nonvar(X),!,
	X=..[_F|Args],
	l_term_nesting_level(Args,NA,SA),
	N is NA + 1,
	S is SA + 1.

l_term_nesting_level([],0,0).
l_term_nesting_level([H|T],N,S) :-
	term_nesting_level(H,NH,SH),
	l_term_nesting_level(T,NT,ST),
	(NH>NT -> N=NH ; N=NT),
	S is SH + ST.




/* ===================================================== */


:- use_module(library(terms)).
:- use_module(library(terms_check)).
:- use_module(library(lists)).

/* ---------- */
/* VARIANT_OF */
/* ---------- */

%:- assert_must_fail(homeomorphic:variant_of(p(_X),p(a))).
%:- assert_must_fail(homeomorphic:variant_of(p(a),p(_X))).
%:- assert_must_fail(homeomorphic:variant_of(q(X,_Y),q(X,X))).
%:- assert_must_succeed(homeomorphic:variant_of(q(X,Y),q(Y,X))).
%:- assert_must_succeed(homeomorphic:variant_of(q(X,Y),q(X,Y))).

/* test whether something is variant of something else */

variant_of(Goal,UIGoal) :- variant(UIGoal,Goal).
	
%variant_of(Goal,UIGoal) :-
%	copy_term(Goal,CGoal),
%	variant(UIGoal,CGoal).

/* BIM Version:
variant_of(Goal,UIGoal) :- copy(Goal,CGoal),
			not(not(( numbervars(CGoal,0,N),
				  numbervars(UIGoal,0,N),
				  CGoal = UIGoal))).
*/

/* ===================================================== */

/* ----------- */
/* INSTANCE_OF */
/* ----------- */

/* tests whether Goal is an instance (covered) by UIGoal */
/* copy is made below, so that ?-covered(p(a,X),p(X,Y)). succeeds */

%:- assert_must_fail(homeomorphic:instance_of(q(X),q(f(X)))).
%:- assert_must_fail(homeomorphic:instance_of(q(X,_Y),q(X,X))).
%:- assert_must_fail(homeomorphic:instance_of(q(_Y,a),q(X,X))).
%:- assert_must_fail(homeomorphic:instance_of(q(X,X),q(_Y,a))).
%:- assert_must_fail(homeomorphic:instance_of(r,q(X,X))).
%:- assert_must_fail(homeomorphic:instance_of(p([s],_X),s)).
%:- assert_must_succeed(homeomorphic:instance_of(q(X),q(X))).
%:- assert_must_succeed(homeomorphic:instance_of(q(f(X)),q(X))).
%:- assert_must_succeed(homeomorphic:instance_of(q(X,Y),q(Y,X))).
%:- assert_must_succeed(homeomorphic:instance_of(q(X,Y),q(Y,X))).


instance_of(Goal,UIGoal) :- instance(UIGoal,Goal).

%instance_of(Goal,UIGoal) :- 
%	copy_term(Goal,CGoal),
%	subsumes_chk(UIGoal,CGoal).

/* BIM Version:
instance_of(Goal,UIGoal) :- copy(Goal,CGoal),
			not(not((numbervars(CGoal,0,_N),
				 CGoal = UIGoal))).
*/

/* ===================================================== */

/* ------------------ */
/* STRICT_INSTANCE_OF */
/* ------------------ */

%:- assert_must_fail(homeomorphic:strict_instance_of(q(_Z,_V),q(_X,_Y))).
%:- assert_must_fail(homeomorphic:strict_instance_of(q(Z,V),q(Z,V))).
%:- assert_must_fail(homeomorphic:strict_instance_of(q(X,X),q(_Y,a))).
%:- assert_must_fail(homeomorphic:strict_instance_of(q(_T,a),q(X,X))).
%:- assert_must_fail(homeomorphic:strict_instance_of(r,q(X,X))).
%:- assert_must_fail(homeomorphic:strict_instance_of(p([s],_X),s)).
%:- assert_must_succeed(homeomorphic:strict_instance_of(q(f(X)),q(X))).
%:- assert_must_succeed(homeomorphic:strict_instance_of(q(X,X),q(X,_Y))).

strict_instance_of(Goal1,Goal2) :-
	instance(Goal1,Goal2),
	\+(instance(Goal2,Goal1)).
%strict_instance_of(Goal1,Goal2) :-
%	copy_term(Goal1,CGoal),
%	subsumes_chk(Goal2,CGoal),
%	\+(subsumes_chk(CGoal,Goal2)).

/* BIM Version:
strict_instance_of(Goal1,Goal2) :-
	instance_of(Goal1,Goal2),
	not(instance_of(Goal2,Goal1)).
*/


/* ===================================================== */

cyclic_term(X, Seen) :- seen(X, Seen), !.
cyclic_term(X, Seen) :- 
        nonvar(X), X =.. [_|As], member(A, As),
        cyclic_term(A, [X|Seen]).

seen(X, Seen) :- member(X0, Seen), X == X0, !.


is_inf(X) :- cyclic_term(X,[]).




