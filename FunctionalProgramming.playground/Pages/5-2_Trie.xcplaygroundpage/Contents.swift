//: 基于字典树的自动补全

struct Trie<Element:Hashable>{
    /// 标记截止于当前节点的字符串是否在树中
    let isElement:Bool
    /// 储存节点元素与子树的对应关系
    let children:[Element:Trie]
}


extension Trie{

    /// 创建一个空树
    init() {
        isElement = false
        children = [:]
    }
    
    /// 创建只含有一个数组元素的字典树
    init(_ key:[Element]) {
        
        if let (head,tail) = key.decompose {
            let children = [head:Trie(tail)]
            self = Trie(isElement: false, children: children)
        }else{
            self = Trie(isElement: true, children: [:])
        }
    }
    
    
}

/*** 数组测试
 
 let a : [[Int]] = [[1]]
 let b:[[Int]] = []
 let c:[[Int]] = [[]]
 
 let d = a+b    // [[1]]
 let e = a+c   // [[1], []]
 
 ****/


extension Trie{
    
    /// 字典树中存放的所有元素(一般是字符串)
    var elements:[[Element]]{
        
        var result:[[Element]] = isElement ? [[]]:[]
        for (key,value) in children{
            result += value.elements.map{ [key] + $0 }
        }
        return result
    }
}


extension Array{
    
    /**decompose 函数会检查一个数组是否为空。如果为空，就返回一个 nil；
     反之，则会返回一个多元组，这个多元组包含该数组的第一个元素，以及去掉第
     一个元素之后由该数组其余元素组成的新数组。我们可以通过重复调用 decompose 
     递归地遍历一个数组，直到返回 nil，而此时数组将为空
     **/
    
    /// 分离数组的首元素与剩余元素 (head, tail)
    var decompose:(Element,[Element])?{
        
        return isEmpty ? nil:(self[startIndex],Array(self.dropFirst()))
    }
}


extension Trie{
    /// 查询给定元素是否在字典树中
    func lookup(key:[Element]) -> Bool {
        
        guard let (head,tail) = key.decompose else { return isElement }
        
        guard let subTrie = children[head] else { return false }
        
        return subTrie.lookup(key: tail)
    }
    
    /// 给定一个前缀,返回所有匹配元素的子树
    func wifthPrefix(prefix:[Element])->Trie<Element>?{
        
        guard let (head,tail) = prefix.decompose else { return self }
        guard let subTrie = children[head] else { return nil }
        return subTrie.wifthPrefix(prefix: tail)
    }
    
    #if true
    /// 插入一个元素  (创建一棵新树)
    func insert_newTrie(key:[Element])->Trie<Element>{
        
        guard let (head,tail) = key.decompose else { return Trie(isElement: true, children: children) }
        
        var newChildren = children
        if let subTrie = children[head] {
            newChildren[head] = subTrie.insert_newTrie(key: tail)
        }else{
            newChildren[head] = Trie(tail)
        }
        
        return Trie(isElement: isElement, children: newChildren)
    }
    #endif
    
    #if true
    /// 插入一个元素 (修改当前树)
    mutating func insert_self(key:[Element]){
        
        guard let (head,tail) = key.decompose else {
            self = Trie(isElement: true, children: children)
            return
        }
        
        var newChildren = children
        if var subTrie = children[head] { // 更新当前子树
            subTrie.insert_self(key: tail)
            newChildren[head] = subTrie
        }else{ // 创建一棵新子树
            newChildren[head] = Trie(tail)
        }
        
        self = Trie(isElement: isElement, children: newChildren)
    }
    #endif
    
}

extension Trie{
    
    
    /// 自动补全
    ///
    /// - parameter key: 输入的前缀
    ///
    /// - returns: 字典树中带有该前缀的所有剩余元素
    func autoComplete(key:[Element])->[[Element]]{
        
        return wifthPrefix(prefix: key)?.elements ?? []
    }
    
}


/// 创建一个字符串字典树
///
/// - parameter words: 字符串数组
///
/// - returns: 字符串字典树
func buildStringTrie(words:[String])->Trie<Character>{
        
        let emptyTrie = Trie<Character>()
        return words.reduce(emptyTrie) { (trie, word) in
//            var newTrie = trie
//            newTrie.insert(key: Array(word.characters))
//            return newTrie
            trie.insert_newTrie(key: Array(word.characters))
        }
    }
    
/// 字符串自动补全
///
/// - parameter trie: 存储字符串的字典树
/// - parameter word: 输入字符串前缀
///
/// - returns: 字典树中含有输入字符串前缀的字符串元素数组
func autocompleteString(trie:Trie<Character>,word:String)->[String]{
        
        let chars = Array(word.characters)
        let completedArr = trie.autoComplete(key: chars)
        
        return completedArr.map{word + String($0)}
        
}
    

//: 测试 1. 字典树
var a:Trie<Character> = Trie()
/*
let b = a.insert_newTrie(key: ["a","b","c"])
let b2 = b.insert_newTrie(key: ["a","d","c"])
print(b2.elements)
let c = b2.autoComplete(key: ["a"])
 */
a.insert_self(key: ["a","b","c"])
a.insert_self(key: ["a","d","c"])
let c = a.autoComplete(key: ["a"])
print(a.elements)
print(c)
/*
 输出:
 [["a", "b", "c"], ["a", "d", "c"]]
 [["b", "c"], ["d", "c"]]
 */
print("==================")

//: 测试 2. 字符串字典树

let m = buildStringTrie(words: ["asdf","asxc","aer"])
let n = autocompleteString(trie: m, word: "as")
print(n)
/*
 输出:
 ["asdf", "asxc"]
 */
