(deffunction banner (?txt)
(printout t crlf "== " ?txt " ==" crlf))

(deffunction compute-total (?oid)
(bind ?sum 0)
(do-for-all-facts ((?it order-item)) (and (eq ?it:orden-id ?oid) (eq ?it:tipo smartphone))
(do-for-all-facts ((?p smartphone)) (and (eq ?p:marca ?it:marca) (eq ?p:modelo ?it:modelo))

(bind ?sum (+ ?sum (* ?p:precio ?it:qty)))))
(do-for-all-facts ((?it order-item)) (and (eq ?it:orden-id ?oid) (eq ?it:tipo computer))
(do-for-all-facts ((?p computer)) (and (eq ?p:marca ?it:marca) (eq ?p:modelo ?it:modelo))
(bind ?sum (+ ?sum (* ?p:precio ?it:qty)))))

(do-for-all-facts ((?it order-item)) (and (eq ?it:orden-id ?oid) (eq ?it:tipo accessory))
(do-for-all-facts ((?a accessory)) (eq ?a:sku ?it:sku)
(bind ?sum (+ ?sum (* ?a:precio ?it:qty)))))
?sum)

(deffunction count-items (?oid ?tipo)
(bind ?cnt 0)
(do-for-all-facts ((?it order-item)) (and (eq ?it:orden-id ?oid) (eq ?it:tipo ?tipo))
(bind ?cnt (+ ?cnt ?it:qty)))
?cnt)

(deffunction expired? (?exp)
  (if (or (numberp ?exp) (eq ?exp nil)) then (return FALSE))
  (bind ?now "2025-11")
  (if (< (str-compare ?exp ?now) 0)
      then TRUE
      else FALSE))

(defrule seg-mayorista
?o <- (order (id ?oid))
(order-item (orden-id ?oid) (qty ?q&:(> ?q 10)))
(not (segmento-orden (orden-id ?oid)))
=>
(assert (segmento-orden (orden-id ?oid) (tipo mayorista)))
(printout t "[SEGMENTO] Orden " ?oid ": mayorista (qty>10)" crlf))

(defrule seg-menudista
?o <- (order (id ?oid))
(not (order-item (orden-id ?oid) (qty ?q&:(> ?q 10))))
(not (segmento-orden (orden-id ?oid)))
=>
(assert (segmento-orden (orden-id ?oid) (tipo menudista)))
(printout t "[SEGMENTO] Orden " ?oid ": menudista (qty<=10)" crlf))

(defrule msi-iphone16-banamex-24
(order (id ?oid) (pago tarjeta) (banco banamex))
(order-item (orden-id ?oid) (tipo smartphone) (marca apple) (modelo iphone16))
=>
(assert (oferta (orden-id ?oid) (tipo msi) (detalle "iPhone16 + Banamex: 24 MSI") (valor 24)))
(printout t "[OFERTA] Orden " ?oid ": 24 MSI con Banamex por iPhone16" crlf))

(defrule msi-note21-liverpool-12
(order (id ?oid) (pago tarjeta) (banco liverpool) (grupo visa))
(order-item (orden-id ?oid) (tipo smartphone) (marca samsung) (modelo note21))
=>
(assert (oferta (orden-id ?oid) (tipo msi) (detalle "Note21 + Liverpool VISA: 12 MSI") (valor 12)))
(printout t "[OFERTA] Orden " ?oid ": 12 MSI con Liverpool VISA por Note21" crlf))

(defrule msi-generica-bbva-6
(order (id ?oid) (pago tarjeta) (banco bbva) (grupo visa))
(order-item (orden-id ?oid) (qty ?q))
(test (> (compute-total ?oid) 10000))
=>
(assert (oferta (orden-id ?oid) (tipo msi) (detalle "BBVA VISA > $10k: 6 MSI") (valor 6)))
(printout t "[OFERTA] Orden " ?oid ": 6 MSI BBVA VISA (>10k)" crlf))

(defrule descuento-accesorios-15
(order (id ?oid))
(order-item (orden-id ?oid) (tipo smartphone))
(not (descuento (orden-id ?oid) (categoria accesorios)))
=>
(assert (descuento (orden-id ?oid) (categoria accesorios) (porcentaje 15)))
(printout t "[DESCUENTO] Orden " ?oid ": 15% en accesorios por compra de smartphone" crlf))

