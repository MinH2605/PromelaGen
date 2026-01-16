/*
NAME
  mutex_L_N2 : Lamport's livelock-free nonatomic algorithm

DESCRIPTION
  Mutual exclusion with nonatomic operations by Lamport.
  This algorithm is not starvation-free.

AUTHER
  Fumiyoshi Kobayashi

HISTORY
  2008/08/19(Tue) New

Copyright(C) 2008 Fumiyoshi Kobayashi, Ueda Laboratory.
*/

#ifndef  N
#define  N  3
#endif

bit _P[N];
byte in_cs;

init {
  atomic {
    byte i = 0;

    do
    :: i < N -> run P(i); i++;
    :: else  -> break;
    od;
  }
}

proctype P(byte id) {
  byte i;
NonCritical:
  atomic { _P[id] = true; i = 0; }
Wait:
  do
  :: i < id && _P[i] == true ->
     do
     :: _P[i] == true -> _P[id] = false;
     :: _P[i] == false -> goto NonCritical;
     od;
  :: atomic { i < id && _P[i] == false -> i++; }
  :: atomic { i == id -> i++; } break;
  od;
  do
  :: atomic { i < N && _P[i] == false -> i++; }
  :: atomic { i == N -> in_cs++; } break;
  od;
Critical:
  atomic { _P[id] = false; in_cs--; }
  goto NonCritical;
}
