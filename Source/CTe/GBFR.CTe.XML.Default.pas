unit GBFR.CTe.XML.Default;

interface

uses
  GBFR.CTe.Model.Classes,
  GBFR.CTe.Model.Types,
  GBFR.CTe.XML.Interfaces,
  GBFR.XML.Base,
  System.Classes,
  System.SysUtils,
  Xml.XMLIntf,
  Xml.XMLDoc;

type TGBFRCTeXMLDefault = class(TGBFRXmlBase, IGBFRCTeXML)

  private
    FCTe: TGBFRCTeModel;
    [Weak]
    FInfCTe: IXMLNode;

    procedure loadTagInfCte;
    procedure loadTagIde;
    procedure loadTagIdeToma3(ANode: IXMLNode);
    procedure loadTagCompl;
    procedure loadTagEmit;
    procedure loadTagRem;
    procedure loadTagExped;
    procedure loadTagDest;
    procedure loadTagEndereco(ANode: IXMLNode; AEndereco: TGBFRCTeModelEndereco);
    procedure loadTagVPrest;
    procedure loadTagImp;
    procedure loadTagAutXML;
    procedure loadTagInfProt;
    procedure loadTagInfCTeSupl;
    procedure loadTagInfCTeNorm;
    procedure loadTagInfCarga(ANodeInfCTeNorm: IXMLNode);
    procedure loadTagInfDoc  (ANodeInfCTeNorm: IXMLNode);
    procedure loadTagInfModal(ANodeInfCTeNorm: IXMLNode);

  protected
    function loadFromContent(Value: String): TGBFRCTeModel;
    function loadFromFile   (Value: String): TGBFRCTeModel;
    function loadFromStream (Value: TStream): TGBFRCTeModel;

  public
    class function New: IGBFRCTeXML;
end;

implementation

{ TGBFRCTeXMLDefault }

function TGBFRCTeXMLDefault.loadFromContent(Value: String): TGBFRCTeModel;
begin
  loadXmlContent(Value);
  Result := TGBFRCTeModel.create;
  try
    FCTe := Result;

    loadTagInfCte;
    loadTagIde;
    loadTagCompl;
    loadTagEmit;
    loadTagRem;
    loadTagExped;
    loadTagDest;
    loadTagVPrest;
    loadTagImp;
    loadTagInfCTeNorm;
    loadTagAutXML;
    loadTagInfProt;
    loadTagInfCTeSupl;
  except
    Result.Free;
    raise;
  end;
end;

function TGBFRCTeXMLDefault.loadFromFile(Value: String): TGBFRCTeModel;
var
  xmlFile: TStrings;
begin
  xmlFile := TStringList.Create;
  try
    xmlFile.LoadFromFile(Value);
    result := loadFromContent(xmlFile.Text);
  finally
    xmlFile.Free;
  end;
end;

function TGBFRCTeXMLDefault.loadFromStream(Value: TStream): TGBFRCTeModel;
var
  stringStream: TStringStream;
  content: string;
begin
  stringStream := TStringStream.Create;
  try
    stringStream.LoadFromStream(Value);
    content := stringStream.DataString;
    result  := loadFromContent(content);
  finally
    stringStream.Free;
  end;
end;

procedure TGBFRCTeXMLDefault.loadTagAutXML;
var
  nodeAutXML : IXMLNode;
  CPF        : string;
  CNPJ       : string;
begin
  nodeAutXML := FInfCTe.ChildNodes.FindNode('autXML');
  while nodeAutXML <> nil do
  begin
    CNPJ := GetNodeStr(nodeAutXML, 'CNPJ');
    CPF := GetNodeStr (nodeAutXML, 'CPF');

    FCTe.addAutXML(CNPJ, CPF);
    nodeAutXML := nodeAutXML.NextSibling;
  end;
end;

procedure TGBFRCTeXMLDefault.loadTagCompl;
var
  nodeCompl: IXMLNode;
