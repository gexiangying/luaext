#include "gelib.h"

int index_self(lua_State* L,const char* classname)
{
	lua_pushstring(L,classname);
	lua_gettable(L,LUA_REGISTRYINDEX);/* t = registry[classname] */
	if(lua_isnil(L,-1)){
		char buf[1024] = {0};
		sprintf(buf,"Not found register[%s].",classname);
		lua_pushstring(L,buf);
		lua_error(L);
	}
	lua_pushvalue(L,-1);
	lua_setfield(L,-2,"__index"); /* t.__index = t */
	lua_pop(L,1);
	return 0;
}
static int glibHandle_gc(lua_State* L)
{
	Ghandle* gh = checkhandle(L,1);
	if(gh->flag){
		/*
		lua_rawgeti(L,LUA_REGISTRYINDEX,gh->ref);
		lua_pushstring(L,"ghandle");
		lua_pushnil(L);
		lua_settable(L,-3);
		lua_pop(L,1);
		*/
		luaL_unref(L,LUA_REGISTRYINDEX,gh->ref);
		gh->flag = 0;
	}
	if(gh->gc)
		gh->gc(gh);
	return 0;
}
int new_class(lua_State* L,const char* classname)
{
	lua_newtable(L); /* push t */
	lua_pushstring(L,"class"); /* push key="class" */
	lua_pushstring(L,classname); /* push value = classname */
	lua_settable(L,-3); /* t.class = class_name */
	//lua_pushstring(L,classname); /* push key = classname */
	lua_setfield(L,LUA_REGISTRYINDEX,classname); /* registry[classname] = t */
	return 0;
}
/* userdata or table on stack */
int set_class(lua_State* L,const char* classname)
{
	if(lua_istable(L,-1) || lua_isuserdata(L,-1)){
		lua_pushstring(L,classname);
		lua_gettable(L,LUA_REGISTRYINDEX);/* t2 = registry[classname] */
		if(lua_isnil(L,-1)){
			lua_pushstring(L,"Invalid class name.");
			lua_error(L);
		}
		lua_setmetatable(L,-2); /* metatable(t) = t2 */
	}
	else{
		lua_pushstring(L,"not userdata or table");
		lua_error(L);
	}
	return 0;	
}
int set_method(lua_State* L,const char* classname,const char* funcname,lua_CFunction f)
{
	lua_pushstring(L,classname);
	lua_gettable(L,LUA_REGISTRYINDEX);
	if(lua_isnil(L,-1)){
		lua_pushstring(L,"Invalid class name.");
		lua_error(L);
	}
	lua_pushstring(L,funcname);
	lua_pushcfunction(L,f);
	lua_settable(L,-3);
	return 0;
}
/*
	 iup.NewClass("iupHandle") -- this is an Ihandle* with enhancements
	 iup.NewClass("iupWidget") -- this is a Lua object for control construction, see iup.WIDGET and iup.BOX
	 */
static int NewClass(lua_State *L)
{
	const char* classname = lua_tostring(L,1);
	lua_newtable(L);     /* push t */
	lua_pushstring(L, "class");  /* push "class" */
	lua_pushvalue(L, 1); /* push again the class_name to the stack, because settable will remove it */
	lua_settable(L, -3); /* t.class = class_name */
	lua_settable(L, LUA_REGISTRYINDEX);  /* registry[class_name] = t */
	index_self(L,classname);
	//set_method(L,classname,"__gc",glibHandle_gc);
	return 0;
}

/* iup.SetClass(t, class_name) 
 *   Calls:
 *       iup.SetClass(ih, "iupHandle")  --Called only in iup.RegisterHandle and WIDGET.constructor
 *           iup.SetClass(widget, "iupWidget")  --Called whenever a new control class is created.
 *           */
static int SetClass(lua_State *L)
{
	lua_gettable(L, LUA_REGISTRYINDEX);  /* t2 = registry[class_name] */
	if (lua_isnil(L, -1)) {
		lua_pushstring(L, "Invalid class name.");
		lua_error(L);
	}
	lua_setmetatable(L, -2);  /* metatable(t) = t2 */
	return 0;
}

/* class_name = iup.GetClass(t) */
static int GetClass(lua_State *L)
{
	if (lua_istable(L, 1) || lua_isuserdata(L, 1)) 
	{
		lua_getmetatable(L, 1); /* t2 = metatable(t) */
		if (lua_istable(L, -1)) 
		{
			lua_pushstring(L, "class");
			lua_gettable(L, -2);    /* class_name = t2.class */ 
			return 1;
		}
	}
	lua_pushnil(L);
	return 1;
}

/* iup.SetMethod(class_name, method, function)
 *    For ex:
 *         iup.SetMethod("iupHandle", "__index", ihandle_gettable)
 *         */
static int SetMethod(lua_State *L)
{
	lua_pushvalue(L, 1); /* push class_name */
	lua_gettable(L, LUA_REGISTRYINDEX);  /* t = registry[class_name] */
	if (lua_isnil(L, -1)) {
		lua_pushstring(L, "Invalid class name.");
		lua_error(L);
	}
	lua_pushvalue(L, -3); /* push method */
	lua_pushvalue(L, -3); /* push function */
	lua_settable(L, -3);  /* t.method = function */
	return 0;
}
int get_link(lua_State* L)
{
	Ghandle* gh = checkhandle(L,-1);
	if(gh->flag)
		lua_rawgeti(L,LUA_REGISTRYINDEX,gh->ref);
	else
		lua_pushnil(L);
	return 0;
}
/* local link = glib.GetLink(gh) */
static int GetLink(lua_State* L)
{
	Ghandle* gh = checkhandle(L,1);
	if(gh->flag)
		lua_rawgeti(L,LUA_REGISTRYINDEX,gh->ref);
	else
		lua_pushnil(L);
	return 1;
}
/* glib.SetLink(gh,link) */
static int SetLink(lua_State* L)
{
	Ghandle* gh = checkhandle(L,1);
	if(!gh->flag){
		gh->flag = 1;
		gh->ref = luaL_ref(L,LUA_REGISTRYINDEX);
	}
	return 0;
}
static int new_ghandle(lua_State* L)
{
	void* handle = lua_touserdata(L,1);
	DESTROY_CB gc = (DESTROY_CB)lua_touserdata(L,2);
	Ghandle* gh = (Ghandle*)lua_newuserdata(L,sizeof(Ghandle));
	gh->handle = handle;
	gh->gc = gc;
	gh->flag = 0;
	gh->ref = 0;
	set_class(L,GLIB_HANDLE_NAME);
	return 1;
}
static const struct luaL_Reg luaglib_m[] ={
	{"NewClass",NewClass},
	{"SetClass",SetClass},
	{"GetClass",GetClass},
	{"SetMethod",SetMethod},
	{"GetLink",GetLink},
	{"SetLink",SetLink},
	{"Ghandle",new_ghandle},
	{NULL,NULL}
};
int luaopen_luaext_glib(lua_State* L)
{
	new_class(L,GLIB_HANDLE_NAME);
	index_self(L,GLIB_HANDLE_NAME);
	set_method(L,GLIB_HANDLE_NAME,"__gc",glibHandle_gc);
	luaL_newlib(L,luaglib_m);
	return 1;
}
