Pod::Spec.new do |s|
  s.name     = 'VBAnimator'
  s.version  = '0.0.1'
  s.license  = 'MIT'
  s.summary  = 'Decode and encode HTML character entities.'
  s.homepage = 'https://github.com/bespalown/NSString-HTML'
  s.author   = { 'Viktor Bespalov' => 'bespalown@gmail.com' }
  s.source   = { :git => 'https://github.com/bespalown/NSString-HTML.git', :branch => 'master' }
  s.platform = :ios
  s.source_files = 'NSString-HTML.{h,m}'
end