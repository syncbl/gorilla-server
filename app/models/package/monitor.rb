# TODO: Scrapper for package monitoring
# Check page size limit

class Package::Monitor < Package::ExternalBase
  jsonb_accessor :params,
                 check_url: [:string],
                 element_xpath: [:string]
end