begin
  nodeCompl := FInfCTe.ChildNodes.FindNode('compl');
  if not Assigned(nodeCompl) then
    Exit;

  FCTe.compl.xCaracAd  := GetNodeStr(nodeCompl, 'xCaracAd');
  FCTe.compl.xCaracSer := GetNodeStr(nodeCompl, 'xCaracSer');
  FCTe.compl.xEmi      := GetNodeStr(nodeCompl, 'xEmi');
  FCTe.compl.origCalc  := GetNodeStr(nodeCompl, 'origCalc');
  FCTe.compl.destCalc  := GetNodeStr(nodeCompl, 'destCalc');
  FCTe.compl.xObs      := GetNodeStr(nodeCompl, 'xObs');
end;

procedure TGBFRCTeXMLDefault.loadTagDest;
var
  nodeDest: IXMLNode;
  nodeEndereco: IXMLNode;
begin
  nodeDest := FInfCTe.ChildNodes.FindNode('dest');
  if not Assigned(nodeDest) then
    Exit;

  FCTe.dest.CNPJ  := GetNodeStr(nodeDest, 'CNPJ');
  FCTe.dest.IE    := GetNodeStr(nodeDest, 'IE');
  FCTe.dest.IEST  := GetNodeStr(nodeDest, 'IEST');
  FCTe.dest.xNome := GetNodeStr(nodeDest, 'xNome');
  FCTe.dest.xFant := GetNodeStr(nodeDest, 'xFant');
  FCTe.dest.fone  := GetNodeStr(nodeDest, 'fone');
  FCTe.dest.ISUF  := GetNodeStr(nodeDest, 'ISUF');

  nodeEndereco := nodeDest.ChildNodes.FindNode('enderDest');
  loadTagEndereco(nodeEndereco, FCTe.dest.enderDest);
end;

procedure TGBFRCTeXMLDefault.loadTagEmit;
var
  nodeEmit: IXMLNode;
  nodeEndereco: IXMLNode;
begin
  nodeEmit := FInfCTe.ChildNodes.FindNode('emit');
  if not Assigned(nodeEmit) then
    Exit;

  FCTe.emit.CNPJ  := GetNodeStr(nodeEmit, 'CNPJ');
  FCTe.emit.IE    := GetNodeStr(nodeEmit, 'IE');
  FCTe.emit.IEST  := GetNodeStr(nodeEmit, 'IEST');
  FCTe.emit.xNome := GetNodeStr(nodeEmit, 'xNome');
  FCTe.emit.xFant := GetNodeStr(nodeEmit, 'xFant');

  nodeEndereco := nodeEmit.ChildNodes.FindNode('enderEmit');
  loadTagEndereco(nodeEndereco, FCTe.emit.enderEmit);
end;

procedure TGBFRCTeXMLDefault.loadTagEndereco(ANode: IXMLNode; AEndereco: TGBFRCTeModelEndereco);
begin
  if not Assigned(ANode) then
    Exit;

  AEndereco.xLgr    := GetNodeStr(ANode, 'xLgr');
  AEndereco.nro     := GetNodeStr(ANode, 'nro');
  AEndereco.xCpl    := GetNodeStr(ANode, 'xCpl');
  AEndereco.xBairro := GetNodeStr(ANode, 'xBairro');
  AEndereco.cMun    := GetNodeStr(ANode, 'cMun');
  AEndereco.xMun    := GetNodeStr(ANode, 'xMun');
  AEndereco.CEP     := GetNodeStr(ANode, 'CEP');
  AEndereco.UF      := GetNodeStr(ANode, 'UF');
  AEndereco.cPais   := GetNodeStr(ANode, 'cPais');
  AEndereco.xPais   := GetNodeStr(ANode, 'xPais');
  AEndereco.email   := GetNodeStr(ANode, 'email');
  AEndereco.fone    := GetNodeStr(ANode, 'fone');
end;

procedure TGBFRCTeXMLDefault.loadTagExped;
var
  nodeExped: IXMLNode;
  nodeEndereco: IXMLNode;
