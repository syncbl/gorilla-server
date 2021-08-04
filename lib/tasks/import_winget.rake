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

  desc "Import all the files"
  task :import, [:path] => [:environment] do |task, args|
    sh "git -C ~/winget-pkgs pull"
    user = User.find_by!(name: "WinGetMirror")
    Dir.glob("#{args[:path]}/**/*.yaml").each do |f|
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
        p.save
        if p.persisted?
          puts "+ #{p.name}"
        else
          puts "- #{p.errors.full_messages} #{p.name} #{p.caption}"
        end
      end
    end
  end
end
