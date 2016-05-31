require 'pathname'
module TapeBoxer
  class Overwriter < ExecutionModule
    TapeBoxer.register_module :overwrite, self

    action :role,
      proc { overwrite_role },
      "Overwrite a taperole ansible role"

    def overwrite_role
      FileUtils.cp_r("#{tape_dir}/roles/#{opts.role}", "taperole/roles/")
    end
  end
end
