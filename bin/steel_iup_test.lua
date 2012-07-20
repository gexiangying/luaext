package.cpath="?.dll;?51.dll";
local iup = require "iuplua"
local iupcontrol = require( "iupluacontrols" )
module (...,package.seeall)



--main----------------
function pop_tabs()
	-- Creates boxes
	vboxA = iup.vbox{iup.fill{}, iup.label{title="TABS AAA", expand="HORIZONTAL"}, iup.button{title="AAA"}}
	vboxB = iup.vbox{iup.label{title="TABS BBB"}, iup.button{title="BBB"}}

	-- Sets titles of the vboxes
	vboxA.tabtitle = "AAAAAA"
	vboxB.tabtitle = "BBBBBB"

	-- Creates tabs 
	tabs = iup.tabs{vboxA, vboxB}

	-- Creates dialog
	dlg = iup.dialog{iup.vbox{tabs; margin="10x10"}; title="Test IupTabs", size="150x80"}
	-- Shows dialog in the center of the screen
	dlg:showxy(iup.CENTER, iup.CENTER)

	if (iup.MainLoopLevel()==0) then
	  iup.MainLoop()
	end
end

function pop_toggle()
	img1 = iup.image{
		   {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
		   {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
		   {1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1},
		   {1,1,1,1,1,1,2,2,1,1,1,1,1,1,1,1},
		   {1,1,1,1,1,2,1,2,1,1,1,1,1,1,1,1},
		   {1,1,1,1,2,1,1,2,1,1,1,1,1,1,1,1},
		   {1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1},
		   {1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1},
		   {1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1},
		   {1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1},
		   {1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1},
		   {1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1},
		   {1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1},
		   {1,1,1,2,2,2,2,2,2,2,2,2,1,1,1,1},
		   {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
		   {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1};
		   colors = {"255 255 255", "0 192 0"}
	}

	img2 = iup.image{
		   {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
		   {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
		   {1,1,1,1,2,2,2,2,2,2,1,1,1,1,1,1},
		   {1,1,1,2,1,1,1,1,1,1,2,1,1,1,1,1},
		   {1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1},
		   {1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1},
		   {1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1},
		   {1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,1},
		   {1,1,1,1,1,1,1,1,2,1,1,1,1,1,1,1},
		   {1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1},
		   {1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1},
		   {1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1},
		   {1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1},
		   {1,1,1,2,2,2,2,2,2,2,2,2,1,1,1,1},
		   {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
		   {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1};
		   colors = {"255 255 255", "0 192 0"}
	}

	toggle1 = iup.toggle{title = "", image = img1}
	toggle2 = iup.toggle{title = "deactivated toggle with image", image = img2, active="NO"}
	toggle3 = iup.toggle{title = "regular toggle"}
	toggle4 = iup.toggle{title = "toggle with blue foreground color", fgcolor = BLUE }
	toggle5 = iup.toggle{title = "toggle with red background color", bgcolor = RED }
	toggle6 = iup.toggle{title = "toggle with black backgrounf color and green foreground color", fgcolor = GREEN, bgcolor = BLACK }
	toggle7 = iup.toggle{title = "deactivated toggle", active = "NO" }
	toggle8 = iup.toggle{title = "toggle with Courier 14 Bold font", font = "COURIER_BOLD_14" }
	toggle9 = iup.toggle{title = "toggle with size EIGHTxEIGHT", size = "EIGHTHxEIGHTH" }

	function toggle1:action(v)
	   if v == 1 then estado = "pressed" else estado = "released" end
	   iup.Message("Toggle 1",estado)
	end

	box = iup.vbox{ 
					 toggle1,
					 toggle2,
					 toggle3,
					 toggle4,
					 toggle5,
					 toggle6,
					 toggle7,
					 toggle8,
					 toggle9
				   }
					
	toggles = iup.radio{box; expand="YES"}
	dlg = iup.dialog{toggles; title = "IupToggle", margin="5x5", gap="5", resize="NO"}
	dlg:showxy(iup.CENTER, iup.CENTER)
end

function pop_list()
	-- IupList Example in IupLua 
	-- Creates a dialog with three frames, each one containing a list. The first is a simple list, the second one is a multiple list and the last one is a drop-down list. The second list has a callback associated. 

	require( "iuplua" )

	-- Creates a list and sets items, initial item and size
	list = iup.list {"Gold", "Silver", "Bronze", "None"
		   ; value = 4, size = "EIGHTHxEIGHTH"}
		   
	list[5] = "test"

	-- Creates frame with simple list and sets its title
	frm_medal = iup.frame {list ; title = "Best medal"}
	  
	-- Creates a list and sets its items, multiple selection, initial items and size
	list_multiple = iup.list {"100m dash", "Long jump", "Javelin throw", "110m hurdlers", "Hammer throw", "High jump"
					; multiple="YES", value="+--+--", size="EIGHTHxEIGHTH"}

	-- Creates frame with multiple list and sets its title
	frm_sport = iup.frame {list_multiple
				; title = "Competed in"}

	-- Creates a list and sets its items, dropdown and amount of visible items 
	list_dropdown = iup.list {"Less than US$ 1000", "US$ 2000", "US$ 5000", "US$ 10000", "US$ 20000", "US$ 50000", "More than US$ 100000"
					; dropdown="YES", visible_items=5}
	  
	-- Creates frame with dropdown list and sets its title
	frm_prize = iup.frame {list_dropdown
				; title = "Prizes won"}

	-- Creates a dialog with the the frames with three lists and sets its title
	dlg = iup.dialog {iup.hbox {frm_medal, frm_sport, frm_prize}
		  ; title = "IupList Example"}

	-- Shows dialog in the center of the screen
	dlg:showxy(iup.CENTER, iup.CENTER)

	function list_multiple:action(t, i, v)
	  if v == 0 then 
		state = "deselected" 
	  else 
		state = "selected" 
	  end
	  iup.Message("Competed in", "Item "..i.." - "..t.." - "..state)
	  return iup.DEFAULT
	end

	if (iup.MainLoopLevel()==0) then
	  iup.MainLoop()
	end

end
