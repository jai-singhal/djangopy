#define ALPHA_ST_VOID	0
#define ALPHA_ST_INT	1
#define ALPHA_ST_FLOAT	2
#define ALPHA_ST_DOUBLE	3
#define ALPHA_ST_CPLXF	4
#define ALPHA_ST_CPLXD	5

#define ALPHA_LD_VOID	0
#define ALPHA_LD_INT64	1
#define ALPHA_LD_INT32	2
#define ALPHA_LD_UINT16	3
#define ALPHA_LD_SINT16	4
#define ALPHA_LD_UINT8	5
#define ALPHA_LD_SINT8	6
#define ALPHA_LD_FLOAT	7
#define ALPHA_LD_DOUBLE	8
#define ALPHA_LD_CPLXF	9
#define ALPHA_LD_CPLXD	10

#define ALPHA_ST_SHIFT		0
#define ALPHA_LD_SHIFT		8
#define ALPHA_RET_IN_MEM	0x10000
#define ALPHA_FLAGS(S, L)	(((L) << ALPHA_LD_SHIFT) | (S))