(defrule rec-funda-y-mica
(order (id ?oid))
(order-item (orden-id ?oid) (tipo smartphone) (marca ?m) (modelo ?mod))
=>
(assert (oferta (orden-id ?oid) (tipo recomendacion)
(detalle (str-cat "Recomendado: funda y mica para " ?m " " ?mod))))
(printout t "[RECOM] Orden " ?oid ": funda y mica recomendadas" crlf))

(defrule rec-powerbank
(order (id ?oid))
(order-item (orden-id ?oid) (tipo smartphone))
(accessory (sku POWER-10K) (stock ?s&:(> ?s 0)))
=>
(assert (oferta (orden-id ?oid) (tipo recomendacion) (detalle "Agregar powerbank 10KmAh")))
(printout t "[RECOM] Orden " ?oid ": powerbank recomendado" crlf))

(defrule rec-applecare
(order (id ?oid))
(order-item (orden-id ?oid) (tipo smartphone) (marca apple))
=>
(assert (oferta (orden-id ?oid) (tipo recomendacion) (detalle "Agregar AppleCare+")))
(printout t "[RECOM] Orden " ?oid ": AppleCare+ sugerido" crlf))

(defrule rec-mac-hub
(order (id ?oid))
(order-item (orden-id ?oid) (tipo computer) (marca apple))
(accessory (sku HUB-USBC) (stock ?x&:(> ?x 0)))
=>
(assert (oferta (orden-id ?oid) (tipo recomendacion) (detalle "USB-C hub para Mac")))
(printout t "[RECOM] Orden " ?oid ": hub USB-C sugerido" crlf))

(defrule rec-windows-antivirus
(order (id ?oid))
(order-item (orden-id ?oid) (tipo computer) (marca ?m))
(computer (marca ?m) (modelo ?cm) (so windows))
=>
(assert (oferta (orden-id ?oid) (tipo recomendacion) (detalle "Licencia antivirus para Windows")))
(printout t "[RECOM] Orden " ?oid ": antivirus sugerido" crlf))

(defrule vales-macair-iphone16-contado
(order (id ?oid) (pago contado) (cliente-id ?cid))
(order-item (orden-id ?oid) (tipo smartphone) (marca apple) (modelo iphone16) (qty ?qs))
(order-item (orden-id ?oid) (tipo computer) (marca apple) (modelo macbookair) (qty ?qc))
(smartphone (marca apple) (modelo iphone16) (precio ?ps))
(computer (marca apple) (modelo macbookair) (precio ?pc))
=>
(bind ?total (+ (* ?ps ?qs) (* ?pc ?qc)))
(bind ?vales (* 100 (div ?total 1000)))
(if (> ?vales 0) then
(assert (voucher (orden-id ?oid) (cliente-id ?cid) (monto ?vales)
(motivo "Combo MacBook Air + iPhone16 contado")))
(printout t "[VALES] Orden " ?oid ": $" ?vales " en vales (combo contado)" crlf)
(assert (oferta (orden-id ?oid) (tipo vales)
(detalle "Vales por combo contado MacAir+iPhone16") (valor ?vales)))))

(defrule extra-desc-accesorios-ticket-alto
(order (id ?oid) (pago contado))
(test (> (compute-total ?oid) 50000))
(not (oferta (orden-id ?oid) (tipo descuento) (detalle "+5% accesorios por ticket alto")))
=>
(assert (oferta (orden-id ?oid) (tipo descuento) (detalle "+5% accesorios por ticket alto")))
(printout t "[DESCUENTO] Orden " ?oid ": +5% accesorios por ticket > $50k" crlf))

(defrule extra-desc-seg-mayorista
(segmento-orden (orden-id ?oid) (tipo mayorista))
=>
(assert (oferta (orden-id ?oid) (tipo descuento) (detalle "+3% total por mayorista")))
(printout t "[DESCUENTO] Orden " ?oid ": +3% por segmento mayorista" crlf))

