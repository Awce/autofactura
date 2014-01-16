require "uri"
require "net/http"
require "date"

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
    
    # Emite un Comprobatnte CFDi de AutoFactura.com
    # --------------------------------------------------------------------------------
    # --------------------------------------------------------------------------------
    def emitir(comprobante)
      
      return if invalid?
      
      # TODO
      
      params = {
        'data[metodo]' => 'emitir',
        'data[userg]' => self.user,
        'data[sucursalg]' => self.sucursal,
        'data[Comprobante]' => '',
      }
      #request = Net::HTTP.post_form(URI.parse(self.url), params)
      
    end
    # Termina Metodo Ticket
    
    # Emite un ticket de Autofacturacion
    # --------------------------------------------------------------------------------
    # exito = 1 = Éxito, 0 = Fracaso
    # mensaje = Mensaje en caso de haber error
    #￼Id = Identificador interno de AutoFactura
    # codigof = Código utilizado por sus clientes para auto facturarse en la aplicación
    # --------------------------------------------------------------------------------
    def ticket(nota)
      
      return if invalid?
      
      # TODO
      
      params = {
        'data[metodo]' => 'ticket',
        'data[userg]' => self.user,
        'data[sucursalg]' => self.sucursal,
        'data[nota]' => '',
      }
      #request = Net::HTTP.post_form(URI.parse(self.url), params)
      
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
        'data[sucursalg]' => self.sucursal,
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
  
  # Clase Comprobante
  class Comprobante
    
    attr_accessor :fecha, :serie, :tipoDeComprobante, :condicionesDePago, :formaDePago, :metodoDePago, :numerocta, :version, :tipoCambio, :moneda, :decimales, :Receptor, :Conceptos, :Impuestos, :ret_iva_cant, :tras_ieps_cant, :tras_iva_cant, :ret_isr_cant, :Addenda, :subTotal, :total, :descuento, :descuento_porcentual
    
    def initialize(params)
      
      # Generales
      self.fecha = DateTime.parse(Time.now.to_s).strftime("%Y-%m-%dT%H:%M:%S").to_s
      self.serie = params[:serie]
      self.tipoDeComprobante = params[:tipoDeComprobante]
      self.condicionesDePago = params[:condicionesDePago].blank? ? "CONTADO" : params[:condicionesDePago]
      self.formaDePago = params[:formaDePago].blank? ? "PAGO EN UNA SOLA EXHIBICION" : params[:formaDePago]
      self.metodoDePago = params[:metodoDePago].blank? ? "NO IDENTIFICADO" : params[:metodoDePago]
      self.numerocta = params[:numerocta].blank? ? "NO IDENTIFICADO" : params[:numerocta]
      self.version = params[:version].blank? ? "3.2" : params[:version]
      self.tipoCambio = params[:tipoCambio].blank? ? 1.00 : params[:tipoCambio]
      self.moneda = params[:moneda].blank? ? "MXN" : params[:moneda]
      self.decimales = params[:decimales].blank? ? 2 : params[:decimales]
      
      # Receptor
      self.Receptor = Receptor.new(params[:Receptor])
      
      # Conceptos e Impuestos
      # Impuestos por Concepto
      self.subTotal = 0.00 # subTotal
      self.Impuestos = Array.new
      self.Conceptos = Array.new
      #puts "------- CONCEPTOS -------"
      params[:Conceptos].each do |conc|
        imp = {}
        concepto = Concepto.new(conc)
        
        unless concepto.tras_iva.blank?
          imp[:tras_iva] = concepto.tras_iva
          imp[:tras_iva_cant] = ( ( concepto.importe - concepto.descuento ) * concepto.tras_iva / 100 )
        end
        
        unless concepto.tras_ieps.blank?
          imp[:tras_ieps] = concepto.tras_ieps
          imp[:tras_ieps_cant] = ( ( concepto.importe - concepto.descuento ) * concepto.tras_ieps / 100 )
        end
        
        unless concepto.ret_iva.blank?
          imp[:ret_iva] = concepto.ret_iva
          imp[:ret_iva_cant] = ( ( concepto.importe - concepto.descuento ) * concepto.ret_iva / 100 )
        end
        
        unless concepto.ret_isr.blank?
          imp[:ret_isr] = concepto.ret_isr
          imp[:ret_isr_cant] = ( ( concepto.importe - concepto.descuento ) * concepto.ret_isr / 100 )
        end
        
        self.Conceptos.push(concepto)
        self.Impuestos.push(Impuesto.new(imp))
        
        self.subTotal += ( concepto.importe )
        
      end
      #puts "------- FIN CONCEPTOS -------"
      
      # Impuestos Totalizados
      self.tras_iva_cant = 0.00
      self.tras_ieps_cant = 0.00
      self.ret_iva_cant = 0.00
      self.ret_isr_cant = 0.00
      #puts "------- IMPUESTOS -------"
      self.Impuestos.each do |impuesto|
        
        unless impuesto.tras_iva_cant.blank?
          self.tras_iva_cant += impuesto.tras_iva_cant
        end
        
        unless impuesto.tras_ieps_cant.blank?
          self.tras_ieps_cant += impuesto.tras_ieps_cant
        end
        
        unless impuesto.ret_iva_cant.blank?
          self.ret_iva_cant += impuesto.ret_iva_cant
        end
        
        unless impuesto.ret_isr_cant.blank?
          self.ret_isr_cant += impuesto.ret_isr_cant
        end
        
      end
      #puts "------- FIN IMPUESTOS -------"
      
      # Totales
      self.descuento_porcentual = params[:descuento_porcentual].blank? ? 0.00 : params[:descuento_porcentual]
      self.descuento = ( (self.subTotal * self.descuento_porcentual) / 100 )
      self.total = self.subTotal - self.descuento + self.tras_iva_cant + self.tras_ieps_cant - self.ret_iva_cant - self.ret_isr_cant
      
    end
    
  end
  # Termina Clase Comprobante
  
  # Clase Receptor
  class Receptor
    
    attr_accessor :rfc, :nombre, :email, :Domicilio
    
    def initialize(params)
      
      self.rfc = params[:rfc]
      self.nombre = params[:nombre]
      self.email = params[:email]
      self.Domicilio = Domicilio.new(params[:Domicilio]) # Clase Domicilio
      
    end
    
  end
  # Termina Clase Receptor
  
  # Clase Domicilio
  class Domicilio
    
    attr_accessor :noExterior, :noInterior, :calle, :colonia, :municipio, :estado, :pais, :codigoPostal
    
    def initialize(params)
      
      self.noExterior = params[:noExterior]
      self.noInterior = params[:noInterior].blank? ? nil : params[:noInterior]
      self.calle = params[:calle]
      self.colonia = params[:colonia]
      self.municipio = params[:municipio]
      self.estado = params[:estado]
      self.pais = params[:pais]
      self.codigoPostal = params[:codigoPostal]
      
    end
    
  end
  # Termina Clase Domicilio
  
  # Clase Concepto
  class Concepto
    
    attr_accessor :cantidad, :unidad, :descripcion, :valorUnitario, :importe, :tras_iva, :ret_iva, :ret_isr, :tras_ieps, :tras_ieps_cant, :tras_iva_cant, :ret_iva_cant, :ret_isr_cant, :descuento, :descuento_porcentual
    
    def initialize(params)
      
      # Generales
      self.cantidad = params[:cantidad]
      self.unidad = params[:unidad].blank? ? "NO APLICA" : params[:unidad]
      self.descripcion = params[:descripcion]
      self.valorUnitario = params[:valorUnitario]
      
      # Importe
      self.importe = (self.cantidad * self.valorUnitario)
      
      # Descuento
      self.descuento_porcentual = params[:descuento_porcentual].blank? ? nil : params[:descuento_porcentual]
      if params[:descuento_porcentual].blank?
        self.descuento = 0.00
      else
        self.descuento = ( self.importe * self.descuento_porcentual / 100 )
      end
      
      # Impuestos
      # Impuestos Porcentaje
      self.tras_iva = params[:tras_iva].blank? ? 0 : params[:tras_iva].to_f
      self.ret_iva = params[:ret_iva].blank? ? 0 : params[:ret_iva].to_f
      self.ret_isr = params[:ret_isr].blank? ? 0 : params[:ret_isr].to_f
      self.tras_ieps = params[:tras_ieps].blank? ? 0 : params[:tras_ieps].to_f
      # Impuestos Cantidad
      self.tras_ieps_cant = ( ( self.importe - self.descuento ) * params[:tras_ieps] / 100 )
      self.ret_isr_cant = ( ( self.importe - self.descuento ) * params[:ret_isr] / 100 )
      self.ret_iva_cant = ( ( self.importe - self.descuento ) * params[:ret_iva] / 100 )
      self.tras_iva_cant = ( ( self.importe - self.descuento ) * params[:tras_iva] / 100 )
      
    end
    
    def invalid
      
      if self.unidad.blank?
        raise 'Debe especificar la unidad del concepto.'
      end
      
      if self.cantidad <= 0
        raise 'La cantidad del concepto no puede ser 0 o menor.'
      end
      
      return false
      
    end
    
  end
  # Termina Clase Concepto
  
  # Clase Impuesto
  class Impuesto
    
    attr_accessor :tras_iva, :ret_iva, :ret_isr, :tras_ieps, :tras_ieps_cant, :ret_isr_cant, :ret_iva_cant, :tras_iva_cant
    
    def initialize(params)
      
      self.tras_iva = params[:tras_iva].blank? ? 0 : params[:tras_iva].to_f
      self.ret_iva = params[:ret_iva].blank? ? 0 : params[:ret_iva].to_f
      self.ret_isr = params[:ret_isr].blank? ? 0 : params[:ret_isr].to_f
      self.tras_ieps = params[:tras_ieps].blank? ? 0 : params[:tras_ieps].to_f
      
      self.tras_ieps_cant = params[:tras_ieps_cant].blank? ? 0 : params[:tras_ieps_cant].to_f
      self.ret_isr_cant = params[:ret_isr_cant].blank? ? 0 : params[:ret_isr_cant].to_f
      self.ret_iva_cant = params[:ret_iva_cant].blank? ? 0 : params[:ret_iva_cant].to_f
      self.tras_iva_cant = params[:tras_iva_cant].blank? ? 0 : params[:tras_iva_cant].to_f
      
    end
    
  end
  # Termina Clase Impuesto
  
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
