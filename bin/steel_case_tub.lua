module(..., package.seeall)

m = {
	member = {
		section = "S200*150*20";
		start_point = {x=0,y=2500,z=0};
		end_point = {x=2000,y=2500,z=0};
		color = {r=0.5,g=0,b=1};
	};
	index = 0;
	SurNum = 10;
	surflist = {
		-- 1
		{
			pointn = 4;
			line = 4;
			triangle = 0;
			quadric = 1;
			pointlist = {
				{x = 0;	y = -75; z =  100;};
				{x = 0; y = -75; z = -100;};
				{x = 1000; y = -75; z =  100;};
				{x = 1000; y = -75; z = -100;};
			};
			patchlist = {1,2; 2,4; 4,3; 3,1; 1,2,4,3;};
		};
		{
			pointn = 4;
			line = 4;
			triangle = 0;
			quadric = 1;
			pointlist = {
				{x = 0; y = -75; z = -100;};
				{x = 0;	y =  75; z = -100;};
				{x = 1000; y = -75; z = -100;};
				{x = 1000; y =  75; z = -100;};
			};
			patchlist = {1,2; 2,4; 4,3; 3,1; 1,2,4,3;};
		};
		{
			pointn = 4;
			line = 4;
			triangle = 0;
			quadric = 1;
			pointlist = {
				{x = 0; y = 75; z = -100;};
				{x = 0;	y = 75; z =  100;};
				{x = 1000; y = 75; z = -100;};
				{x = 1000; y = 75; z =  100;};
			};
			patchlist = {1,2; 2,4; 4,3; 3,1; 1,2,4,3;};
		};
		{
			pointn = 4;
			line = 4;
			triangle = 0;
			quadric = 1;
			pointlist = {
				{x = 0;	y =  75; z = 100;};
				{x = 0; y = -75; z = 100;};
				{x = 1000; y =  75; z = 100;};
				{x = 1000; y = -75; z = 100;};
			};
			patchlist = {1,2; 2,4; 4,3; 3,1; 1,2,4,3;};
		};
		-- 5
		{
			pointn = 4;
			line = 4;
			triangle = 0;
			quadric = 1;
			pointlist = {
				{x = 0;	y = -55; z =  80;};
				{x = 0; y = -55; z = -80;};
				{x = 1000; y = -55; z =  80;};
				{x = 1000; y = -55; z = -80;};
			};
			patchlist = {1,2; 2,4; 4,3; 3,1; 1,2,4,3;};
		};
		{
			pointn = 4;
			line = 4;
			triangle = 0;
			quadric = 1;
			pointlist = {
				{x = 0; y = -55; z = -80;};
				{x = 0;	y =  55; z = -80;};
				{x = 1000; y = -55; z = -80;};
				{x = 1000; y =  55; z = -80;};
			};
			patchlist = {1,2; 2,4; 4,3; 3,1; 1,2,4,3;};
		};
		{
			pointn = 4;
			line = 4;
			triangle = 0;
			quadric = 1;
			pointlist = {
				{x = 0; y = 55; z = -80;};
				{x = 0;	y = 55; z =  80;};
				{x = 1000; y = 55; z = -80;};
				{x = 1000; y = 55; z =  80;};
			};
			patchlist = {1,2; 2,4; 4,3; 3,1; 1,2,4,3;};
		};
		{
			pointn = 4;
			line = 4;
			triangle = 0;
			quadric = 1;
			pointlist = {
				{x = 0;	y =  55; z = 80;};
				{x = 0; y = -55; z = 80;};
				{x = 1000; y =  55; z = 80;};
				{x = 1000; y = -55; z = 80;};
			};
			patchlist = {1,2; 2,4; 4,3; 3,1; 1,2,4,3;};
		};
		-- 9
		{
			pointn = 8;
			line = 8;
			triangle = 0;
			quadric = 4;
			pointlist = {
				{x = 0;	y = -75; z =  100;};
				{x = 0; y = -75; z = -100;};
				{x = 0; y = 75; z = -100;};
				{x = 0;	y = 75; z =  100;};
				
				{x = 0;	y = -55; z =  80;};
				{x = 0; y = -55; z = -80;};
				{x = 0; y = 55; z = -80;};
				{x = 0;	y = 55; z =  80;};
			};
			patchlist = {1,2; 2,3; 3,4; 4,1; 5,6; 6,7; 7,8; 8,5; 
						1,2,6,5; 2,3,7,6; 3,4,8,7; 4,1,5,8;};
		};
		{
			pointn = 8;
			line = 8;
			triangle = 0;
			quadric = 4;
			pointlist = {
				{x = 1000;	y = -75; z =  100;};
				{x = 1000; y = -75; z = -100;};
				{x = 1000; y = 75; z = -100;};
				{x = 1000;	y = 75; z =  100;};
				
				{x = 1000;	y = -55; z =  80;};
				{x = 1000; y = -55; z = -80;};
				{x = 1000; y = 55; z = -80;};
				{x = 1000;	y = 55; z =  80;};
			};
			patchlist = {1,2; 2,3; 3,4; 4,1; 5,6; 6,7; 7,8; 8,5; 
						1,2,6,5; 2,3,7,6; 3,4,8,7; 4,1,5,8;};
		};
	};
};


return m