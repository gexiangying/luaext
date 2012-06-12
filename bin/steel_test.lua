package.cpath="?.dll"
local m = require "steel"
mb1 = {
	section = "H200*150*20*15";
	length = 1000;{
	}
}

a = m.create_member(mb1)
print("surfaces pointlist ")
print("pointn == "..a["pointn"])
print("pt1 == "..a["pointlist"][1]["y"])
print("pt2 == "..a["pointlist"][2]["y"])
print("pt3 == "..a["pointlist"][3]["y"])
print("pt4 == "..a["pointlist"][4]["y"])
print("surfaces patchlist ")
print("line == "..a["line"])
print("triangle == "..a["triangle"])
print("quadric == "..a["quadric"])
print("patch1 == "..a["patchlist"][1])
print("patch2 == "..a["patchlist"][2])
print("patch3 == "..a["patchlist"][3])
print("patch4 == "..a["patchlist"][4])

m.member_surface(a);
