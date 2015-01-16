Gem::Specification.new do |spec|
  spec.name = "tape"
  spec.version = '0.1.5'
  spec.authors = ['Jack Forrest', 'Smashing Boxes', 'Brandon Mathis']
  spec.email = ['jack@smashingboxes.com', 'brandon@sbox.es']
  spec.summary = 'A tool for provisioning and deploying boxes for hosting Rails apps'
  spec.license = 'MIT'

  spec.files = `git ls-files`.split("\n")
  spec.executables = 'tape'
end
