%Helper functions to get the correct Path output.
appendToEnd(A,B,C) :- append(B,[A],C). %Add an element X to the end of List Y to get final result Z.
second([_,E|_], E). %Get the second element of a list.

%Required predicate astar(+Node,?Path,?Cost,+KB)
astar(Node,Path,Cost,KB) :- search([[Node, [], 0]],A,Cost,KB), %Calculate Cost (final value) and Path As "A" (Not final value - elements in wrong order)
    						second(A, B), %Get the second element of the unfinished Path list
    						reverse(B, C), %Reverse the resulting list
    						appendToEnd([], C, Path). %Add a [] to the end of the result to get the output according to the assignment specification.

%Modified skeletal search algorithm
search([[Node, Path, Cost]|_], [Node,Path], Cost, _) :- goal(Node).
search([[Node, A, B]|C], Path, Cost, KB) :- findall([D,[Node|A],Sum], (arc(Node, D, E, KB), Sum is E+B), Children), %Modified findall to get a list of path cost pairs
											add2frontier(Children, C, Temporary), %Modified add2frontier returns a list of path cost pairs with the lowest heuristic value path cost pair at the head of the list
											minSort(Temporary, [[F, G, H]|I]), %Sort by min
											search([[F, G, H]|I], Path, Cost, KB). %recursion with search

%add2frontier predicate which fulfills the the equation f(node) = cost(node) + h(node).
add2frontier(Children, Frontier, FrontierNew) :- append(Children, Frontier, FrontierNew).
%minSort predicate to sort by min
minSort([Head|Tail], Answer) :- sort(Head, [], Tail, Answer).
%sort predicate to sort the list by min rec
sort(Head, S, [], [Head|S]).
sort(C, S, [Head|Tail], Answer) :- less-than(C, Head), 
    							   !,
								   sort(C, [Head|S], Tail, Answer);
								   sort(Head, [C|S], Tail, Answer).
%less-than predicate which uses the heuristic predicate to compare heuristics to see if one is less than the other.
less-than([Node1,_,Cost1|_],[Node2,_,Cost2|_]) :- heuristic(Node1,Hvalue1), 					                              
                                    			  heuristic(Node2,Hvalue2),
                                                  F1 is Cost1+Hvalue1, 
                                                  F2 is Cost2+Hvalue2,
                                                  F1 =< F2.

%arc predicate used by the search predicate.
arc([H|T],Node,Cost,KB) :- member([H|A],KB), append(A,T,Node),length(A,L), Cost is 1+ L/(L+1).

%heuristic predicate used by the less-than predicate.
heuristic(Node,HeuristicValue) :- length(Node,HeuristicValue).

% We are implementing A∗, returning a path from Node to the goal node [].
goal([]).
