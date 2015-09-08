/* exMARS  -- Exhaust Memory Array Redcode Simulator
 * Copyright (C) 1993-2003 Albert Ma, Na'ndor Sieben, Stefan Strack,
 * Mintardjo Wangsawidjaja and Martin Ankerl
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

#define VERSION 1
#define REVISION 0

#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <time.h>
#include <stdio.h>
#include <exmars/exhaust.h>
#include <exmars/sim.h>
#include <exmars/insn_help.h>
#include <exmars/insn.h>

#include <chrono>
#include <iostream>

#include <omp.h>

#define concat(a,b) (strlen(a)+strlen(b)<MAXALLCHAR?pstrcat((a),(b)):NULL)

/**************************** config **********************************/
#define NEW_OPCODES
#define NEW_MODES
#define PSPACE
#define SHARED_PSPACE

#define NONE      0
#define ADDRTOKEN 1
#define FSEPTOKEN 2
#define COMMTOKEN 3
#define MODFTOKEN 4
#define EXPRTOKEN 5
#define WSPCTOKEN 6
#define CHARTOKEN 7
#define NUMBTOKEN 8
#define APNDTOKEN 9
#define MISCTOKEN 10                /* unrecognized token */

#define sep_sym ','
#define com_sym ';'
#define mod_sym '.'
#define cat_sym '&'
#define cln_sym ':'

#include <stdio.h>
#include <limits.h>
#include <stdlib.h>

#ifndef min
#define min(x,y) ((x)<(y) ? (x) : (y))
#endif


/* *********************************************************************
   System dependent definitions or declarations
   ********************************************************************* */



/* ************************************************************************
   pmars global structures and definitions
   ************************************************************************ */

#define PMARSVER  92
#define PMARSDATE "25/12/00"

/* return code:
   0: success
   Negative number: System error such as insufficient space, etc
   Positive number: User error such as number too big, file not found, etc */
#define GRAPHERR  -4                /* graphic error */
#define NOT386    -3                /* trying to execute 386 code on lesser
                                     * machine */
#define MEMERR    -2                /* insufficient memory, cannot free, etc. */
#define SERIOUS   -1                /* program logic error */
#define FNOFOUND   1                /* File not found */
#define CLP_NOGOOD 2                /* command line argument error */
#define PARSEERR   3                /* File doesn't assemble correctly */
#define USERABORT  4                /* user stopped program from cdb, etc. */

/* these are used as return codes of internal functions */

/* used by eval.c */
#define PMARS_OVERFLOW  1
#define OK_EXPR   0
#define BAD_EXPR -1
#define DIV_ZERO -2

/* used by cdb.c */
#define NOBREAK 0
#define BREAK   1
#define STEP    2

#define SKIP    1                /* cmdMod settings for cdb: skip next command */
#define RESET   2                /* clear command queue */

#define UNSHARED -1                /* P-space is private */
#define PIN_APPEARED -2


/* used by many */
#define STDOUT stdout

#define MAXCORESIZE   ((INT_MAX>>1)+1)
#define MAXTASKNUM    INT_MAX
#define MAXROUND      INT_MAX
#define MAXCYCLE      LONG_MAX
#define MAXINSTR      ((INT_MAX>>1)+1)

const char    addr_sym[] = {'#', '$', '@', '<', '>', '*', '{', '}', '\0'};
const char    expr_sym[] =
{'(', ')', '/', '+', '-', '%', '!', '=', '\0'};

const char   *opname[] =
{"MOV", "ADD", "SUB", "MUL", "DIV", "MOD", "JMZ",        /* op */
 "JMN", "DJN", "CMP", "SLT", "SPL", "DAT", "JMP",        /* op */
 "SEQ", "SNE", "NOP",                /* ext op */
 "LDP", "STP",
 "ORG", "END",                        /* pseudo-opcodes */
#ifdef SHARED_PSPACE
 "PIN", ""};
#else
""};
#endif

const char   *modname[] = {"A", "B", "AB", "BA", "F", "X", "I", ""};
const char   *swname[] = {"ASSERT", ""};

/* ***********************************************************************
   function prototypes
   *********************************************************************** */
int parse_param(int argc, char *argv[]);
int eval_expr(mars_t* mars, char *expr, long *result);
int assemble(char *fName, int aWarrior);
void disasm(mars_t* mars, mem_struct * cells, ADDR_T n, ADDR_T offset);
void simulator1(void);
char *locview(ADDR_T loc, char *outp);
int cdb(char *msg);
int score(int warnum);
int deaths(int warnum);
void results(FILE * outp);
void Exit(int code);
void reset_regs(mars_t* mars);

char *cellview(mars_t* mars, mem_struct * cell, char *outp);

char* pstrdup(char *);
char* pstrcat(char *, char *);
const char* pstrchr(const char *, int);
uChar ch_in_set(char c, const char* s);
uChar skip_space(char *, uChar);
uChar str_in_set(char *, const char *s[]);
int get_token(char * , uChar *, char *);
void to_upper(char *);


/* ****************** required local prototypes ********************* */

static void textout(char *);
static void errprn(mars_t* mars, errType code, line_st* aline, const char* arg);

/* ***************** conforming local prototypes ******************** */
static int trav2(mars_t* mars, char* buffer, char* dest, int wdecl);
static int normalize(mars_t* mars, long);
static int blkfor(mars_t* mars, char *, char *);
static int equtbl(mars_t* mars, char *);
static int equsub(mars_t* mars, char *, char *, int, ref_st *);
static ref_st *lookup(mars_t* mars, char *);
static grp_st *addsym(mars_t* mars, char *, grp_st *);
static src_st *addlinesrc(mars_t* mars, char *, uShrt);
static void newtbl(mars_t* mars);
static void addpredef(mars_t* mars, char *, U32_T);
static void addpredefs(mars_t* mars);
static void addline(mars_t* mars, char*, src_st*, uShrt);
static void disposeline(line_st *), disposegrp(grp_st *);
static void disposetbl(ref_st *, ref_st *);
static void cleanmem(mars_t* mars);
static void nocmnt(char *);
static void automaton(mars_t* mars, char *, stateCol, mem_struct *);
static void dfashell(mars_t* mars, char *, mem_struct *);
static void expand(mars_t* mars, uShrt);

int denormalize(mars_t* mars, int x);
void disposesrc(src_st* r);

int globalswitch_warrior(mars_t* mars, warrior_struct* w, char* str, uShrt idx, uShrt loc, uShrt lspnt);
void encode_warrior(mars_t* mars, warrior_struct* w, uShrt sspnt);
s32_t rng(s32_t seed);
void panic(char *msg);
int assemble_warrior(mars_t* mars, char* fName, warrior_struct* w);
void clear_results(mars_t* mars);
void save_pspaces(mars_t* mars);
void amalgamate_pspaces(mars_t* mars);
void accumulate_results(mars_t* mars);
void check_sanity(mars_t* mars);
void readargs(int argc, char** argv, mars_t* mars);
void usage(void);
void load_warriors(mars_t* mars);
void set_starting_order(unsigned int round, mars_t* mars);
void output_results(mars_t* mars);
s32_t compute_positions(s32_t seed, mars_t* mars);
void npos(s32_t *seed, mars_t* mars);
int posit(s32_t *seed, mars_t* mars);
mars_t* init(int argc, char** argv);
void pmars2exhaust(mars_t* mars, warrior_struct** warriors, int wCount);

char* eval(mars_t* mars, int prevPrec, long val1, int oper1, char *expr, long *result);
char   *getreg(mars_t* mars, char *expr, int regId, long *val);
char   *getval(mars_t* mars, char *expr, long *val);
char   *getop(char *expr, char *op);
long    calc(mars_t* mars, long x, long y, int op);


/* *************************** external strings ************************** */

char   *outOfMemory = "Out of memory\n";
char   *warriorTerminated = "Warrior %d: %s terminated\n";
char   *fatalErrorInSimulator = "Fatal error in simulator. Please report this error.\n";
char   *warriorTerminatedEndOfRound = "Warrior %d: %s terminated - End of round %d\n";
char   *endOfRound = "End of round %d\n";

char   *nameByAuthorScores = "%s by %s scores %d\n";
char   *resultsAre = "  Results:";
char   *resultsWLT = "Results: %d %d %d\n";

/* pmars.c */

char   *info01 = "Program \"%s\" (length %d) by \"%s\"\n\n";

/* asm.c */
char   *logicErr = "Error in %s. Line: %d\n";
char   *labelRefMsg = "Label references:\n";
char   *groupLabel = "Group label(s):\n";
char   *textMsg = "(TEXT):";
char   *stackMsg = "(STACK):";
char   *labelMsg = "(LABEL):";
char   *endOfChart = "***END*OF*CHART***\n\n";
char   *afterPass = "After pass %d\n";
char   *instrMsg = "Instruction (physical line, instr):\n\n";
char   *endOfPass = "\n***END*OF*PASS***\n\n";
char   *unknown = "Unknown";
char   *anonymous = "Anonymous";
char   *illegalAppendErr = "Attempting to append a string to an undefined label";
char   *bufferOverflowErr = "Buffer overflow. Substitution is too complex";
char   *illegalConcatErr = "Illegal use of string concatenation '%s'";
char   *tooManyLabelsErr = "Too many labels for a declaration (last: '%s')";
char   *unopenedFORErr = "Unopened FOR";
char   *unclosedROFErr = "Unclosed ROF";
char   *bad88FormatErr = "Bad '88 format at token '%s'";
char   *badOffsetErr = "Execution starts from outside of the program";
char   *noInstErr = "No instructions";
char   *spaceRedErr = "Putting space between ';' and 'redcode' is useless";
char   *tokenErr = "Unrecognized or improper placement of token: '%s'";
char   *terminatedRedErr = "Source code terminated by ';redcode'";
char   *undefinedSymErr = "Undefined label or symbol: '%s'";
char   *expectNumberErr = "Expecting a number";
char   *syntaxErr = "Syntax error";
char   *discardLabelErr = "Discarding these labels: '%s'";
char   *tooManyInstrErr = "Too many instructions (about %s more)";
char   *missingErr = "Missing '%s'";
char   *recursiveErr = "Recursive reference of label '%s'";
char   *badExprErr = "Bad expression";
char   *divZeroErr = "Division by zero";
char   *overflowErr = "Arithmetic overflow detected";
char   *missingAssertErr = "Missing ';assert'. Warrior may not work with the current setting";
char   *concatErr = "Unable to derefer and concatenate symbol '%s'";
char   *ignoreENDErr = "Both opcodes ORG and END are used. Ignoring END";
char   *invalidAssertErr = "Invalid ';assert' parameter";
char   *tooMuchStuffErr = "Lines generated by the source exceed the limit %d\n\tIgnoring code generation";
char   *extraTokenErr = "Ignored, extra tokens in line '%s'";
char   *improperPlaceErr = "Improper placement of '%s'";
char   *invalid88Err = "Invalid '88 format. Proper format: '%s'";
char   *incompleteOpErr = "Incomplete operand at instruction '%s'";
char   *redefinitionErr = "Ignored, redefinition of label '%s'";
char   *undefinedLabelErr = "Undefined label '%s'";
char   *assertionFailErr = "Assertion in this line fails";
char   *tooManyMsgErr = "\nToo many errors or warnings.\nProgram aborted.\n";
char   *fileOpenErr = "Unable to open file '%s'";
char   *fileReadErr = "Unable to read file '%s'";
char   *notEnoughMemErr = "MALLOC() fails\nProgram aborted\n";
char   *warning = "Warning";
char   *error = "Error";
char   *inLine = " in line %d: '%s'\n";
char   *opcodeMsg = "opcode";
char   *modifierMsg = "modifier";
char   *aTerm = "A-term";
char   *bTerm = "B-term";
char   *currentAssertMsg = "Current parameter for ';assert': %s\n";
char   *currentFORMsg = "Current parameter for FOR: %s\n";
char   *CURLINEErr = "CURLINE is a reserved keyword";
char   *paramCheckMsg = "Parameter checking:\n";
char   *errNumMsg = "Number of errors: %d\n";
char   *warNumMsg = "Number of warnings: %d\n";
char   *duplicateMsg = "Duplicate errors/warnings found in line %d (%d)\n";

