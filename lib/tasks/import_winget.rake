require "yaml"

namespace :winget do
  desc "Create WinGet account"
  task :create => [:environment] do
    User.create(
      name: "WinGetMirror",
      fullname: "Microsoft WinGet (unofficial)",
      email: "admin@syncbl.com",
      password: "testtest",
      plan: :unlimited,
    )
  end

  desc "Empty WinGet account"
  task :clear => [:environment] do
    User.find_by!(name: "WinGetMirror").packages.delete_all
  end

  desc "Import all the files"
  task :import, [:path] => [:environment] do |task, args|
    user = User.find_by!(name: "WinGetMirror")
    Dir.glob("#{args[:path]}/**/*.yaml").each do |f|
      y = YAML.load_file(f)
      unless y["Installers"].nil? || y["PackageName"].nil?
        name = y["PackageName"].gsub(" ", "_")
        if p = Package::External.find_by(name: name)
          version = y["PackageVersion"].to_s.gsub(".", "_")
          p.update(
            name: "#{name}-#{version}",
            external_url: y["Installers"][0]["InstallerUrl"],
          )
        end
        p = Package::External.create(
          name: name,
          caption: name,
          description: y["ShortDescription"],
          user: user,
          external_url: y["Installers"][0]["InstallerUrl"],
        )
        if p.persisted?
          puts "+ #{p.name}"
        else
          puts "- #{p.errors.full_messages} #{name} #{p.caption}"
        end
      end
    end
  end
end
