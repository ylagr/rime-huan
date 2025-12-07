

-- 处理器：监听 ~ 键，提取 comment 中的原字上屏
local function raw_commit(key, env)
   local context = env.engine.context
   -- 只有在输入状态（菜单开启）时才拦截
   if context:is_composing() then
    
    local keystr = key:repr()
    if string.find(keystr, "asciitilde") then
        if context.input == "~" then 
            return 2
        end
        local cand = context:get_selected_candidate()
        -- 尝试从 type 字段中提取 || 后面的内容
        -- 匹配模式：任意字符 + || + (我们要的繁体字) + 结尾
        local origin_text = cand.type:match("|||(.+)$")
        
        if origin_text then
            context:clear_previous_segment()
            local commit_text = context:get_commit_text()
            context:clear()
            log.error(origin_text .. "  :test raw_commit")
            env.engine:commit_text(commit_text .. origin_text)
            return 1 -- 1 代表 kAccepted，表示按键已被处理
         end
    end
   end
   return 2 -- 2 代表 kNoop，表示未处理，交给后续流程（如默认输入 ~）
end

return raw_commit