begin
  nodeExped := FInfCTe.ChildNodes.FindNode('exped');
  if not Assigned(nodeExped) then
    Exit;

  FCTe.exped.CNPJ  := GetNodeStr(nodeExped, 'CNPJ');
  FCTe.exped.IE    := GetNodeStr(nodeExped, 'IE');
  FCTe.exped.IEST  := GetNodeStr(nodeExped, 'IEST');
  FCTe.exped.xNome := GetNodeStr(nodeExped, 'xNome');
  FCTe.exped.xFant := GetNodeStr(nodeExped, 'xFant');
  FCTe.exped.fone  := GetNodeStr(nodeExped, 'fone');

  nodeEndereco := nodeExped.ChildNodes.FindNode('enderExped');
  loadTagEndereco(nodeEndereco, FCTe.exped.enderExped);
end;

procedure TGBFRCTeXMLDefault.loadTagIde;
var
  nodeIDE : IXMLNode;
begin
  try
    nodeIDE := FInfCTe.ChildNodes.FindNode('ide');

    if Assigned(nodeIDE) then
    begin
      FCTe.ide.tpAmb.fromInteger(GetNodeInt(nodeIDE, 'tpAmb', 2));
      FCTe.ide.tpImp.fromInteger(GetNodeInt(nodeIDE, 'tpImp', 1));
      FCTe.ide.tpEmis.fromInteger(GetNodeInt(nodeIDE, 'tpEmis', 1));
      FCTe.ide.tpCTe.fromInteger(GetNodeInt(nodeIDE, 'tpCTe', 0));
      FCTe.ide.procEmi.fromInteger(GetNodeInt(nodeIDE, 'procEmi', 0));
      FCTe.ide.modal.fromString(GetNodeStr(nodeIDE, 'modal', '00'));
      FCTe.ide.tpServ.fromInteger(GetNodeInt(nodeIDE, 'tpServ', 0));
      FCTe.ide.indIEToma.fromInteger(GetNodeInt(nodeIDE, 'indIEToma', 9));

      FCTe.ide.cUF            := GetNodeStr(nodeIDE, 'cUF');
      FCTe.ide.cCT            := GetNodeStr(nodeIDE, 'cCT');
      FCTe.ide.CFOP           := GetNodeStr(nodeIDE, 'CFOP');
      FCTe.ide.natOp          := GetNodeStr(nodeIDE, 'natOp');
      FCTe.ide.&mod           := GetNodeInt(nodeIDE, 'mod');
      FCTe.ide.serie          := GetNodeStr(nodeIDE, 'serie');
      FCTe.ide.nCT            := GetNodeInt(nodeIDE, 'nCT');
      FCTe.ide.dhEmi          := GetNodeDate(nodeIDE, 'dhEmi');
      FCTe.ide.cDV            := GetNodeStr(nodeIDE, 'cDV');
      FCTe.ide.verProc        := GetNodeStr(nodeIDE, 'verProc');
      FCTe.ide.indGlobalizado := GetNodeStr(nodeIDE, 'indGlobalizado');
      FCTe.ide.cMunEnv        := GetNodeStr(nodeIDE, 'cMunEnv');
      FCTe.ide.xMunEnv        := GetNodeStr(nodeIDE, 'xMunEnv');
      FCTe.ide.UFEnv          := GetNodeStr(nodeIDE, 'UFEnv');
      FCTe.ide.cMunIni        := GetNodeStr(nodeIDE, 'cMunIni');
      FCTe.ide.xMunIni        := GetNodeStr(nodeIDE, 'xMunIni');
      FCTe.ide.UFIni          := GetNodeStr(nodeIDE, 'UFIni');
      FCTe.ide.cMunFim        := GetNodeStr(nodeIDE, 'cMunFim');
      FCTe.ide.xMunFim        := GetNodeStr(nodeIDE, 'xMunFim');
      FCTe.ide.UFFim          := GetNodeStr(nodeIDE, 'UFFim');
      FCTe.ide.retira         := GetNodeBoolInt(nodeIDE, 'retira');
      FCTe.ide.xRetira        := GetNodeStr(nodeIDE, 'xRetira');

      loadTagIdeToma3(nodeIDE.ChildNodes.FindNode('toma3'));
    end;
  except
    on e : Exception do
    begin
      e.Message := 'Error on read Tag <ide>: ' + e.Message;
      raise;
    end;
  end;
