@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reporte Tesoreria v2'
@Metadata.ignorePropagatedAnnotations: true
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_I_REPOR_TESORE_V2 as select from Z_REPOR_TESORE_V12
{

    // --- Selection Fields (Filtros del LRT) ---
    @UI.selectionField: [{ position: 10 }]
    CompanyCode,
    
    @UI.selectionField: [{ position: 20 }]
    Plant,
    
    @UI.selectionField: [{ position: 30 }]
    MonedaTransaccion,
    
    @UI.selectionField: [{ position: 40 }]
    FechaCompensacion,


    // --- Campos visibles en el reporte ---
    @UI.lineItem: [{ position: 10 }]
    CompanyCode as Sociedad,

    @UI.lineItem: [{ position: 20 }]
    AccountingDocument,

    @UI.lineItem: [{ position: 30 }]
    FiscalYear,

    @UI.lineItem: [{ position: 40 }]
    Centro,

    @UI.lineItem: [{ position: 50 }]
    MonedaTransaccion as Moneda,

    @UI.lineItem: [{ position: 60 }]
    BancoPropio,

    @UI.lineItem: [{ position: 70 }]
    FechaContabilizacion,

    @UI.lineItem: [{ position: 80 }]
    Referencia,

    @UI.lineItem: [{ position: 90 }]
    OrdenCompra,

    @UI.lineItem: [{ position: 100 }]
    IDSocioComercial,

    @UI.lineItem: [{ position: 110 }]
    FechaEmision,

    @UI.lineItem: [{ position: 120 }]
    FechaRegistro,

    @UI.lineItem: [{ position: 130 }]
    RazonSocial,

    @UI.lineItem: [{ position: 140 }]
    @Semantics.amount.currencyCode: 'MonedaTransaccion'
    ImportePEN,

    @UI.lineItem: [{ position: 150 }]
    @Semantics.amount.currencyCode: 'MonedaTransaccion'
    ImporteUSD,

    @UI.lineItem: [{ position: 160 }]
    TipoDocumento,

    @UI.lineItem: [{ position: 170 }]
    FechaCompensacion as Fecha,

    @UI.lineItem: [{ position: 180 }]
    FechaVencimiento,

    @UI.lineItem: [{ position: 190 }]
    @Semantics.amount.currencyCode: 'MonedaTransaccion'
    ImporteRetenidoPEN,

    @UI.lineItem: [{ position: 200 }]
    @Semantics.amount.currencyCode: 'MonedaTransaccion'
    ImporteRetenidoUSD,

    @UI.lineItem: [{ position: 210 }]
    TipoRetencion,

    @UI.lineItem: [{ position: 220 }]
    NombreCentro,

    @UI.lineItem: [{ position: 230 }]
    IndicadorPartidaAbierta

}
