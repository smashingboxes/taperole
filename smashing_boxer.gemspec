Gem::Specification.new do |spec|
  spec.name = "smashing_boxer"
  spec.version = '0.1.2'
  spec.authors = ['Jack Forrest', 'Smashing Boxes']
  spec.email = ['jack@smashingboxes.com']
  spec.summary = 'A tool for provisioning and deploying boxes for hosting Rails apps'
  spec.license = 'All rights reserved'

  spec.files = `git ls-files`.split("\n")
  spec.executables = 'smashing_boxer'
end
