@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vista CDS para determinar la contrapartida Alternativa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CONTRA_PARTIDA_ALT
  as select from I_OperationalAcctgDocItem
{
  key CompanyCode,
  key AccountingDocument,
  key FiscalYear,
      min(GLAccount) as AlternativeGLAccount
}
where
  (
       GLAccount = '0028711010'
    or GLAccount = '0028711020'
    or GLAccount = '0042211010'
    or GLAccount = '0065931030'
  )

  and  GLAccount not like '0065%' and GLAccount not like '%0067611010%'


group by
  CompanyCode,
  AccountingDocument,
  FiscalYear;
