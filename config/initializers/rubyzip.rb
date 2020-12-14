Zip.setup do |z|
  z.on_exists_proc = true
  z.continue_on_exists_proc = true
  z.unicode_names = true
  z.force_entry_names_encoding = 'UTF-8'
end
