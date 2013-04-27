module(..., package.seeall)



error_count_ = 0;
function cmp_number(tip, a, b)
	txt = tip.."\t"..a.."\t"..b.."\t\t";
	FMIN = 0.0001;
	L = a-b;
	R = b-a;
	if L>FMIN or R>FMIN then
		txt=txt.."¡Á";
		error_count_ = error_count_+1;
	else
		txt=txt.."¡Ì";
	end
	print(txt);
end

function cmp_array(tip, a, b, f)
	print(tip);
	local an = table.getn(a);
	local bn = table.getn(b);
	cmp_number("n: ", an, bn);
	if an ~= bn then return end;
	for i=1, bn, 1 do
		txt = tip.."["..i.."]";
		f(txt, a[i], b[i]);
	end
end

function cmp_point(tip, a, b)
	print(tip);
	local an = table.getn(a);
	local bn = table.getn(b);
	cmp_number("point:", an, bn);
	if an < 8 then print("an<8") return end;
	if bn < 8 then print("bn<8") return end;
--	cmp_number("r:", a[1], b[1]);
--	cmp_number("g:", a[2], b[2]);
--	cmp_number("g:", a[3], b[3]);
	cmp_number("x:", a[6], b[6]);
	cmp_number("y:", a[7], b[7]);
	cmp_number("z:", a[8], b[8]);
end

function cmp_patch(tip, a, b, patchn)
	print(tip);
	local an = table.getn(a);
	local bn = table.getn(b);
	cmp_number("patch:", an, bn);
	if an < patchn then print("an<"..patchn) return end;
	if bn < patchn then print("bn<"..patchn) return end;
	for i=1, patchn,  1 do
		cmp_number(i..":", a[i], b[i]);
	end
end

function cmp_lines(tip, a, b)
	cmp_patch(tip, a, b, 2);
end
function cmp_triangles(tip, a, b)
	cmp_patch(tip, a, b, 3);
end
function cmp_quadrangles(tip, a, b)
	cmp_patch(tip, a, b, 3);
end

function cmp_surface(tip, a, b)
	print(tip.."------------------------------------------------------------------");
	cmp_array("points", a.points, b.points, cmp_point);
	cmp_array("lines", a.lines, b.lines, cmp_lines);
	cmp_array("triangles", a.triangles, b.triangles, cmp_triangles);
	cmp_array("quadrangles", a.quadrangles, b.quadrangles, cmp_quadrangles);
end

function cmp_obj(tip, a, b)
	print(tip);
	cmp_number("index:", a.index, b.index);
	cmp_array("surfaces", a.surfaces, b.surfaces, cmp_surface);
end

function error_count()
	return error_count_;
end


