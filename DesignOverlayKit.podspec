Pod::Spec.new do |s|
  s.name         = "DesignOverlayKit"
  s.version      = "0.0.2"
  s.summary      = "show design overlay for checking margin and content size."
  s.description  = <<-DESC
                    - Debug feature.
                    - Show grid as overlay.
                   DESC

  s.homepage     = "https://github.com/himaratsu/DesignOverlayKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Ryosuke Hiramatsu" => "himaratsu@gmail.com" }
  s.social_media_url   = "http://twitter.com/himara2"
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/himaratsu/DesignOverlayKit.git", :tag => s.version }
  s.source_files  = "DesignOverlayKit/**/*.swift"
  s.requires_arc = true
end