/* Strings from clparse.c: */
char   *credits_screen1 = "pMARS v%d.%d.%d, %s, corewar simulator with ICWS'94 extensions\n";
char   *credits_screen2 = "Copyright (C) 1993-95 Albert Ma, Na'ndor Sieben, Stefan Strack and Mintardjo Wangsaw\n";
char   *credits_screen3 = "SERVER version without debugger\n";
char   *usage_screen = "Usage:\n   pmars [options] file1 [files ..]\n   The special file - stands for standard input\n\n";
char   *optionsAre = "Options:\n";
char   *readingStdin = "[Reading from standard input until EOF or \"$\"]\n";
char   *readOptionsFromFile = "  -@ $ Read options from file $\n";
char   *standardInput = "standard input";
char   *errorIsLocatedIn = "The error is located in \"%s\"\n";
char   *unknownOption = "\nUnknown option \"%s\"\n";
char   *badArgumentForSwitch = "\nBad argument for \"-%c\" switch\n";
char   *optionMustBeInTheRange = "\nOption \"-%c\" value must be in the range ";
char   *tooManyParameters = "\nToo many parameters \"%s\"\n";
char   *cannotOpenParameterFile = "\nCannot open parameter file\n";
char   *optRounds = "Rounds to play [1]";
char   *optEnterDebugger = "Enter debugger";
char   *optDisabledInServerVersion = "(disabled in SERVER version)";
char   *optCoreSize = "Size of core [8000]";
char   *optBrief = "Brief mode (no source listings)";
char   *optCycles = "Cycles until tie [80000]";
char   *optVerboseAssembly = "Verbose assembly";
char   *optProcesses = "Max. processes [8000]";
char   *optKotH = "Output in KotH format";
char   *optLength = "Max. warrior length [100]";
char   *opt88 = "Enforce ICWS'88 rules";
char   *optDistance = "Min. warriors distance";
char   *optFixedSeries = "Fixed position series";
char   *optFixedPosition = "Fixed position of warrior #2";
char   *optSort = "Sort result output by score";
char   *optScoreFormula = "Score formula $ [(W*W-1)/S]";
char   *optPSpaceSize = "Size of P-space [1/16th core]";
char   *optPermutate = "Permutate starting positions";
char   *noWarriorFile = "\nNo warrior file specified\n";
char   *fFExclusive = "\nOnly one of -f and -F can be given\n";
char   *coreSizeTooSmall = "\nCore size is too small\n";
char   *dLessThanl = "\nWarrior distance cannot be smaller than warrior length\n";
char   *FLessThand = "\nPosition of warrior #2 cannot be smaller than warrior distance\n";
char   *badScoreFormula = "\nBad score formula\n";
char   *pSpaceTooBig = "\nP-space is bigger than core\n";
char   *permutateMultiWarrior = "\nPermutation cannot be used in multiwarrior battles\n";



/* ********************** macros + type definitions ********************** */

#define LOGICERROR do { fprintf(STDOUT, logicErr, __FILE__, __LINE__);  \
        exit(PARSEERR); } while(0)

#define MEMORYERROR errprn(mars, MLCERR, (line_st *) NULL, "")


#ifdef SHARED_PSPACE
#define PSEOPNUM 4                /* also PIN */
#else
#define PSEOPNUM 3
#endif                                /* SHARED_PSPACE */

#define OPNUM (sizeof(opname)/sizeof(opname[0])) - PSEOPNUM

#define ORGOP (OPNUM + 0)
#define ENDOP (OPNUM + 1)
#define PINOP (OPNUM + 2)
#define EQUOP (OPNUM + 3)        /* this has to be the last */

#define MODNUM ((sizeof(modname)/sizeof(modname[0])) - 1)
#define SWNUM  ((sizeof(swname)/sizeof(swname[0])) - 1)

#define ERRMAX   9                /* max error */
#define GRPMAX   7                /* max group */
#define LEXCMAX  50                /* max number of excess lines */

#define BIGNUM 20                /* largest number taken */

/* two-char operators */
enum {
    EQUAL, NEQU, GTE, LTE, AND, OR, IDENT
};

#define TERMINAL(c) (((c)==')' || !(c)) ? 1 : 0)
/* order of precedence (high to low):
 * / %
 + -
 > < == != >= <=
 &&
 ||
 =
*/
#define PRECEDENCE(op) (op=='*' || op=='/' || op=='%' ? 5 :             \
                        (op=='+' || op=='-' ? 4 :                       \
                         (op=='>' || op=='<' || op==EQUAL || op==NEQU   \
                          || op==GTE || op==LTE ? 3 :                   \
                          (op==AND ? 2 : (op==OR ? 1 : 0)))))
#define SKIP_SPACE(e) while(isspace(*(e))) ++(e)


/* converts pmars order to exhaust order */

enum ex_op p2eOp[] = {
    EX_MOV, EX_ADD, EX_SUB, EX_MUL, EX_DIV, EX_MODM, EX_JMZ,
    EX_JMN, EX_DJN, EX_SEQ, EX_SLT, EX_SPL, EX_DAT, EX_JMP, /* CMP = SEQ */
    EX_SEQ, EX_SNE, EX_NOP, EX_LDP, EX_STP
};

enum ex_modifier p2eModifier[] = {
    EX_mA,                                /* .A */
    EX_mB,                                /* .B */
    EX_mAB,                                /* .AB */
    EX_mBA,                                /* .BA */
    EX_mF,                                /* .F */
    EX_mX,                                /* .X */
    EX_mI                                /* .I */   
};

enum ex_addr_mode p2eAddr[] = {
/* addr_sym[] = {'#', '$', '@', '<', '>', '*', '{', '}', '\0'}; */
    EX_IMMEDIATE, /* # */
    EX_DIRECT,  /* $ */
    EX_BINDIRECT,   /* @ */
    EX_BPREDEC, /* < */
    EX_BPOSTINC,    /* > */
    EX_AINDIRECT,   /* * */
    EX_APREDEC, /* { */
    EX_APOSTINC /* } */   /* 8 */
};

    

/*--------------------*/
long calc(mars_t* mars, long x, long y, int op)
{
    long    z;

    switch (op) {
    case '+':
        if (mars->evalerr == OK_EXPR && (x > 0 ?
                                         y > 0 && x > LONG_MAX - y :
                                         y < 0 && x < LONG_MIN - y ))
            mars->evalerr = PMARS_OVERFLOW;
        z = x + y;
        break;
    case '-':
        if (mars->evalerr == OK_EXPR && (x > 0 ?
                                         y < 0 && x > LONG_MAX + y :
                                         y > 0 && x < LONG_MIN + y ))
            mars->evalerr = PMARS_OVERFLOW;
        z = x - y;
        break;
    case '/':
        if (y == 0) {
            mars->evalerr = DIV_ZERO;
            z = 0;
        } else
            z = x / y;
        break;
    case '*':
        if (mars->evalerr == OK_EXPR && x != 0 && y != 0 &&
            x != -1 && y != -1 &&    /* LONG_MIN/(-1) causes FP error! */
            ((x > 0) == (y > 0) ?
             LONG_MAX / y / x == 0 :
             LONG_MIN / y / x == 0 ))
            mars->evalerr = PMARS_OVERFLOW;
        z = x * y;
        break;
    case '%':
        if (y == 0) {
            mars->evalerr = DIV_ZERO;
            z = 0;
        } else
            z = x % y;
        break;
    case AND:
        z = x && y;
        break;
    case OR:
        z = x || y;
        break;
    case EQUAL:
        z = x == y;
        break;
    case NEQU:
        z = x != y;
        break;
    case '<':
        z = x < y;
        break;
    case '>':
        z = x > y;
        break;
    case LTE:
        z = x <= y;
        break;
    case GTE:
        z = x >= y;
        break;
    case IDENT:                        /* the right-identity operator, used for
                                        * initial call to eval() */
        z = y;
        break;
    default:
        z = 0;
        mars->evalerr = BAD_EXPR;
    }
    return z;
}

/*--------------------*/
char   *
getop(char* expr, char* oper)
{
    char    ch;
    switch (ch = *(expr++)) {
    case '&':
        if (*(expr++) == '&')
            *oper = AND;
        break;
    case '|':
        if (*(expr++) == '|')
            *oper = OR;
        break;
    case '=':
        if (*(expr++) == '=')
            *oper = EQUAL;
        break;
    case '!':
        if (*(expr++) == '=')
            *oper = NEQU;
        break;
    case '<':
        if (*expr == '=') {
            ++expr;
            *oper = LTE;
        } else
            *oper = '<';
        break;
    case '>':
        if (*expr == '=') {
            ++expr;
            *oper = GTE;
        } else
            *oper = '>';
        break;
    default:
        *oper = ch;
        break;
    }
    return expr;
}
/*--------------------*/
char   *
getreg(mars_t* mars, char* expr, int regId, long* val)
{
    SKIP_SPACE(expr);
    if (*expr == '=' && *(expr + 1) != '=') {        /* assignment, not equality */
        expr = eval(mars, -1, 0L, IDENT, expr + 1, val);
        mars->regAr[regId] = *val;
    } else
        *val = mars->regAr[regId];
    return expr;
}

/*--------------------*/
char   *
getval(mars_t* mars, char* expr, long* val)
{
    char    buffer[BIGNUM];
    int     regId;
    int     bufptr = 0;
    long    accum;

    SKIP_SPACE(expr);
    if (*expr == '(') {                /* parenthetical expression */
        expr = eval(mars, -1, 0L, IDENT, expr + 1, val);
        if (*expr != ')')
            mars->evalerr = BAD_EXPR;
        return expr + 1;
    }
    if (*expr == '-') {                /* unary minus */
        expr = getval(mars, expr + 1, &accum);
        *val = accum * -1;
        return expr;
    } else if (*expr == '!') {        /* logical NOT */
        expr = getval(mars, expr + 1, &accum);
        *val = (accum ? 0 : 1);
        return expr;
    } else if (*expr == '+')        /* unary plus */
        return getval(mars, expr + 1, val);
    else if (((regId = (int) toupper(*expr)) >= 'A') && (regId <= 'Z'))
        return getreg(mars, expr + 1, regId - 'A', val);
    else
        while (isdigit(*expr))
            buffer[bufptr++] = *expr++;
    if (bufptr == 0)
        mars->evalerr = BAD_EXPR;                /* no digits */
    buffer[bufptr] = 0;
    sscanf(buffer, "%ld", val);
    return expr;
}

/*--------------------*/
char* 
eval(mars_t* mars, int prevPrec, long val1, int oper1, char *expr, long *result) {
    long    result2, val2;
    char    oper2;
    int     prec1, prec2;


    expr = getval(mars, expr, &val2);
    SKIP_SPACE(expr);
    if (TERMINAL(*expr)) {        /* trivial: expr is number or () */
        *result = calc(mars, val1, val2, oper1);
        return expr;
    }
    expr = getop(expr, &oper2);
    mars->saveOper = 0;

    if ((prec1 = PRECEDENCE(oper1)) >= (prec2 = PRECEDENCE(oper2))) {
        if (prec2 >= prevPrec || prec1 <= prevPrec) {
            expr = eval(mars, prec1, calc(mars, val1, val2, oper1), oper2, expr, result);
        } else {
            *result = calc(mars, val1, val2, oper1);
            mars->saveOper = oper2;
        }
    } else {
        expr = eval(mars, prec1, val2, oper2, expr, &result2);
        *result = calc(mars, val1, result2, oper1);

        if (mars->saveOper && PRECEDENCE(mars->saveOper) >= prevPrec) {
            expr = eval(mars, prec2, *result, mars->saveOper, expr, result);
            mars->saveOper = 0;
        }
    }

    return expr;
}

/*--------------------*/
void
reset_regs(mars_t* mars)
{
    register int idx;

    for (idx = 0; idx < 26; ++idx)
        mars->regAr[idx] = 0L;
}

/*--------------------*/
int
eval_expr(mars_t* mars, char* expr, long* result)                /* wrapper for eval() */
{
    mars->evalerr = OK_EXPR;
    if (*eval(mars, -1, 0L, IDENT, expr, result) != 0)
        mars->evalerr = BAD_EXPR;                /* still chars left */
    return (mars->evalerr);
}





#define toupper_(x) (toupper(x))

/* *************************** definitions ******************************* */

#define is_addr(ch)  pstrchr(addr_sym, (int) ch)
#define is_expr(ch)  pstrchr(expr_sym, (int) ch)
#define is_alpha(ch) (isalpha(ch) || (ch) == '_')

/* ********************************************************************** */

const char   *
pstrchr(const char* s, int c)
{
    do {
        if ((int) *s == c)
            return s;
    } while (*s++);

    return NULL;
}

/* ********************************************************************** */

char* pstrdup(char* s)
{
    char   *p, *q;
    register int i;

    for (q = s, i = 0; *q; q++)
        i++;

    if ((p = (char *) MALLOC(sizeof(char) * (i + 1))) != NULL) {
        q = p;
        while (*s)
            *q++ = *s++;
        *q = '\0';
    }
    return p;
}

/* ********************************************************************** */

char* pstrcat(char* s1, char* s2)
{
    register char *p = s1;

    while (*p)
        p++;
    while (*s2)
        *p++ = *s2++;
    *p = '\0';

    return s1;
}

/* ********************************************************************** */

/* return src of char in charset. charset is a string */
uChar ch_in_set(char c, const char* s)
{
    char    cc;
    register char a;
    register uChar i;

    cc = c;
    for (i = 0; ((a = s[i]) != '\0') && (a != cc); i++);
    return (i);
}

/* ********************************************************************** */

/*
 * return src of str in charset. charset is a string set. case is significant
 */
