Pod::Spec.new do |s|
  s.name         = "JSONModel@thehtb"
  s.version      = "0.9"
  s.summary      = "The High Technology Bureau FORK of JSONModel: Magical Data Modelling Framework for JSON. Create rapidly powerful, atomic and smart data model classes."
  s.homepage     = "http://www.jsonmodel.com"

  s.license      = { :type => 'MIT', :file => 'LICENSE_jsonmodel.txt' }
  s.authors      = { "Marin Todorov" => "touch-code-magazine@underplot.com",
                     "Mark Aufflick" => "mark@htb.io" }

  s.source       = { :git => "https://github.com/thehtb/JSONModel.git", :tag => "0.9@thehtb" }

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'

  s.source_files = 'JSONModel/**/*.{m,h}'
  s.public_header_files = 'JSONModel/**/*.h'

  s.requires_arc = true

end
