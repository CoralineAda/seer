# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{seer}
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Corey Ehmke / SEO Logic"]
  s.date = %q{2010-02-15}
  s.description = %q{A lightweight, semantically rich wrapper for the Google Visualization API.}
  s.email = %q{corey@seologic.com}
  s.extra_rdoc_files = ["README.rdoc", "lib/seer.rb", "lib/seer/area_chart.rb", "lib/seer/bar_chart.rb", "lib/seer/chart.rb", "lib/seer/column_chart.rb", "lib/seer/gauge.rb", "lib/seer/line_chart.rb", "lib/seer/pie_chart.rb", "lib/seer/visualization_helper.rb"]
  s.files = ["MIT-LICENSE", "Manifest", "README.rdoc", "Rakefile", "lib/seer.rb", "lib/seer/area_chart.rb", "lib/seer/bar_chart.rb", "lib/seer/chart.rb", "lib/seer/column_chart.rb", "lib/seer/gauge.rb", "lib/seer/line_chart.rb", "lib/seer/pie_chart.rb", "lib/seer/visualization_helper.rb", "seer.gemspec"]
  s.homepage = %q{http://github.com/Bantik/seer}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Seer", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{seer}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A lightweight, semantically rich wrapper for the Google Visualization API.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
