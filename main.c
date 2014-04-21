#include <windows.h>
#include "include/lua.h"
#include "include/lauxlib.h"
#include <string.h>
#include <objbase.h>
#include "md5.h"
#include "encrypt.h"
#define FUN_TOKEN 1
#define STR_TOKEN 2
#define NUMBER_TOKEN 3
#define S_TOKEN 4
#define L_TOKEN 5
#define E_TOKEN 6
#define T_TOKEN 7
#define STAR_TOKEN 8
typedef struct _g_token_
{
	int type; 
	char* str;
}G_TOKEN;
static void free_token(G_TOKEN* token)
{
	free(token->str);
	free(token);
}
static G_TOKEN* e_token(const char** str)
{
	G_TOKEN* token = (G_TOKEN*)calloc(1,sizeof(G_TOKEN));
	token->type  =  E_TOKEN;
	const char* lpstr = *str;
	int index = 0;
	int flag = 0;
	do{
		if(*lpstr == '.'){
			flag++;
			if(flag == 2){
				index++,lpstr++;
				token->str=calloc(index + 1,sizeof(char));
				strncpy(token->str,*str,index);
				break;
			}
		}
		lpstr++,index++;
	}while(*lpstr != 0);
	*str = lpstr;
	return token;

}
static G_TOKEN* number_token(const char** str)
{
	G_TOKEN* token = (G_TOKEN*)calloc(1,sizeof(G_TOKEN));
	token->type  =  NUMBER_TOKEN;
	const char* lpstr = *str;
	int index = 0;
	do{
		if(*lpstr == ',' || *lpstr == ')'){
			break;
		}
		lpstr++,index++;
	}while(*lpstr != 0);
	token->str=calloc(index + 1,sizeof(char));
	strncpy(token->str,*str,index);
	*str = lpstr;
	return token;
}
static G_TOKEN* t_token(const char** str)
{
	G_TOKEN* token = number_token(str);
	token->type = T_TOKEN;
	return token;
}
static G_TOKEN* star_token(const char** str)
{
	G_TOKEN* token = (G_TOKEN*)calloc(1,sizeof(G_TOKEN));
	token->type = STAR_TOKEN;
	token->str = calloc(2,sizeof(char));
	token->str[0] = '*';
	*str += 1;
	return token;
}
static G_TOKEN* s_token(const char** str)
{
	G_TOKEN* token = (G_TOKEN*)calloc(1,sizeof(G_TOKEN));
	token->type = S_TOKEN;
	token->str = calloc(2,sizeof(char));
	token->str[0] = '$';
	*str += 1;
	return token;
}
static G_TOKEN* str_token(const char** str)
{
	G_TOKEN* token = (G_TOKEN*)calloc(1,sizeof(G_TOKEN));
	token->type = STR_TOKEN;
	const char* lpstr = *str;
	int index = 0;
	int flag = 0;
	do{
		if(*lpstr == '\''){
			flag++;
			if(flag == 2){
				index++;
				lpstr++;
				token->str=calloc(index + 1,sizeof(char));
				strncpy(token->str,*str,index);
				break;
			}
		}
		index++;
		lpstr++;
	}while(*lpstr != 0);
	*str = lpstr;
	return token;
}
static G_TOKEN* fun_token(const char** str)
{
	G_TOKEN* token = (G_TOKEN*)calloc(1,sizeof(G_TOKEN));
	token->type = FUN_TOKEN;
	const char* lpstr = *str;
	int flag = 0;
	int index = 0;
	do{
		if(*lpstr == '(') flag++;
		else if(*lpstr == ')' && flag == 1) {
			flag--;
			lpstr++;
			index++;
			token->str=calloc(index + 1,sizeof(char));
			strncpy(token->str,*str,index);
			break;
		}
		else if(*lpstr == ')') flag --;
		lpstr++;
		index++;
	}while(*lpstr != 0);
	*str = lpstr;
	return token;
}
static G_TOKEN* l_token(const char** str)
{
	G_TOKEN* token = fun_token(str);
	token->type = L_TOKEN;
	return token;
}
static void add_token(G_TOKEN* token,lua_State* L,int i)
{
	lua_newtable(L);
	lua_pushinteger(L,token->type);
	lua_setfield(L,-2,"type");
	if(token->str){
		lua_pushstring(L,token->str);
		lua_setfield(L,-2,"str");
	}
	lua_rawseti(L,-2,i);
}
static int str_machine(lua_State* L)
{
	const char* str = lua_tostring(L,-1);
	if(*str == '(') str++;
	int i = 0;
	lua_newtable(L);
	G_TOKEN* token = NULL;
	do{
		while(isspace(*str)) str++;
		if(*str == '(') {
			token = l_token(&str);
			i++;
			add_token(token,L,i);
			free_token(token);
		}
		else if(*str == '\''){
			token = str_token(&str);
			i++;
			add_token(token,L,i);
			free_token(token);
		}
		else if(*str == '$') {
			token = s_token(&str);
			i++;
			add_token(token,L,i);
			free_token(token);
		}
		else if(*str == '.'){
			token = e_token(&str);
			i++;
			add_token(token,L,i);
			free_token(token);
		}
		else if(isalpha(*str)){
			token = fun_token(&str);
			i++;
			add_token(token,L,i);
			free_token(token);
		}
		else if(*str == '-' || isdigit(*str)){
			token = number_token(&str);
			i++;
			add_token(token,L,i);
			free_token(token);
		}
		else if(*str == '#') {
			token = t_token(&str);
			i++;
			add_token(token,L,i);
			free_token(token);
		}
		else if(*str == '*') {
			token = star_token(&str);
			i++;
			add_token(token,L,i);
			free_token(token);
		}
		else {
			str++;
		}
		token = NULL;
	}while(*str != 0);
	return 1;
}
static int msg(lua_State *L)
{
	const char* title = luaL_checkstring(L,1);
	const char* content = luaL_checkstring(L,2);
	MessageBox(NULL,content,title,MB_OK);
	return 0;
}
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
static char * getString64FromGuid( const GUID *pGuid, char * buf, int len )
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
#define CHAR_SCALE (sizeof(wchar_t)/sizeof(char))

