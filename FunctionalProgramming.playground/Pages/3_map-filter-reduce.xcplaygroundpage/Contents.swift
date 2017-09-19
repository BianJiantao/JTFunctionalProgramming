//: 数组的 map/filter/reduce 函数

struct City{
    /// 城市名称
    let name:String
    /// 城市人口 ( /千人 )
    var population:Int
}

extension City{
    
    /// 城市人口换算单位  /人
    func cityByScalingPopulation() -> City {
        return City(name: name, population: population*1000)
    }
    
}

//: 测试,筛选人口大于 100万 的城市,并输出
let city1 = City(name: "City-1", population: 2345)
let city2 = City(name: "City-2", population: 3678)
let city3 = City(name: "City-3", population: 800)
let city4 = City(name: "City-4", population: 1400)

let cities = [city1,city2,city3,city4]

let resultCities = cities.filter{$0.population > 1000}  // 筛选人口大于100万的城市
      .map{$0.cityByScalingPopulation()}  // 换算人口单位
      .reduce("City:Population") { (result, city) -> String in  // 拼接一个结果字符串
        return result + "\n" + "\(city.name): \(city.population)"
}
print(resultCities)






