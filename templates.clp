(deftemplate smartphone
(slot marca)
(slot modelo)
(slot color (default ninguno))
(slot os (default ios))
(slot precio (type NUMBER))
(slot stock (type INTEGER)))

(deftemplate computer
(slot marca)
(slot modelo)
(slot color (default ninguno))
(slot so (default macos))
(slot precio (type NUMBER))
(slot stock (type INTEGER)))

(deftemplate accessory
(slot sku)
(slot tipo)
(slot compat (default any))
(slot precio (type NUMBER))
(slot stock (type INTEGER)))

(deftemplate client
(slot id)
(slot nombre)
(slot segmento (default desconocido)))

(deftemplate creditcard
(slot tarjeta-id)
(slot cliente-id)
(slot banco)
(slot grupo)
(slot nivel (default clasica))
(slot exp-date))

(deftemplate order
(slot id)
(slot cliente-id)
(slot pago)
(slot banco (default ninguno))
(slot grupo (default ninguno))
(slot nivel (default ninguno)))


(deftemplate order-item
(slot orden-id)
(slot tipo)
(slot marca (default ninguno))
(slot modelo (default ninguno))
(slot sku (default ninguno))
(slot qty (type INTEGER)) )

(deftemplate oferta
  (slot orden-id) (slot tipo) (slot detalle) (slot valor (default 0)))

(deftemplate descuento
  (slot orden-id) (slot categoria) (slot porcentaje (type NUMBER)))

(deftemplate voucher
  (slot orden-id) (slot cliente-id) (slot monto (type NUMBER)) (slot motivo))

(deftemplate stock-alert
  (slot producto) (slot nivel))

(deftemplate segmento-orden
  (slot orden-id) (slot tipo))