uChar 
str_in_set(char* str, const char* s[])
{
    register uChar i;
    for (i = 0; *s[i] && strcmp(str, s[i]); i++);
    return (i);
}

/* ********************************************************************** */

/* return next char which is non-whitespace char */
uChar skip_space(char* str, uChar i)
{
    register uChar idx;
    idx = i;
    while (isspace(str[idx]))
        idx++;
    return (idx);
}

/* ********************************************************************** */

void to_upper(char* str)
{
    while ((*str = (char)toupper_(*str)) != '\0')
        str++;
}

/* ********************************************************************** */

/* Get token which depends on the first letter. token need to be allocated. */
int 
get_token(char* str, uChar* curIndex, char* myToken)
{
    register uChar src, dst = 0;
    register int ch;                /* int for ctype compliance */
    int     tokenType;

    src = skip_space(str, *curIndex);

    if (str[src])
        if (isdigit(ch = str[src])) {        /* Grab the whole digit */
            while (isdigit(str[src]))
                myToken[dst++] = str[src++];
            tokenType = NUMBTOKEN;
        }
    /* Grab the whole identifier. There would be special treatment to modifiers */
        else if (is_alpha(ch)) {
            for (; ((ch = str[src]) != '\0') && (is_alpha(ch) || isdigit(ch));)
                myToken[dst++] = str[src++];
            tokenType = CHARTOKEN;
        }
    /*
     * The following would accept only one single char. The order should
     * reflect the frequency of the symbols being used
     */
        else {
            /* Is operator symbol ? */
            if (is_expr(ch))
                tokenType = EXPRTOKEN;
            /* Is addressing mode symbol ? */
            else if (is_addr(ch))
                tokenType = ADDRTOKEN;
            /* Is concatenation symbol ? */
            /* currently force so that there is no double '&' */
            else if (ch == cat_sym)
                if (str[src + 1] == '&') {
                    myToken[dst++] = str[src++];
                    tokenType = EXPRTOKEN;
                } else
                    tokenType = APNDTOKEN;
            /* comment symbol ? */
            else if (ch == com_sym)
                tokenType = COMMTOKEN;
            /* field separator symbol ? */
            else if (ch == sep_sym)
                tokenType = FSEPTOKEN;
            /* modifier symbol ? */
            else if (ch == mod_sym)
                tokenType = MODFTOKEN;
            else if ((ch == '|') && (str[src + 1] == '|')) {
                myToken[dst++] = str[src++];
                tokenType = EXPRTOKEN;
            } else
                tokenType = MISCTOKEN;

            myToken[dst++] = str[src++];
        }
    else
        tokenType = NONE;

    myToken[dst] = '\0';
    *curIndex = src;

    return (tokenType);
}






int denormalize(mars_t* mars, int x) 
{
    if (x > (int)(mars->coresize/2)) return x - mars->coresize;
    else return x;
}


typedef mem_struct mem_st;

/* whether INITIALINST is displayed or not */
#define HIDE 0
#define SHOW 1

/* ******************************************************************** */
char* cellview(mars_t* mars, mem_struct* cell, char* outp)
{
    FIELD_T opcode, modifier;

    opcode = ((FIELD_T) (cell->opcode & 0xf8)) >> 3;
    modifier = (cell->opcode & 0x07);

    sprintf(outp, "%3s%c%-2s %c%6d, %c%6d %4s",
            opname[opcode],
            '.',
            modname[modifier],
            PM_INDIR_A(cell->A_mode) ? addr_sym[INDIR_A_TO_SYM(cell->A_mode)] : addr_sym[cell->A_mode], 
            denormalize(mars, cell->A_value),
            PM_INDIR_A(cell->B_mode) ? addr_sym[INDIR_A_TO_SYM(cell->B_mode)] : addr_sym[cell->B_mode],
            denormalize(mars, cell->B_value),
            "");

    return (outp);
}
/* ******************************************************************** */

void
disasm(mars_t* mars, mem_struct* cells, ADDR_T n, ADDR_T offset)
{
    ADDR_T  i;
    char    myBuf[MAXALLCHAR];

    if (SHOW && (offset >= 0) && (offset < n))
        fprintf(STDOUT, "%-6s %3s%3s  %6s\n", "", "ORG", "", "START");

    for (i = 0; i < n; ++i)
        fprintf(STDOUT, "%-6s %s\n", i == offset ? "START" : "",
                cellview(mars, (mem_struct *) cells + i, myBuf));

    if (SHOW && (offset >= 0) && (offset < n))
        fprintf(STDOUT, "%-6s %3s%3s  %6s\n", "", "END", "", "START");
}





/* ************************** Functions ***************************** */

static ref_st *
lookup(mars_t* mars, char* symn)
{
    ref_st *curtbl;
    grp_st *symtable;

    for (curtbl = mars->reftbl; curtbl; curtbl = curtbl->nextref)
        for (symtable = curtbl->grpsym; symtable;
             symtable = symtable->nextsym)
            if (!strcmp(symtable->symn, symn))
                return curtbl;

    return NULL;
}

/* ******************************************************************* */

static void
newtbl(mars_t* mars)
{
    ref_st *curtbl;
    if ((curtbl = (ref_st *) MALLOC(sizeof(ref_st))) != NULL) {
        curtbl->grpsym = NULL;
        curtbl->sline = NULL;
        curtbl->visit = FALSE;        /* needed to detect recursive reference */
        curtbl->nextref = mars->reftbl;
        mars->reftbl = curtbl;
    } else
        MEMORYERROR;
}

/* ******************************************************************* */

static grp_st *
addsym(mars_t* mars, char* symn, grp_st* curgroup)
{
    grp_st *symgrp;

    if ((symgrp = (grp_st *) MALLOC(sizeof(grp_st))) != NULL) {
        if ((symgrp->symn = pstrdup(symn)) != NULL)
            symgrp->nextsym = curgroup;
        else {
            FREE(symgrp);
            MEMORYERROR;
        }
    }

    return symgrp;
}

/* ******************************************************************* */

static void
addpredef(mars_t* mars, char* symn, U32_T value)
{
    grp_st *lsymtbl = NULL;
    line_st *aline;

    lsymtbl = addsym(mars, symn, lsymtbl);
    sprintf(mars->token, "%lu", (unsigned long) value);
    newtbl(mars);
    mars->reftbl->grpsym = lsymtbl;
    mars->reftbl->reftype = RTEXT;
    if (((aline = (line_st *) MALLOC(sizeof(line_st))) != NULL) &&
        ((aline->vline = pstrdup(mars->token)) != NULL)) {
        aline->nextline = NULL;
        mars->reftbl->sline = aline;
    } else
        MEMORYERROR;
}

/* ******************************************************************* */

static void
addpredefs(mars_t* mars)
{
    /* predefined constants */
    addpredef(mars, "CORESIZE", (U32_T) mars->coresize);
    addpredef(mars, "MAXPROCESSES", (U32_T) mars->processes);
    addpredef(mars, "MAXCYCLES", (U32_T) mars->cycles);
    addpredef(mars, "MAXLENGTH", (U32_T) mars->maxWarriorLength);
    addpredef(mars, "MINDISTANCE", (U32_T) mars->minsep);
    addpredef(mars, "VERSION", (U32_T) PMARSVER);
    addpredef(mars, "WARRIORS", (U32_T) mars->nWarriors);
    addpredef(mars, "ROUNDS", (U32_T) mars->rounds);
    addpredef(mars, "PSPACESIZE", (U32_T) mars->pspaceSize);
}

/* ******************************************************************* */

/* Add line, with sline and lline, it is possible to add line to multiple
   group of inst */
static void addline(mars_t* mars, char* vline, src_st* src, uShrt lspnt)
{
    line_st *temp;
    if ((temp = (line_st *) MALLOC(sizeof(line_st))) != NULL) {
        if ((temp->vline = pstrdup(vline)) != NULL) {
            temp->dbginfo = (FIELD_T)(mars->dbginfo ? TRUE : FALSE);
            temp->linesrc = src;
            temp->nextline = NULL;
            if (mars->sline[lspnt])                /* First come first serve */
                mars->lline[lspnt] = mars->lline[lspnt]->nextline = temp;
            else                        /* lline init depends on sline */
                mars->sline[lspnt] = mars->lline[lspnt] = temp;
        } else {
            FREE(temp);
            MEMORYERROR;
        }
    }
}

/* ******************************************************************* */

static src_st* addlinesrc(mars_t* mars, char* src, uShrt loc)
{
    src_st *alinesrc;

    if ((alinesrc = (src_st *) MALLOC(sizeof(src_st))) == NULL)
        MEMORYERROR;
    else {
        alinesrc->src = pstrdup(src);
        alinesrc->loc = loc;
        alinesrc->nextsrc = mars->srctbl;
        mars->srctbl = alinesrc;
    }

    return alinesrc;
}

/* ******************************************************************* */
/*
  typedef struct src_st {
  char   *src;
  struct src_st *nextsrc;
  uShrt   loc;
  }       src_st;
*/

void disposesrc(src_st* r) {
    while (r) {
        src_st* next = r->nextsrc;
        FREE(r->src);
        FREE(r);
        r = next;
    }
}

/*
  typedef struct line_st {
  char   *vline;
  FIELD_T dbginfo;
  src_st *linesrc;
  struct line_st *nextline;
  }       line_st;
*/
static void disposeline(line_st *aline)
{
    line_st *tmp;

    while ((tmp = aline) != NULL) {
        FREE(tmp->vline);
        /*disposesrc(tmp->linesrc);  *//* by martinus */
        /*tmp->linesrc = NULL;*/
        aline = aline->nextline;
        FREE(tmp);
    }
}

/* ******************************************************************* */

/*
  typedef struct grp_st {
  char   *symn;
  struct grp_st *nextsym;
  }       grp_st;
*/
static void disposegrp(grp_st *agrp)
{
    grp_st *tmp;

    while ((tmp = agrp) != NULL) {
        FREE(tmp->symn);
        agrp = agrp->nextsym;
        FREE(tmp);
    }
}

/* ******************************************************************* */

/*
  typedef struct ref_st {
  grp_st *grpsym;
  line_st *sline;
  uShrt   value, visit;
  RType   reftype;
  struct ref_st *nextref;
  }       ref_st;
*/
static void disposetbl(ref_st *atbl, ref_st *btbl)
{
    ref_st *tmp;

    while ((tmp = atbl) != btbl) {
        atbl = atbl->nextref;
        disposegrp(tmp->grpsym);
        disposeline(tmp->sline);  /* memory leak fix by martinus */
        FREE(tmp);
    }
}

/* ******************************************************************* */

/* clear all allocated mem */
static void
cleanmem(mars_t* mars)
{
    disposeline(mars->sline[0]);
    disposeline(mars->sline[1]);
    mars->sline[0] = mars->sline[1] = NULL;
    disposetbl(mars->reftbl, NULL);
    mars->reftbl = NULL;
    disposegrp(mars->symtbl);
    mars->symtbl = NULL;
    mars->symnum = 0;
}

/* ******************************************************************* */

/* Remove trailing comment from str */
static void nocmnt(char* str)
{
    while (*str && (*str != com_sym))
        str++;
    *str = '\0';
}

/* ******************************************************************* */


/* stst && wangsawm v0.4.0: output for different displays */
static void
textout(char* str)
{
    fprintf(stderr, str);
}

/* ******************************************************************* */

