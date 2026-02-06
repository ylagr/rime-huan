
local function commit_history(input, seg, env)
   local ctx = env.engine.context
   -- log.error(tostring(ctx))
   -- ctx.commit_notifier:connect(function()
   -- local commit_text = ctx:get_commit_text()
   -- if not commit_text or commit_text == "" then return end
   ctx.commit_notifier:connect(
      function ()
	 
	 local commit_text = ctx:get_commit_text()

	 if not commit_text or commit_text == "" then return end
	 log.error(commit_text)	 
      end
   )

end

local function func(input, seg, env)
   local ctx = env.engine.context
   log.error(type(env))
   log.error(type(ctx))
   
end

return commit_history
