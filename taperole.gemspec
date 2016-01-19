Gem::Specification.new do |spec|
  spec.name = "taperole"
  spec.version = '1.3.3'
  spec.authors = ['Jack Forrest', 'Smashing Boxes', 'Brandon Mathis']
  spec.email = ['jack@smashingboxes.com', 'brandon@sbox.es']
  spec.summary = 'A tool for provisioning and deploying boxes for hosting Rails apps'
  spec.license = 'MIT'
  spec.homepage = 'https://github.com/smashingboxes/taperole'

  spec.files = `git ls-files`.split("\n")
  spec.executables = 'tape'
  spec.add_runtime_dependency 'slack-notifier'
end