end;

procedure TGBFRCTeXMLDefault.loadTagIdeToma3(ANode: IXMLNode);
begin
  if not Assigned(ANode) then
    Exit;

  FCTe.ide.toma3.toma.fromInteger(GetNodeInt(ANode, 'toma'));
end;

procedure TGBFRCTeXMLDefault.loadTagImp;
var
  nodeImp: IXMLNode;
  nodeICMS: IXMLNode;
begin
  nodeImp := FInfCTe.ChildNodes.FindNode('imp');
  if not Assigned(nodeImp) then
    Exit;

  FCTe.imp.vTotTrib   := GetNodeCurrency(nodeImp, 'vTotTrib');
  FCTe.imp.infAdFisco := GetNodeStr(nodeImp, 'infAdFisco');

  nodeICMS := nodeImp.ChildNodes.FindNode('ICMS');
  if not Assigned(nodeICMS) then
    Exit;

  nodeICMS := nodeICMS.ChildNodes.First;
  if not Assigned(nodeICMS) then
    Exit;

  FCTe.imp.ICMS.CST           := GetNodeStr(nodeICMS, 'CST');
  FCTe.imp.ICMS.vBC           := GetNodeCurrency(nodeICMS, 'vBC');
  FCTe.imp.ICMS.pICMS         := GetNodeCurrency(nodeICMS, 'pICMS');
  FCTe.imp.ICMS.vICMS         := GetNodeCurrency(nodeICMS, 'vICMS');
  FCTe.imp.ICMS.pRedBC        := GetNodeCurrency(nodeICMS, 'pRedBC');
  FCTe.imp.ICMS.vCred         := GetNodeCurrency(nodeICMS, 'vCred');
  FCTe.imp.ICMS.pRedBCOutraUF := GetNodeCurrency(nodeICMS, 'pRedBCOutraUF');
  FCTe.imp.ICMS.vBCOutraUF    := GetNodeCurrency(nodeICMS, 'vBCOutraUF');
  FCTe.imp.ICMS.pICMSOutraUF  := GetNodeCurrency(nodeICMS, 'pICMSOutraUF');
  FCTe.imp.ICMS.vICMSOutraUF  := GetNodeCurrency(nodeICMS, 'vICMSOutraUF');
  FCTe.imp.ICMS.indSN         := GetNodeStr(nodeICMS, 'indSN') = '1';
end;

procedure TGBFRCTeXMLDefault.loadTagInfCarga(ANodeInfCTeNorm: IXMLNode);
var
  nodeCarga: IXMLNode;
  nodeInfQ : IXMLNode;
begin
  if not Assigned(ANodeInfCTeNorm) then
    exit;

  nodeCarga := ANodeInfCTeNorm.ChildNodes.FindNode('infCarga');
  if not Assigned(nodeCarga) then
    exit;

  FCTe.infCTeNorm.infCarga.vCarga      := GetNodeCurrency(nodeCarga, 'vCarga');
  FCTe.infCTeNorm.infCarga.proPred     := GetNodeStr(nodeCarga, 'proPred');
  FCTe.infCTeNorm.infCarga.xOutCat     := GetNodeStr(nodeCarga, 'xOutCat');
  FCTe.infCTeNorm.infCarga.vCargaAverb := GetNodeCurrency(nodeCarga, 'vCargaAverb');

  nodeInfQ := nodeCarga.ChildNodes.FindNode('infQ');
  while nodeInfQ <> nil do
  begin
    if not GetNodeStr(nodeInfQ, 'tpMed').Trim.IsEmpty then
    begin
      FCTe.infCTeNorm.infCarga.AddInfoQuantidade;

      FCTe.infCTeNorm.infCarga.infQ.Last.tpMed  := GetNodeStr(nodeInfQ, 'tpMed');
      FCTe.infCTeNorm.infCarga.infQ.Last.qCarga := GetNodeCurrency(nodeInfQ, 'qCarga');

      FCTe.infCTeNorm.infCarga.infQ.Last.cUnid.fromString(GetNodeStr(nodeInfQ, 'cUnid'));
      nodeInfQ := nodeInfQ.NextSibling;
    end
    else
      nodeInfQ := nil;
  end;
