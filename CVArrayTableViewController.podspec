Pod::Spec.new do |s|
  s.name         = "CVArrayTableViewController"
  s.version      = "0.2"
  s.summary      = "A reusable data source and delegate for UITableView."

  s.description  = <<-DESC
                   CVArrayTableViewController removes some of the boiler plate you have to write get a UITableView set up, when using an array as a data source.
                   Usually filling in -tableView:numberOfRowsInSection: and -tableView:cellForRowAtIndexPath: gets tiresome and is not very reusable. CVArrayTableViewController deals with all that.

                   It also deals with:
                   - Responding to when a user tapped a cell.
                   - Selecting a table view to dequeue cells from (ideal for a searchResultsTableView.)
                   - Segmented arrays to create a table view with sections.
                   DESC
  s.homepage     = "https://github.com/kaspth/CVArrayTableViewController"
  s.license      = 'MIT'
  s.author       = { "Kasper Timm Hansen" => "kaspth@gmail.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/kaspth/CVArrayTableViewController.git", :tag => "0.1" }

  s.source_files  = '*.{h,m}'
  s.public_header_files = '*.h'

  s.requires_arc = true
end