static wchar_t * AToU (const char * str)
{
	int textlen;
	wchar_t * result;

	textlen=MultiByteToWideChar (CP_ACP,0,str,-1,NULL,0);
	result= (wchar_t*) malloc ((textlen+1) *sizeof (wchar_t));
	memset (result,0, (textlen+1) *sizeof (wchar_t));
	MultiByteToWideChar (CP_ACP,0,str,-1, (LPWSTR) result,textlen);
	return result;
}

static char * UToA (const wchar_t * str)
{
	char * result;
	int textlen;

	// wide char to multi char
	textlen=WideCharToMultiByte (CP_ACP,0,str,-1,NULL,0,NULL,NULL);
	result= (char*) malloc ((textlen+1) *sizeof (char));
	memset (result,0,sizeof (char) * (textlen+1));
	WideCharToMultiByte (CP_ACP,0,str,-1,result,textlen,NULL,NULL);
	return result;
}

static wchar_t * U8ToU (const char * str)
{
	int textlen;
	wchar_t * result;

	textlen=MultiByteToWideChar (CP_UTF8,0,str,-1,NULL,0);
	result= (wchar_t*) malloc ((textlen+1) *sizeof (wchar_t));
	memset (result,0, (textlen+1) *sizeof (wchar_t));
	MultiByteToWideChar (CP_UTF8,0,str,-1, (LPWSTR) result,textlen);
	return result;
}

static char * UToU8 (const wchar_t * str)
{
	char * result;
	int textlen;

	// wide char to multi char
	textlen=WideCharToMultiByte (CP_UTF8,0,str,-1,NULL,0,NULL,NULL);
	result= (char*) malloc ((textlen+1) *sizeof (char));
	memset (result,0,sizeof (char) * (textlen+1));
	WideCharToMultiByte (CP_UTF8,0,str,-1,result,textlen,NULL,NULL);
	return result;
}

static int Unicode_a2u (lua_State * L)
{
	const char * str;
	wchar_t * result;

	/*传递第一个参数 */
	str=lua_tostring (L,-1);
	/*开始转换 */
	result=AToU (str);
	/*返回值， */
	lua_pushlstring (L, (char*) result,wcslen (result) *CHAR_SCALE);
	free(result);
	return 1;
}

static int Unicode_u2a (lua_State * L)
{
	const wchar_t * str;
	char * result;

	/*传递第一个参数 */
	str= (wchar_t*) lua_tostring (L,-1);
	/*开始转换 */
	result=UToA (str);
	/*返回值， */
	lua_pushstring (L,result);
	free(result);
	return 1;
}

static int Unicode_u2u8 (lua_State * L)
{
	const wchar_t * str;
	char * result;

	/*传递第一个参数 */
	str= (wchar_t*) lua_tostring (L,-1);
	/*开始转换 */
	result=UToU8 (str);
	/*返回值， */
	lua_pushstring (L,result);
	free(result);
	return 1;
}

static int Unicode_u82u (lua_State * L)
{
	const char * str;
	wchar_t * result;

	/*传递第一个参数 */
	str=lua_tostring (L,-1);
	/*开始转换 */
	result=U8ToU (str);
	/*返回值， */
	lua_pushlstring (L, (char*) result,wcslen (result) *CHAR_SCALE);
	free(result);
	return 1;
}

