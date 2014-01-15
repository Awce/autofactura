require "uri"
require "net/http"

module Autofactura
  
  # Clase Principal Autofactura
  class Autofactura
    
    attr_accessor :url, :user, :sucursal
    
    # initialize
    def initialize(params)
      
      self.url = params[:url].blank? ? "http://app.autofactura.com/users/api/" : params[:url]
      self.user = params[:user].blank? ? "" : params[:user]
      self.sucursal = params[:sucursal].blank? ? "" : params[:sucursal]
      
    end
    
    def series
      
      params = {
        'data[metodo]' => 'series',
        'data[userg]' => self.user,
        'data[sucursalg]' => self.sucursal
      }
      request = Net::HTTP.post_form(URI.parse(self.url), params)
      puts request.body
      
      series = []
      request.body.each do |serie|
        series.push Serie.new(serie)
      end
      return series
      
    end
    
    # Privado
    private
    
      def self.invalid?
       self.user.blank? || self.sucursal.blank? || self.url.blank?
      end
    
  end
  # Termina Clase Autofactura
  
  # Clase Serie
  class Serie
    
    attr_accessor :id, :nombre
    
    def initialize(params)
      
      self.id = params[:id]
      self.nombre = params[:nombre]
      
    end
    
  end
  # Termina Clase Serie
  
end
