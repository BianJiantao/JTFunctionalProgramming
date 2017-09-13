//:     战舰能否击中敌舰

import Foundation

//: ************************  坐标点 *************************************
/// 定义 坐标点 或 二维矢量
struct Position {
    var x:Double
    var y:Double
}

/// 定义 距离 类型
typealias Distance = Double

extension Position{
    
    /// 两个坐标点的矢量差 (参数坐标点指向自身)
    ///
    /// - parameter p: 参照坐标点
    ///
    /// - returns: 矢量坐标
    func minus(p:Position) -> Position {
        return Position(x: x - p.x , y: y - p.y)
    }
    
    /// 矢量的模
    var length:Double{
        return sqrt(x*x + y*y)
    }
}

//: ************************  区域  *************************************

/// 定义区域类型 ( 函数式编程的重心: 把函数看做普通的数据类型 )
//typealias Region = (Position)->Bool // 缺点:函数调用要传 region 参数,对其操纵;改进: 定义为结构体,则只是成员函数间的调用
struct Region {
    
    let lookup: (Position)->Bool
    
}


extension Region{
    
    /// 类型方法
    ///
    /// - parameter radius: 半径
    ///
    /// - returns: 半径为radius的圆型区域
    static func circle(radius:Distance)->Region{
        
        return Region(lookup: { (point) -> Bool in
            
            return point.length <= radius
        })
        
    }

    func shift(offset:Position)->Region{ // 区域平移函数
        
        return Region(lookup: { (point) -> Bool in
            self.lookup(point.minus(p: offset))
        })
        
    }
    
    
    func invert()->Region{ // 区域的补集
        return Region(lookup: { (point) -> Bool in
            
            return !self.lookup(point)
        })
    }
    
    func intersection(other:Region)->Region{ // 区域交集
        return Region(lookup: { (point) -> Bool in
            
            return self.lookup(point) && other.lookup(point)
        })
    }
    
    func union(other:Region)->Region{ // 区域的并集
        
        return Region(lookup: { (point) -> Bool in
            
            return self.lookup(point) || other.lookup(point)
        })
        
    }
    
    
    func difference(region:Region)->Region{ // 集合 A-AB = AB`(A 与 B 补集的交集)
        
        return self.intersection(other: region.invert())
    }
    

}



//: ************************  战舰  *************************************
struct Ship{
    /// 位置
    var position:Position
    /// 射程
    var firingDistance:Distance
    /// 危险距离
    var unsafeDistance:Distance
}

extension Ship{
    
    func canSafelyEngageShip(target:Ship,friend:Ship)->Bool{
        
        /// 安全开火区域
        let safeFireRange = Region.circle(radius: firingDistance).difference(region: Region.circle(radius: unsafeDistance))
        
        /// 友舰的危险区域
        let friendRange = Region.circle(radius: friend.unsafeDistance).shift(offset: friend.position)
    
        return safeFireRange.shift(offset: position).difference(region: friendRange).lookup(target.position)
    }
}

let current = Ship(position:Position(x: 5, y: 5) , firingDistance: 10, unsafeDistance: 2)

let target = Ship(position:Position(x: 9, y: 9) , firingDistance: 10, unsafeDistance: 2)

let friend = Ship(position:Position(x: 3, y: 3) , firingDistance: 10, unsafeDistance: 2)

let isHit = current.canSafelyEngageShip(target: target, friend: friend)



