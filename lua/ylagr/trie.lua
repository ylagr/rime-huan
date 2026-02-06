-- 定义 Trie 类和其方法
local Trie = {}
Trie.__index = Trie

-- 构造函数：创建一个新的 Trie 实例
function Trie:new()
    local self = setmetatable({}, Trie)
    -- 根节点是一个表格，用于存储子节点
    self.root = { children = {}, isEndOfWord = false }
    return self
end

-- 辅助方法：遍历前缀树，找到指定键（单词/前缀）的最后一个节点
local function traverse(self, word)
    local current = self.root
    for i = 1, #word do
        local char = word:sub(i, i)
        if not current.children[char] then
            return nil
        end
        current = current.children[char]
    end
    return current
end

-- 插入一个单词到前缀树中
function Trie:insert(word)
   local current = self.root
   -- log.error("trie: " .. word)
    for i = 1, #word do
        local char = word:sub(i, i)
        -- 如果子节点不存在，则创建它
        if not current.children[char] then
            current.children[char] = { children = {}, isEndOfWord = false }
        end
        -- 移动到下一个节点
        current = current.children[char]
    end
    -- 标记单词的结束
    current.isEndOfWord = true
end

-- 查找一个完整的单词是否存在
function Trie:search(word)
    local node = traverse(self, word)
    -- 如果找到了节点，并且该节点被标记为单词结束
    return node ~= nil and node.isEndOfWord
end

-- 检查是否有单词以指定前缀开头
function Trie:startsWith(prefix)
    -- 只要能沿着路径走到底，就说明前缀存在
    return traverse(self, prefix) ~= nil
end

-- 接着上面的 Trie 实现，添加 delete 方法
-- 假设 Trie 类和辅助函数 traverse 已经定义

-- 辅助函数：递归删除（私有方法）
-- node: 当前节点, word: 待删除的单词, index: 当前处理到的字符索引
local function delete_recursive(node, word, index)
    if index > #word then
        -- 已经到达单词末尾，检查是否确实是一个完整的单词
        if not node.isEndOfWord then
            return false -- 单词不存在，无需删除
        end
        -- 标记为不再是单词结尾
        node.isEndOfWord = false
        -- 如果当前节点没有子节点了，可以开始回溯删除
        return next(node.children) == nil
    end

    local char = word:sub(index, index)
    local child_node = node.children[char]

    if not child_node then
        return false -- 路径不存在，单词不存在
    end

    -- 递归删除下一个字符
    local should_delete_child = delete_recursive(child_node, word, index + 1)

    -- 如果子节点应该被删除
    if should_delete_child then
        node.children[char] = nil -- 移除子节点的引用
        -- 如果父节点自身也不是其他单词的结尾，且没有其他子节点，则父节点也可以被删除
        return next(node.children) == nil and not node.isEndOfWord
    end

    return false -- 子节点有其他用途，不能删除当前路径
end

-- 公共删除方法
function Trie:delete(word)
    -- 从根节点开始调用递归删除
    delete_recursive(self.root, word, 1)
end


-- 辅助函数：深度优先搜索（DFS），收集从当前节点开始的所有单词
local function collect_words_dfs(node, current_word, results)
    if node.isEndOfWord then
        table.insert(results, current_word)
    end

    -- 遍历所有可能的子节点
    for char, child_node in pairs(node.children) do
        collect_words_dfs(child_node, current_word .. char, results)
    end
end

-- 公共方法：根据前缀查询所有匹配的单词
function Trie:findByPrefix(prefix)
    local current = self.root
    -- 1. 遍历到前缀的最后一个字符节点
    for i = 1, #prefix do
        local char = prefix:sub(i, i)
        if not current.children[char] then
            return {} -- 如果前缀不存在，返回空列表
        end
        current = current.children[char]
    end

    -- 2. 从前缀结束的节点开始，进行 DFS 收集所有单词
    local results = {}
    collect_words_dfs(current, prefix, results)
    return results
end



return Trie
