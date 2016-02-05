#ifndef _GELIB_H_
#define _GELIB_H_
#include <lua.h>
#include <lauxlib.h>
#define GLIB_HANDLE_NAME "glibHandle"
#define checkhandle(L,index) (Ghandle*)luaL_checkudata(L,index,GLIB_HANDLE_NAME)
struct _glib_handle_;
typedef int (*DESTROY_CB)(struct _glib_handle_*);
typedef struct _glib_handle_{
	void* handle;
	int ref;
	int flag;
	DESTROY_CB gc;
}Ghandle;

int new_class(lua_State* L,const char* classname);
int set_class(lua_State* L,const char* classname);
int set_method(lua_State* L,const char* classname,const char* funcname,lua_CFunction f);
int index_self(lua_State* L,const char* classname);
int get_link(lua_State* L);
#endif
