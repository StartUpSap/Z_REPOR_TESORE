@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reporte Tesoreria v4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_I_REPOR_TESORE_V4
  as select from    I_AccountingDocumentJournal  ( P_Language: 'S' ) as Doc
    inner join      I_OperationalAcctgDocItem                        as _JEItem            on  Doc.CompanyCode            = _JEItem.CompanyCode
                                                                                           and Doc.FiscalYear             = _JEItem.FiscalYear
                                                                                           and Doc.AccountingDocument     = _JEItem.AccountingDocument
                                                                                           and Doc.AccountingDocumentItem = _JEItem.AccountingDocumentItem
                                                                                           and Doc.GLAccount              = _JEItem.GLAccount
    left outer join ZI_CONTRA_PARTIDA_CORE                           as _ContraPartidaCore on  _ContraPartidaCore.CompanyCode        = Doc.CompanyCode
                                                                                           and _ContraPartidaCore.AccountingDocument = Doc.AccountingDocument
                                                                                           and _ContraPartidaCore.FiscalYear         = Doc.FiscalYear
    left outer join I_GLAccount                                      as _GlAccountCore     on  _GlAccountCore.GLAccount   = _ContraPartidaCore.CoreGLAccount
                                                                                           and _GlAccountCore.CompanyCode = _ContraPartidaCore.CompanyCode
    left outer join ZI_CONTRA_PARTIDA_ALT                            as _ContraPartidaAlt  on  _ContraPartidaAlt.CompanyCode        = Doc.CompanyCode
                                                                                           and _ContraPartidaAlt.AccountingDocument = Doc.AccountingDocument
                                                                                           and _ContraPartidaAlt.FiscalYear         = Doc.FiscalYear
    left outer join I_GLAccount                                      as _GlAccountAlt      on  _GlAccountAlt.GLAccount   = _ContraPartidaAlt.AlternativeGLAccount
                                                                                           and _GlAccountAlt.CompanyCode = _ContraPartidaAlt.CompanyCode

  association [0..1] to I_BusinessPartner    as _Supplier          on  Doc.Supplier = _Supplier.BusinessPartner
  association [0..1] to I_Plant              as _Plant             on  Doc.Plant = _Plant.Plant
  association [0..1] to ZC_I_REPOR_TESORE_V5 as _Factura           on  Doc.DocumentReferenceID = _Factura.SupplierInvoiceIDByInvcgParty
                                                                   and Doc.ReferenceDocument   = _Factura.SupplierInvoice
  association [0..1] to I_Withholdingtaxitem as _With              on  Doc.CompanyCode        = _With.CompanyCode
                                                                   and Doc.FiscalYear         = _With.FiscalYear
                                                                   and Doc.AccountingDocument = _With.AccountingDocument

  association [0..1] to I_GLAccountText      as _GlAccountCoreText on  _GlAccountCoreText.GLAccount       = _GlAccountCore.GLAccount
                                                                   and _GlAccountCoreText.ChartOfAccounts = _GlAccountCore.ChartOfAccounts
                                                                   and _GlAccountCoreText.Language        = 'S'

  association [0..1] to I_GLAccountText      as _GlAccountAltText  on  _GlAccountAltText.GLAccount       = _GlAccountAlt.GLAccount
                                                                   and _GlAccountAltText.ChartOfAccounts = _GlAccountAlt.ChartOfAccounts
                                                                   and _GlAccountAltText.Language        = 'S'
  association [0..1] to I_GLAccountText      as _GlAccountText     on  _GlAccountText.GLAccount       = _JEItem.GLAccount
                                                                   and _GlAccountText.ChartOfAccounts = _JEItem.ChartOfAccounts
                                                                   and _GlAccountText.Language        = 'S'

  /*association [0..1] to C_SupplierInvoiceItemDEX as supplier on
    Doc.AccountingDocument = supplier.SupplierInvoice*/
{
      /* === Claves === */
  key Doc.AccountingDocument,
  key Doc.AccountingDocumentItem                                        as posicion,
  key Doc.CompanyCode,
  key Doc.FiscalYear,


      @EndUserText.label: 'Texto de posición (glosa)'
      max(_JEItem.DocumentItemText )                                    as DocumentItemText,

      /* === Filtros visibles === */

      @UI.selectionField: [{ position: 10 }]
      @Consumption.valueHelpDefinition: [{
        entity: { name: 'ZC_I_CENTROS_01', element: 'Plant' }
      }]
      max(_Factura.Plant)                                               as Centro,

      @UI.selectionField: [{ position: 20 }]
      @Consumption.valueHelpDefinition: [{
        entity: { name: 'ZC_I_MONEDA', element: 'Currency' }
      }]
      Doc.TransactionCurrency                                           as MonedaTransaccion,

      @UI.selectionField: [{ position: 30 }]
      @Consumption.filter: { selectionType: #SINGLE }
      @EndUserText.label: '¿Partida abierta?'
      cast ( case
        when coalesce(max(_JEItem.ClearingJournalEntry), '') = '' then 'X' else ' '
      end    as abap_boolean )                                          as IndicadorPartidaAbierta,

      @UI.selectionField: [{ position: 40 }]
      @Consumption.filter: { selectionType: #RANGE }
      max(_JEItem.ClearingDate)                                         as FechaCompensacion,

      /* === Datos de cabecera === */
      @Consumption.valueHelpDefinition: [{
        entity: { name: 'ZC_I_MONEDA', element: 'Currency' }
      }]
      Doc.FunctionalCurrency,
      Doc.Supplier,
      _JEItem.ClearingJournalEntry                                      as AsientoCompensacion,
      max(_Supplier.BusinessPartnerFullName)                            as RazonSocial,
      max(Doc.HouseBank)                                                as BancoPropio,
      max(Doc.PostingDate)                                              as FechaContabilizacion,
      max(Doc.DocumentReferenceID)                                      as Referencia,
      max(_Factura.PurchaseOrder)                                       as OrdenCompra,
      max(Doc.Supplier)                                                 as IDSocioComercial,
      max(Doc.DocumentDate)                                             as FechaEmision,
      max(Doc.CreationDate)                                             as FechaRegistro,
      max(_Factura.PlantName)                                           as NombreCentro,
      max(_JEItem.GLAccount)                                            as CuentaContable,
      max(_GlAccountText.GLAccountName)                                 as TextoCuentaContable,

      /* === Montos === */
      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'FunctionalCurrency'
      cast(max(_JEItem.AmountInCompanyCodeCurrency) as abap.curr(17,2)) as ImportePEN,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'MonedaTransaccion'
      @EndUserText.label: 'Importe en Moneda transacción'
      cast(max(_JEItem.AmountInTransactionCurrency) as abap.curr(17,2)) as ImporteUSD,

      //      @Semantics.amount.currencyCode: 'MonedaTransaccion'
      //      cast(_JEItem.AmountInGlobalCurrency as abap.curr(17,2))      as ImporteUSD,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'FunctionalCurrency'
      cast( max(_With.WhldgTaxAmtInCoCodeCrcy) as abap.curr(17,2))      as ImporteRetenidoPEN,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'MonedaTransaccion'
      @EndUserText.label: 'Retención en Moneda transacción'
      cast( max(_With.WhldgTaxAmtInTransacCrcy) as abap.curr(17,2))     as ImporteRetenidoUSD,

      @UI.hidden: true
      cast(
        case
          when coalesce(max(_JEItem.ClearingJournalEntry), '') = '' then 3  -- Verde
                  else 1                    -- Rojo
        end
        as abap.int1
      )                                                                 as IndicPartCrit,

      /* === Información adicional === */
      max(_JEItem.AccountingDocumentType)                               as TipoDocumento,
      max(_JEItem.NetDueDate)                                           as FechaVencimiento,
      max(_With.WithholdingTaxCode)                                     as TipoRetencion,
      max(_With.WithholdingTaxCode)                                     as IndicadorDetraccion,


      //---- Información de cuenta contra partida
      @EndUserText.label: 'Cuenta contra partida'

      case
        when max(_ContraPartidaCore.CoreGLAccount) is not null then max(_ContraPartidaCore.CoreGLAccount)
        when max(_ContraPartidaAlt.AlternativeGLAccount) is not null then max(_ContraPartidaAlt.AlternativeGLAccount)
        else max(_JEItem.GLAccount)
      end                                                               as GlAccountContraPartida,
      @EndUserText.label: 'Desc. Cuenta contra partida'

      case
        when max(_ContraPartidaCore.CoreGLAccount) is not null then max(_GlAccountCoreText.GLAccountName)
        when max(_ContraPartidaAlt.AlternativeGLAccount) is not null then max(_GlAccountAltText.GLAccountName)
        else max(_GlAccountText.GLAccountName)
      end                                                               as DescrGlAccountContraPartida
}
where
       Doc.FinancialAccountType   = 'K'
  and  Doc.Ledger                 = '0L'
  /*and _With.WithholdingTaxCode ='9P'*/
  and(
       Doc.AccountingDocumentType = 'K0'
    or Doc.AccountingDocumentType = 'K1'
    or Doc.AccountingDocumentType = 'K2'
    or Doc.AccountingDocumentType = 'K3'
    or Doc.AccountingDocumentType = 'K7'
    or Doc.AccountingDocumentType = 'SU'
    or Doc.AccountingDocumentType = 'KZ'
  )
group by
  Doc.CompanyCode,
  Doc.AccountingDocument,
  Doc.FiscalYear,
  Doc.Supplier,
  Doc.Plant,
  Doc.TransactionCurrency,
  Doc.PostingDate,
  Doc.FunctionalCurrency,
  _JEItem.ClearingJournalEntry,
  Doc.AccountingDocumentItem
