# =============================================================================
# acr.tf - Demo Sesión 1: el ACR con VARIANTES para enseñar posibilidades
# =============================================================================

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  # --- POSIBILIDAD a) SKU --------------------------------------------------
  sku = "Basic" # económico, suficiente para el caso
  # sku = "Standard"   # más almacenamiento y throughput
  # sku = "Premium"    # geo-replicación, private link, content trust

  # --- POSIBILIDAD b) autenticación ---------------------------------------
  admin_enabled = true # usuario+contraseña (simple). En producción: identidades/tokens.

  # --- POSIBILIDAD c) acceso de red (solo Premium soporta network_rule_set) -
  # public_network_access_enabled = true

  tags = {
    environment = "casopractico2"
  }
}
