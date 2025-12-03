@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help: Monedas'
@VDM.viewType: #BASIC
define view entity ZC_I_MONEDA as select from I_Currency
{
    key Currency,
    //Decimals,
    CurrencyISOCode,
    //AlternativeCurrencyKey,
    //IsPrimaryCurrencyForISOCrcy,
    /* Associations */
    _Text
}
