module(...,package.seeall)
menu = { name = "test", items = {
	{ id = ID + 2, name = "test1"},
	{ id = ID + 3, name = "test2"},
  { id = ID + 4, name = "test3"},
	},
}
menu1 = { name = "test2", items = {
	{ id = ID + 5, name = "test21"},
	{ id = ID + 6, name = "test22"},
  { id = ID + 7, name = "test23"},
	},
}
function create_menu()
add_menu(frm,menu)
add_menu(frm,menu1)
end
toolbar = { bmpname = "toolbar.bmp",nbmps = 36,id = 11040,dxButton = 0, dyButton = 0,dxBitmap = 16,dyBitmap = 15,
	buttons = {
		{iBitmap = 8,idCommand = 10002 , fsState = TBSTATE_ENABLED, fsStyle = BTNS_BUTTON, iString = "open"},
		{iBitmap = 9,idCommand = ID + 2, fsState = TBSTATE_ENABLED, fsStyle = BTNS_BUTTON, iString = "tool1"},
		{iBitmap = 10,idCommand = ID + 3, fsState = TBSTATE_ENABLED, fsStyle = BTNS_BUTTON, iString = "tool2"},
		{iBitmap = 11,idCommand = ID + 4, fsState = TBSTATE_ENABLED, fsStyle = BTNS_BUTTON, iString = "tool3"},
	},
}
toolbar1 = { bmpname = "toolbar.bmp",nbmps = 36,id = 11041,dxButton = 0, dyButton = 0,dxBitmap = 16,dyBitmap = 15,
	buttons = {
		{iBitmap = 8,idCommand = ID + 5, fsState = TBSTATE_ENABLED, fsStyle = BTNS_BUTTON, iString = "≤‚ ‘5"},
		{iBitmap = 9,idCommand = ID + 6, fsState = TBSTATE_ENABLED, fsStyle = BTNS_BUTTON, iString = "tool6"},
		{iBitmap = 10,idCommand = ID + 7, fsState = TBSTATE_ENABLED, fsStyle = BTNS_BUTTON, iString = "tool7"},
	},
}
function create_toolbar()
crt_toolbar(frm,toolbar)
crt_toolbar(frm,toolbar1)
end
