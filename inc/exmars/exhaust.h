#ifndef EXHAUST_H
#define EXHAUST_H
/*  exhaust.h:  Global constants, structures, and types
 * $Id: exhaust.h,v 1.3 2003/08/19 15:59:53 martinus Exp $
 */

/* This file is part of `exhaust', a memory array redcode simulator.
 * Copyright (C) 2002 M Joonas Pihlaja
 * Public Domain.
 */


/* global debug level */
#ifndef DEBUG
#define DEBUG 0
#endif


#define SUCCESS    0
#define WARNING    0


/***** Others which don't have MALLOC() defined. *****/

#if !defined(MALLOC)
#define MALLOC(x)     malloc((size_t)(x))
#define REALLOC(x, y) realloc((pointer_t)(x), (size_t)(y))
#define FREE(x)       { free((pointer_t)(x)); (x)=NULL; }
#endif                                /* ! MALLOC */


/* used by sim.c and asm.c */
#define PM_INDIR_A(x) (0x80 & (x))
#define PM_RAW_MODE(x) (0x7F & (x))
#define SYM_TO_INDIR_A(x) ( ((x) - 3) | 0x80)        /* turns index into
                                                      * addr_sym[] to INDIR_A code */
#define INDIR_A_TO_SYM(x) ( PM_RAW_MODE(x) + 3 )        /* vice versa */



/* pmars typedefs */
/* Generic Pointer type */
typedef void *pointer_t;
/* unsigned types (renamed to avoid conflict with possibly predefined types) */
typedef unsigned char uChar;
typedef unsigned short uShrt;
typedef unsigned long uLong;

/* FALSE, TRUE */
#ifndef TRUE
enum {
    FALSE, TRUE
};
#endif

/* exhaust typedefs */
/* misc. integral types */
typedef unsigned char u8_t;
typedef unsigned short u16_t;
typedef unsigned long u32_t;
typedef long s32_t;

/*  u16_t: coresize 0..65535
  u32_t: coresize 0..4294967295 */
typedef u16_t field_t;

typedef struct pspace_st {
    field_t* mem;       /* current p-space locations 1..PSPACESIZE-1. unit offset array. */
    field_t* ownmem;    /* private locations 1..PSPACESIZE-1. */
    u32_t len;
    field_t lastresult; /* p-space location 0. */
} pspace_t;

/* Instructions in core: */
typedef struct insn_st {
    field_t a, b;               /* a-value, b-value */
    u16_t in;                   /* flags, opcode, modifier, a- and b-modes */
} insn_t;

/* Warrior data struct */
typedef struct warrior_st {
    insn_t* code; /* code of warrior */
    u32_t len; /* length of warrior */
    u32_t start; /* start relative to first insn */

    int have_pin; /* does warrior have pin? */
    u32_t pin; /* pin of warrior or garbage. */

    /* info fields -- these aren't automatically set or used */
    char *name;
    int no;                     /* warrior no. */
} warrior_t;

/* active warrior struct, only used inside of sim_proper() */
typedef struct w_st {
    insn_t** tail;          /* next free location to queue a process */
    insn_t** head;      /* next process to run from queue */
    u32_t nprocs;           /* number of live processes in this warrior */
    struct w_st *succ;      /* next warrior alive */
    struct w_st* pred;      /* previous warrior alive */
    int id;             /* index (or identity) of warrior */
} w_t;

/* single linked list of warrior names */
typedef struct warriorNames_st {
    char* warriorName;
    struct warriorNames_st* next;
} warriorNames_t;


/* pmars stuff */
#define MAXALLCHAR 256

typedef int ADDR_T;
#define ISNEG(x) ((x)<0)

typedef unsigned char FIELD_T;
typedef unsigned long U32_T;        /* unsigned long (32 bits) */
typedef long S32_T;

typedef enum RType {
    RTEXT, RSTACK, RLABEL
}       RType;

typedef enum errType {
    BUFERR, M88ERR, TOKERR, SYNERR, SNFERR, F88ERR, NOPERR,
    EVLERR, EXPERR, RECERR, ANNERR, LINERR, APPERR, PMARS_IGNORE,
    ZLNERR, NUMERR, IDNERR, ROFERR, FORERR, ERVERR, GRPERR,
    CHKERR, NASERR, BASERR, EXXERR, FNFERR, UDFERR, CATERR,
    DLBERR, OFSERR, DOEERR, DSKERR, MLCERR, DIVERR, OFLERR,
    MISC
}       errType;

typedef enum stateCol {
    S_OP, S_MOD_ADDR_EXP, S_MODF, S_ADDR_EXP_A,
    S_EXP_FS, S_ADDR_EXP_B, S_EXPR
}       stateCol;

typedef struct src_st {
    char   *src;
    struct src_st *nextsrc;
    uShrt   loc;
} src_st;

