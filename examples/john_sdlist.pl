
p([],[]).
p([a|T],[b|T2]) :- p(T,T2).
p([b|_],[]).

