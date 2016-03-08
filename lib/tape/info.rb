module TapeBoxer
  class Version < ExecutionModule
    TapeBoxer.register_module :version, self

    action :number,
      proc { STDOUT.puts Gem::Specification::load("taperole.gemspec").version },
      "Tape Version Number"
  end
end
