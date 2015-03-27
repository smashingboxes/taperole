Gem::Specification.new do |spec|
  spec.name = "taperole"
  spec.version = '1.1.0'
  spec.authors = ['Jack Forrest', 'Smashing Boxes', 'Brandon Mathis']
  spec.email = ['jack@smashingboxes.com', 'brandon@sbox.es']
  spec.summary = 'A tool for provisioning and deploying boxes for hosting Rails apps'
  spec.license = 'MIT'

  spec.files = `git ls-files`.split("\n")
  spec.executables = 'tape'
end