static void
errprn(mars_t* mars, errType code, line_st* aline, const char* arg)
{
    char abuf[MAXALLCHAR];

    mars->errorcode = PARSEERR;
    mars->errorlevel = SERIOUS;

    switch (code) {
    case ANNERR:
        strcpy(abuf, illegalAppendErr);
        mars->errorlevel = WARNING;
        break;
    case BUFERR:
        strcpy(abuf, bufferOverflowErr);
        break;
    case ERVERR:
        sprintf(abuf, illegalConcatErr, arg);
        break;
    case GRPERR:
        sprintf(abuf, tooManyLabelsErr, arg);
        break;
    case FORERR:
        strcpy(abuf, unopenedFORErr);
        break;
    case ROFERR:
        strcpy(abuf, unclosedROFErr);
        mars->errorlevel = WARNING;
        break;
    case M88ERR:
        sprintf(abuf, bad88FormatErr, arg);
        break;
    case ZLNERR:
        strcpy(abuf, noInstErr);
        mars->errorlevel = WARNING;
        break;
    case DLBERR:
        sprintf(abuf, discardLabelErr, arg);
        mars->errorlevel = WARNING;
        break;
    case TOKERR:
        sprintf(abuf, tokenErr, arg);
        break;
    case SNFERR:
        sprintf(abuf, undefinedSymErr, arg);
        break;
    case NUMERR:
        strcpy(abuf, expectNumberErr);
        break;
    case SYNERR:
        strcpy(abuf, syntaxErr);
        break;
    case LINERR:
        sprintf(abuf, tooManyInstrErr, arg);
        break;
    case EXPERR:
        sprintf(abuf, missingErr, arg);
        break;
    case RECERR:
        sprintf(abuf, recursiveErr, arg);
        break;
    case EVLERR:
        strcpy(abuf, badExprErr);
        break;
    case DIVERR:
        strcpy(abuf, divZeroErr);
        break;
    case OFLERR:
        strcpy(abuf, overflowErr);
        mars->errorlevel = WARNING;
        break;
    case NASERR:
        strcpy(abuf, missingAssertErr);
        mars->errorlevel = WARNING;
        break;
    case OFSERR:
        strcpy(abuf, badOffsetErr);
        mars->errorlevel = WARNING;
        break;
    case CATERR:
        sprintf(abuf, concatErr, arg);
        break;
    case DOEERR:
        strcpy(abuf, ignoreENDErr);
        mars->errorlevel = WARNING;
        break;
    case BASERR:
        strcpy(abuf, invalidAssertErr);
        mars->errorlevel = WARNING;
        break;
    case EXXERR:
        sprintf(abuf, tooMuchStuffErr, MAXINSTR);
        break;
    case PMARS_IGNORE:
        sprintf(abuf, extraTokenErr, arg);
        mars->errorlevel = WARNING;
        break;
    case APPERR:
        sprintf(abuf, improperPlaceErr, arg);
        break;
    case F88ERR:
        sprintf(abuf, invalid88Err, arg);
        break;
    case NOPERR:
        sprintf(abuf, incompleteOpErr, arg);
        break;
    case IDNERR:
        sprintf(abuf, redefinitionErr, arg);
        mars->errorlevel = WARNING;
        break;
    case UDFERR:
        sprintf(abuf, undefinedLabelErr, arg);
        mars->errorlevel = WARNING;
        break;
    case CHKERR:
        strcpy(abuf, assertionFailErr);
        break;
    case MISC:
        strcpy(abuf, arg);
        break;
    case FNFERR:
        sprintf(abuf, fileOpenErr, arg);
        break;
    case DSKERR:
        sprintf(abuf, fileReadErr, arg);
        break;
    case MLCERR:
        cleanmem(mars);                        /* refresh memory for fprintf and system */
        fprintf(stderr, notEnoughMemErr);
        exit(MEMERR);
        break;
    }

    if (mars->errorlevel == WARNING)
        mars->warnum++;
    else
        mars->errnum++;

    if (aline) {

        int     i = 0;

        if (aline->linesrc == NULL)
            LOGICERROR;

        while ((i < mars->ierr) && ((mars->errkeep[i].loc != aline->linesrc->loc) ||
                                    (mars->errkeep[i].code != code)))
            i++;

        if (i == mars->ierr) {
            sprintf(mars->outs, "%s", mars->errorlevel == WARNING ? warning : error);
            textout(mars->outs);
            sprintf(mars->outs, inLine, aline->linesrc->loc, aline->linesrc->src);
            textout(mars->outs);
            sprintf(mars->outs, "        %s\n", abuf);
            textout(mars->outs);
            mars->errkeep[mars->ierr].num = 1;
            mars->errkeep[mars->ierr].loc = aline->linesrc->loc;
            mars->errkeep[mars->ierr++].code = (uShrt)code;
        } else
            mars->errkeep[i].num++;
    } else {
        sprintf(mars->outs, "%s:\n",
                mars->errorlevel == WARNING ? warning : error);

        textout(mars->outs);
        sprintf(mars->outs, "        %s\n", abuf);
        textout(mars->outs);
    }

    if (mars->ierr >= ERRMAX) {
        sprintf(mars->outs, tooManyMsgErr);
        textout(mars->outs);
        exit(PARSEERR);
    }
    strcpy(mars->errmsg, abuf);
}

/* ******************************************************************* */

#define A_expr mars->buf
#define B_expr mars->buf2
#define vallen 8

/* ******************************************************************* */

/* Here is the automaton */
static void
automaton(mars_t* mars, char* expr, stateCol state, mem_struct* cell)
{
    uChar   idx = 0;
    char   *tmp;
    ref_st *atbl;

    switch (mars->laststate = state) {

    case S_OP:
        mars->statefine = FALSE;
        if (get_token(expr, &idx, mars->token) == CHARTOKEN) {
            to_upper(mars->token);
            if ((mars->opcode = str_in_set(mars->token, opname)) < OPNUM)
                automaton(mars, (char *) expr + idx, S_MOD_ADDR_EXP, cell);
            else if (mars->opcode < EQUOP)
                automaton(mars, (char *) expr + idx, S_EXPR, cell);
            else
/* This should be toggled as error. No label should appear at this point */
                LOGICERROR;
        } else
            errprn(mars, EXPERR, mars->aline, opcodeMsg);
        break;

    case S_MOD_ADDR_EXP:
        mars->statefine = FALSE;
        switch (get_token(expr, &idx, mars->token)) {
        case MODFTOKEN:
            automaton(mars, (char *) expr + idx, S_MODF, cell);
            break;
        case ADDRTOKEN:
            cell->A_mode = (FIELD_T) ch_in_set(*(mars->token), addr_sym);
            if (cell->A_mode > 4) {
                cell->A_mode = SYM_TO_INDIR_A(cell->A_mode);
            }
            automaton(mars, (char *) expr + idx, S_EXP_FS, cell);
            break;
        case NUMBTOKEN:
        case EXPRTOKEN:
            automaton(mars, expr, S_EXP_FS, cell);
            break;
        case CHARTOKEN:
            if ((atbl = lookup(mars, mars->token)) != NULL)
                if (atbl->visit)
                    errprn(mars, RECERR, mars->aline, mars->token);
                else if (atbl->reftype == RTEXT)
                    if (atbl->sline) {
                        atbl->visit = TRUE;
                        automaton(mars, atbl->sline->vline, S_MOD_ADDR_EXP, cell);
                        atbl->visit = FALSE;
                        automaton(mars, (char *) expr + idx, mars->laststate, cell);
                    } else
/* all slines should've been filled */
                        LOGICERROR;
                else if ((tmp = (char *) MALLOC(sizeof(char) * vallen)) != NULL) {
                    sprintf(tmp, "%d", (int) atbl->value - mars->line);
                    atbl->visit = TRUE;
                    automaton(mars, tmp, S_MOD_ADDR_EXP, cell);
                    FREE(tmp);
                    atbl->visit = FALSE;
                    automaton(mars, (char *) expr + idx, mars->laststate, cell);
                } else
                    MEMORYERROR;
            else if (!mars->token[1])
                automaton(mars, expr, S_EXP_FS, cell);
            else
                errprn(mars, SNFERR, mars->aline, mars->token);
            break;
        case NONE:
            break;
        default:
            errprn(mars, APPERR, mars->aline, mars->token);
        }
        break;

    case S_MODF:
        mars->statefine = FALSE;
        switch (get_token(expr, &idx, mars->token)) {
        case CHARTOKEN:
            to_upper(mars->token);
            if ((mars->modifier = str_in_set(mars->token, modname)) < MODNUM)
                automaton(mars, (char *) expr + idx, S_ADDR_EXP_A, cell);
            else
                errprn(mars, EXPERR, mars->aline, modifierMsg);
            break;
        case NONE:
            break;
        default:
            errprn(mars, EXPERR, mars->aline, modifierMsg);
        }
        break;

    case S_ADDR_EXP_A:
        mars->statefine = FALSE;
        switch (get_token(expr, &idx, mars->token)) {
        case ADDRTOKEN:
            cell->A_mode = (FIELD_T) ch_in_set(*(mars->token), addr_sym);
            if (cell->A_mode > 4) {
                cell->A_mode = SYM_TO_INDIR_A(cell->A_mode);
            }
            automaton(mars, (char *) expr + idx, S_EXP_FS, cell);
            break;
        case NUMBTOKEN:
        case EXPRTOKEN:
            automaton(mars, expr, S_EXP_FS, cell);
            break;
        case CHARTOKEN:
            if ((atbl = lookup(mars, mars->token)) != NULL)
                if (atbl->visit)
                    errprn(mars, RECERR, mars->aline, mars->token);
                else if (atbl->reftype == RTEXT)
                    if (atbl->sline) {
                        atbl->visit = TRUE;
                        automaton(mars, atbl->sline->vline, S_ADDR_EXP_A, cell);
                        atbl->visit = FALSE;
                        automaton(mars, (char *) expr + idx, mars->laststate, cell);
                    } else
/* all slines should've been filled */
                        LOGICERROR;
                else if ((tmp = (char *) MALLOC(sizeof(char) * vallen)) != NULL) {
                    sprintf(tmp, "%d", (int) atbl->value - mars->line);
                    atbl->visit = TRUE;
                    automaton(mars, tmp, S_ADDR_EXP_A, cell);
                    FREE(tmp);
                    atbl->visit = FALSE;
                    automaton(mars, (char *) expr + idx, mars->laststate, cell);
                } else
                    MEMORYERROR;
            else if (!mars->token[1])
                automaton(mars, expr, S_EXP_FS, cell);
            else
                errprn(mars, SNFERR, mars->aline, mars->token);
            break;
        case NONE:
            break;
        default:
            errprn(mars, EXPERR, mars->aline, aTerm);
        }
        break;

    case S_EXP_FS:
        switch (get_token(expr, &idx, mars->token)) {
        case FSEPTOKEN:
            automaton(mars, (char *) expr + idx, S_ADDR_EXP_B, cell);
            break;
        case ADDRTOKEN:
            if ((mars->token[0] != '>') && (mars->token[0] != '<') && (mars->token[0] != '*'))
                errprn(mars, APPERR, mars->aline, mars->token);
            else {
                if (!concat(A_expr, mars->token))
                    errprn(mars, BUFERR, mars->aline, "");
                mars->statefine = TRUE;
                automaton(mars, (char *) expr + idx, S_EXP_FS, cell);
            }
            break;
        case NUMBTOKEN:
            if (!concat(mars->token, " "))
                errprn(mars, BUFERR, mars->aline, "");
            /* FALLTHROUGH */
        case EXPRTOKEN:
            if (!concat(A_expr, mars->token))
                errprn(mars, BUFERR, mars->aline, "");
            mars->statefine = TRUE;
            automaton(mars, (char *) expr + idx, S_EXP_FS, cell);
            break;
        case CHARTOKEN:
            if ((atbl = lookup(mars, mars->token)) != NULL)
                if (atbl->visit)
                    errprn(mars, RECERR, mars->aline, mars->token);
                else if (atbl->reftype == RTEXT)
                    if (atbl->sline) {
                        atbl->visit = TRUE;
                        automaton(mars, atbl->sline->vline, S_EXP_FS, cell);
                        atbl->visit = FALSE;
                        automaton(mars, (char *) expr + idx, mars->laststate, cell);
                    } else
/* all slines should've been filled */
                        LOGICERROR;
                else if ((tmp = (char *) MALLOC(sizeof(char) * vallen)) != NULL) {
                    sprintf(tmp, "%d", (int) atbl->value - mars->line);
                    atbl->visit = TRUE;
                    automaton(mars, tmp, S_EXP_FS, cell);
                    FREE(tmp);
                    atbl->visit = FALSE;
                    automaton(mars, (char *) expr + idx, mars->laststate, cell);
                } else
                    MEMORYERROR;
            else if (!mars->token[1])        /* check if it's a register. */
                if (concat(A_expr, mars->token)) {
                    mars->statefine = TRUE;
                    automaton(mars, (char *) expr + idx, S_EXP_FS, cell);
                } else
                    errprn(mars, BUFERR, mars->aline, "");
            else
                errprn(mars, SNFERR, mars->aline, mars->token);
            break;
        case NONE:
            break;
        default:
            errprn(mars, APPERR, mars->aline, mars->token);
        }
        break;

    case S_ADDR_EXP_B:
        mars->statefine = FALSE;
        switch (get_token(expr, &idx, mars->token)) {
        case ADDRTOKEN:
            cell->B_mode = (FIELD_T) ch_in_set(*(mars->token), addr_sym);
            if (cell->B_mode > 4) {
                cell->B_mode = SYM_TO_INDIR_A(cell->B_mode);
            }
            automaton(mars, (char *) expr + idx, S_EXPR, cell);
            break;
        case NUMBTOKEN:
        case EXPRTOKEN:
            automaton(mars, expr, S_EXPR, cell);
            break;
        case CHARTOKEN:
            if ((atbl = lookup(mars, mars->token)) != NULL)
                if (atbl->visit)
                    errprn(mars, RECERR, mars->aline, mars->token);
                else if (atbl->reftype == RTEXT)
                    if (atbl->sline) {
                        atbl->visit = TRUE;
                        automaton(mars, atbl->sline->vline, S_ADDR_EXP_B, cell);
                        atbl->visit = FALSE;
                        automaton(mars, (char *) expr + idx, mars->laststate, cell);
                    } else
/* all slines should've been filled */
                        LOGICERROR;
                else if ((tmp = (char *) MALLOC(sizeof(char) * vallen)) != NULL) {
                    sprintf(tmp, "%d", (int) atbl->value - mars->line);
                    atbl->visit = TRUE;
                    automaton(mars, tmp, S_ADDR_EXP_B, cell);
                    FREE(tmp);
                    atbl->visit = FALSE;
                    automaton(mars, (char *) expr + idx, mars->laststate, cell);
                } else
                    MEMORYERROR;
            else if (!mars->token[1])
                automaton(mars, expr, S_EXPR, cell);
            else
                errprn(mars, SNFERR, mars->aline, mars->token);
            break;
        case NONE:
            break;
        default:
            errprn(mars, EXPERR, mars->aline, bTerm);
        }
        break;

    case S_EXPR:
        switch (get_token(expr, &idx, mars->token)) {
        case ADDRTOKEN:
            if ((mars->token[0] != '>') && (mars->token[0] != '<') && (mars->token[0] != '*'))
                errprn(mars, APPERR, mars->aline, mars->token);
            else {
                if (!concat(B_expr, mars->token))
                    errprn(mars, BUFERR, mars->aline, "");
                mars->statefine = TRUE;
                automaton(mars, (char *) expr + idx, S_EXPR, cell);
            }
            break;
        case NUMBTOKEN:
            if (!concat(mars->token, " "))
                errprn(mars, BUFERR, mars->aline, "");
            /* FALLTHROUGH */
        case EXPRTOKEN:
            if (!concat(B_expr, mars->token))
                errprn(mars, BUFERR, mars->aline, "");
            mars->statefine = TRUE;
            automaton(mars, (char *) expr + idx, S_EXPR, cell);
            break;
        case CHARTOKEN:
            if ((atbl = lookup(mars, mars->token)) != NULL)
                if (atbl->visit)
                    errprn(mars, RECERR, mars->aline, mars->token);
                else if (atbl->reftype == RTEXT)
                    if (atbl->sline) {
                        atbl->visit = TRUE;
                        automaton(mars, atbl->sline->vline, S_EXPR, cell);
                        atbl->visit = FALSE;
                        automaton(mars, (char *) expr + idx, S_EXPR, cell);
                    } else
/* all slines should've been filled */
                        LOGICERROR;
                else if ((tmp = (char *) MALLOC(sizeof(char) * vallen)) != NULL) {
                    if (mars->opcode < OPNUM)
                        sprintf(tmp, "%d", (int) atbl->value - mars->line);
                    else
                        sprintf(tmp, "%d", (int) atbl->value);
                    atbl->visit = TRUE;
                    automaton(mars, tmp, S_EXPR, cell);
                    FREE(tmp);
                    atbl->visit = FALSE;
                    automaton(mars, (char *) expr + idx, S_EXPR, cell);
                } else
                    MEMORYERROR;
            else if (!mars->token[1])        /* check for register use */
                if (concat(B_expr, mars->token)) {
                    mars->statefine = TRUE;
                    automaton(mars, (char *) expr + idx, S_EXPR, cell);
                } else
                    errprn(mars, BUFERR, mars->aline, "");
            else
                errprn(mars, SNFERR, mars->aline, mars->token);
            break;
        case NONE:
            break;
        default:
            errprn(mars, APPERR, mars->aline, mars->token);
        }
        break;
    }
}

