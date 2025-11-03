(deffacts seed-products

(smartphone (marca apple) (modelo iphone16) (color rojo) (os ios) (precio 27000) (stock 60))
(smartphone (marca samsung) (modelo note21) (color negro) (os android) (precio 22000) (stock 40))
(smartphone (marca samsung) (modelo a35) (color azul) (os android) (precio 7500) (stock 100))

(computer (marca apple) (modelo macbookair) (color gris) (so macos) (precio 30000) (stock 25))
(computer (marca dell) (modelo xps13) (color plata) (so windows) (precio 28000) (stock 18))

(accessory (sku FUNDA-IP16) (tipo funda) (compat apple) (precio 500) (stock 150))
(accessory (sku MICA-UNIV) (tipo mica) (compat universal) (precio 200) (stock 300))
(accessory (sku POWER-10K) (tipo powerbank) (compat universal) (precio 900) (stock 80))
(accessory (sku HUB-USBC) (tipo hub) (compat mac) (precio 1200) (stock 35))
(accessory (sku CASE-N21) (tipo funda) (compat samsung) (precio 450) (stock 70))
)

(deffacts seed-clients
(client (id C1) (nombre "Angel"))
(client (id C2) (nombre "Tienda Mayorista SA"))

(creditcard (tarjeta-id T1) (cliente-id C1) (banco banamex) (grupo visa) (nivel oro) (exp-date 2027-11))
(creditcard (tarjeta-id T2) (cliente-id C2) (banco liverpool) (grupo visa) (nivel clasica) (exp-date 2026-05))
)