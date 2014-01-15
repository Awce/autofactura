$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "autofactura/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "autofactura"
  s.version     = Autofactura::VERSION
  s.authors     = ["Fco. Andres Amaya Diaz"]
  s.email       = ["andres.amaya.diaz@gmail.com"]
  s.homepage    = "http://www.andresamayadiaz.com"
  s.summary     = "AutoFactura.com es un servicio de Facturacion Electronica (CFDi) en Mexico."
  s.description = "Mediante esta Gema podras utilizar y consumir el API de AutoFactura.com de manera sencilla."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.14"

  s.add_development_dependency "sqlite3"
end
