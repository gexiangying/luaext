
Entity = {}
Member = {}
Plate = {}
setmetatable(Member,Entity)
setmetatable(Plate,Entity)	

model = {};

model.nodes = {
	["O"] = {x=0,y=0,z=0};
	["1"] = {x=1000,y=0,z=1000};
	["2"] = {x=0,y=1000,z=1000};
	["3"] = {x=0,y=0,z=1000};
};

model.styles = {
	["1G-1"] = {
		section = "H200*150*20*15";
		beta = 0;
		color = {r=1,g=0,b=0};
		material = "SS440";
	};
	["PL-1"] = {
		thick = 6;
		color ={r=1,g=0,b=0};
		material = "SS440";
	};
};

model.db = {
	{
		pt1 = model.nodes["0"];
		pt2 = model.nodes["1"];
		style = model.styles["1G-1"];
	};
	{
		pts = {model.nodes["0"];model.nodes["1"];model.nodes["1"];model.nodes["1"];};
		style = model.styles["PL-1"];
	};
};

