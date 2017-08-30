#include <windows.h>
#include <GL/gl.h>
#include "lua.h"
#include "lauxlib.h"
static int lua_glScaled(lua_State* L){
	double x = lua_tonumber(L,1);
	double y = lua_tonumber(L,2);
	double z = lua_tonumber(L,3);
	glScaled(x,y,z);
	return 0;
}
static int lua_glMultMatrixd(lua_State* L){
	GLdouble m[4][4]; 
	ZeroMemory(&m[0][0],sizeof(m));
	int i,j;
	for(i = 0; i < 4; i++)
		for(j = 0; j < 4; j++){
			lua_rawgeti(L,-1,i * 4 + j * 1);
			m[i][j] = lua_tonumber(L,-1);
			lua_pop(L,1);
		}
	glMultMatrixd(&m[0][0]);
	return 0;
}
static int lua_glTexCoord2d(lua_State* L)
{
	double s = lua_tonumber(L,1);
	double t = lua_tonumber(L,2);
	glTexCoord2d(s,t);
	return 0;
}
static int lua_glRotated(lua_State* L){
	double angle = lua_tonumber(L,1);
	double x = lua_tonumber(L,2);
	double y = lua_tonumber(L,3);
	double z = lua_tonumber(L,4);
	glRotated(angle,x,y,z);
	return 0;
}
static int lua_glTranslated(lua_State* L)
{
	double x = lua_tonumber(L,1);
	double y = lua_tonumber(L,2);
	double z = lua_tonumber(L,3);
	glTranslated(x,y,z);
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
static int lua_CreateFont(lua_State* L)
{
	int size = lua_tointeger(L,1);
	const char* s_charset = lua_tostring(L,2);
	const char* face = lua_tostring(L,3);	
	int charset;	
	if(strcmp(s_charset,"ANSI_CHARSET") == 0)
		charset = ANSI_CHARSET;
	else if(strcmp(s_charset,"BALTIC_CHARSET") == 0)
		charset = BALTIC_CHARSET;
	else if(strcmp(s_charset,"CHINESEBIG5_CHARSET") == 0)
		charset = CHINESEBIG5_CHARSET;
	else if(strcmp(s_charset,"DEFAULT_CHARSET") == 0)
		charset = DEFAULT_CHARSET;
	else if(strcmp(s_charset,"EASTEUROPE_CHARSET") == 0)
		charset = EASTEUROPE_CHARSET;
	else if(strcmp(s_charset,"GB2312_CHARSET") == 0)
		charset = GB2312_CHARSET;
	else if(strcmp(s_charset,"GREEK_CHARSET") == 0)
		charset = GREEK_CHARSET;
	else if(strcmp(s_charset,"HANGUL_CHARSET") == 0)
		charset = HANGUL_CHARSET;
	else if(strcmp(s_charset,"MAC_CHARSET") == 0)
		charset = MAC_CHARSET;
	else if(strcmp(s_charset,"OEM_CHARSET") == 0)
		charset = OEM_CHARSET;
	else if(strcmp(s_charset,"RUSSIAN_CHARSET") == 0)
		charset = RUSSIAN_CHARSET;
	else if(strcmp(s_charset,"SHIFTJIS_CHARSET") == 0)
		charset = SHIFTJIS_CHARSET;
	else if(strcmp(s_charset,"SYMBOL_CHARSET") == 0)
		charset = SYMBOL_CHARSET;
	else if(strcmp(s_charset,"TURKISH_CHARSET") == 0)
		charset = TURKISH_CHARSET;
	HFONT hFont = CreateFontA(size, 0, 0, 0, FW_MEDIUM, 0, 0, 0, 
			charset, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, 
			DEFAULT_QUALITY, DEFAULT_PITCH | FF_SWISS, face); 
	lua_pushlightuserdata(L,hFont);
	return 1;
}
static int lua_wglUseFontBitmaps(lua_State* L)
{	
	DWORD first = (DWORD) lua_tointeger(L,1);
	DWORD listBase = (DWORD) lua_tointeger(L,2);
	HDC hDC = wglGetCurrentDC(); 
	wglUseFontBitmapsW(hDC,first,1,listBase);
	return 0;
}
static int lua_DeleteFont(lua_State* L)
{
	HFONT hFont = (HFONT) lua_touserdata(L,1);
	DeleteObject(hFont); 
	return 0;
}
static int lua_SetFont(lua_State* L)
{
	HFONT hFont = (HFONT) lua_touserdata(L,1);
	HFONT hOldFont = (HFONT)SelectObject(wglGetCurrentDC(), hFont); 
	lua_pushlightuserdata(L,hOldFont);
	return 1;	
}
static int lua_wglShareLists(lua_State* L)
{
  HGLRC hrc1 = (HGLRC)lua_touserdata(L,1);
  HGLRC hrc2 = (HGLRC)lua_touserdata(L,2);
	wglShareLists(hrc1,hrc2);	
	return 0;
}
static int lua_wglMakeCurrent(lua_State* L)
{
	if(lua_isnil(L,1)){
		wglMakeCurrent(NULL,NULL);
		return 0;
	}
	HDC hdc = (HDC)lua_touserdata(L,1);
  HGLRC hrc = (HGLRC)lua_touserdata(L,2);
	wglMakeCurrent(hdc,hrc);	
	return 0;
}
static int lua_glGenLists(lua_State* L)
{
	int size = lua_tointeger(L,1);
	int id = glGenLists(size);
	lua_pushinteger(L,id);
	return 1;
}
static int lua_SetWindowPixelFormat(lua_State* L)
{
	HDC hDC = (HDC)lua_touserdata(L,1);
	PIXELFORMATDESCRIPTOR pixelDesc;
	pixelDesc.nSize = sizeof(PIXELFORMATDESCRIPTOR);
	pixelDesc.nVersion = 1;
	pixelDesc.dwFlags = PFD_DRAW_TO_WINDOW | PFD_SUPPORT_OPENGL |
		PFD_DOUBLEBUFFER | PFD_STEREO_DONTCARE;
	pixelDesc.iLayerType = PFD_TYPE_RGBA;
	pixelDesc.cColorBits = 32;
	pixelDesc.cRedBits = 8;
	pixelDesc.cRedShift = 16;
	pixelDesc.cGreenBits = 8;
	pixelDesc.cGreenShift = 8;
	pixelDesc.cBlueBits = 8;
	pixelDesc.cAlphaBits = 0;
	pixelDesc.cAlphaShift = 0;
	pixelDesc.cAccumBits = 64;
	pixelDesc.cAccumRedBits = 16;
	pixelDesc.cAccumGreenBits = 16;
	pixelDesc.cAccumBlueBits = 16;
	pixelDesc.cAccumAlphaBits = 0;
	pixelDesc.cDepthBits = 32;
	pixelDesc.cStencilBits = 8;
	pixelDesc.cAuxBuffers = 0;
	pixelDesc.iLayerType = PFD_MAIN_PLANE;
	pixelDesc.bReserved = 0;
	pixelDesc.dwLayerMask = 0;
	pixelDesc.dwVisibleMask = 0;
	pixelDesc.dwDamageMask = 0;

	int m_GLPixelIndex = ChoosePixelFormat(hDC,&pixelDesc);
	if(m_GLPixelIndex == 0) {
		m_GLPixelIndex = 1;
		if(DescribePixelFormat(hDC,m_GLPixelIndex,
					sizeof(PIXELFORMATDESCRIPTOR),&pixelDesc) == 0)
		lua_pushboolean(L,FALSE);
			return 1;
	}
	if(!SetPixelFormat(hDC,m_GLPixelIndex,&pixelDesc)){
		lua_pushboolean(L,FALSE);
		return 0;
	}
	lua_pushboolean(L,TRUE);
	return 1;
}
static int lua_wglCreateContext(lua_State* L)
{
	HDC hdc = (HDC) lua_touserdata(L,1);
	HGLRC hrc = wglCreateContext(hdc);
	lua_pushlightuserdata(L,hrc);
	return 1;
}
static int lua_wglDeleteContext(lua_State* L)
{
	HGLRC hrc = (HGLRC) lua_touserdata(L,1);
	wglDeleteContext(hrc);
	return 0;
}
static int lua_wglGetCurrentDC(lua_State* L)
{
	HDC hdc = wglGetCurrentDC();
	lua_pushlightuserdata(L,hdc);
	return 1;
}
static int lua_FreeImage(lua_State* L)
{
	unsigned char* image = (unsigned char*)lua_touserdata(L,1);
	free(image);
	return 0;
}
static int lua_GetDC(lua_State* L)
{
	HWND hwnd = (HWND)lua_touserdata(L,1);
	HDC hdc = GetDC(hwnd);
	lua_pushlightuserdata(L,hdc);
	return 1;
}
static int lua_glLoadName(lua_State* L)
{
	GLuint name = (GLuint)lua_tointeger(L,1);
	glLoadName(name);
	return 0;
}
static int lua_ReleaseDC(lua_State* L)
{
	HWND hwnd = (HWND)lua_touserdata(L,1);
	HDC hdc = (HDC) lua_touserdata(L,2);
	ReleaseDC(hwnd,hdc);
	return 0;
}
static int lua_ReadBmpTexture(lua_State* L)
{
  const char* ImageName = lua_tostring(L,1);	
	unsigned char *image;
	FILE *fp;
	int srcx, srcy;
	int i, j;
	int rc;
	int width, height;

	/* load a image */ 
	fp = fopen(ImageName,"rb");
	if(!fp) return 0;
	fseek(fp,18L,0);
	rc=fread(&width,sizeof(long),1,fp);
	rc=fread(&height,sizeof(long),1,fp);
	srcx = width;  srcy = height;
	fseek(fp,54L,0);	
	image = (unsigned char *)malloc(width*height*3);
	rc=fread(image,width*height*3,1,fp);
	fclose(fp);
	unsigned char* imagedata = (unsigned char *)malloc(srcx*srcy*3);	
	for(i=0; i<srcx; i++) {
		for(j=0; j<srcy; j++) {
			*(imagedata+i*srcx*3+j*3+0) = (unsigned char)*(image+i*srcx*3+j*3+2);
			*(imagedata+i*srcx*3+j*3+1) = (unsigned char)*(image+i*srcx*3+j*3+1);
			*(imagedata+i*srcx*3+j*3+2) = (unsigned char)*(image+i*srcx*3+j*3+0);
		}
	}
	free(image);
	lua_pushinteger(L,srcx);
	lua_pushinteger(L,srcy);
	lua_pushlightuserdata(L,imagedata);
	return 3;
}
static int lua_glPushMatrix(lua_State* L){
	glPushMatrix();
	return 0;
}
static int lua_glPopMatrix(lua_State* L){
	glPopMatrix();
	return 0;
}
static void inside(GLuint a,GLuint b,GLenum face,GLenum test)
{
	glEnable(GL_CULL_FACE); 
	glEnable(GL_DEPTH_TEST);
	glDisable(GL_STENCIL_TEST);
	glColorMask(GL_FALSE, GL_FALSE, GL_FALSE, GL_FALSE);
	glCullFace(face);
	glCallList(a);

	glDepthMask(GL_FALSE);
	glEnable(GL_STENCIL_TEST);
	glStencilFunc(GL_ALWAYS, 0, 0);
	glStencilOp(GL_KEEP, GL_KEEP, GL_INCR);
	glCullFace(GL_BACK);
	glCallList(b);

	glStencilOp(GL_KEEP, GL_KEEP, GL_DECR);
	glCullFace(GL_FRONT);
	glCallList(b);


	glDepthMask(GL_TRUE);
	glColorMask(GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);
	glStencilFunc(test, 0, 1);
	glDisable(GL_DEPTH_TEST);
	glCullFace(face);
	glCallList(a);

	glDisable(GL_STENCIL_TEST);
	glEnable(GL_DEPTH_TEST);
}
static void fixup(GLuint glid)
{
	glColorMask(GL_FALSE, GL_FALSE, GL_FALSE, GL_FALSE);
	glEnable(GL_DEPTH_TEST);
	glDisable(GL_STENCIL_TEST);
	glDepthFunc(GL_ALWAYS);
	glCallList(glid);

	glDepthFunc(GL_LESS);
}
static int lua_and_obj(lua_State* L)
{
	int a = lua_tointeger(L,1);
	int b = lua_tointeger(L,2);
	inside(a,b,GL_BACK,GL_NOTEQUAL);
	fixup(b);
	inside(b,a,GL_BACK,GL_NOTEQUAL);
	return 0;
}
static int lua_sub_obj(lua_State* L)
{
	int a = lua_tointeger(L,1);
	int b = lua_tointeger(L,2);
	inside(b,a,GL_FRONT,GL_NOTEQUAL);
	fixup(a);
	//inside(b,a,GL_FRONT,GL_NOTEQUAL);
	inside(a,b,GL_BACK,GL_EQUAL);
	return 0;
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
	{"CreateFont",lua_CreateFont},
	{"SetFont",lua_SetFont},
	{"DeleteFont",lua_DeleteFont},
	{"wglUseFontBitmaps",lua_wglUseFontBitmaps},
	{"wglMakeCurrent",lua_wglMakeCurrent},
	{"wglShareLists",lua_wglShareLists},
	{"SetWidowPixelFormat",lua_SetWindowPixelFormat},
	{"wglCreateContext",lua_wglCreateContext},
	{"wglDeleteContext",lua_wglDeleteContext},
	{"wglGetCurrentDC",lua_wglGetCurrentDC},
	{"ReadBmpTexture",lua_ReadBmpTexture},
	{"FreeImage",lua_FreeImage},
	{"GetDC",lua_GetDC},
	{"ReleaseDC",lua_ReleaseDC},
	{"glLoadName",lua_glLoadName},
	{"glPopMatrix",lua_glPopMatrix},
	{"glPushMatrix",lua_glPushMatrix},
	{"glAndObj",lua_and_obj},
	{"glSubObj",lua_sub_obj},
	{"glTranslated",lua_glTranslated},
	{"glRotated",lua_glTranslated},
	{"glMultMatrixd",lua_glMultMatrixd},
	{"glScaled",lua_glScaled},
	{NULL,NULL}
};

int luaopen_luaext_gl(lua_State* L){
	luaL_newlib(L,luagl_f);
	return 1;
}
