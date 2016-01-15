%% @author Gandi
%% @doc @todo Add description to life22.

-module(main).
-compile(export_all).

state() ->
	{{dead, dead, dead, dead, dead, dead},
	 {dead, alive, dead, dead, dead, dead},
	{dead, alive, dead, dead, dead, dead},
	{dead, alive, dead, dead, dead, dead},
	{dead, alive, dead, dead, dead, dead},
	 {dead, dead, dead, dead, dead, dead}
	}.

start() ->
	Grid = state(),
	next_gen(6,Grid).

next_row(M, R, Grid) ->
	Cells = next_cells(M, R, 0, Grid),
	list_to_tuple(Cells).

next_cells(M, _, M, _) ->
	[];

next_cells(M, R, C, Grid) ->
	[next_cell(M, R, C, Grid)|next_cells(M, R, C+1, Grid)].

next_gen(M, Grid) ->
	Rows = next_rows(M, 0, Grid),
	list_to_tuple(Rows).

next_rows(M, M, _) ->
	[];

next_rows(M, R, Grid) ->
	[next_row(M,R,Grid) | next_rows(M,R+1,Grid)].

next_cell(M,R,C,Grid) ->
	S = s(M,R,C,Grid),
	SW = sw(M,R,C,Grid),
	SE = se(M,R,C,Grid),
	E = e(M,R,C,Grid),
	W = w(M,R,C,Grid),
	N = n(M,R,C,Grid),
	NW = nw(M,R,C,Grid),
	NE = ne(M,R,C,Grid),	
	This = this(R,C,Grid),
	rule([S, SW, SE, E, W, N, NW, NE], This).

element (Row, Col, Grid) ->
	element(Col+1, element(Row+1, Grid)).


s(M, Row, Col, Grid) ->
	element((Row+1) rem M, Col, Grid).
  
sw(M, Row, Col, Grid) ->
	element((Row+1) rem M, (Col+(M-1)) rem M, Grid).

se(M, Row, Col, Grid) ->
	element((Row+1) rem M, (Col+1) rem M, Grid).

e(M, Row, Col, Grid) ->
	element(Row, (Col+1) rem M, Grid).

w(M, Row, Col, Grid) ->
	element(Row, (Col+(M-1)) rem M, Grid).

n(M, Row, Col, Grid) ->
	element((Row+(M-1)) rem M, Col, Grid).

ne(M, Row, Col, Grid) ->
	element((Row+(M-1)) rem M, (Col+1) rem M, Grid).

nw(M, Row, Col, Grid) ->
	element((Row+(M-1)) rem M, (Col+(M-1)) rem M, Grid).

this(Row, Col, Grid) ->
	element(Row, Col, Grid).

alive(Neighbours) ->
	lists:foldl(fun(X,Count) -> if X == alive -> Count + 1; X == dead -> Count end end ,0,Neighbours).

rule(Neighbours,State) ->
	Alive = alive(Neighbours),
	if		
		Alive < 2 ->
			dead;
		Alive == 2 ->
			State;
		Alive == 3, State == dead ->
			alive;
		Alive == 3 ->
			State;
		Alive > 3 ->
			dead
	end.
