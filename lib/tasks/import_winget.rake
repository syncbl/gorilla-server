require "yaml"

namespace :import do
  namespace :winget do
    desc "Create WinGet account"
    task create: [:environment] do
      puts u = User.create(
        name: "WinGet",
        fullname: "Microsoft WinGet (unofficial)",
        email: "admin@syncbl.com",
        password: "testtest",
        plan: :unlimited,
      )
      Subscription.create(
        user: u,
        start_time: Time.current,
        end_time: Time.current + 100.years,
      )
    end

    desc "Empty WinGet account"
    task clear: [:environment] do
      puts User.find_by!(name: "WinGet").packages.delete_all
    end
  end

  desc "Import latest files"
  task winget: [:environment] do
    sh "git -C ~/winget-pkgs pull"
    c = 0
    user = User.find_by!(name: "WinGet")
    user.packages.update_all(updated_at: Time.at(0))
    files = Dir.glob("../winget-pkgs/manifests/**/*.yaml").sort
    files.each_with_index do |f, i|
      y = YAML.load_file(f)
      next if y["Installers"].nil? || y["PackageName"].nil?
      if i < files.size - 1
        z = YAML.load_file(files[i + 1])
        next if y["PackageName"] == z["PackageName"]
      end
      name = y["PackageName"].gsub(/[ ]/, "").gsub(/[.:#&]/, "_").gsub("__", "_")
      p = Package::External.find_by(user: user, name: "#{name}") ||
          Package::External.new(
            name: "#{name}",
            user: user,
            version: y["PackageVersion"],
          )
      # TODO: Architecture check for x64
      p.caption = name
      p.description = y["ShortDescription"]
      p.external_url = y["Installers"][0]["InstallerUrl"]
      if y["InstallerSwitches"]
        p.switches = y["InstallerSwitches"]["Silent"] || y["InstallerSwitches"]["SilentWithProgress"]
      end
      if y["Installers"][0]["InstallerSha256"]
        p.checksum = "sha256:#{y["Installers"][0]["InstallerSha256"]}"
      end
      p.blocked_at = nil
      if p.save
        c += 1
        puts "+ #{p.name}"
      else
        puts "- #{p.name} #{p.errors.full_messages}"
      end
    end
    user.packages.where(updated_at: Time.at(0)).update_all(published_at: nil)
    puts "#{c} packages imported"
  end
end
