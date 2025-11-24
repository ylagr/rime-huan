-- by light

local M = {}

-- 主处理函数
function M.func(input, env)
   for cand in input:iter() do
      -- 直接获取拆分注释
      -- {"type", "text", "comment", "quality", "start", "_end", "preedit"}
      if cand.type ~= "" then
	 if cand.type == "table" or cand.type == "user_table" then
	    cand.comment = cand.comment .. "|" .. "☯️"
	 else
	    cand.comment = cand.comment .. "|" .. cand.type .. "|" .. cand.quality
	 end
      end
      yield(cand)
   end
end

return { func = M.func }
