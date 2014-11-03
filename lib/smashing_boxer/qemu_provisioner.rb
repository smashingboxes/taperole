require 'fileutils'
module SmashingBoxer
class QemuProvisioner < ExecutionModule
  BASE_IMG = File.realpath(File.join(__dir__, ''))
  PIDFILE_DIR = "/tmp/smashing_boxer"
  BOXIMG_DIR = File.join(ENV['HOME'], '.smashing_boxer', 'boxes')
  BOXLOG_DIR = '/tmp/smashing_boxer'
  DEFAULT_PORT = 2255

  SmashingBoxer.register_module :qemu, self

  action :create,
    proc {create_img},
    'Creates a new qemu box with the given name'
  action :start,
    proc {start_box},
    'Ensures the qemu box by the given name is running'
  action :ssh,
    proc {ssh_to_box},
    'SSHes to the box by the given name. Requires id_rsa_sb_basebox
         key to be added to the current SSH agent'
  action :reset,
    proc {reset_box},
    'Destroys and re-creates the box by the given name'

  protected

  def ssh_to_box
    require_opt :name
    ensure_box_running
    Kernel.exec("ssh root@127.0.0.1 -p #{port}")
  end

  def create_img
    require_opt :name
    img_name = opts[:name] + '.img'

    if File.exists?(image_path)
      STDERR.puts "That image already exists!"
      exit 1
    else
      Kernel.exec "qemu-img create -b '#{base_image_path}' -fqcow2 '#{image_path}'"
    end
  end

  def start_box
    require_opt :name
    ensure_box_created
    ensure_box_not_running

    cmd = "qemu-system-x86_64 -m 512 "\
      "-netdev user,hostfwd=tcp:127.0.0.1:#{qemu_port}-:22,id=net.0 "\
      "-device e1000,netdev=net.0 "\
      "-nographic -enable-kvm #{image_path}"

    pid = Process.spawn(cmd, out: boxlog_path)

    write_pidfile(pid)
    Process.detach(pid)
  end

  def qemu_port
    opts.port || DEFAULT_PORT
  end

  def reset_box
    require_opt :name
    ensure_box_created

    File.delete(image_path)
    create_img
  end

  def ensure_box_created
    unless File.exists?(image_path)
      raise ActionError, "The machine (#{opts.name}) has not yet been created!"
    end
  end

  def ensure_box_running
    unless pidfile_present? and process_alive?(read_pidfile)
      raise ActionError, "The machine(#{opts.name}) needs to be "\
        "running before you can do this!"
    end
  end

  def port
    opts.port or 2255
  end

  def ensure_box_not_running
    if pidfile_present? and process_alive?(read_pidfile)
      raise ActionError, "The machine (#{opts.name}) is already running!"
    end
  end

  def process_alive?(pid)
    Process.kill(0, pid)
  rescue Errno::ESRCH
    return false
  end

  def base_image_path
    path = File.join(image_dir, "sb_ubuntu_12.04_x64_base.img")
    unless File.exists?(path)
      raise ActionError, "The base image (#{path}) needs to be present!"
    end

    return path
  end

  def pidfile_present?
    File.exists? pidfile_path
  end

  def image_path
    File.expand_path(File.join(image_dir, "qemu-#{opts.name}.img"))
  end

  def delete_pidfile
    File.delete(pidfile_path)
  end

  def write_pidfile(pid)
    File.open(pidfile_path, 'w').write(pid.to_s)
  end

  def read_pidfile
    STDERR.puts "Reading pidfile #{pidfile_path}" if opts.verbose
    pid = File.open(pidfile_path, 'r').read.to_i

    unless pid > 0
      raise ActionError, "Pidfile (#{pidfile_path}) does not appear to be numeric!"
    end

    return pid
  end

  def boxlog_path
    @boxlog_path ||=
      File.expand_path(File.join(boxlog_dir, "qemu-#{opts.name}.log"))
  end

  def pidfile_path
    @pidfile_path ||=
      File.expand_path(File.join(pidfile_dir, "qemu-#{opts[:name]}.pid"))
  end

  def boxlog_dir
    FileUtils.mkdir_p(PIDFILE_DIR) && PIDFILE_DIR
  end

  def pidfile_dir
    FileUtils.mkdir_p(PIDFILE_DIR) && PIDFILE_DIR
  end

  def image_dir
    FileUtils.mkdir_p(BOXIMG_DIR) && BOXIMG_DIR
  end
end
end
