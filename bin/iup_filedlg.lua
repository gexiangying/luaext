package.cpath="?;?.lua;?.dll"

local iup = require "iuplua"

module (...,package.seeall)




function open_file_dlg(file_kind)
    file_kind = file_kind or "ifc"
	local dlg = iup.filedlg{ filter = "*." .. file_kind , filterinfo = file_kind .." files"}
    local file = "";
	

	dlg:popup()
    if dlg.status ~= "-1" then
        file = dlg.value;
    end
	return file
end
function save_file_dlg(file_kind)
    file_kind = file_kind or "ifc"
    local dlg = iup.filedlg{ dialogtype="SAVE", filter = "*." .. file_kind , filterinfo = file_kind .." files"}
	local file = ""
    dlg:popup()
    if dlg.status ~= "-1" then
        file = dlg.value
		if(not string.find(file,file_kind))then
			file = file .. "."	.. file_kind;
		end
   end
	
	return file
end


function idle_cb()
  local value = gauge.value
  --do_something();
  value = value + g_step;
  if value > 1.0 then
	 value = 0.0;
  end
  gauge.value = value
  return iup.DEFAULT
end


g_dlg = {};

iup.LoopStep()

function create_progress_bar_dlg(step)
	g_step = step;
	gauge = iup.gauge{};
	gauge.show_text = "YES";
	g_dlg = iup.dialog{gauge; title = "Please Waitting...";minbox="NO";maxbox = "NO";size = "130,150"};
	iup.SetIdle(idle_cb);
	g_dlg:showxy(iup.CENTER, iup.CENTER);
	if (iup.MainLoopLevel()==0) then
		iup.MainLoop()
	end

end




local cancelflag;
local gaugeProgress;
local dlgProgress;

function start_progress_bar()
    cancelbutton = iup.button {
        title = "Cancel",
        action=function()
            cancelflag = true
            return iup.CLOSE
        end
    }
    gaugeProgress = iup.gauge{ expand="HORIZONTAL" ,show_text = "YES",fgcolor = "1 2 192"};

	dlgProgress = iup.dialog{
        title = "Please Waiting",
        dialogframe = "YES", border = "YES",
        iup.vbox {
            gaugeProgress,
            --cancelbutton,
    }
    }
    --dlgProgress.size = "QUARTERxEIGHTH"
    dlgProgress.menubox = "Yes"  --  Remove Windows close button and menu.
	dlgProgress.inbox="NO";
	dlgProgress.maxbox = "NO";
 	dlgProgress.size = "130,150" ;
    --dlgProgress.close_cb = cancelbutton.action
    dlgProgress:showxy(iup.CENTER, iup.CENTER)  --  Put up Progress Display
	gaugeProgress.value = 0.0;
    return gaugeProgress
end

function close_progress_bar()
	dlgProgress:hide();
end


function show_dlg_info(info)
	local empty = iup.label{title="                 ",size=140}
	local info_static = iup.label{title=info,size=140}

	
	g_dlg = iup.dialog{iup.vbox {empty,info_static}; title = "Tools";size = "150x60"};
	g_dlg:showxy(iup.CENTER, iup.CENTER);
	
end

function show_rei_info()
	local empty = iup.label{title="                 ",size=140}
	local com = iup.label{title="阿依艾工程软件(大连)有限公司",size=140}
	local eng = iup.label{title="REI ENGINEERING SOFTWARE CO., LTD",size=140}
	local tel = iup.label{title="86-041184753206 ",size=140}
	local ver = iup.label{title="v1.0",size=140}

	
	g_dlg = iup.dialog{iup.vbox {empty,com,eng,tel,ver}; title = "About";size = "150x80"};
	g_dlg:showxy(iup.CENTER, iup.CENTER);
	
end











