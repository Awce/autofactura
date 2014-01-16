require 'test_helper'

class AutofacturaTest < ActiveSupport::TestCase
  test "truth" do
  
    assert_kind_of Module, Autofactura
  end
  
  test "comprobante" do
    
    comp = { 
      :serie => "SERIE",
      :tipoDeComprobante => "ingreso",
      :condicionesDePago => "CONTADO2",
      :formaDePago => "PAGO EN UNA SOLA EXHIBICION2",
      :metodoDePago => "NO IDENTIFICADO2",
      :numerocta => "NO IDENTIFICADO2",
      :version => "3.2",
      :tipoCambio => 1,
      :moneda => "MXN",
      :decimales => 2,
      :Receptor => {
        :rfc => "RFC",
        :nombre => "RAZON SOCIAL RECEPTOR",
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
          :unidad => "NO APLICA2",
          :descripcion => "Primer Concepto",
          :valorUnitario => 100,
          :descuento_porcentual => 0,
          :ret_iva => 0,
          :tras_ieps => 0,
          :tras_iva => 16,
          :ret_isr => 0
        },{
          :cantidad => 1,
          :unidad => "NO APLICA2",
          :descripcion => "Segundo Concepto",
          :valorUnitario => 1000,
          :descuento_porcentual => 0,
          :ret_iva => 0,
          :tras_ieps => 0,
          :tras_iva => 16,
          :ret_isr => 0
        }],
        :Addenda => ""
     }
     
     comprobante = Autofactura::Comprobante.new( comp )
     puts "COMPROBANTE: " + comprobante.to_json
     assert_not_nil(comprobante, "El Comprobante no se ha creado.")
     
  end
  
end
