unit GBFR.NFe.Model.Imposto.ICMS;

interface

uses
  GBFR.NFe.Types;

type TGBFRNFeModelICMS = class
  private
    Forig: string;
    FmodBC: TNFeModalidadeBC;
    FvBC: Currency;
    FpICMS: Currency;
    FvICMS: Currency;
    FmodBCST: TNFeModalidadeBCST;
    FCST: String;
    FpRedBC: Currency;
    FvICMSDeson: Currency;
    FvBCSTRet: Currency;
    FpST: Currency;
    FvICMSSTRet: Currency;
    FvBCST: Currency;
    FpICMSST: Currency;
    FvICMSST: Currency;

  public
    property orig: string read Forig write Forig;
    property CST: String read FCST write FCST;
    property modBC: TNFeModalidadeBC read FmodBC write FmodBC;
    property vBC: Currency read FvBC write FvBC;
    property pICMS: Currency read FpICMS write FpICMS;
    property vICMS: Currency read FvICMS write FvICMS;
    property modBCST: TNFeModalidadeBCST read FmodBCST write FmodBCST;
    property pRedBC: Currency read FpRedBC write FpRedBC;
    property vICMSDeson: Currency read FvICMSDeson write FvICMSDeson;
    property vBCSTRet: Currency read FvBCSTRet write FvBCSTRet;
    property pST: Currency read FpST write FpST;
    property vICMSSTRet: Currency read FvICMSSTRet write FvICMSSTRet;
    property vBCST: Currency read FvBCST write FvBCST;
    property pICMSST: Currency read FpICMSST write FpICMSST;
    property vICMSST: Currency read FvICMSST write FvICMSST;
end;

implementation

end.
