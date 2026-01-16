/*
NAME
  mutex_L_N3 : Lamport's starvation-free nonatomic algorithm

DESCRIPTION
  Mutual exclusion with nonatomic operations by Lamport.
  This algorithm is starvation-free.

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
bit _E[N];
bit _T[N];
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

inline Low(k, i) {
  d_step {
  i = 0;
  do
  :: i == 0 && _T[i] == _T[N-1] -> k = 0; break;
  :: i == 0 && _T[i] != _T[N-1] -> i++;
  :: i > 0 && _T[i] != _T[i-1] -> k = i; break;
  :: i > 0 && _T[i] == _T[i-1] -> i++;
  od;
  }
}

proctype P(byte id) {
  byte i, k;
  bit temp;
NonCritical:
  _P[id] = true;
Wait:
  _E[id] = true;
  Low(k, i);
  if
  :: k != id -> i = k;
     do
     :: (i % N != id-1) ->
        if
        :: _E[i%N] == true -> _P[id] = false; goto Wait;
        :: _E[i%N] == false -> i++;
        fi;
     :: (i % N == id-1); break;
     od;
  :: k == id;
  fi;
  if
  :: _P[id] == false -> goto NonCritical;
  :: atomic { _P[id] == true -> i = id + 1; }
  fi;
  do
  :: atomic { (i % N != k-1) && _P[i%N] == false -> i++; }
  :: (i % N != k-1) && _P[i%N] == true; goto NonCritical;
  :: atomic { (i % N == k-1) -> in_cs++; } break;
  od;
Critical:
  atomic { temp = 1 - _T[id]; in_cs--; }
  _T[id] = temp;
  _P[id] = false;
  _E[id] = false;
  goto NonCritical;
}
