# TODO: Scrapper for package monitoring
# Check page size limit

class Package::Monitor < Package::External
  jsonb_accessor :params,
                 external_url: [:string],
                 check_url: [:string],
                 element_xpath: [:string]
end
