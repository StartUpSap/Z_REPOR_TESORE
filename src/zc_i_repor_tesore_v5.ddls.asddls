@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Match para Nombre Centro'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_I_REPOR_TESORE_V5 
as select from C_SupplierInvoiceItemDEX as Supplier

 join I_Plant as _Plant on Supplier.Plant = _Plant.Plant
{
    key Supplier.SupplierInvoice,
    Supplier.PurchaseOrder,
    _Plant.Plant,
    _Plant.PlantName,
    Supplier.SupplierInvoiceIDByInvcgParty
    }
