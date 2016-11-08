#include <windows.h>
#include "lua.h"
#include "lauxlib.h"
#include <string.h>
#include <objbase.h>
#include "md5.h"
#include "encrypt.h"
#include "guid.h"
#include "mac.h"
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
	size_t slen = 0;
	const char* s = luaL_checklstring(L,1,&slen);
	char buffer[255] = {0};
	char* d = md5(s,buffer,slen);
	lua_pushstring(L,d);
	return 1;
}
static int lua_get_mac(lua_State* L)
{
	char* mac = get_mac_str();
	lua_pushstring(L,mac);
	free(mac);
	return 1;
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
static int lua_wchar_split(lua_State* L)
{
	const wchar_t * str;
	/*传递第一个参数 */
	str= (wchar_t*) lua_tostring (L,-1);
	int len = wcslen(str);
	int i;
	lua_newtable(L);
	for(i=0; i < len; ++i){
		lua_pushinteger(L,(int)str[i]);
		lua_rawseti(L,-2,i+1);		
	}
	return 1;
}
static const struct luaL_Reg luaext [] = {
	{"guid",lua_guid},
	{"md5",lua_md5},
	{"mac",lua_get_mac},
	{"encrypt",lua_encrypt},
	{"decrypt",lua_decrypt},
	{"a2u",Unicode_a2u},
	{"u2a",Unicode_u2a},
	{"u2u8",Unicode_u2u8},
	{"u82u",Unicode_u82u},
	{"a2u8",Unicode_a2u8},
	{"u82a",Unicode_u82a},
	{"wchar_split",lua_wchar_split},
	{NULL,NULL}
};
int luaopen_luaext(lua_State *L){
	luaL_newlib(L,luaext);
	return 1;
};