/* ******************************************************************* */

static void
dfashell(mars_t* mars, char* expr, mem_struct* cell)
{
    cell->A_mode = (FIELD_T) ch_in_set('$', addr_sym);
    cell->B_mode = (FIELD_T) ch_in_set('$', addr_sym);
    mars->modifier = MODNUM;                /* marked as not used */
    A_expr[0] = B_expr[0] = '\0';

    mars->errorcode = SUCCESS;
    automaton(mars, expr, S_OP, cell);

    if (mars->opcode < OPNUM) {

/* This is also represented in a NONE case in automaton function call */
        if ((mars->statefine == FALSE) && (mars->errorcode == SUCCESS))
            errprn(mars, SYNERR, mars->aline, opname[mars->opcode]);

        else if (B_expr[0] == '\0')        /* If there's only one argument */
            switch (mars->opcode) {
            case DAT:                /* The default in DAT statement is #0 */
                cell->B_mode = cell->A_mode;
                strcpy(B_expr, A_expr);
                cell->A_mode = (FIELD_T) ch_in_set('#', addr_sym);
                strcpy(A_expr, "0");
                break;
            case SPL:                /* The default in SPL/JMP statement is $0 */
            case JMP:
            case NOP:
                cell->B_mode = (FIELD_T) ch_in_set('$', addr_sym);
                strcpy(B_expr, "0");
                break;
            default:
                errprn(mars, NOPERR, mars->aline, opname[mars->opcode]);        /* opcode < OPNUM */
            }

        if (mars->modifier == MODNUM)        /* no modifier, pick default */
            switch (mars->opcode) {
            case DAT:
            case NOP:
                mars->modifier = (FIELD_T) mF;
                break;
            case MOV:
            case CMP:
            case SEQ:
            case SNE:
                if (cell->A_mode == (FIELD_T) IMMEDIATE)
                    mars->modifier = (FIELD_T) mAB;
                else if (cell->B_mode == (FIELD_T) IMMEDIATE)
                    mars->modifier = (FIELD_T) mB;
                else
                    mars->modifier = (FIELD_T) mI;
                break;
            case ADD:
            case SUB:
            case MUL:
            case DIV:
            case MOD:
                if (cell->A_mode == (FIELD_T) IMMEDIATE)
                    mars->modifier = (FIELD_T) mAB;
                else if (cell->B_mode == (FIELD_T) IMMEDIATE)
                    mars->modifier = (FIELD_T) mB;
                else
                    mars->modifier = (FIELD_T) mF;
                break;
            case LDP:
            case STP:
            case SLT:
                if (cell->A_mode == (FIELD_T) IMMEDIATE)
                    mars->modifier = (FIELD_T) mAB;
                else
                    mars->modifier = (FIELD_T) mB;
                break;
            default:
                mars->modifier = (FIELD_T) mB;
            }
        cell->opcode = (FIELD_T) (mars->opcode << 3) + mars->modifier;
    }
}

/* ******************************************************************* */

static int
normalize(mars_t* mars, long value)
{
    while (value >= (long) mars->coresize)
        value -= (long) mars->coresize;
    while (value < 0)
        value += (long) mars->coresize;
    return ((int) value);
}


/* ******************************************************************* */

#define SNIL 0
#define SLBL 1
#define SVAL 2
#define SCOM 3
#define SPSE 4
#define SFOR 5
#define SROF 6
#define SERR -1

/* ******************************************************************* */

static int
blkfor(mars_t* mars, char* expr, char* dest)
{
    int myEvalerr;
    line_st *cline;
    long    result;
    ref_st *atbl, *ptbl;
    grp_st *forSymGr;

    if (mars->symtbl) {
        forSymGr = addsym(mars, mars->symtbl->symn, NULL);
        if (mars->symtbl->nextsym) {
            newtbl(mars);
            mars->reftbl->reftype = RLABEL;
            mars->reftbl->grpsym = mars->symtbl->nextsym;
            mars->reftbl->value = mars->line;
        }
        /*disposegrp(mars->symtbl); */ /* memory leak fix by martinus */
        mars->symtbl = NULL;
        mars->symnum = 0;
    } else
        forSymGr = NULL;

    *dest = '\0';
    trav2(mars, expr, dest, SVAL);

    if ((myEvalerr = eval_expr(mars, dest, &result)) < OK_EXPR) {
        if (myEvalerr == DIV_ZERO)
            errprn(mars, DIVERR, mars->aline, "");
        else
            errprn(mars, EVLERR, mars->aline, "");
    } else if (result <= 0L) {
        if (myEvalerr == PMARS_OVERFLOW)
            errprn(mars, OFLERR, mars->aline, "");
        mars->statefine++;
    } else {
        if (myEvalerr == PMARS_OVERFLOW)
            errprn(mars, OFLERR, mars->aline, "");

        newtbl(mars);
        mars->reftbl->reftype = RSTACK;
        mars->reftbl->grpsym = forSymGr;
        mars->reftbl->visit = 1;
        atbl = mars->reftbl;

        cline = mars->aline;
        for (atbl->value = 1; mars->vcont && atbl->value <= (uShrt) result && mars->aline;
             atbl->value++)
            for (mars->aline = cline; mars->vcont;)
                if (mars->aline->nextline) {
                    int     r;

                    mars->aline = mars->aline->nextline;
                    *dest = '\0';
                    if ((r = trav2(mars, mars->aline->vline, dest, SNIL)) == SROF)
                        break;
                    else if (r == SCOM) {
                        addline(mars, dest, mars->aline->linesrc, mars->dspnt);
                        if (mars->dbginfo == 3)
                            mars->dbginfo = 0;
                    }
                } else {
                    errprn(mars, ROFERR, (line_st *) NULL, "");
                    mars->vcont = FALSE;
                }

        for (ptbl = NULL, atbl = mars->reftbl; atbl; ptbl = atbl, atbl = atbl->nextref)
            if (atbl->reftype == RSTACK)
                break;

        if (ptbl)
            ptbl->nextref = atbl->nextref;
        else
            mars->reftbl = atbl->nextref;

        disposetbl(atbl, atbl->nextref);
    }

    return SFOR;
}

/* ******************************************************************* */

static int
equtbl(mars_t* mars, char* expr)
{
    line_st *cline, *pline = NULL;
    uChar   i;

    if (mars->symtbl) {

        newtbl(mars);
        mars->reftbl->reftype = RTEXT;
        mars->reftbl->grpsym = mars->symtbl;
        mars->symtbl = NULL;
        mars->symnum = 0;

        if (((cline = (line_st *) MALLOC(sizeof(line_st))) != NULL) &&
            ((cline->vline = pstrdup(expr)) != NULL)) {
            cline->linesrc = mars->aline->linesrc;
            cline->nextline = NULL;
            pline = mars->reftbl->sline = cline;
        } else
            MEMORYERROR;

        while (mars->aline->nextline) {

            i = 0;
            get_token(mars->aline->nextline->vline, &i, mars->token);
            to_upper(mars->token);
            if (strcmp(mars->token, "EQU") == 0) {
                mars->aline = mars->aline->nextline;

                if (((cline = (line_st *) MALLOC(sizeof(line_st))) != NULL) &&
                    ((cline->vline = pstrdup((char *) mars->aline->vline + i)) != NULL)) {
                    cline->linesrc = mars->aline->linesrc;
                    cline->nextline = NULL;
                    pline = pline->nextline = cline;
                } else
                    MEMORYERROR;
            }
            else
                break;
        }
    } else
        errprn(mars, ANNERR, mars->aline, "");

    return SVAL;
}

/* ******************************************************************* */

static int equsub(mars_t* mars, char* expr, char* dest, int wdecl, ref_st* tbl)
{
    line_st *cline;

    tbl->visit = 1;
    cline = mars->aline;
    mars->aline = tbl->sline;
    wdecl = trav2(mars, mars->aline->vline, dest, wdecl);

    while (mars->aline->nextline && mars->vcont) {
        if (mars->statefine == 0)
            if (wdecl == SCOM) {
                addline(mars, dest, mars->aline->linesrc, mars->dspnt);
                if (mars->dbginfo == 3)
                    mars->dbginfo = 0;
            }
        mars->aline = mars->aline->nextline;
        *dest = '\0';
        wdecl = trav2(mars, mars->aline->vline, dest, SNIL);
    }

    mars->aline = cline;
    if (isspace(*expr))
        concat(dest, " ");

    tbl->visit = 0;
    return trav2(mars, expr, dest, wdecl);
}

/* ******************************************************************* */

