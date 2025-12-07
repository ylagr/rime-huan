--- type filter

-- 【过滤器】放在 simplifier 之后
-- 负责把“原繁体字”藏进 type 字段里
local function origin_injector(input, env)
   for cand in input:iter() do
      -- 获取“真身”候选词（即未经过 simplifier 转换前的候选词）
      local genuine = cand:get_genuine()
      
      -- 如果真身存在，且真身的文本与当前显示的文本不同（说明发生了转换）
      if genuine 
      -- and genuine.text ~= cand.text 
      then
         -- 将原字（genuine.text）追加到 type 字段中，使用 ||| 作为分隔符
         -- 这样不仅保存了原有的 type（如 simplified），还带上了私货
         cand.type = cand.type .. "|||" .. genuine.text
      end
      
      yield(cand)
   end
end


return origin_injector





