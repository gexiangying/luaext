#include <windows.h>
#include <stdio.h>
#include <iprtrmib.h>
#include <Iphlpapi.h>
#include "mac.h"
char* get_mac(char** p_mac_str)
{
	ULONG size = 0;
	MIB_IFTABLE*	pIfTable= NULL;
	unsigned int i =0;
	unsigned int j =0;
	GetIfTable(NULL,&size,TRUE);
	pIfTable= malloc(size);
	GetIfTable(pIfTable,&size,TRUE); 
	*p_mac_str = (char*)calloc(1,32 * pIfTable->dwNumEntries);
	char* buf = *p_mac_str;
	for (int i=0; i< pIfTable->dwNumEntries; i++ ) 
	{ 
		if((pIfTable->table[i]).dwPhysAddrLen == 6){
			for(int j =0; j < (pIfTable->table[i]).dwPhysAddrLen; j++){
				BYTE byte = (pIfTable->table[i]).bPhysAddr[j];
				sprintf(buf,"%02X-",byte);
				buf += 3;
			}
		 buf -= 1;
	   sprintf(buf,"\r\n");
	   buf += 2;	 
		}
	} 
	free(pIfTable);
	return *p_mac_str;
}
char* get_mac_str()
{
	char* mac_str =NULL;
	int i;
	if(!get_mac(&mac_str))
		return NULL;
	return mac_str;
}