/* recursively traverse the buffer */
/* buf[] has to be "" */
static int trav2(mars_t* mars, char* buffer, char* dest, int wdecl)
{
    int myEvalerr;
    uChar   idxp = 0;
    ref_st *tbl;

    switch (get_token(buffer, &idxp, mars->token)) {

    case NONE:
        return wdecl;

    case COMMTOKEN:
        if ((wdecl == SNIL) && (mars->statefine == 0)) {

            uChar   idx;

            idx = idxp;
            get_token(buffer, &idx, mars->token);
            to_upper(mars->token);
            if (strcmp(mars->token, "ASSERT") == 0) {
                long    result;

                trav2(mars, (char *) buffer + idx, dest, SVAL);

                if ((myEvalerr = eval_expr(mars, dest, &result)) < OK_EXPR)
                    errprn(mars, BASERR, mars->aline, "");
                else {
                    if (myEvalerr == PMARS_OVERFLOW)
                        errprn(mars, OFLERR, mars->aline, "");
                    mars->noassert = FALSE;
                    if (result == 0L)
                        errprn(mars, CHKERR, mars->aline, "");
                }
            }
        }
        return wdecl;

    case CHARTOKEN:

        strcpy(mars->buf, mars->token);
        to_upper(mars->buf);

        if (strcmp(mars->buf, "ROF") == 0)
            if (mars->statefine)
                mars->statefine--;
            else if (wdecl <= SLBL)
                return SROF;
            else
                errprn(mars, APPERR, mars->aline, mars->token);

        else if (strcmp(mars->buf, "FOR") == 0)
            if (mars->statefine)
                mars->statefine++;
            else if (wdecl <= SLBL)
                return blkfor(mars, (char *) buffer + idxp, dest);
            else
                errprn(mars, APPERR, mars->aline, mars->token);

        else if (strcmp(mars->token, "CURLINE") == 0)
            if (mars->statefine)
                return SNIL;
            else if (wdecl > SLBL) {
                sprintf(mars->buf, "%d", mars->line);
                if (isspace(buffer[idxp]))
                    concat(mars->buf, " ");
                if (concat(dest, mars->buf))
                    return (trav2(mars, (char *) buffer + idxp, dest, wdecl));
                else
                    errprn(mars, BUFERR, mars->aline, "");
            } else
                errprn(mars, MISC, mars->aline, CURLINEErr);

        else if (strcmp(mars->buf, "EQU") == 0)
            if (mars->statefine)
                return SNIL;
            else if (wdecl <= SLBL)
                return equtbl(mars, (char *) buffer + idxp);
            else
                errprn(mars, APPERR, mars->aline, mars->token);

        else if ((mars->opcode = str_in_set(mars->buf, opname)) < EQUOP)
            if (mars->statefine)
                return SNIL;

            else if (wdecl <= SLBL) {

                uChar   j, op;

                for (j = 0; mars->buf[j]; j++);

                while (buffer[idxp] && !isspace(buffer[idxp]))
                    mars->buf[j++] = buffer[idxp++];

                if (isspace(buffer[idxp])) {
                    mars->buf[j++] = ' ';
                    mars->buf[j] = '\0';
                }
                if (!concat(dest, mars->buf))
                    errprn(mars, BUFERR, mars->aline, "");

                else {
                    op = mars->opcode;
                    if ((wdecl = trav2(mars, (char *) buffer + idxp, dest,
                                       op < OPNUM ? SVAL : SPSE)) != SERR) {

                        if (mars->symtbl) {
                            newtbl(mars);
                            mars->reftbl->reftype = RLABEL;
                            mars->reftbl->value = mars->line;
                            mars->reftbl->grpsym = mars->symtbl;
                            mars->symtbl = NULL;
                            mars->symnum = 0;
                        }
                        if (op < OPNUM) {
                            mars->line++;
                            if (mars->dbginfo == 2)
                                mars->dbginfo++;
                        } else if (op == ENDOP)
                            mars->vcont = FALSE;

                        return SCOM;
                    } else
                        return SERR;
                }
            } else
                errprn(mars, APPERR, mars->aline, mars->token);

        else if (mars->statefine == 0) {

            char    tmp = 1;

            while ((buffer[idxp] == cat_sym) && (isalpha(buffer[idxp + 1])) &&
                   (idxp++, get_token(buffer, &idxp, mars->buf) == CHARTOKEN) && tmp)
                if (((tbl = lookup(mars, mars->buf)) != NULL) && (tbl->reftype == RSTACK)) {
                    sprintf(mars->buf, "%02u", (unsigned int) tbl->value);
                    if (!concat(mars->token, mars->buf))
                        errprn(mars, BUFERR, mars->aline, "");
                } else {
                    errprn(mars, CATERR, mars->aline, mars->buf);
                    tmp = 0;
                }

            if ((tbl = lookup(mars, mars->token)) != NULL)
                if (tbl->reftype == RTEXT)
                    if (tbl->visit)
                        errprn(mars, RECERR, mars->aline, mars->token);
                    else
                        return equsub(mars, (char *) buffer + idxp, dest, wdecl, tbl);

                else if (wdecl > SLBL) {
                    if (tbl->reftype == RSTACK)
                        sprintf(mars->buf, "%02u", (unsigned int) tbl->value);
                    else if (wdecl == SPSE)
                        sprintf(mars->buf, "%d", tbl->value);        /* absolute value */
                    else
                        sprintf(mars->buf, "%d", tbl->value - mars->line);        /* relative value */

                    if (isspace(buffer[idxp]))
                        concat(mars->buf, " ");

                    if (concat(dest, mars->buf))
                        return (trav2(mars, (char *) buffer + idxp, dest, wdecl));
                    else
                        errprn(mars, BUFERR, mars->aline, "");
                } else
                    errprn(mars, IDNERR, mars->aline, mars->token);

            else if (wdecl <= SLBL) {
                if (mars->symnum < GRPMAX) {
                    mars->symtbl = addsym(mars, mars->token, mars->symtbl);
                    mars->symnum++;
                } else
                    errprn(mars, GRPERR, mars->aline, mars->token);

                if (buffer[idxp] == cln_sym)        /* ignore a colon after a line-label */
                    idxp++;

                /* traverse the rest of buffer */
                return trav2(mars, (char *) buffer + idxp, dest, SLBL);
            } else {
                if (isspace(buffer[idxp]))
                    concat(mars->token, " ");
                if (concat(dest, mars->token))
                    return (trav2(mars, (char *) buffer + idxp, dest, wdecl));
                else
                    errprn(mars, BUFERR, mars->aline, "");
            }
        } else
            return trav2(mars, (char *) buffer + idxp, dest, SNIL);
        break;
    default:
        if (mars->statefine)
            return SNIL;
        else if (wdecl <= SLBL)
            errprn(mars, TOKERR, mars->aline, mars->token);
        else {
            if (concat(dest, mars->token))
                return trav2(mars, (char *) buffer + idxp, dest, wdecl);
            else
                errprn(mars, BUFERR, mars->aline, "");
        }
    }
    return SERR;
}

/* ******************************************************************* */

/* collect and expand equ */
static void expand(mars_t* mars, uShrt sspnt)
{
    mars->dspnt = 1 - sspnt;
    disposeline(mars->sline[mars->dspnt]);
    mars->sline[mars->dspnt] = NULL;

    mars->vcont = TRUE;
    mars->statefine = 0;
    mars->linemax = (uShrt) mars->maxWarriorLength + LEXCMAX;

    mars->aline = mars->sline[sspnt];
    while (mars->aline && mars->vcont) {
        mars->buf2[0] = '\0';
        switch (trav2(mars, mars->aline->vline, mars->buf2, SNIL)) {
        case SCOM:
            addline(mars, mars->buf2, mars->aline->linesrc, mars->dspnt);
            if (mars->dbginfo == 3)
                mars->dbginfo = 0;
            break;
        case SFOR:
            break;
        case SROF:
            errprn(mars, FORERR, mars->aline, "");
        }
        mars->aline = mars->aline->nextline;
    }
}

/* ******************************************************************* */

static char stdinstart = 0;


/****************************************************/
/* martinus */
/****************************************************/

int globalswitch_warrior(mars_t* mars, warrior_struct* w, char* str, uShrt idx, uShrt loc, uShrt lspnt) 
{
    uChar   i;
    i = (uChar) idx;

    get_token(str, &i, mars->token);
    to_upper(mars->token);

    if (!strcmp(mars->token, "REDCODE") && i == idx + 7)        /* no leading spaces */
        return -1;

    while (isspace(str[i]))
        i++;

    if (strcmp(mars->token, "NAME") == 0) {
        FREE(w->name);
        if (str[i] == '\0')
            w->name = pstrdup(unknown);
        else
            w->name = pstrdup((char *) str + i);
    } else if (strcmp(mars->token, "AUTHOR") == 0) {
        FREE(w->authorName);
        if (str[i] == '\0')
            w->authorName = pstrdup(anonymous);
        else
            w->authorName = pstrdup((char *) str + i);
    } else if (strcmp(mars->token, "DATE") == 0) {
        FREE(w->date);
        if (str[i] == '\0')
            w->date = pstrdup("");
        else
            w->date = pstrdup((char *) str + i);
    } else if (strcmp(mars->token, "VERSION") == 0) {
        FREE(w->version);
        if (str[i] == '\0')
            w->version = pstrdup("");
        else
            w->version = pstrdup((char *) str + i);
    } else if (str_in_set(mars->token, swname) < SWNUM) {
        nocmnt(str + i);                /* don't remove first comment */
        addline(mars, str, addlinesrc(mars, str, loc), lspnt);
    }
    return 0;
}




void encode_warrior(mars_t* mars, warrior_struct* w, uShrt sspnt)
{
    int evalerrA, evalerrB;
    long    resultA, resultB;
    mem_struct *base;

/*  if (line <= MAXINSTR) { */

    if (mars->line > (uShrt) mars->maxWarriorLength) {
        sprintf(mars->buf, "%ld", mars->line - mars->maxWarriorLength);
        errprn(mars, LINERR, (line_st *) NULL, mars->buf);
    }
    w->instLen = mars->line;

    if (mars->line)
        if ((w->instBank = base = (mem_struct *)
             MALLOC((mars->line + 1) * sizeof(mem_struct))) != NULL) {
            for (mars->aline = mars->sline[sspnt], mars->line = 0; mars->aline; mars->aline = mars->aline->nextline) {
                dfashell(mars, mars->aline->vline, (mem_struct *) base + mars->line);
                if (mars->errnum == 0) {
                    if (*A_expr == '\0')
                        strcpy(A_expr, "0");
                    if (*B_expr == '\0')
                        strcpy(B_expr, "0");

                    if ((mars->opcode == ENDOP) || (mars->opcode == ORGOP)
#ifdef SHARED_PSPACE
                        || (mars->opcode == PINOP)
#endif
                        )
                        if ((evalerrA = eval_expr(mars, B_expr, &resultB)) < OK_EXPR) {
                            if (evalerrA == DIV_ZERO)
                                errprn(mars, DIVERR, mars->aline, "");
                            else
                                errprn(mars, EVLERR, mars->aline, "");
                        } else {                /* by absolute */
                            if (evalerrA == PMARS_OVERFLOW)
                                errprn(mars, OFLERR, mars->aline, "");

                            if (mars->opcode == ORGOP)
                                w->offset = normalize(mars, resultB);
#ifdef SHARED_PSPACE
                            else if (mars->opcode == PINOP) {
                                w->pSpaceIDNumber = resultB;        /* not an address, no
                                                                     * need to normalize */
                                w->pSpaceIndex = PIN_APPEARED;        /* to indicate PIN has
                                                                       * been set */
                            }
#endif
                            else if (resultB) {
                                if (w->offset)
                                    errprn(mars, DOEERR, mars->aline, "");
                                else
                                    w->offset = normalize(mars, resultB);
                            }
                            /* else ignore 'end' with parameter == 0L */
                        }
                    else if ((evalerrA = eval_expr(mars, A_expr, &resultA)) < OK_EXPR) {
                        if (evalerrA == DIV_ZERO)
                            errprn(mars, DIVERR, mars->aline, "");
                        else
                            errprn(mars, EVLERR, mars->aline, "");
                    } else if ((evalerrB = eval_expr(mars, B_expr, &resultB)) < OK_EXPR) {
                        if (evalerrB == DIV_ZERO)
                            errprn(mars, DIVERR, mars->aline, "");
                        else
                            errprn(mars, EVLERR, mars->aline, "");
                    } else {
                        if (evalerrA == PMARS_OVERFLOW || evalerrB == PMARS_OVERFLOW)
                            errprn(mars, OFLERR, mars->aline, "");
                        base[mars->line].A_value = (ADDR_T) normalize(mars, resultA);
                        base[mars->line].B_value = (ADDR_T) normalize(mars, resultB);
                        if ((base[mars->line++].debuginfo = (FIELD_T) mars->aline->dbginfo) != 0) {
                            /* debugState = BREAK; */
                            /* not supported */
                        }
                    }
                }
            }
            if ((w->offset < 0) ||
                (w->offset >= w->instLen))
                errprn(mars, OFSERR, (line_st *) NULL, "");
        } else
            MEMORYERROR;
    else
        errprn(mars, ZLNERR, (line_st *) NULL, "");
    /*
      } else
      errprn(mars, EXXERR, (line_st *) NULL, "");
    */
}



