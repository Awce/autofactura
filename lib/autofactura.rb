require "uri"
require "net/http"

module Autofactura
  
  # Clase Principal Autofactura
  class Autofactura
    
    attr_accessor :url, :user, :sucursal
    
    # Initialize
    def initialize(params)
      
      self.url = params[:url].blank? ? "http://app.autofactura.com/users/api/" : params[:url]
      self.user = params[:user].blank? ? "" : params[:user]
      self.sucursal = params[:sucursal].blank? ? "" : params[:sucursal]
      
    end
    
    # Emite un ticket de Autofacturacion
    # --------------------------------------------------------------------------------
    # exito = 1 = Éxito, 0 = Fracaso
    # mensaje = Mensaje en caso de haber error
    #￼Id = Identificador interno de AutoFactura
    # codigof = Código utilizado por sus clientes para auto facturarse en la aplicación
    # --------------------------------------------------------------------------------
    def ticket(nota)
      
      return if invalid?
      
      
      
      params = {
        'data[metodo]' => 'ticket',
        'data[userg]' => self.user,
        'data[sucursalg]' => self.sucursal,
        'data[nota]' => '',
      }
      request = Net::HTTP.post_form(URI.parse(self.url), params)
      
    end
    # Termina Metodo Ticket
    
    # Devuelve un Array de Series con id y nombre
    # --------------------------------------------------------------------------------
    def series
      
      return if invalid?
      
      params = {
        'data[metodo]' => 'series',
        'data[userg]' => self.user,
        'data[sucursalg]' => self.sucursal
      }
      request = Net::HTTP.post_form(URI.parse(self.url), params)
      #puts request.body
      
      series = Array.new
      if request.kind_of? Net::HTTPSuccess
        JSON.parse(request.body.to_s).each do |serie|
          series.push Serie.new({:id => serie['id'], :nombre => serie['nombre']})
        end
      end
      return series
      
    end
    # Termina Metodo series
    
    # Cancela un Comprobante CFDi Emitido
    # --------------------------------------------------------------------------------
    # exito = 1 = Éxito, 0 = Fracaso
    # mensaje = Mensaje en caso de haber error
    # fechacancelacion = Fecha de cancelación reportada al SAT formato YYYY-mm- ddTHH:ii:ss
    # url = URL de descarga de acuse en formato XML
    # --------------------------------------------------------------------------------
    def cancelar(comprobante_uuid)
      
      return if invalid?
      
      params = {
        'data[metodo]' => 'cancelar',
        'data[userg]' => self.user,
        'data[sucursalg]' => self.sucursal
        'data[id]' => comprobante_uuid
      }
      request = Net::HTTP.post_form(URI.parse(self.url), params)
      #puts request.body
      
      return JSON.parse(request.body.to_s)
      
    end
    # Termina Metodo cancelar
    
    # Privado
    private
    
      def invalid?
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
  
  # Clase Remision
  class Remision
    
    attr_accessor :sucursal, :formapago, :metodopago, :moneda, :rate, :descuento, :articulos
    
    def initialize(params)
      
      self.sucursal = params[:sucursal]
      self.formapago = params[:formapago].blank? ? "PAGO EN UNA SOLA EXHIBICION" : params[:formapago]
      self.metodopago = params[:metodopago].blank? ? "CONTADO" : params[:metodopago]
      self.moneda = params[:moneda].blank? ? "MXN" : params[:moneda]
      self.rate = params[:rate].blank? ? "1.00" : params[:rate]
      self.desceunto = params[:descuento].blank? ? "0.00" : params[:descuento]
      self.articulos = params[:articulos]
      
    end
    
  end
  # Termina Clase Remision
  
  # Clase Articulo
  class Articulo
    
    attr_accessor :nombre, :precios, :cantidades, :unidades, :ivatrans, :iepstrans, :ivaret, :isret
    
    def initialize(params)
      
      self.nombre = params[:nombre]
      self.precios = params[:precios]
      self.cantidades = params[:cantidades]
      self.unidades = params[:unidades].blank? ? "no aplica" : params[:unidades]
      self.ivatrans = params[:ivatrans].blank? ? "0.00" : params[:ivatrans]
      self.iepstrans = params[:iepstrans].blank? ? "0.00" : params[:iepstrans]
      self.ivaret = params[:ivaret].blank? ? "0.00" : params[:ivaret]
      self.isret = params[:isret].blank? ? "0.00" : params[:isret]
      
    end
    
  end
  # Termina Clase Articulo
  
end
