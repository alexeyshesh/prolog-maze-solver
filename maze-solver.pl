/*
### Вариант ЛБ: Поиск в лабиринте

Лабиринт состоит из входа, выхода (они единственны) и комнат, соединенных проходами.
При записи лабиринта его комнаты идентифицируются номерами, вход и выход обозначаются
знаками IN и OUT, и указываются все пары комнат, соединенных проходом. Предполагается,
что лабиринт проходим, т.е. существует хотя бы один путь по проходам лабиринта,
соединяющий его вход и выход.

Определить, можно ли засыпать какой-нибудь один проход между комнатами заданного
лабиринта так, чтобы лабиринт стал непроходимым (т.е нет пути от входа до выхода).
Засыпать два прохода? Найти все такие варианты превратить лабиринт в непроходимый.

tr(X, Y) – переход из комнаты X в комнату Y
*/

% вспомогателные функции

member(X, [_ | T]) :- member(X, T).
member(X, [X | _]).

member1(X, [X | _]) :- !.
member1(X, [_ | T]) :- member1(X, T).

subseq([], _).
subseq([H | T], [H | T1]) :- subseq(T, T1).
subseq([A | B], [H | T]) :- subseq([A | B], T).

seqsub(A, [], A) :- !.
seqsub([H | T], [H | T1], X) :- seqsub(T, T1, X).
seqsub([H | T], B, [H | X]) :- seqsub(T, B, X).

len([], 0).
len([X | T], L) :- len(T, L1), L is L1 + 1.


% find_path(X, Y, Graph, Path) – поиск пути Path от точки X до Y в графе Graph

find_path(X, Y, Graph, [X | [Z | Tail]], Vizited) :-
    not(member(X, Vizited)),
    (member(tr(X, Z), Graph); member(tr(Z, X), Graph)),
    find_path(Z, Y, Graph, [Z | Tail], [X | Vizited]).
find_path(X, Y, Graph, [X, Y], Vizited) :-
    not(member(X, Vizited)),
    not(member(Y, Vizited)),
    (member(tr(X, Y), Graph); member(tr(Y, X), Graph)).


% Поиск пути Path в лабиринте Maze от точки in до точки out

solve_maze(Maze, Path) :- find_path(in, out, Maze, Path, []).


% Лабиринт Maze непроходим, если убрать из него N переходов BrokeTransitions

destroy_maze(Maze, BrokeTransitions, N) :-
    subseq(BrokeTransitions, Maze),
    seqsub(Maze, BrokeTransitions, M),
    len(BrokeTransitions, N),
    member1(tr(in, _), M),
    member1(tr(_, out), M),
    not(solve_maze(M, _)).
