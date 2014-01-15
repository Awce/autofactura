require "uri"
require "net/http"

module Autofactura
  
  # Clase Principal Autofactura
  class Autofactura
    
    attr_accessor :url, :user, :sucursal
    
    # initialize
    def initialize(config = {})
      
      self.url = config[:url].blank? ? "http://app.autofactura.com/users/api/" : config[:url]
      self.user = config[:user].blank? ? "" : config[:user]
      self.sucursal = config[:sucursal].blank? ? "" : config[:sucursal]
      
    end
    
    def series
      
      params = {
        'data[metodo]' => 'series',
        'data[userg]' => self.user,
        'data[sucursalg]' => self.sucursal
      }
      request = Net::HTTP.post_form(URI.parse(self.url), params)
      puts request.body
      return request
      
    end
    
    # Privado
    private
  
      def invalid
        self.user.blank? || self.sucursal.blank?
      end
    
  end
  # Termina Clase Autofactura
  
  # Clase Serie
  class Serie
    
    attr_accessible :id, :nombre
    
  end
  # Termina Clase Serie
  
end
