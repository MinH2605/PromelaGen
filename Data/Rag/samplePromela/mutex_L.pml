/*
NAME
  mutex_L : Lamport's fast mutual exclusion algorithm

DESCRIPTION
  This is 'fast mutual exclusion algorithm' that uses
  only reads and writes.
  It's devised by Lamport.

AUTHER
  Fumiyoshi Kobayashi

HISTORY
  2008/08/18(Mon) New

Copyright(C) 2008 Fumiyoshi Kobayashi, Ueda Laboratory.
*/

#ifndef  N
#define  N  3
#endif

bit B[N];
byte X;
byte Y;
byte in_cs;

init {
  atomic {
    byte i = 0;
    Y = N;

    do
    :: i < N -> run P(i); i++;
    :: else  -> break;
    od;
  }
}

proctype P(byte id) {
  byte j;
NonCritical:
  B[id] = true;
Wait:
  X = id;
  if
  :: Y != N ->
     B[id] = false;
     if
     :: Y == N -> goto NonCritical;
     fi;
  :: Y == N -> Y = id;
  fi;
  if
  :: X != id ->
     d_step { B[id] = false; j = 0; }
     do
     :: atomic { j < N && B[j] == false -> j++; }
     :: j == N -> break;
     od;
     if
     :: Y != id ->
        if
        :: Y == N -> goto NonCritical;
        fi;
     :: atomic { Y == id; in_cs++; }
     fi;
  :: atomic { X == id; in_cs++; }
  fi;
Critical:
  d_step { Y = N; in_cs--; }
  B[id] = false;
  goto NonCritical;
}
