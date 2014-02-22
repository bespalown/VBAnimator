Pod::Spec.new do |s|
  s.name     = 'VBAnimator'
  s.version  = '0.0.1'
  s.license  = 'MIT'
  s.summary  = 'Animation large quantities of pictures'
  s.homepage = 'https://github.com/bespalown/VBAnimator'
  s.author   = { 'Viktor Bespalov' => 'bespalown@gmail.com' }
  s.source   = { :git => 'https://github.com/bespalown/VBAnimator.git', :branch => 'master' }
  s.platform = :ios
  s.source_files = 'VBAnimator/VBAnimator/VBAnimator.{h,m}’
end