static int Unicode_a2u8 (lua_State * L)
{
	const char * str;
	wchar_t * temp;
	char * result;

	/*传递第一个参数 */
	str=lua_tostring (L,-1);
	/*开始转换 */
	temp=AToU (str);
	result=UToU8 (temp);
	/*返回值， */
	lua_pushstring (L,result);
	free(result);
	return 1;
}

static int Unicode_u82a (lua_State * L)
{
	const char * str;
	wchar_t * temp;
	char * result;

	/*传递第一个参数 */
	str=lua_tostring (L,-1);
	/*开始转换 */
	temp=U8ToU (str);
	result=UToA (temp);
	/*返回值， */
	lua_pushstring (L,result);
	free(result);
	return 1;
}

static int lua_guid(lua_State* L)
{
	GUID id;
	if(CoCreateGuid(&id) != S_OK){
		lua_pushstring(L,"error cocreate");
		return 1;
	}
	char buf[24] = {0};
	getString64FromGuid(&id,buf,24); 
	lua_pushstring(L,buf);
	return 1;
}
static int lua_encrypt(lua_State* L)
{
	const char* s = lua_tostring(L,1);
	char buffer[1024] = {0};
	char* d = encrypt(s,buffer);
  lua_pushstring(L,d);
	return 1;
}
static int lua_decrypt(lua_State* L)
{
	const char* s = lua_tostring(L,1);
	char buffer[1024] = {0};
	char* d = decrypt(s,buffer);
	lua_pushstring(L,d);
	return 1;
}
static int lua_md5(lua_State* L)
{
	const char* s = lua_tostring(L,1);
	char buffer[255] = {0};
	char* d = md5(s,buffer);
	lua_pushstring(L,d);
	return 1;
}
static int lua_sleepex(lua_State* L)
{
	DWORD dwMilliseconds = (DWORD)lua_tointeger(L,1);
	DWORD result = SleepEx(dwMilliseconds,FALSE);
	lua_pushinteger(L,result);
	return 1;
}

static int lua_I16(lua_State* L)
{
	int num = 2;
	int i = 0;
	int a = lua_tonumber(L,1);
	unsigned char* bytes = (unsigned char*)&a;
	for(i = 0;i < num;i++)
		lua_pushinteger(L,bytes[i]);
	return num;
}
static int lua_I32(lua_State* L)
{
	int num = 4;
	int i = 0;
	int a = lua_tonumber(L,1);
	unsigned char* bytes = (unsigned char*)&a;
	for(i = 0;i < num;i++)
		lua_pushinteger(L,bytes[i]);
	return num;
}
static int lua_F64(lua_State* L)
{
	int num = 8;
	int i = 0;
	float a = lua_tonumber(L,1);
	unsigned char* bytes = (unsigned char*)&a;
	for(i = 0;i < num;i++)
		lua_pushinteger(L,bytes[i]);
	return num;
}
static int lua_F32(lua_State* L)
{
	int num = 4;
	int i = 0;
	float a = lua_tonumber(L,1);
	unsigned char* bytes = (unsigned char*)&a;
	for(i = 0;i < num;i++)
		lua_pushinteger(L,bytes[i]);
	return num;
}
static int lua_U32(lua_State* L)
{
	int num = 4;
	int i = 0;
	LONG a = lua_tonumber(L,1);
	unsigned char* bytes = (unsigned char*)&a;
	for(i = 0;i < num;i++)
		lua_pushinteger(L,bytes[i]);
	return num;
}
static int lua_U16(lua_State* L)
{
	int num = 2;
	int i = 0;
	LONG a = lua_tonumber(L,1);
	unsigned char* bytes = (unsigned char*)&a;
	for(i = 0;i < num;i++)
		lua_pushinteger(L,bytes[i]);
	return num;
}
static int lua_U8(lua_State* L)
{
	int num = 1;
	int i = 0;
	LONG a = lua_tonumber(L,1);
	unsigned char* bytes = (unsigned char*)&a;
	for(i = 0;i < num;i++)
		lua_pushinteger(L,bytes[i]);
	return num;
}
static const struct luaL_Reg luaext [] = {
	{"a2u",Unicode_a2u},
	{"u2a",Unicode_u2a},
	{"u2u8",Unicode_u2u8},
	{"u82u",Unicode_u82u},
	{"a2u8",Unicode_a2u8},
	{"u82a",Unicode_u82a},
	{"msg",msg},
	{"str_machine",str_machine},
	{"guid",lua_guid},
	{"md5",lua_md5},
	{"encrypt",lua_encrypt},
	{"decrypt",lua_decrypt},
	{"sleepex",lua_sleepex},
	{"U8",lua_U8},
	{"U16",lua_U16},
	{"U32",lua_U32},
	{"I16",lua_I16},
	{"I32",lua_I32},
	{"F32",lua_F32},
	{"F64",lua_F64},
	{NULL,NULL}
};
int luaopen_luaext(lua_State *L){
	luaL_register(L,"luaext",luaext);
	return 1;
};

