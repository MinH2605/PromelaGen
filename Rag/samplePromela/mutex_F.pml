/*
NAME
  mutex_F : Fischer's mutex algorithm

DESCRIPTION
  A simple timing-based mutual exclusion algorithm by Fischer.

AUTHER
  Fumiyoshi Kobayashi

HISTORY
  2008/08/17(Sun) Added ERROR option
  2008/08/17(Sun) Chengeed delay procedure
  2008/08/16(Sat) New

Copyright(C) 2008 Fumiyoshi Kobayashi, Ueda Laboratory.
*/

#ifndef  N
#define  N  3
#endif

byte Y;
byte in_cs;
byte getY;

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
NonCritical:
  skip;
Wait:
  if
  :: atomic { Y == N; getY++; }
  fi;
  d_step { Y = id; getY--; }
#ifndef ERROR
  if
  :: getY == 0;
  fi;
#endif
  if
  :: atomic { Y == id -> in_cs++; }
  :: Y != id -> goto Wait;
  fi;
Critical:
  d_step { Y = N; in_cs--; }
  goto NonCritical;
}
