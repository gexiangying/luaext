
setfenv(1,ifc);

local model_ = nil;
function model(md)
	trace_out("#### ifc_model ####\n");
	model_ = md or model_;
	return model_;
end

function model_draw()
	trace_out("#### ifc_model_draw ####\n");
	
end
