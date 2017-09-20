//: 枚举

/// 城市:市长
let mayors = [
                "City-1":"Mayor-1",
                "City-2":"Mayor-2",
                "City-3":"Mayor-3",
                "City-4":"Mayor-4"
            ]

/// 城市:人口
let cities = [
                "City-1":2345,
                "City-2":3678,
                "City-3":800,
                "City-4":1400
            ]

/// 国家:首都
let capitals = [
                "Country-0":"City-0",
                "Country-1":"City-1",
                "Country-2":"City-2",
                "Country-3":"City-3",
                "Country-4":"City-4"
                ]

//: 1. 利用枚举获取 使用可选值类型时的中间过程错误信息

/// 字典查询错误类型
enum LookupError:Error{ //  遵守 Error 协议,才能 throw 错误
    case CapitalNotFound
    case PopulationNotFound
    case MayorNotFound
}


/// 城市人口查询结果
enum PopulationResult{ // 关联值 枚举
    case Success(Int)  // 成功时,关联一个 人口数
    case Error(LookupError) // 失败时, 关联一个 查找错误类型
}

/// 城市市长查询结果
enum MayorResult{
    
    case Success(String)
    case Error(LookupError)
}


print("==========1.关联值枚举===========")

/// 人口查询
func populationOfCapital(country:String)->PopulationResult{

    guard let capital = capitals[country] else { // 定位错误,未找到首都
        return .Error(.CapitalNotFound)
    }
    
    guard let population = cities[capital] else { // 定位错误,未找到人口
        return .Error(.PopulationNotFound)
    }
    
    return .Success(population)
    
}

switch populationOfCapital(country: "Country-0"){
    
    case .Success(let population):
        print("人口为: \(population)")
    case .Error(let error):
        print("错误: \(error)")
}

/// 市长查询
func mayorOfCapital(country:String)->MayorResult{
    
    guard let capital = capitals[country] else { // 定位错误,未找到首都
        return .Error(.CapitalNotFound)
    }
    
    guard let mayor = mayors[capital] else { // 定位错误,未找到市长
        return .Error(.MayorNotFound)
    }
    
    return .Success(mayor)
}

switch mayorOfCapital(country: "Country-8"){
    
    case .Success(let mayor):
        print("市长为: \(mayor)")
    case .Error(let error):
        print("错误: \(error)")
}

print("==========2.泛型枚举===========")

//: 2. 泛型枚举
enum LookResult<T>{
    
    case Success(T)
    case Error(LookupError)
}

func populationOfCapital_2(country:String)->LookResult<Int>{
    
    guard let capital = capitals[country] else { // 定位错误,未找到首都
        return .Error(.CapitalNotFound)
    }
    
    guard let population = cities[capital] else { // 定位错误,未找到人口
        return .Error(.PopulationNotFound)
    }
    
    return .Success(population)
}

switch populationOfCapital_2(country: "Country-1"){
    
    case .Success(let population):
        print("人口为: \(population)")
    case .Error(let error):
        print("错误: \(error)")
}

/// 市长查询
func mayorOfCapital_2(country:String)->LookResult<String>{
    
    guard let capital = capitals[country] else { // 定位错误,未找到首都
        return .Error(.CapitalNotFound)
    }
    
    guard let mayor = mayors[capital] else { // 定位错误,未找到市长
        return .Error(.MayorNotFound)
    }
    
    return .Success(mayor)
}

switch mayorOfCapital_2(country: "Country-1"){
    
    case .Success(let mayor):
        print("市长为: \(mayor)")
    case .Error(let error):
        print("错误: \(error)")
}

print("==========3.错误处理 throw ===========")
//: 3. 错误处理机制 throw
func  populationOfCapital_3(country:String) throws->Int{
    
    guard let capital = capitals[country] else { // 定位错误,未找到首都
        throw LookupError.CapitalNotFound
    }
    
    guard let population = cities[capital] else { // 定位错误,未找到人口
        throw LookupError.PopulationNotFound
    }
    
    return population

}

do {
    let population_3 = try populationOfCapital_3(country: "Country-2")
    print("人口为: \(population_3)")
} catch {
    print("Error:\(error)")
}

/// 市长查询
func mayorOfCapital_3(country:String) throws ->String{
    
    guard let capital = capitals[country] else { // 定位错误,未找到首都
        throw LookupError.CapitalNotFound
    }
    
    guard let mayor = mayors[capital] else { // 定位错误,未找到市长
        throw LookupError.MayorNotFound
    }
    
    return mayor
}

do {
    let mayor_3 = try mayorOfCapital_3(country: "Country-0")
    print("市长为: \(mayor_3)")
} catch {
    print("Error:\(error)")
}

