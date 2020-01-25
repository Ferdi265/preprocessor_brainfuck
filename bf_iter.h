#ifndef STATE
#   define EXECUTE 0
#   define SKIP 1
#   define RSKIP 2
#   define STATE EXECUTE
#endif
#
#if STATE == EXECUTE
#ifdef DEBUG
execute: cell = T0, cell index = Tr
#endif
#   if C0 == '>'
#ifdef DEBUG
opcode >
#endif
#       include "shift_T.h"
#   elif C0 == '<'
#ifdef DEBUG
opcode <
#endif
#       include "rshift_T.h"
#   elif C0 == '+'
#ifdef DEBUG
opcode +
#endif
#       define T0_NEXT ((T0 + 1) & 0xff)
#       include "literals/T0.h"
#   elif C0 == '-'
#ifdef DEBUG
opcode -
#endif
#       define T0_NEXT ((T0 - 1) & 0xff)
#       include "literals/T0.h"
#   elif C0 == '.'
#ifdef DEBUG
opcode .
#endif
#       define PRINT T0
#       include "print.h"
#   elif C0 == ','
#ifdef DEBUG
opcode ,
#endif
#       if Ic == 0
#           define T0_NEXT 0
#           include "literals/T0.h"
#       else
#           define T0_NEXT I0
#           include "literals/T0.h"
#           include "shift_I.h"
#       endif
#   elif C0 == '['
#ifdef DEBUG
opcode [
#endif
#       if T0 == 0
#           undef STATE
#           define STATE SKIP
#           define NESTCOUNT 0
#       endif
#   elif C0 == ']'
#ifdef DEBUG
opcode ]
#endif
#       if T0 != 0
#           undef STATE
#           define STATE RSKIP
#           define NESTCOUNT 0
#           include "rshift_C.h"
#       endif
#   endif
#   if STATE == EXECUTE
#       include "shift_C.h"
#   endif
#elif STATE == SKIP
#ifdef DEBUG
skip: nest = NESTCOUNT
#endif
#   if C0 == '['
#ifdef DEBUG
skipcode [
#endif
#       define NESTCOUNT_NEXT (NESTCOUNT + 1)
#       include "literals/NESTCOUNT.h"
#   elif C0 == ']'
#ifdef DEBUG
skipcode ]
#endif
#       if NESTCOUNT == 0
#           undef STATE
#           define STATE EXECUTE
#           undef NESTCOUNT
#       else
#           define NESTCOUNT_NEXT (NESTCOUNT - 1)
#           include "literals/NESTCOUNT.h"
#       endif
#   endif
#   include "shift_C.h"
#elif STATE == RSKIP
#ifdef DEBUG
rskip: nest = NESTCOUNT
#endif
#   if C0 == ']'
#ifdef DEBUG
rskipcode ]
#endif
#       define NESTCOUNT_NEXT (NESTCOUNT + 1)
#       include "literals/NESTCOUNT.h"
#   elif C0 == '['
#ifdef DEBUG
rskipcode [
#endif
#       if NESTCOUNT == 0
#           undef STATE
#           define STATE EXECUTE
#           undef NESTCOUNT
#       else
#           define NESTCOUNT_NEXT (NESTCOUNT - 1)
#           include "literals/NESTCOUNT.h"
#       endif
#   endif
#   if STATE == RSKIP
#       include "rshift_C.h"
#   endif
#endif
#
#if Cc == 0
#   undef HALT
#   define HALT 1
#endif
