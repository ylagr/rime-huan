
-- 示例用法：
local trie = Trie:new()
trie:insert("apple")
trie:insert("app")
trie:insert("banana")

print("查找 apple:", trie:search("apple")) -- true
print("查找 app:", trie:search("app"))   -- true
print("查找 banana:", trie:search("banana")) -- true
print("查找 ban:", trie:search("ban"))   -- false
print("查找 orange:", trie:search("orange")) -- false

print("检查前缀 app:", trie:startsWith("app")) -- true
print("检查前缀 ora:", trie:startsWith("ora")) -- false

-- 示例用法：
local trie = Trie:new()
trie:insert("apple")
trie:insert("app")
trie:insert("banana")

print("--- 初始状态 ---")
print("查找 apple:", trie:search("apple")) -- true
print("查找 app:", trie:search("app"))     -- true
print("前缀 app:", trie:startsWith("app")) -- true

trie:delete("apple")

print("\n--- 删除 'apple' 后 ---")
print("查找 apple:", trie:search("apple")) -- false
print("查找 app:", trie:search("app"))     -- true (app 仍然存在)
print("前缀 app:", trie:startsWith("app")) -- true (因为 app 还在)

trie:delete("app")

print("\n--- 删除 'app' 后 ---")
print("查找 apple:", trie:search("apple")) -- false
print("查找 app:", trie:search("app"))     -- false
print("前缀 app:", trie:startsWith("app")) -- false (路径被彻底清除了)

print("查找 banana:", trie:search("banana")) -- true (不影响其他单词)