int assemble_warrior(mars_t* mars, char* fName, warrior_struct* w)
{
    FILE   *infp = 0;
    uChar   cont = TRUE, conLine = FALSE, i;
    uShrt   lines;                /* logical and physical lines */
    uShrt   spnt = 0;                /* index/pointer to sline and lline */

    /* release all allocated memory */
    mars->errorlevel = WARNING;
    mars->errorcode = SUCCESS;
    *(mars->errmsg) = '\0';
    mars->errnum = mars->warnum = 0;

    mars->pass = 0;

    mars->srctbl = NULL;
    mars->sline[0] = mars->sline[1] = NULL;
    mars->reftbl = NULL;
    mars->symtbl = NULL;
    mars->symnum = 0;

    lines = 0;
    mars->ierr = 0;

    if (mars->errkeep == NULL) {
        if ((mars->errkeep = (err_st *) MALLOC(sizeof(err_st) * ERRMAX)) == NULL)
            MEMORYERROR;
    }

    w->name = pstrdup(unknown);
    w->authorName = pstrdup(anonymous);
    w->date = pstrdup("");
    w->version = pstrdup("");
    w->pSpaceIndex = UNSHARED;        /* tag */

    /* These two inits turn out to be neccessary */
    w->instBank = NULL;
    w->instLen = 0;
    mars->dbgproceed = TRUE;
    mars->dbginfo = FALSE;
    mars->noassert = TRUE;

    addpredefs(mars);

    /* stage 1: file reading module */
    if ((*fName == '\0') || (infp = fopen(fName, "r")) != NULL) {

        char    pstart;

        if (*fName == '\0') {
            infp = stdin;
            pstart = stdinstart;
        } else
            pstart = 0;

        lines = 0;
        mars->aline = NULL;

        while (cont) {

            /*
             * Read characters until newline or EOF encountered. newline is
             * excluded. Need to be non-strict boolean evaluation
             */
            *(mars->buf) = '\0';
            i = 0;                        /* pointer to line buffer start */

            do {
                if (fgets(mars->buf + i, MAXALLCHAR - i, infp)) {
                    for (; mars->buf[i]; i++)
                        if (mars->buf[i] == '\n' || mars->buf[i] == '\r')
                            break;
                    mars->buf[i] = 0;
                    if (mars->buf[i - 1] == '\\') {        /* line continued */
                        conLine = TRUE;
                        mars->buf[--i] = 0;        /* reset */
                    } else
                        conLine = FALSE;
                } else if (ferror(infp)) {
                    errprn(mars, DSKERR, (line_st *) NULL, fName);
                    fclose(infp);
                    return PARSEERR;
                } else
                    cont = (feof(infp) == 0);
            } while (conLine == TRUE);
            lines++;
            i = 0;

            switch (get_token(mars->buf, &i, mars->token)) {
                /*
                 * COMMTOKEN before any non-whitespace chars may contains switches.
                 * We treat them first and therefore we don't have to save it in
                 * sline
                 */
            case COMMTOKEN:
                if ((globalswitch_warrior(mars, w, mars->buf, (uShrt) i, lines, spnt))) {        /* REDCODE? */
                    switch (pstart) {
                    case 0:
                        disposeline(mars->sline[spnt]);
                        mars->sline[spnt] = mars->lline[spnt] = NULL;
                        pstart++;
                        break;
                    case 1:
                        pstart++;
                        /* fallthru */
                    case 2:
                        cont = 0;
                        break;
                    }
				}
                break;
				
            case NONE:
                break;
				
            default:
                nocmnt(mars->buf);                /* saving some space */
                addline(mars, mars->buf, addlinesrc(mars, mars->buf, lines), spnt);
                break;
            }
        } /* !while */
        if (pstart)
            pstart--;

        if (*fName)
            fclose(infp);
        else
            stdinstart = pstart;        /* save value for next stdin reference */

        mars->line = 0;
        expand(mars, spnt);

        if (mars->symtbl) {
            grp_st *tmp;

            *(mars->buf) = '\0';
            for (tmp = mars->symtbl; tmp; tmp = tmp->nextsym) {
                if (*(mars->buf))
                    if (!concat(mars->buf, " "))
                        break;
                if (!concat(mars->buf, tmp->symn))
                    break;
            }

            errprn(mars, DLBERR, (line_st *) NULL, mars->buf);
            disposegrp(mars->symtbl);        /* discount any mars->symtbl with empty reference */
            mars->symtbl = NULL;
            mars->symnum = 0;
        }
        spnt = 1 - spnt;
        mars->pass++;

        if (mars->noassert)
            errprn(mars, NASERR, (line_st *) NULL, "");

        /* printf("Entering pass 2 (parsing and loading)\n"); */
        encode_warrior(mars, w, spnt);

        mars->dbginfo = FALSE;
        mars->dbgproceed = TRUE;
        /* release all allocated memory */
        cleanmem(mars);
        while (mars->srctbl) {
            src_st *tmp = mars->srctbl;
            mars->srctbl = mars->srctbl->nextsrc;
            FREE(tmp->src);
            FREE(tmp);
        }

        if (mars->errnum) {
            FREE(w->instBank);
            w->instLen = 0;
        }
        if (mars->errnum) {
            sprintf(mars->outs, errNumMsg, mars->errnum);
            textout(mars->outs);
        }
        if (mars->warnum) {
            sprintf(mars->outs, warNumMsg, mars->warnum);
            textout(mars->outs);
        }
        while (mars->ierr)
            if (mars->errkeep[--(mars->ierr)].num > 1) {
                sprintf(mars->outs, duplicateMsg, mars->errkeep[mars->ierr].loc, mars->errkeep[mars->ierr].num);
                textout(mars->outs);
            }
        if (mars->errnum + mars->warnum) {
            sprintf(mars->outs, "\n");
            textout(mars->outs);
        }
    } else
        errprn(mars, FNFERR, (line_st *) NULL, fName);

    if (mars->errnum)
        mars->errorcode = PARSEERR;
    else
        mars->errorcode = SUCCESS;
    reset_regs(mars);
    return (mars->errorcode);
}


/* exhaust related */


/* pmars/rng.c random number generator
 */
s32_t rng(s32_t seed)
{
    /* return FIX2INT(rb_eval_string("rand(2147483647)")); */
    register s32_t temp = seed;
    temp = 16807 * (temp % 127773) - 2836 * (temp / 127773);
    if (temp < 0)
        temp += 2147483647;
    return temp;
}


void panic(char *msg)
{
    /*  fprintf(stderr, "%s: ", prog_name );*/
    fprintf(stderr, "%s", msg );
    exit(1);
}


void usage(void)
{
    printf("exmasr v%d.%d\n", VERSION, REVISION );
    printf("usage: exhaust [opts] warriors...\n");
    printf("opts: -r <rounds>, -c <cycles>, -F <pos>, -s <coresize>,\n"
           "      -p <maxprocs>, -d <minsep>, -bk\n");
    exit(1);
}

void clear_results(mars_t* mars)
{
    memset(mars->results, 0, sizeof(u32_t)*mars->nWarriors*(mars->nWarriors+1));
    /*
      unsigned int i, j;
      for (i=0; i<NWarriors; i++) {
      for (j=0; j<=NWarriors; j++) {
      Results[i*(NWarriors+1) + j] = 0;
      }
      }
    */
}

void save_pspaces(mars_t* mars)
{
    memcpy(mars->pspaces, mars->pspacesOrigin, sizeof(pspace_t *)*mars->nWarriors );
}

void amalgamate_pspaces(mars_t* mars)
{
    unsigned int i, j;

    /* Share p-space according to PINs. */
    for (i=0; i<mars->nWarriors; i++) {
        if ( mars->warriors[i].have_pin ) {
            for (j=0; j<i; j++) {
                if ( mars->warriors[j].have_pin &&
                     mars->warriors[j].pin == mars->warriors[i].pin )
                {
                    pspace_share(mars->pspaces[i], mars->pspaces[j]);
                }
            }
        }
    }
}


void load_warriors(mars_t* mars)
{
    unsigned int i;
    for (i=0; i<mars->nWarriors; i++) {
        sim_load_warrior(mars, mars->positions[i], mars->warriors[i].code, mars->warriors[i].len);
    }
}

void set_starting_order(unsigned int round, mars_t* mars)
{
    unsigned int i;

    /* Copy load positions into starting positions array
       with a cyclic shift of rounds places. */
    for (i=0; i<mars->nWarriors; i++) {
        unsigned int j = (i+round) % (mars->nWarriors);
        mars->startPositions[i] =(field_t)((mars->positions[j] + mars->warriors[j].start ) % (mars->coresize));
    }

    /* Copy p-spaces into simulator p-space array with a
       cyclic shift of rounds places. */
    /*
      ps = sim_get_pspaces();
      for (i=0; i<NWarriors; i++) {
      ps[i] = PSpaces[(i + round) % NWarriors];
      }
    */
    for (i=0; i<mars->nWarriors; i++) {
        mars->pspacesOrigin[i] = mars->pspaces[(i + round) % (mars->nWarriors)];
    }
}

void accumulate_results(mars_t* mars)
{
    unsigned int i;

    /* Fetch the results of the last round from p-space location 0
       that has been updated by the simulator. */
    for (i=0; i<mars->nWarriors; i++) {
        unsigned int result;
        result = pspace_get(mars->pspaces[i], 0);
        /* printf("%d ", result); */
        mars->results[i*(mars->nWarriors+1) + result]++;
    }
}

void accumulate_results(mars_t* source, mars_t* target) {
    for (u32_t i = 0; i<source->nWarriors * (source->nWarriors + 1); i++) {
        target->results[i] += source->results[i];
    }
}

void output_results(mars_t* mars)
{
    unsigned int i;
    unsigned int j;

    if (mars->nWarriors == 2 && !mars->isMultiWarriorOutput) {
        printf("%ld %ld\n", mars->results[0*(mars->nWarriors+1) + 1], mars->results[0*(mars->nWarriors+1) + 2]);
        printf("%ld %ld\n", mars->results[1*(mars->nWarriors+1) + 1], mars->results[1*(mars->nWarriors+1) + 2]);
    } else {
        for (i=0; i<mars->nWarriors; i++) {
            for (j=1; j<=mars->nWarriors; j++) {
                printf("%ld ", mars->results[i*(mars->nWarriors+1) + j]);
            }
            printf("%ld\n", mars->results[i*(mars->nWarriors+1) + 0]);
        }
    }
}

/*---------------------------------------------------------------
 * Warrior positioning algorithms
 *
 * These are pMARS compatible.  Warrior 0 is always positioned at 0.
 * posit() and npos() are transcribed from pmars/pos.c.  */

#define RETRIES1 20                /* how many times to try generating one
                                    * position */
#define RETRIES2 4                /* how many times to start backtracking */
int posit(s32_t *seed, mars_t* mars)
{
    unsigned int pos = 1, i;
    unsigned int retries1 = RETRIES1, retries2 = RETRIES2;
    int     diff;

    do {
        /* generate */
        *seed = rng(*seed);
        /*mars->positions[pos] = (field_t)(rand()%(mars->coresize - 2*mars->minsep+1) + mars->minsep);*/
        mars->positions[pos] = (field_t)((*seed % (mars->coresize - 2*mars->minsep+1))+mars->minsep);

        /* test for overlap */
        for (i = 1; i < pos; ++i) {
            /* calculate positive difference */
            diff = (int) mars->positions[pos] - mars->positions[i];
            if (diff < 0)
                diff = -diff;
            if ((unsigned int)diff < mars->minsep)
                break;      /* overlap! */
        }

        if (i == pos)       /* no overlap, generate next number */
            ++pos;
        else {          /* overlap */
            if (!retries2)
                return 1;   /* exceeded attempts, fail */
            if (!retries1) {    /* backtrack: generate new sequence starting */
                pos = i;    /* at arbitrary position (last conflict) */
                --retries2;
                retries1 = RETRIES1;
            } else      /* generate new current number (pos not
                         * incremented) */
                --retries1;
        }
    } while (pos < mars->nWarriors);
    return 0;
}

void npos(s32_t *seed, mars_t* mars)
{
    unsigned int i, j;
    unsigned int temp;
    unsigned int room = mars->coresize - mars->minsep*mars->nWarriors+1;

    /* Choose NWarriors-1 positions from the available room. */
    for (i = 1; i < mars->nWarriors; i++) {
        *seed = rng(*seed);
        temp = *seed % room;
        for (j = i - 1; j > 0; j--) {
            if (temp > mars->positions[j])
                break;
            mars->positions[j+1] = mars->positions[j];
        }
        mars->positions[j+1] = temp;
    }

    /* Separate the positions by minsep cells. */
    temp = mars->minsep;
    for (i = 1; i < mars->nWarriors; i++) {
        mars->positions[i] += temp;
        temp += mars->minsep;
    }

    /* Random permutation of positions. */
    for (i = 1; i < mars->nWarriors; i++) {
        *seed = rng(*seed);
        j = *seed % (mars->nWarriors - i) + i;
        temp = mars->positions[j];
        mars->positions[j] = mars->positions[i];
        mars->positions[i] = temp;
    }
}


s32_t compute_positions(s32_t seed, mars_t* mars)
{
    u32_t avail = mars->coresize+1 - mars->nWarriors * mars->minsep;

    mars->positions[0] = 0;

    /* Case single warrior. */
    if (mars->nWarriors == 1) return seed;

    /* Case one on one. */
    if (mars->nWarriors == 2) {
        mars->positions[1] = (field_t)(mars->minsep + seed % avail);
        /*printf("s: %ld\n", mars->positions[pos]),
          ++seedtest[mars->positions[pos]];*/
        seed = rng(seed);
        return seed;
    }

    if (mars->nWarriors>2) {
        if (posit(&seed, mars)) {
            npos(&seed, mars);
        }
    }
    return seed;
}