typedef struct line_st {
    char   *vline;
    src_st *linesrc;
    struct line_st *nextline;
    FIELD_T dbginfo;
} line_st;

typedef struct grp_st {
    char   *symn;
    struct grp_st *nextsym;
}       grp_st;

typedef struct ref_st {
    grp_st *grpsym;
    line_st *sline;
    uShrt   value, visit;
    RType   reftype;
    struct ref_st *nextref;
}       ref_st;

typedef struct err_st {
    uShrt   code, loc, num;
}       err_st;

/* Memory structure */
typedef struct mem_struct {
    ADDR_T  A_value, B_value;
    FIELD_T opcode;
    FIELD_T A_mode, B_mode;
    FIELD_T debuginfo;

} mem_struct;


/* Warrior structure */
typedef struct warrior_struct {
    long    pSpaceIDNumber;
    ADDR_T *taskHead, *taskTail;
    int     tasks;
    ADDR_T  lastResult;
    int     pSpaceIndex;
    ADDR_T  position;                /* load position in core */
    int     instLen;                /* Length of instBank */
    int     offset;                /* Offset value specified by 'ORG' or 'END'.
                                    * 0 is default */
    char   *name;                        /* warrior name */
    char   *version;
    char   *date;
    char   *fileName;                /* file name */
    char   *authorName;                /* author name */
    mem_struct* instBank;

    struct warrior_struct *nextWarrior;
} warrior_struct;



/* whole data needed by one simulator */
typedef struct mars_st {
    u32_t nWarriors;
    warrior_t* warriors;
    warriorNames_t* warriorNames;
    field_t* positions;
    field_t* startPositions;
    u32_t* deaths;  
    /* Results[war_id][j] is the number of rounds in which warrior war_id survives until the end with exactly
       j-1 other warriors.  For j=0, then it is the number of rounds where the warrior died. */
    u32_t* results;

    int cycles;     /* cycles until tie */
    u32_t rounds;       /* number of rounds to fight */
    u32_t coresize;
    u32_t minsep;       /* minimum distance between warriors */
    u32_t processes;        /* default max. procs./warrior */

    int fixedPosition;      /* initial position of warrior 2 */
    int isMultiWarriorOutput;   /* multi-warrior output format. */
    u32_t maxWarriorLength;

    w_t* warTab;
    insn_t* coreMem;
    insn_t** queueMem;
    u32_t pspaceSize;    /* # p-space slots per warrior. */
    pspace_t** pspaces;         /* p-spaces of each warrior. */
    pspace_t** pspacesOrigin;
    
    
    /* pmars stuff */
    char noassert;
    uChar errnum, warnum;        /* Number of error and warning */
    uChar symnum;

    ref_st *reftbl;
    grp_st *symtbl;
    src_st *srctbl;
    line_st *sline[2], *lline[2];
    err_st *errkeep;

    unsigned int pass;
    int ierr;

    char buf[MAXALLCHAR], buf2[MAXALLCHAR];
    char token[MAXALLCHAR], outs[MAXALLCHAR];   
    
    /* We might need this var */
    int errorcode;
    int errorlevel;
    char errmsg[MAXALLCHAR];

    /* Some parameters */
    int taskNum;
    ADDR_T separation;
    int SWITCH_8;
    
    /* global error flag */
    int evalerr;

    /* registers */
    long regAr[26];
    /* kludge to implement several precedence levels */
    char saveOper;
    
    /* automaton */
    uChar opcode, modifier;
    uChar statefine;
    stateCol laststate;

    uShrt line, linemax;
    uChar vcont;
    FIELD_T dbginfo;
    uShrt dspnt;
    line_st *aline;
    
    s32_t seed;
    int dbgproceed;
} mars_t;

/* The following holds the order in which opcodes, modifiers, and addr_modes
   are represented as in parser. The enumerated field should start from zero */
enum addr_mode {
    IMMEDIATE,  /* # */
    DIRECT,     /* $ */
    INDIRECT,   /* @ */
    PREDECR,    /* < */
    POSTINC     /* > */
};

enum op {
    MOV, ADD, SUB, MUL, DIV, MOD, JMZ,
    JMN, DJN, CMP, SLT, SPL, DAT, JMP,
    SEQ, SNE, NOP, LDP, STP
};                                /* has to match asm.c:opname[] */

enum modifier {
    mA,                                /* .A */
    mB,                                /* .B */
    mAB,                                /* .AB */
    mBA,                                /* .BA */
    mF,                                /* .F */
    mX,                                /* .X */
    mI                                /* .I */
};

extern const char addr_sym[];
extern const char expr_sym[];
extern const char *modname[];
extern const char *swname[];
extern const char *opname[];

#endif /* EXHAUST_H */
