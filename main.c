#include <windows.h>
#include "include/lua.h"
#include "include/lauxlib.h"
static int test(lua_State *L)
{
	MessageBox(NULL,"hello","world",MB_OK);
	return 0;
}
static const struct luaL_Reg mylib [] = {
	{"test",test},
	{NULL,NULL}
};
int luaopen_mylib(lua_State *L){
	luaL_register(L,"mylib",mylib);
	return 1;
};

