//:  合成滤镜

import UIKit

/// 定义滤镜类型
typealias Filter = (CIImage)->CIImage

//: 基础滤镜

/// 高斯模糊滤镜
///
/// - parameter radius: 模糊半径
///
/// - returns: 模糊滤镜
func blur(radius:Double)->Filter{
    
    return { image in
        
        let parameters = [kCIInputRadiusKey:radius,
                          kCIInputImageKey:image]  as [String : Any]
        guard let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: parameters) else{
            fatalError()
        }
        guard let outputImage = filter.outputImage else{
            fatalError()
        }
        
        return outputImage
    }
    
}

///  error: 颜色滤镜缺少上下文绘图环境
/// bug反馈记录 : https://forums.developer.apple.com/thread/13683
/// 颜色生成滤镜
///
/// - parameter color: 滤镜颜色
///
/// - returns: 颜色滤镜
func colorGenerator(color:UIColor)->Filter{
    return { image in
        
//        let c = CIColor(color: color)
//        let parameters = [kCIInputColorKey:c]
//        
//        guard let filter = CIFilter(name: "CIConstantColorGenerator", withInputParameters: parameters) else{
//            fatalError()
//        }
//        guard let outputImage = filter.outputImage else{
//            fatalError()
//        }
        
        return image
        
    }
}

/// 图像覆盖合成滤镜
///
/// - parameter overlay: 前景图
///
/// - returns: 覆盖合成滤镜
func compositeSourceOver(overlay:CIImage)->Filter{
    
    return { image in
        let parameters = [kCIInputBackgroundImageKey:image,
                          kCIInputImageKey:overlay]
        guard let filter = CIFilter(name: "CISourceOverCompositing", withInputParameters: parameters) else{
            fatalError()
        }
        guard let outputImage = filter.outputImage else{
            fatalError()
        }
    
        let cropRect = image.extent // 获取原始图片尺寸
        return outputImage.cropping(to: cropRect) // 裁剪
    }
}


/// 颜色叠层滤镜 ( 颜色生成滤镜+图像覆盖合成滤镜 )
func colorOverlay(color:UIColor)->Filter{
    
    return { image in
        
        let overlay = colorGenerator(color: color)(image)
        return compositeSourceOver(overlay: overlay)(image)
        
    }
}


//:  测试滤镜1

let url = URL(string: "http://img17.3lian.com/d/file/201701/16/779db6efe9d4520e07e8bfb8b9e55175.jpg")!

let image = CIImage(contentsOf: url)!

let blurRadius = 5.0
let overlayColor = UIColor.red.withAlphaComponent(0.2)
let blurImage = blur(radius: blurRadius)(image)

let overlaidImage = colorOverlay(color: overlayColor)(blurImage)

//: 1.复合函数 (合成滤镜)

func composeFilters(filter1:@escaping Filter,filter2:@escaping Filter)->Filter{
    
    return{ image in
        
        return filter2(filter1(image))
    }
    
}

let myFilter1 = composeFilters(filter1: blur(radius: blurRadius), filter2: colorOverlay(color: overlayColor))

let myResult1 = myFilter1(image)

//: 2.自定义 合成滤镜运算符

precedencegroup composeFiltersPrecedence {
    associativity: left    // 结合律左
}

// 声明 >>> 运算符
infix operator >>>: composeFiltersPrecedence  // infix 表示是:中位操作符(前后都有输入)

func >>>(filter1:@escaping Filter,filter2:@escaping Filter)->Filter{
    return{ image in  filter2(filter1(image))
    }
}

let myFilter2 = blur(radius: blurRadius) >>> colorOverlay(color: overlayColor)

let myResult2 = myFilter2(image)
 