(defrule promo-samsung-cases
(order (id ?oid))
(order-item (orden-id ?oid) (tipo smartphone) (marca samsung) (modelo note21))
(accessory (sku CASE-N21) (stock ?st&:(> ?st 0)))
=>
(assert (oferta (orden-id ?oid) (tipo descuento) (detalle "Fundas Note21 -25%")))
(printout t "[DESCUENTO] Orden " ?oid ": -25% fundas Note21" crlf))

(defrule envio-gratis-smartphone-premium
(order (id ?oid))
(order-item (orden-id ?oid) (tipo smartphone) (marca ?m) (modelo ?mod))
(smartphone (marca ?m) (modelo ?mod) (precio ?p&:(> ?p 20000)))
=>
(assert (oferta (orden-id ?oid) (tipo descuento) (detalle "Envío gratis (smartphone premium)")))
(printout t "[DESCUENTO] Orden " ?oid ": envío gratis (smartphone > $20k)" crlf))

(defrule multi-smartphones-2nd-accessory-10
(order (id ?oid))
(test (>= (count-items ?oid smartphone) 2))
=>
(assert (oferta (orden-id ?oid) (tipo descuento) (detalle "2º accesorio -10%")))
(printout t "[DESCUENTO] Orden " ?oid ": 2º accesorio -10% (>=2 smartphones)" crlf))

(defrule tarjeta-expirada-aviso
(order (id ?oid) (cliente-id ?cid) (pago tarjeta))
(creditcard (cliente-id ?cid) (tarjeta-id ?tid) (exp-date ?exp))
(test (expired? ?exp))
=>
(assert (oferta (orden-id ?oid) (tipo aviso) (detalle "Tarjeta expirada: usar contado u otra tarjeta")))
(printout t "[AVISO] Orden " ?oid ": tarjeta expirada" crlf))

(defrule disminuir-stock-smartphone
(order-item (orden-id ?oid) (tipo smartphone) (marca ?m) (modelo ?mod) (qty ?q))
?s <- (smartphone (marca ?m) (modelo ?mod) (stock ?st&:(>= ?st ?q)))
=>
(modify ?s (stock (- ?st ?q)))
(printout t "[STOCK] " ?m " " ?mod ": -" ?q " => ahora " (- ?st ?q) crlf))

(defrule stock-smartphone-insuficiente
(order-item (orden-id ?oid) (tipo smartphone) (marca ?m) (modelo ?mod) (qty ?q))
(smartphone (marca ?m) (modelo ?mod) (stock ?st&:(< ?st ?q)))
=>
(assert (stock-alert (producto (str-cat "smartphone " ?m " " ?mod)) (nivel (str-cat "stock " ?st ", requerido " ?q))))
(printout t "[ALERTA] Stock insuficiente para " ?m " " ?mod " (" ?st "/" ?q ")" crlf))

(defrule disminuir-stock-computer
(order-item (orden-id ?oid) (tipo computer) (marca ?m) (modelo ?mod) (qty ?q))
?c <- (computer (marca ?m) (modelo ?mod) (stock ?st&:(>= ?st ?q)))
=>
(modify ?c (stock (- ?st ?q)))
(printout t "[STOCK] " ?m " " ?mod ": -" ?q " => ahora " (- ?st ?q) crlf))

(defrule disminuir-stock-accessory
(order-item (orden-id ?oid) (tipo accessory) (sku ?sku) (qty ?q))
?a <- (accessory (sku ?sku) (stock ?st&:(>= ?st ?q)))
=>
(modify ?a (stock (- ?st ?q)))
(printout t "[STOCK] Acc " ?sku ": -" ?q " => ahora " (- ?st ?q) crlf))

(defrule restock-alert-bajo
(or (smartphone (marca ?m) (modelo ?mod) (stock ?s&:(< ?s 5)))
(computer (marca ?mc) (modelo ?md) (stock ?sc&:(< ?sc 5)))
(accessory (sku ?sk) (stock ?sa&:(< ?sa 5))))
=>
(assert (stock-alert (producto "varios") (nivel "bajo<5")))
(printout t "[ALERTA] Restock recomendado: algún producto < 5" crlf))