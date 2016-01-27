#include <windows.h>
#include <string.h>
#include <objbase.h>
#include "guid.h"

static const char *cConversionTable =
//          1         2         3         4         5         6   
//0123456789012345678901234567890123456789012345678901234567890123
"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_$";

static BOOL cv_to_64( const unsigned long number, char *code, int len )
{
	unsigned long   act;
	int             iDigit, nDigits;
	char            result[5];

	if (len > 5)
		return FALSE;

	act = number;
	nDigits = len - 1;

	for (iDigit = 0; iDigit < nDigits; iDigit++) {
		result[nDigits - iDigit - 1] = cConversionTable[(int) (act % 64)];
		act /= 64;
	}
	result[len - 1] = '\0';

	if (act != 0)
		return FALSE;

	strcpy (code, result);
	return TRUE;
}
char * getString64FromGuid( const GUID *pGuid, char * buf, int len )
{
	unsigned long   num[6];
	char            str[6][5];
	int             i, n;

	if (len < 23) {
		return NULL;
	}

	//
	// Creation of six 32 Bit integers from the components of the GUID structure
	//
	num[0] = (unsigned long) (pGuid->Data1 / 16777216);                                                 //    16. byte  (pGuid->Data1 / 16777216) is the same as (pGuid->Data1 >> 24)
	num[1] = (unsigned long) (pGuid->Data1 % 16777216);                                                 // 15-13. bytes (pGuid->Data1 % 16777216) is the same as (pGuid->Data1 & 0xFFFFFF)
	num[2] = (unsigned long) (pGuid->Data2 * 256 + pGuid->Data3 / 256);                                 // 12-10. bytes
	num[3] = (unsigned long) ((pGuid->Data3 % 256) * 65536 + pGuid->Data4[0] * 256 + pGuid->Data4[1]);  // 09-07. bytes
	num[4] = (unsigned long) (pGuid->Data4[2] * 65536 + pGuid->Data4[3] * 256 + pGuid->Data4[4]);       // 06-04. bytes
	num[5] = (unsigned long) (pGuid->Data4[5] * 65536 + pGuid->Data4[6] * 256 + pGuid->Data4[7]);       // 03-01. bytes
	//
	// Conversion of the numbers into a system using a base of 64
	//
	buf[0]='\0';
	n = 3;
	for (i = 0; i < 6; i++) {
		if (!cv_to_64 (num[i], str[i], n)) {
			return NULL;
		}
		strcat (buf, str[i]);
		n = 5;
	}
	return buf;
}


