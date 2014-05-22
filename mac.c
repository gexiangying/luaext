#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <iprtrmib.h>
#include <iphlpapi.h>
#include "mac.h"
static int get_mac(BYTE* bytes)
{
	ULONG size = 0;
	MIB_IFTABLE*	pIfTable= NULL;
	unsigned int i =0;
	unsigned int j =0;
	GetIfTable(NULL,&size,TRUE);
	pIfTable= malloc(size);
	GetIfTable(pIfTable,&size,TRUE); 
	for (i=0; i< pIfTable->dwNumEntries; i++ ) 
	{ 
		if((pIfTable->table[i]).dwPhysAddrLen == 6){
			for(j =0; j < (pIfTable->table[i]).dwPhysAddrLen; j++)
				*bytes++ = (pIfTable->table[i]).bPhysAddr[j];
			return 1;
		}
	} 
	free(pIfTable);
	return 0;
}
int get_mac_str(char str[19])
{
	BYTE bytes[6];
	int i;
	if(!get_mac(bytes))
		return 0;
	
	for(i = 0; i < 6; i++){
		sprintf(str,"%02x",bytes[i]);
		str +=2;
		if(i != 5) sprintf(str++,"-");
	}
	return 1;
}
