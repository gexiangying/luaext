#include <windows.h>
#include "lua.h"
#include "lauxlib.h"
#include <string.h>
#include <objbase.h>
#include "md5.h"
#include "encrypt.h"
#include "guid.h"
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
static const struct luaL_Reg luaext [] = {
	{"guid",lua_guid},
	{"md5",lua_md5},
	{"encrypt",lua_encrypt},
	{"decrypt",lua_decrypt},
	{NULL,NULL}
};
int luaopen_luaext(lua_State *L){
	luaL_newlib(L,luaext);
	return 1;
};

