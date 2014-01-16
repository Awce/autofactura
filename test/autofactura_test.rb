require 'test_helper'

class AutofacturaTest < ActiveSupport::TestCase
  test "truth" do
  
    assert_kind_of Module, Autofactura
  end
  
  test "comprobante" do
    
     comp = create_comprobante()

     comprobante = Autofactura::Comprobante.new( comp )
     #puts "COMPROBANTE: " + comprobante.to_json
     assert_not_nil(comprobante, "El Comprobante no se ha creado.")
     
  end
  
  test "emitir_comprobante" do
    
    # Comprobante
    comp = create_comprobante_descuento()
    comprobante = Autofactura::Comprobante.new( comp )
    
    af = Autofactura::Autofactura.new( { :user => 'XYZ', :sucursal => 'XYZ' } )
    
    resp = af.emitir(comprobante)
    puts "EMITIR REGRESA"
    puts "----------------------------"
    puts resp.to_json
    puts "----------------------------"
    puts resp.body
    puts "----------------------------"
    
  end
  
  def create_comprobante
    
    comp = { 
      :serie => "ABC",
      :tipoDeComprobante => "ingreso",
      :condicionesDePago => "CONTADO",
      :formaDePago => "PAGO EN UNA SOLA EXHIBICION",
      :metodoDePago => "NO IDENTIFICADO",
      :numerocta => "NO IDENTIFICADO",
      :version => "3.2",
      :tipoCambio => 1,
      :moneda => "MXN",
      :decimales => 2,
      :Receptor => {
        :rfc => "RFC_RECEPTOR",
        :nombre => "ALGUNA RAZON SOCIAL SA DE CV",
        :email => "andres.amaya.diaz@gmail.com",
        :Domicilio => {
          :noExterior => "103",
          :calle => "San Juan",
          :colonia => "Colonia",
          :municipio => "Monterrey",
          :estado => "Nuevo Leon",
          :pais => "Mexico",
          :codigoPostal => "66250"
        } # Fin Domicilio
      }, # Fin Receptor
      :Conceptos => [{
          :cantidad => 1,
          :unidad => "NO APLICA",
          :descripcion => "Primer Concepto de Prueba",
          :valorUnitario => 1,
          :ret_iva => 0,
          :tras_ieps => 0,
          :tras_iva => 16,
          :ret_isr => 0
        },{
          :cantidad => 1,
          :unidad => "NO APLICA",
          :descripcion => "Segundo Concepto de Prueba",
          :valorUnitario => 1,
          :ret_iva => 0,
          :tras_ieps => 0,
          :tras_iva => 16,
          :ret_isr => 0
        }], # Fin Conceptos
        :Addenda => ""
     }
     
     return comp
    
  end
  
  def create_comprobante_descuento
    
    comp = { 
      :serie => "ABC",
      :tipoDeComprobante => "ingreso",
      :condicionesDePago => "CONTADO",
      :formaDePago => "PAGO EN UNA SOLA EXHIBICION",
      :metodoDePago => "NO IDENTIFICADO",
      :numerocta => "NO IDENTIFICADO",
      :version => "3.2",
      :tipoCambio => 1,
      :moneda => "MXN",
      :decimales => 2,
      :descuento_porcentual => 0,
      :Receptor => {
        :rfc => "RFC_RECEPTOR",
        :nombre => "ALGUNA RAZON SOCIAL SA DE CV",
        :email => "andres.amaya.diaz@gmail.com",
        :Domicilio => {
          :noExterior => "103",
          :calle => "San Juan",
          :colonia => "Colonia",
          :municipio => "Monterrey",
          :estado => "Nuevo Leon",
          :pais => "Mexico",
          :codigoPostal => "66250"
        } # Fin Domicilio
      }, # Fin Receptor
      :Conceptos => [{
          :cantidad => 1,
          :unidad => "NO APLICA",
          :descripcion => "Primer Concepto de Prueba",
          :valorUnitario => 10,
          :ret_iva => 0,
          :tras_ieps => 0,
          :tras_iva => 16,
          :ret_isr => 0
        },{
          :cantidad => 1,
          :unidad => "NO APLICA",
          :descripcion => "Segundo Concepto de Prueba",
          :valorUnitario => 100,
          :ret_iva => 0,
          :tras_ieps => 0,
          :tras_iva => 16,
          :ret_isr => 0
        }], # Fin Conceptos
        :Addenda => ""
     }
     
     return comp
    
  end
  
end
