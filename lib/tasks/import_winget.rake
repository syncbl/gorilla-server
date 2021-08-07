require "yaml"

namespace :winget do
  desc "Create WinGet account"
  task create: [:environment] do
    u = User.create(
      name: "WinGetMirror",
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
    User.find_by!(name: "WinGetMirror").packages.delete_all
  end

  desc "Update WinGet repo"
  task update: [:environment] do
    sh "git -C ~/winget-pkgs pull"
  end

  # TODO: Bulk Upsert using activerecord-import
  namespace :import do
    desc "Import all files with versions"
    task all: [:environment] do
      c = 0
      user = User.find_by!(name: "WinGetMirror")
      Dir.glob("../winget-pkgs/manifests/**/*.yaml").each do |f|
        y = YAML.load_file(f)
        unless y["Installers"].nil? || y["PackageName"].nil?
          name = y["PackageName"].gsub(" ", "").gsub(".", "_")
          version = y["PackageVersion"].to_s.gsub(".", "_")
          p = Package::External.find_by(name: "#{name}-#{version}", version: version) ||
              Package::External.new(
                name: "#{name}-#{version}",
                user: user,
                version: version,
              )
          p.caption = name
          p.description = y["ShortDescription"]
          p.external_url = y["Installers"][0]["InstallerUrl"]
          if y["InstallerSwitches"]
            p.switches = y["InstallerSwitches"]["Silent"] || y["InstallerSwitches"]["SilentWithProgress"]
            puts "#{p.name} #{p.switches}"
          end
          if y["Installers"][0]["InstallerSha256"]
            p.checksum = y["Installers"][0]["InstallerSha256"]
            p.hash_type = :sha256                     
          end
          if p.save
            c += 1
          else
            puts "- #{p.name} #{p.errors.full_messages}"
          end
        end
      end
      puts "#{c} packages imported"
    end

    desc "Import latest files"
    task latest: [:environment] do
      c = 0
      user = User.find_by!(name: "WinGetMirror")
      Dir.glob("../winget-pkgs/manifests/**/*.yaml").each do |f|
        y = YAML.load_file(f)
        unless y["Installers"].nil? || y["PackageName"].nil?
          name = y["PackageName"].gsub(" ", "").gsub(".", "_")
          version = y["PackageVersion"].to_s.gsub(".", "_")
          p = Package::External.find_by(name: "#{name}") ||
              Package::External.new(
                name: "#{name}",
                user: user,
                version: version,
              )
          p.caption = name
          p.description = y["ShortDescription"]
          p.external_url = y["Installers"][0]["InstallerUrl"]
          if y["InstallerSwitches"]
            p.switches = y["InstallerSwitches"]["Silent"] || y["InstallerSwitches"]["SilentWithProgress"]
          end
          if y["Installers"][0]["InstallerSha256"]
            p.checksum = y["Installers"][0]["InstallerSha256"]
            p.hash_type = :sha256                     
          end
          if p.save
            c += 1
            puts "+ #{p.name}"
          else
            puts "- #{p.name} #{p.errors.full_messages}"
          end
        end
      end
      puts "#{c} packages imported"
    end    
  end
end
