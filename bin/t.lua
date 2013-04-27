package.cpath="?.dll;?51.dll"

require "luaredis"

function trace_out(str)
	print(str);
end

function add_user(name,pass)
	trace_out("#### 	add_user() 	####\n");
	if not name or not pass then return end;
	local redis = luaredis.new("www.qqft.com",6379);
	if not redis then trace_out("Net wrong\n") return end;
	local result = redis:hset("user",name,pass)
	trace_out("hset result="..result.."\n");
	local val = redis:hget("user",name);
	trace_out("hget value="..(val or "nil").."\n");
	redis:close();
	trace_out("Teh End\n");
end

add_user("x","x")