Pod::Spec.new do |s|

  s.name          = "XYBlankSlate"
  s.version       = "1.0.0"
  s.summary       = "showing the custom view for empty/loading/network error, based on DZNEmptyDataSet."
  s.homepage      = "https://github.com/Loveying/XYBlankSlate"
  s.license       = "MIT"
  s.author        = { "xiayingying" => "xia.yy@ejlchina.com" }
  s.source        = { :git => "https://github.com/Loveying/XYBlankSlate.git", :tag => s.version}
  s.source_files  = "XYBlankSlate/*.{h,m}"
  s.requires_arc  = true
  s.platform      = :ios, '8.0'
  s.dependency "DZNEmptyDataSet"
end