void check_sanity(mars_t* mars)
{
    u32_t space_used;
    unsigned int i;

    /* Make sure each warrior has some code. */
    for (i=0; i<mars->nWarriors; i++) {
        if (mars->warriors[i].len == 0) {
            sprintf(mars->errmsg,"warrior %d has no code\n", i);
            panic(mars->errmsg);
        }
    }

    /* Make sure there is some minimum sepation. */
    if ( mars->minsep == 0 ) {
        mars->minsep = min(mars->coresize/mars->nWarriors, mars->maxWarriorLength);
    }

    /* Make sure minsep dominates the lengths of all warriors. */
    for (i=0; i<mars->nWarriors; i++) {
        if ( mars->minsep < mars->warriors[i].len ) {
            panic("minimum separation must be >= longest warrior\n");
        }
    }

    /* Make sure there is space for all warriors to be loaded. */
    space_used = mars->nWarriors*mars->minsep;
    if ( space_used > mars->coresize ) {
        panic("warriors too large to fit into core\n");
    }
}


/*
 * parse options
 */
void readargs(int argc, char** argv, mars_t* mars) {
    int n;
    char c;
    int cix;
    int tmp;
    warriorNames_t* currWarrior = NULL;

    mars->warriorNames = NULL;
    mars->nWarriors = 0;
    n = 1;
    while ( n < argc ) {
        cix = 0;
        c = argv[n][cix++];
        if ( c == '-' && argv[n][1] ) {
            do {
                c = argv[n][cix++];
                if (c)
                    switch (c) {

                    case 'k': break;
                    case 'b': break;
                    case 'm': mars->isMultiWarriorOutput = 1; break;

                    case 'F':
                        if ( n == argc-1 || !isdigit(argv[n+1][0]) )
                            panic( "bad argument for option -F\n");
                        c = 0;
                        mars->fixedPosition = atoi( argv[++n] );
                        break;

                    case 's':
                        if ( n == argc-1 || !isdigit(argv[n+1][0]) )
                            panic( "bad argument for option -s\n");
                        c = 0;
                        mars->coresize = atoi( argv[++n] );
                        if ( mars->coresize <= 0 )
                            panic( "core size must be > 0\n");
                        break;

                    case 'd':
                        if ( n == argc-1 || !isdigit(argv[n+1][0]) )
                            panic( "bad argument for option -d\n");
                        c = 0;
                        mars->minsep = atoi( argv[++n] );
                        if ( (int)mars->minsep <= 0 )
                            panic( "minimum warrior separation must be > 0\n" );
                        break;

                    case 'p':
                        if ( n == argc-1 || !isdigit(argv[n+1][0]) )
                            panic( "bad argument for option -p\n");
                        c = 0;
                        mars->processes = atoi( argv[++n] );
                        if ( mars->processes <= 0 )
                            panic( "max processes must be > 0\n" );
                        break;

                    case 'r':
                        if ( n == argc-1 || !isdigit(argv[n+1][0]) )
                            panic( "bad argument for option -r\n");
                        c = 0;
                        tmp = atoi( argv[++n] );
                        if ( tmp < 0 )
                            panic( "can't do a negative number of rounds!\n" );
                        mars->rounds = tmp;
                        break;
                    case 'c':
                        if ( n == argc-1 || !isdigit(argv[n+1][0]) )
                            panic( "bad argument for option -c\n");
                        c = 0;
                        mars->cycles = atoi( argv[++n] );
                        if ( mars->cycles <= 0 )
                            panic( "cycles must be > 0\n" );
                        break;
                    default:
                        sprintf(mars->errmsg,"unknown option '%c'\n", c);
                        panic(mars->errmsg);
                    }
            } while (c);

        } else /* it's a file name */ {
            /*
              if (NWarriors == MAX_WARRIORS) {
              panic("too many warriors\n");
              }
            */
            mars->nWarriors++;
            if (mars->warriorNames == NULL) {
                mars->warriorNames = (warriorNames_t*)malloc(sizeof(warriorNames_t));
                currWarrior = mars->warriorNames;
            }
            else { 
                currWarrior->next = (warriorNames_t*)malloc(sizeof(warriorNames_t));
                currWarrior = currWarrior->next;
            }
            currWarrior->warriorName = argv[n];
            currWarrior->next = NULL;
        }
        n++;
    }

    if ( mars->nWarriors == 0 )
        usage();
}


mars_t* init(int argc, char** argv) {
    mars_t* mars = 0;
    mars = (mars_t*)malloc(sizeof(mars_t));
    memset(mars, 0, sizeof(mars_t));
    mars->rounds = 1;
    mars->cycles = 80000;
    mars->coresize = 8000;
    mars->processes = 8000;
    mars->maxWarriorLength = 100;
    //mars->seed = rng((s32_t)time(0)*0x1d872b41);
    mars->minsep = 100;
    mars->nWarriors = 2;
    /* pmars */
    mars->errorcode = SUCCESS;
    mars->errorlevel = WARNING;
    mars->saveOper = 0;
    mars->errmsg[0] = '\0';                /* reserve for future */

    readargs(argc, argv, mars);
    if (!sim_alloc_bufs(mars)) {
        printf("memory alloc failed.\n");
        exit(1);
    }
    return mars;
}

/* convert pmars parsed warriors to exhaust's format */
void pmars2exhaust(mars_t* mars, warrior_struct** warriors, int wCount)
{
    int currWarrior;
    for(currWarrior=0; currWarrior<wCount; ++currWarrior) {
        int i;
        warrior_struct* w = warriors[currWarrior];
            
        /* exhaust */
        warrior_t* warrior = &(mars->warriors[currWarrior]);
        insn_t* in = NULL;
        warrior->start = w->offset;
        warrior->len = w->instLen;
        warrior->have_pin = 0; /* TODO! */
        in = warrior->code;
        
        for (i=0; i < w->instLen; ++i) {
            /* pmars */
            mem_struct* cell = w->instBank + i;
            FIELD_T opcode = ((FIELD_T) (cell->opcode & 0xf8)) >> 3;
            FIELD_T modifier = (cell->opcode & 0x07);

            /* exhaust */
            int op, m, ma, mb;
            int flags = 0;
            
            op = p2eOp[opcode];
            m = p2eModifier[modifier];
            
            ma = PM_INDIR_A(cell->A_mode) ? p2eAddr[INDIR_A_TO_SYM(cell->A_mode)] : p2eAddr[cell->A_mode];
            in->a = MODS(cell->A_value, (int)mars->coresize);
            mb = PM_INDIR_A(cell->B_mode) ? p2eAddr[INDIR_A_TO_SYM(cell->B_mode)] : p2eAddr[cell->B_mode];
            in->b = MODS(cell->B_value, (int)mars->coresize);            

            in->in = (flags << flPOS) | OP( op, m, ma, mb );
            ++in;
            
            /* build new instruction */
            /*
              sprintf(instrStr, "Instruction.new(\"%s\", \"%s\", \"%c\", %d, \"%c\", %d)",
              replaceOpname,
              modname[modifier],
              PM_INDIR_A(cell->A_mode) ? addr_sym[INDIR_A_TO_SYM(cell->A_mode)] : addr_sym[cell->A_mode],
              cell->A_value,
              PM_INDIR_A(cell->B_mode) ? addr_sym[INDIR_A_TO_SYM(cell->B_mode)] : addr_sym[cell->B_mode],
              cell->B_value);
              rb_ary_push(rInstructions, rb_eval_string(instrStr));
            */
        }   
    
    }
}


#include <vector>
#include <thread>

int main(int argc, char** argv) {
    const int numThreads = std::thread::hardware_concurrency();
    std::cout << "using " << numThreads << " threads" << std::endl;

    // create mars
    std::vector<mars_t*> mars(numThreads);
#pragma omp parallel for
    for (int i = 0; i < numThreads; ++i) {
        mars[i] = init(argc, argv);
    }

    // load warriors into pmars data structure */
    warriorNames_t* currWarrior = mars[0]->warriorNames;
    warrior_struct** warriors = (warrior_struct**)malloc(sizeof(warrior_struct*)*mars[0]->nWarriors);
    u32_t i = 0;
    while (currWarrior != NULL)
    {
        warrior_struct* w = (warrior_struct*)MALLOC(sizeof(warrior_struct));
        warriors[i] = w;

        memset(w, 0, sizeof(warrior_struct));
        if (assemble_warrior(mars[0], currWarrior->warriorName, w)) {
            printf("can not load warrior '%s'\n", w->fileName);
        }
        currWarrior = currWarrior->next;
        ++i;
    }

    // convert warriors
    omp_set_num_threads(numThreads);

    u32_t seed = 0;
    if (mars[0]->fixedPosition) {
        seed = mars[0]->fixedPosition - mars[0]->minsep;
    }
    else {
        seed = rng((s32_t)time(0) * 0x1d872b41);
        seed = rng(seed);
    }

    auto start = std::chrono::system_clock::now();

#pragma omp parallel for
    for (int i = 0; i < numThreads; ++i) {
        pmars2exhaust(mars[i], warriors, mars[0]->nWarriors);
        check_sanity(mars[i]);
        clear_results(mars[i]);

        save_pspaces(mars[i]);
        amalgamate_pspaces(mars[i]);   /* Share P-spaces with equal PINs */
    }

    // precompute all seeds
    std::vector<u32_t> seeds;
    for (u32_t i = 0; i < mars[0]->rounds; ++i) {
        seeds.push_back(seed);
        seed = compute_positions(seed, mars[0]);
    }

#pragma omp parallel for
    for (int i = 0; i < (int)mars[0]->rounds; ++i) {
        int thread = omp_get_thread_num();
        sim_clear_core(mars[thread]);

        seed = compute_positions(seeds[i], mars[thread]);
        load_warriors(mars[thread]);
        set_starting_order(i, mars[thread]);

        int nalive = sim_mw(mars[thread], mars[thread]->startPositions, mars[thread]->deaths);
        if (nalive<0)
            panic("simulator panic!\n");

        accumulate_results(mars[thread]);
    }

    // accumulate all results into mars[0]
    for (int i = 1; i < numThreads; ++i) {
        accumulate_results(mars[i], mars[0]);
    }

    auto sec = std::chrono::duration<double>(std::chrono::system_clock::now() - start).count();
    output_results(mars[0]);

    //std::cout << sec << " seconds, " << (mars[0]->rounds / sec) << " evals per second" << std::endl;
}


int oldmain(int argc, char** argv) {
    u32_t i, seed;
    warriorNames_t* currWarrior;
    warrior_struct** warriors;

    /* setup mars */
    mars_t* mars = init(argc, argv);
    if ( mars->nWarriors == 0 )
        usage();

    
    /* load warriors into pmars data structure */
    currWarrior = mars->warriorNames;
    warriors = (warrior_struct**)malloc(sizeof(warrior_struct*)*mars->nWarriors);
    i=0;
    while (currWarrior != NULL) 
    {
        warrior_struct* w = (warrior_struct*)MALLOC(sizeof(warrior_struct));
        warriors[i] = w;
        
        memset(w, 0, sizeof(warrior_struct));
        if (assemble_warrior(mars, currWarrior->warriorName, w)) {
            printf("can not load warrior '%s'\n", w->fileName);
        }
        currWarrior = currWarrior->next;
        ++i;
    }

    /* print warriors */
#if 0
    for (i=0; i<mars->nWarriors; ++i) 
    {
        warrior_struct* w = warriors[i];
        fprintf(STDOUT, "Program \"%s\" (length %d) by \"%s\"\n\n", w->name, w->instLen, w->authorName);
        disasm(mars, w->instBank, w->instLen, w->offset);    
        fprintf(STDOUT, "\n\n");        
    }
#endif
    
    /*  convert warriors */
    pmars2exhaust(mars, warriors, mars->nWarriors);
#if 0
    for (i=0; i<mars->nWarriors; ++i) 
    {
        discore(mars->warriors[i].code, 0, mars->warriors[i].len, mars->coresize);
    }
#endif
    /* fight! */
    auto start = std::chrono::system_clock::now();

    check_sanity(mars);
    clear_results(mars);

    if (mars->fixedPosition) {
        seed = mars->fixedPosition - mars->minsep;
    } else {
        seed = rng((s32_t)time(0) * 0x1d872b41);
        seed = rng(seed);
    }

    save_pspaces(mars);
    amalgamate_pspaces(mars);   /* Share P-spaces with equal PINs */

    /* Fight rounds rounds. */

    for (i=0; i < mars->rounds; ++i) {
        int nalive;
        sim_clear_core(mars);

        seed = compute_positions(seed, mars);
        load_warriors(mars);
        set_starting_order(i, mars);

        nalive = sim_mw(mars, mars->startPositions, mars->deaths);
        if (nalive<0)
            panic("simulator panic!\n");    

        accumulate_results(mars);
    }
    //mars->seed = seed;

    auto sec = std::chrono::duration<double>(std::chrono::system_clock::now() - start).count();
    output_results(mars);

    std::cout << sec << " seconds, " << (mars->rounds / sec) << " evals per second" << std::endl;
    sim_free_bufs(mars);
    
    FREE(warriors);
	return 0;
}

