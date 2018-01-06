Pod::Spec.new do |spec|
  spec.name         =  'TagCellLayout'
  spec.version      =  '1.0'
  spec.summary   =  'Tag layout for UICollectoionView supporting 3 types of alignments - Left || Centre || Right'
  spec.author = {
    'Ritesh Gupta' => 'rg.riteshh@gmail.com'
  }
  spec.license          =  'MIT' 
  spec.homepage         =  'https://github.com/riteshhgupta/TagCellLayout'
  spec.source = {
    :git => 'https://github.com/riteshhgupta/TagCellLayout.git',
    :tag => '1.0'
  }
  spec.ios.deployment_target = "8.0"
  spec.source_files =  'Source/*.{swift}'
  spec.requires_arc     =  true
end