end;

procedure TGBFRCTeXMLDefault.loadTagInfCte;
var
  node : IXMLNode;
begin
  repeat
    if node = nil then
      node := FXml.DocumentElement
    else
    begin
      if node.ChildNodes.Count = 0 then
      begin
        node := nil;
        break;
      end;
      node := node.ChildNodes.Get(0);
    end;
  until (node = nil) or (node.NodeName = 'infCte');

  if (not Assigned(node)) or (not node.NodeName.Equals( 'infCte' )) then
    raise Exception.CreateFmt('Error on read Tag infCte', []);

  FInfCTe     := node;
  FCTe.Id     := FInfCTe.Attributes['Id'];
  FCTe.versao := FInfCTe.Attributes['versao'];
end;

procedure TGBFRCTeXMLDefault.loadTagInfCTeNorm;
var
  nodeNorm: IXMLNode;
begin
  nodeNorm := FInfCTe.ChildNodes.FindNode('infCTeNorm');

  if not Assigned(nodeNorm) then
    Exit;

  loadTagInfCarga(nodeNorm);
  loadTagInfDoc(nodeNorm);
  loadTagInfModal(nodeNorm);
end;

procedure TGBFRCTeXMLDefault.loadTagInfCTeSupl;
var
  nodeCTeProc: IXMLNode;
  nodeCTe: IXMLNode;
  nodeInfSupl: IXMLNode;
begin
  nodeCTeProc := FXml.DocumentElement;
  if not Assigned(nodeCTeProc) then
    Exit;

  nodeCTe := nodeCTeProc.ChildNodes.FindNode('CTe');
  if not Assigned(nodeCTe) then
    Exit;

  nodeInfSupl := nodeCTe.ChildNodes.FindNode('infCTeSupl');
  if not Assigned(nodeInfSupl) then
    Exit;

  FCTe.infCTeSupl.qrCodCTe := GetNodeStr(nodeInfSupl, 'qrCodCTe');
end;

procedure TGBFRCTeXMLDefault.loadTagInfDoc(ANodeInfCTeNorm: IXMLNode);
var
  nodeInfDoc: IXMLNode;
  nodeInfNFe: IXMLNode;
begin
  if not Assigned(ANodeInfCTeNorm) then
    Exit;

  nodeInfDoc := ANodeInfCTeNorm.ChildNodes.FindNode('infDoc');
  if not Assigned(nodeInfDoc) then
    Exit;

  nodeInfNFe := nodeInfDoc.ChildNodes.FindNode('infNFe');
  while nodeInfNFe <> nil do
  begin
    FCTe.infCTeNorm.infDoc.infoNFe.Add(TGBFRCTeModelInfoNFe.Create);
    FCTe.infCTeNorm.infDoc.infoNFe.Last.chave := GetNodeStr(nodeInfNFe, 'chave');
    FCTe.infCTeNorm.infDoc.infoNFe.Last.PIN   := GetNodeStr(nodeInfNFe, 'PIN');
    FCTe.infCTeNorm.infDoc.infoNFe.Last.dPrev := GetNodeDate(nodeInfNFe, 'dPrev');
    nodeInfNFe := nodeInfNFe.NextSibling;
  end;
end;

procedure TGBFRCTeXMLDefault.loadTagInfModal(ANodeInfCTeNorm: IXMLNode);
var
  nodeModal: IXMLNode;
  nodeRodo : IXMLNode;
