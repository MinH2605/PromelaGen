/*
NAME
  mutex_AT : Alur and Taubenfeld's mutex algorithm

DESCRIPTION
  A fast timing-based mutual exclusion algorithm by Alur and Taubenfeld.

AUTHER
  Fumiyoshi Kobayashi

HISTORY
  2008/08/17(Sun) Added ERROR option
  2008/08/17(Sun) New

Copyright(C) 2008 Fumiyoshi Kobayashi, Ueda Laboratory.
*/

#ifndef  N
#define  N  3
#endif

byte X;
byte Y;
bit  Z;
byte in_cs;
byte delay;

init {
  atomic {
    byte i = 0;
    Y = N;
    Z = false;

    do
    :: i < N -> run P(i); i++;
    :: else  -> break;
    od;
  }
}

proctype P(byte id) {
NonCritical:
  /* skip; */
Wait:
  X = id;
  if
  :: atomic { Y == N; delay++; }
  fi;
  Y = id;
  if
  :: atomic { X != id -> delay--; }
#ifndef ERROR
     if
     :: delay == 0;
     fi;
#endif
     if
     :: Y != id -> goto Wait;
     :: Y == id;
     fi;
     if
     :: atomic { Z == false -> in_cs++; }
     fi;
  :: X == id ->
     d_step { Z = true; delay--; in_cs++; }
  fi;
Critical:
  d_step { Z = false; in_cs--; }
  if
  :: atomic { Y == id -> delay++; }
     d_step { Y = N; delay--; }
  :: Y != id;
  fi;
  goto NonCritical;
}
