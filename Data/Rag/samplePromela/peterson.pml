/*
NAME
  peterson : Peterson's mutual exclusion algorithm.

DESCRIPTION
  A classical algorithm of mutual exclusion problem.
  Devised by Peterson.

AUTHER
  Fumiyoshi Kobayashi

HISTORY
  2008/08/20(Wed) New

Copyright(C) 2008 Fumiyoshi Kobayashi, Ueda Laboratory.
*/

#ifndef  N
#define  N  3
#endif

byte pos[N];
byte step[N];
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
  byte i, j;
NonCritical:
  i = 0;
Wait:
  do
  :: i < N-1 ->
     pos[id] = i; step[i] = id; j = 0;
     do
     :: atomic { (j < N && j != id && (pos[j] < i || step[i] != id)) -> j++; }
     :: atomic { j == id -> j++; }
     :: atomic { j == N -> i++; } break;
     od;
  :: atomic { i == N-1 -> in_cs++; } break;
  od;
Critical:
  atomic { pos[id] = 0; in_cs--; }
  goto NonCritical;
}
