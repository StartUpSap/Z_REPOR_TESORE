@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vista CDS para determinar la contrapartida Core'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CONTRA_PARTIDA_CORE
  as select from I_OperationalAcctgDocItem
{
  key CompanyCode,
  key AccountingDocument,
  key FiscalYear,
      cast( min(GLAccount) as saknr ) as CoreGLAccount
}
where
  (
       GLAccount like '003%'
    or GLAccount like '006%'
  )

  and  GLAccount not like '0065%' and GLAccount not like '%0067611010%'


group by
  CompanyCode,
  AccountingDocument,
  FiscalYear;
