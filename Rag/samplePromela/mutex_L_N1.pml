/*
NAME
  mutex_L_N1 : Lamport's basic nonatomic algorithm

DESCRIPTION
  Mutual exclusion with nonatomic operations by Lamport.
  Algorithm mutex_L_N1 is not even livelock-free.

AUTHER
  Fumiyoshi Kobayashi

HISTORY
  2008/08/18(Mon) New

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
  :: atomic { i < N && _P[i] == false -> i++; }
  :: atomic { i == id -> i++; }
  :: atomic { i == N -> in_cs++; } break;
  od;
Critical:
  atomic { _P[id] = false; in_cs--; }
  goto NonCritical;
}
