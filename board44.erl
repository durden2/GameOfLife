%% @author Gandi

-module(board44).
-compile(export_all).

init() ->
	Grid = {{dead, dead, dead, alive},
{alive, alive, dead, dead},
{dead, alive, alive, dead},
{dead, alive, dead, dead}}.

element (Row, Col, Grid) ->
	element(Col+1, element(Row+1, Grid)).

s(Row, Col, Grid) ->
	element((Row+1) rem 4, Col, Grid).
  
sw(Row, Col, Grid) ->
	element((Row+1) rem 4, (Col+3) rem 4, Grid).

se(Row, Col, Grid) ->
	element((Row+1) rem 4, (Col+1) rem 4, Grid).

e(Row, Col, Grid) ->
	element(Row, (Col+1) rem 4, Grid).

w(Row, Col, Grid) ->
	element(Row, (Col+3) rem 4, Grid).

n(Row, Col, Grid) ->
	element((Row+3) rem 4, Col, Grid).

ne(Row, Col, Grid) ->
	element((Row+3) rem 4, (Col+1) rem 4, Grid).

nw(Row, Col, Grid) ->
	element((Row+3) rem 4, (Col+3) rem 4, Grid).

this(Row, Col, Grid) ->
	element(Row, Col, Grid).

next_gen(Grid) ->
	R1 = next_row(0, Grid),
	R2 = next_row(1, Grid),
	R3 = next_row(2, Grid),
	R4 = next_row(3, Grid),
	{R1,R2,R3,R4}.

next_row(Row, Grid) ->
	C1 = next_cell(Row,0, Grid),
	C2 = next_cell(Row,1, Grid),
	C3 = next_cell(Row,2, Grid),
	C4 = next_cell(Row,3, Grid),
	{C1,C2,C3,C4}.
	
next_cell(R,C,Grid) ->
	S = s(R,C,Grid),
	SW = sw(R,C,Grid),
	SE = se(R,C,Grid),
	E = e(R,C,Grid),
	W = w(R,C,Grid),
	N = n(R,C,Grid),
	NW = nw(R,C,Grid),
	NE = ne(R,C,Grid),	
	This = this(R,C,Grid),
	rule([S, SW, SE, E, W, N, NW, NE], This).
						
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