
local Module = {}
function splitBlankAndCombineFirstLetter(str)
    local result = ""
    -- %S+ 匹配连续的非空白字符（即单词）
    for word in string.gmatch(str, "%S+") do
        -- 获取每个单词的第一个字母
        result = result .. string.sub(word, 1, 1)
    end
    return result
end

function Module.dump(t, indent)
   indent = indent or ""
   if type(t) ~= "table" then log.error(indent .. tostring(t)) return end

    for k, v in pairs(t) do
       if type(v) == "table" then
            log.error(indent .. tostring(k) .. ":" )
            Module.dump(v, indent .. "  ") -- 递归打印
        else
            log.error(indent .. tostring(k) .. " = " .. tostring(v))
        end
    end
end

local trie = require("ylagr.trie")

function Module.init(env)
   env.commit_history_trie = trie:new()
   env.commit_history_table = {}
   env.commit_history_list = {}
   
   -- log.error(type(env.commit_history_table))
   
   local ctx = env.engine.context
   -- ctx.commit_notifier:connect(function()
   -- local commit_text = ctx:get_commit_text()
   -- if not commit_text or commit_text == "" then return end
   ctx.commit_notifier:connect(
      function ()
	 local commit_text = ctx:get_commit_text()
	 if not commit_text or commit_text == "" then return end
	 
	 -- log.error(commit_text)
	 -- Module.dump(ctx:get_preedit().text)
	 -- Module.dump(ctx:get_preedit())
	 if utf8.len(commit_text) <=4 then return end
	 local commit_preedit = ctx:get_preedit().text
	 if #env.commit_history_list > 500 then
	    local removed_key = table.remove(env.commit_history_list, 1)
	    table[removed_key] = nil
	    env.commit_history_trie:delete(removed_key)
	 end
	 
	 -- table.insert(env.commit_history_table, ctx:get_preedit().text, ctx:get_commit_text())
	 local ijjp = splitBlankAndCombineFirstLetter(commit_preedit)
	 -- log.error(commit_preedit)
	 if ijjp == nil then return end
	 local ijjp_len = utf8.len(ijjp)
	 if ijjp_len == nil or ijjp_len <= 4 then return end
	 -- log.error(ijjp)
	 table.insert(env.commit_history_list, ijjp)
	 env.commit_history_table[ijjp] = commit_text
	 env.commit_history_trie:insert(ijjp)
      end
   )

end

function Module.func(input, seg, env)
   -- local ctx = env.engine.context
   -- log.error(type(env))
   -- log.error(type(ctx))
   
end
function Module.fini(env)
   -- Module.dump(env.commit_history_table, "ijjp test： ")
   -- env.commit_notifier:disconnect()
   -- if env.commit_notifier ~= nil then
      -- env.commit_notifier:disconnect()
   -- end
   -- env.commit_history_list = nilg
   -- env.commit_history_table = nil
   -- env.commit_history_trie = nil
   -- collectgarbage()
end



return Module
