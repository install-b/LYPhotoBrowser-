
Pod::Spec.new do |s|

  s.name         = "LYPhotoBrowser-"
  s.version      = "0.1.0"
  s.summary      = "an ios photo browser tool"

  s.description  = "a photo browser tool , use this you can scroll it infinitly"

  s.homepage     = "https://github.com/install-b/LYPhotoBrowser-.git"


  s.license      = "MIT"

  s.author             = { "ShanggenZhang" => "gkzhangshangen@163.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/install-b/LYPhotoBrowser-.git", :tag => s.version }

  s.source_files  = "LYPhotoBrowser/*.{h,m}"

  s.public_header_files = "LYPhotoBrowser/*.h"


  s.framework  = "UIKit"

  s.requires_arc = true


  s.dependency "SGInfiniteView", "~> 0.2.2"
  s.dependency "SDWebImage", "~> 4.3.3"
  s.dependency "Masonry", "~> 1.1.0"
  
end
