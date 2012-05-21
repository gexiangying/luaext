#include <windows.h>
#include "include/lua.h"
#include "include/lauxlib.h"
static int test(lua_State *L)
{
const char* title = luaL_checkstring(L,1);
const char* content = luaL_checkstring(L,2);
	MessageBox(NULL,content,title,MB_OK);
	return 0;
}
static const struct luaL_Reg luaext [] = {
	{"test",test},
	{NULL,NULL}
};
int luaopen_luaext(lua_State *L){
	luaL_register(L,"luaext",luaext);
	return 1;
};

