//:  枚举实现二叉搜索树,作为无序集合库   (函数式数据结构)

/// 递归枚举实现二叉树
///
/// - Leaf: 空节点
/// - Node: 树节点
indirect enum BinarySearchTree<Element:Comparable>{
    case Leaf
    case Node(BinarySearchTree<Element>,Element,BinarySearchTree<Element>)
}

// MARK: - 初始化方法
extension BinarySearchTree{
    
    init() { // 空树
        self = .Leaf
    }
    
    init(nodeValue:Element) { // 树节点
        self = .Node(.Leaf,nodeValue,.Leaf)
    }
    
}

// MARK: - 二叉树的计算属性
extension BinarySearchTree{
     /// 树节点个数
    var count:Int{
        switch self {
        case .Leaf:
            return 0
        case let .Node(left, _, right):
            return 1 + left.count + right.count
        }
    }
    
    
    /// 树中所有元素
    var elements:[Element]{
        switch self {
        case .Leaf:
            return []
        case let .Node(left,x,right):
            return left.elements + [x] + right.elements
        }
    }

    /// 是否为空树
    var isEmpty:Bool{
        
        if case .Leaf = self{
            return true
        }
        return false
    }
    
}


// MARK: - 数组扩展方法
extension Array{
    
    /// 检查数组的每一个元素是否满足条件
    ///
    /// - parameter condition: 检查条件
    ///
    /// - returns: 只要有一个元素不满条件, 就返回false
    func all(_ condition:(Element)->Bool)->Bool{
        for x in self where !condition(x){
            return false
        }
        return true
    }
}

extension BinarySearchTree{
    
    /// 是否是二叉搜索树
    var isBST:Bool{
        switch self {
        case .Leaf:
            return true
        case let .Node(left, x, right):
            return left.elements.all{ $0<x } // 左子树小于该节点
                && right.elements.all{ $0>x }  // 右子树大于该节点
                && left.isBST
                && right.isBST
        }
    }
}


// MARK: - 树的  查找操作 & 插入操作
extension BinarySearchTree{
    
    /// 查找树中是否有某一个元素
    func contains(element:Element)->Bool{
        
        switch self {
        case .Leaf:
            return false
        case let .Node(_, y, _) where y == element:
            return true
        case let .Node(left,y,_) where y > element:
            return left.contains(element: element)
        case let .Node(_,y,right) where y < element:
            return right.contains(element: element)
        default:
            fatalError("THIS IS IMPOSSIBLE:Search Error")
        }
    }
    /// 向树中插入元素 , 并保持搜索树特性
    mutating func insert(element:Element){
        
        switch self{
        
        case .Leaf:
            self = BinarySearchTree(nodeValue: element)
        case .Node(var left, let x, var right):
            if element < x { left.insert(element: element) }
            if element > x { right.insert(element: element) }
            self = .Node(left,x,right)
            
        }
        
    }
    
    
}



var a :BinarySearchTree<Int> = BinarySearchTree()

a.insert(element: 9)
a.insert(element: 4)
a.insert(element: 12)
a.insert(element: 1)
a.insert(element: 6)
a.insert(element: 4) // 不会二次插入

a.isBST
a.contains(element: 2)
print(a.elements)




