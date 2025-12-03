@AbapCatalog.sqlViewName: 'Z_REP_TESO_RT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reporte Tesoreria'
@Metadata.ignorePropagatedAnnotations: true
define view ZC_I_REPOR_TESORE 
with parameters
    P_BUKRS : bukrs,       // Centro
    P_ExchRateType    : waers       // Tipo de Cotización
as select from I_AccountingDocumentJournal ( P_Language: 'S' )
 association [0..1] to I_BusinessPartner       as _Supplier       on $projection.Supplier = _Supplier.BusinessPartner
    //association [0..1] to I_BankChainBankDetail   as _BankDetail     on $projection.HouseBank = _BankDetail.HouseBank 
    
    association [0..1] to I_Withholdingtaxitem   as _With       on
        $projection.CompanyCode        = _With.CompanyCode and
        $projection.FiscalYear         = _With.FiscalYear and
        $projection.AccountingDocument = _With.AccountingDocument
    association [0..1] to I_JournalEntryItem      as _JEItem         on
        $projection.CompanyCode        = _JEItem.CompanyCode and
        $projection.FiscalYear         = _JEItem.FiscalYear and
        $projection.AccountingDocument = _JEItem.AccountingDocument
    association [0..1] to I_GLAccount as _GLAccount on _JEItem.GLAccount = _GLAccount.GLAccount
    association [0..1] to I_Plant                 as _Plant         on $projection.Plant = _Plant.Plant
    //association [0..1] to I_GLAccount as _GLAccount on CuentaContable = _GLAccount.GLAccount
  
    //association [0..1] to I_PurchasingDocument    as _PO            on $projection.PurchasingDocument = _PO.PurchasingDocument
    
    //association [0..1] to YY1_RUCZ_PDH           as _RUCZ           on $projection.Supplier = _RUCZ.BusinessPartner
    //association [0..1] to I_WithholdingTaxItem   as _WHTaxItem      on ...

{
     /* Claves principales a nivel de documento contable */
    key AccountingDocument,
    key CompanyCode,
    key FiscalYear,
    Supplier,
    Plant,
   

    /* Campos agrupados */
    max(_JEItem.GLAccount) as CuentaContable,
    max(Plant)                            as Centro,
    max(TransactionCurrency)             as MonedaTransaccion,
    max(HouseBank)                       as BancoPropio,
    max(PostingDate)                     as FechaContabilizacion,
    max(DocumentReferenceID)             as Referencia,
    max(PurchasingDocument)             as OrdenCompra,
    max(Supplier)                        as IDSocioComercial,
    max(DocumentDate)                    as FechaEmision,
    max(CreationDate)                    as FechaRegistro,
    max(_Supplier.BusinessPartnerFullName) as RazonSocial,

    /* Importes totalizados */
    sum(_JEItem.AmountInCompanyCodeCurrency) as ImportePEN,
    sum(_JEItem.AmountInGlobalCurrency)      as ImporteUSD,

    /* Otros campos (no numéricos) agrupados por MAX */
    max(_JEItem.AccountingDocumentType)      as TipoDocumento,
    max(_JEItem.ClearingDate)                as FechaCompensacion,
    max(_JEItem.NetDueDate)                  as FechaVencimiento,

    /* Retenciones y detracciones */
    sum(_With.WhldgTaxAmtInCoCodeCrcy)       as ImporteRetenidoPEN,
    sum(_With.WhldgTaxAmtInTransacCrcy)      as ImporteRetenidoUSD,
    max(_With.WithholdingTaxCode)           as TipoRetencion,
    max(_With.WithholdingTaxCode)           as IndicadorDetraccion,
    
    /*Campos nuevos*/
    max(_Plant.PlantName) as NombreCentro,
    max(_JEItem.IsOpenItemManaged) as IndicadorPartidaAbierta
    //max(_JEItem.ItemText) as TextoPosicion
    //max(_GLAccount.GLAccountName) as DescripcionCuentaContable
    //max(_JEItem.ItemText)                     as TextoPosicion,
    //max(__GLAccount._Text)             as DescripcionCuentaContable,
    //max(_JEItem.OpenItemIsExist)              as IndicadorPartidaAbierta
    //max(_JEItem.OpenItemIsExist) as IndicadorPartidaAbierta

}
where
    Plant = :P_BUKRS and
    TransactionCurrency = :P_ExchRateType 
    and FinancialAccountType = 'K'
    and Ledger = '0L'
    and
    (
      AccountingDocumentType = 'K0' or
      AccountingDocumentType = 'K1' or
      AccountingDocumentType = 'K2' or
      AccountingDocumentType = 'K3' or
      AccountingDocumentType = 'SU' or
      AccountingDocumentType = 'KZ'
    )
group by
    CompanyCode,
    AccountingDocument,
    FiscalYear,
    Supplier,
    Plant