begin
  if not Assigned(ANodeInfCTeNorm) then
    Exit;

  nodeModal := ANodeInfCTeNorm.ChildNodes.FindNode('infModal');
  if not Assigned(nodeModal) then
    Exit;

  FCTe.infCTeNorm.infModal.versaoModal := nodeModal.Attributes['versaoModal'];

  nodeRodo := nodeModal.ChildNodes.FindNode('rodo');
  if not Assigned(nodeRodo) then
    Exit;

  FCTe.infCTeNorm.infModal.rodo.RNTRC := GetNodeStr(nodeRodo, 'RNTRC');
end;

procedure TGBFRCTeXMLDefault.loadTagInfProt;
var
  nodeCTeProc: IXMLNode;
  nodeProtCTe: IXMLNode;
  nodeInfProt: IXMLNode;
begin
  nodeCTeProc := FXml.DocumentElement;
  if not Assigned(nodeCTeProc) then
    Exit;

  nodeProtCTe := nodeCTeProc.ChildNodes.FindNode('protCTe');
  if not Assigned(nodeProtCTe) then
    Exit;

  nodeInfProt := nodeProtCTe.ChildNodes.FindNode('infProt');
  if not Assigned(nodeInfProt) then
    Exit;

  FCTe.infProt.tpAmb.fromInteger(GetNodeInt(nodeInfProt, 'tpAmb'));
  FCTe.infProt.verAplic := GetNodeStr(nodeInfProt, 'verAplic');
  FCTe.infProt.chCTe    := GetNodeStr(nodeInfProt, 'chCTe');
  FCTe.infProt.dhRecbto := GetNodeDate(nodeInfProt, 'dhRecbto');
  FCTe.infProt.nProt    := GetNodeStr(nodeInfProt, 'nProt');
  FCTe.infProt.digVal   := GetNodeStr(nodeInfProt, 'digVal');
  FCTe.infProt.cStat    := GetNodeInt(nodeInfProt, 'cStat');
  FCTe.infProt.xMotivo  := GetNodeStr(nodeInfProt, 'xMotivo');
end;

procedure TGBFRCTeXMLDefault.loadTagRem;
var
  nodeRem: IXMLNode;
  nodeEndereco: IXMLNode;
begin
  nodeRem := FInfCTe.ChildNodes.FindNode('rem');
  if not Assigned(nodeRem) then
    Exit;

  FCTe.rem.CNPJ  := GetNodeStr(nodeRem, 'CNPJ');
  FCTe.rem.IE    := GetNodeStr(nodeRem, 'IE');
  FCTe.rem.IEST  := GetNodeStr(nodeRem, 'IEST');
  FCTe.rem.xNome := GetNodeStr(nodeRem, 'xNome');
  FCTe.rem.xFant := GetNodeStr(nodeRem, 'xFant');
  FCTe.rem.fone  := GetNodeStr(nodeRem, 'fone');

  nodeEndereco := nodeRem.ChildNodes.FindNode('enderReme');
  loadTagEndereco(nodeEndereco, FCTe.rem.enderReme);
end;

procedure TGBFRCTeXMLDefault.loadTagVPrest;
var
  nodeVPrest : IXMLNode;
  nodeComp   : IXMLNode;
  name       : string;
  value      : Currency;
begin
  nodeVPrest := FInfCTe.ChildNodes.FindNode('vPrest');
  if not Assigned(nodeVPrest) then
    Exit;

  FCTe.vPrest.vTPrest := GetNodeCurrency(nodeVPrest, 'vTPrest');
  FCTe.vPrest.vRec    := GetNodeCurrency(nodeVPrest, 'vRec');

  nodeComp := nodeVPrest.ChildNodes.FindNode('Comp');
  if not Assigned(nodeComp) then
    Exit;

  repeat
    name := GetNodeStr(nodeComp, 'xNome');
    value:= GetNodeCurrency(nodeComp, 'vComp');

    FCTe.vPrest.AddComponente(name, value);

    nodeComp := nodeComp.NextSibling;
  until nodeComp = nil;
end;

class function TGBFRCTeXMLDefault.New: IGBFRCTeXML;
begin
  result := Self.create;
end;

end.
