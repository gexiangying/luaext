#include <windows.h>
#include <GL/gl.h>
#include "lua.h"
#include "lauxlib.h"
static int lua_glTexCoord2d(lua_State* L)
{
	double s = lua_tonumber(L,1);
	double t = lua_tonumber(L,2);
	glTexCoord2d(s,t);
	return 0;
}
static int lua_glColor3d(lua_State* L)
{
	double r = lua_tonumber(L,1);
	double g = lua_tonumber(L,2);
	double b = lua_tonumber(L,3);
	glColor3d(r,g,b);
	return 0;
}
static int lua_glNormal3d(lua_State* L)
{
	double x = lua_tonumber(L,1);
	double y = lua_tonumber(L,2);
	double z = lua_tonumber(L,3);
	glNormal3d(x,y,z);
	return 0;
}
static int lua_glVertex3d(lua_State* L)
{
	double x = lua_tonumber(L,1);
	double y = lua_tonumber(L,2);
	double z = lua_tonumber(L,3);
	glVertex3d(x,y,z);
	return 0;
}
static int lua_glBegin(lua_State* L)
{
	const char* smode = lua_tostring(L,1);
	GLenum mode = GL_POINTS;
	if(strcmp(smode,"GL_POINTS") == 0)
		mode = GL_POINTS;
	else if(strcmp(smode,"GL_LINES") == 0)
		mode = GL_LINES; 
	else if(strcmp(smode,"GL_LINE_STRIP") == 0)
		mode = GL_LINE_STRIP;
	else if(strcmp(smode,"GL_TRIANGLES") == 0)
		mode = GL_TRIANGLES;
	else if(strcmp(smode,"GL_TRIANGLE_STRIP") == 0)
		mode = GL_TRIANGLE_STRIP;
	else if(strcmp(smode,"GL_TRIANGLE_FAN") == 0)
		mode = GL_TRIANGLE_FAN;
	else if(strcmp(smode,"GL_QUADS") == 0)
		mode = GL_QUADS;
	else if(strcmp(smode,"GL_QUAD_STRIP") == 0)
		mode = GL_QUAD_STRIP;
	else if(strcmp(smode,"GL_POLYGON") == 0)
		mode = GL_POLYGON;
	glBegin(mode);
	return 0;
}
static int lua_glEnd(lua_State* L)
{
	glEnd();
	return 0;
}
static int lua_glCallList(lua_State* L)
{
	int list = lua_tointeger(L,1);
	glCallList(list);
	return 0;
}
static int lua_glDeleteLists(lua_State* L)
{
	int list = lua_tointeger(L,1);
	int size = lua_tointeger(L,2);
	glDeleteLists(list,size);
	return 0;
}
static int lua_glNewList(lua_State* L)
{
	int list = lua_tointeger(L,1);
	glNewList(list,GL_COMPILE);
	return 0;
}
static int lua_glEndList(lua_State* L)
{
	glEndList();
	return 0;
}
static int lua_glGenLists(lua_State* L)
{
	int size = lua_tointeger(L,1);
	int id = glGenLists(size);
	lua_pushinteger(L,id);
	return 1;
}
static const struct luaL_Reg luagl_f[] = {
	{"glGenLists",lua_glGenLists},
	{"glCallList",lua_glCallList},
	{"glDeleteLists",lua_glDeleteLists},
	{"glNewList",lua_glNewList},
	{"glEndList",lua_glEndList},
	{"glBegin",lua_glBegin},
	{"glEnd",lua_glEnd},
	{"glVertex3d",lua_glVertex3d},
	{"glNormal3d",lua_glNormal3d},
	{"glColor3d",lua_glColor3d},
	{"glTexCoord2d",lua_glTexCoord2d},
	{NULL,NULL}
};

int luaopen_luaext_gl(lua_State* L){
	luaL_register(L,"luaext.gl",luagl_f);
	return 1;
}
