Pod::Spec.new do |s|

  s.name         = "TMPopover"
  s.version      = "0.1"
  s.summary      = "A pop over view container. Supports both portrait and landscape."
  s.description  = <<-DESC
          `TMPopover` is a pop over view container `iOS`.
                   DESC
  s.author             = { "vkostechko" => "viacheslav.kostechko@gmail.com" }
  s.homepage     = "https://github.com/vkostechko/TMPopover/"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/vkostechko/TMPopover.git", :tag => "#{s.version}" }
  s.source_files = "TMPopover", "TMPopover/*.{h,m}"
  s.requires_arc = true

end