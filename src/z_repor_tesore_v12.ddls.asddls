@AbapCatalog.sqlViewName: 'Z_REP_TESO_RT2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reporte Tesoreria v12'
@Metadata.ignorePropagatedAnnotations: true
define view Z_REPOR_TESORE_V12 
as select from I_AccountingDocumentJournal ( P_Language: 'S' ) as Journal 
    association [0..1] to I_JournalEntryItem     as _JEItem    on Journal.CompanyCode        = _JEItem.CompanyCode
                                                              and Journal.FiscalYear         = _JEItem.FiscalYear
                                                              and Journal.AccountingDocument = _JEItem.AccountingDocument
    association [0..1] to I_Withholdingtaxitem   as _With      on Journal.CompanyCode        = _With.CompanyCode
                                                              and Journal.FiscalYear         = _With.FiscalYear
                                                              and Journal.AccountingDocument = _With.AccountingDocument
    association [0..1] to I_Plant                as _Plant     on Journal.Plant              = _Plant.Plant
    association [0..1] to I_BusinessPartner      as _Supplier  on Journal.Supplier            = _Supplier.BusinessPartner

{
    key Journal.CompanyCode              as CompanyCode,
    key Journal.AccountingDocument       as AccountingDocument,
    key Journal.FiscalYear               as FiscalYear,

    Journal.Plant                        as Plant,
    Journal.Supplier                     as Supplier,
    //Journal. as Moneda,

    max(_JEItem.GLAccount)              as CuentaContable,
    max(Journal.Plant)                  as Centro,
    max(Journal.TransactionCurrency)    as MonedaTransaccion,
    max(Journal.HouseBank)              as BancoPropio,
    max(Journal.PostingDate)            as FechaContabilizacion,
    max(Journal.DocumentReferenceID)    as Referencia,
    max(Journal.PurchasingDocument)     as OrdenCompra,
    max(Journal.Supplier)               as IDSocioComercial,
    max(Journal.DocumentDate)           as FechaEmision,
    max(Journal.CreationDate)           as FechaRegistro,
    max(_Supplier.BusinessPartnerFullName) as RazonSocial,

    @Semantics.amount.currencyCode: 'MonedaTransaccion'
    cast( sum( _JEItem.AmountInCompanyCodeCurrency ) as abap.curr( 17, 2 ) ) as ImportePEN,
    
    @UI.lineItem: [{ position: 150 }]
    @Semantics.amount.currencyCode: 'MonedaTransaccion'
    cast( sum( _JEItem.AmountInGlobalCurrency ) as abap.curr(17,2) ) as ImporteUSD,

    max(_JEItem.AccountingDocumentType)      as TipoDocumento,
    max(_JEItem.ClearingDate)                as FechaCompensacion,
    max(_JEItem.NetDueDate)                  as FechaVencimiento,

    @UI.lineItem: [{ position: 190 }]
    @Semantics.amount.currencyCode: 'MonedaTransaccion'
    cast( sum( _With.WhldgTaxAmtInCoCodeCrcy ) as abap.curr(17,2) ) as ImporteRetenidoPEN,
    @UI.lineItem: [{ position: 200 }]
    @Semantics.amount.currencyCode: 'MonedaTransaccion'
    cast( sum( _With.WhldgTaxAmtInTransacCrcy ) as abap.curr(17,2) ) as ImporteRetenidoUSD,
    max(_With.WithholdingTaxCode)           as TipoRetencion,
    max(_Plant.PlantName)                   as NombreCentro,
    max(_JEItem.IsOpenItemManaged)          as IndicadorPartidaAbierta

}
group by
    Journal.CompanyCode,
    Journal.AccountingDocument,
    Journal.FiscalYear,
    Journal.Plant,
    Journal.Supplier
