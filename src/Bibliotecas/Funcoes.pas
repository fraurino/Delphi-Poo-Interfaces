{
Mascaras para edit
uses
 System.MaskUtils;
  // Aplicando m�scara do CPF
  ShowMessage(FormatMaskText('000\.000\.000\-00;0;', '51895752337'));
  // Aplicando m�scara do CNPJ
  ShowMessage(FormatMaskText('00\.000\.000\/0000\-00;0;', '44732264000105'));
  // Aplicando m�scara do CEP
  ShowMessage(FormatMaskText('00000\-000;0;', '99200000'));
  // Aplicando m�scara dE TELEFONE
  ShowMessage(FormatMaskText('\(00\)000000009;0;', '11978563215'));
  ShowMessage(FormatMaskText('\(00\)000000009;0;', '5434491111'));
}
unit Funcoes;
interface
uses
 System.Generics.Collections,
 Vcl.Graphics,
 System.SysUtils,
 IdTCPClient,
 System.MaskUtils,
 System.StrUtils,
 Vcl.Forms,
 Winapi.Windows,
 System.Classes,
 Data.SqlExpr,
 FireDAC.Comp.Client,
 Datasnap.DBClient,
 System.RegularExpressions,
 IdHashMessageDigest,
 Vcl.ComCtrls,
 Winapi.Messages,
 math,
 TlHelp32,
 Winapi.PsAPI,
 Vcl.StdCtrls,
 Winapi.UrlMon,
 IdHTTP,
 Winapi.ShellAPI,
 IdCoder,
 IdCoder3to4,
 IdCoderMIME,
 jpeg,
 IdGlobalProtocols;
 Var
  GvarCaption : String;
function TestaInternet: boolean;
function TestaServidor: boolean;
Function TratarCaracter(texto : String) : String;
function FormataCNPJ(Numero: string): string;
function FormataCPF(Numero: string): string;
function ValidaCNPJ(numCNPJ: string): boolean;
function ValidaCPF(numCPF: string): boolean;
function Aviso(Mensagem: String): String;
function PerguntaSimNao(const ATitulo, ATexto: String; ANoDefault: boolean = false): boolean;
procedure MostraAviso(ATexto: String);
procedure MostraErro(ATexto: String);
function IsValidCelular(aCelNumber: string): boolean;
function GetStrNumber(const S: string): string;
function GetNewID(Prefix: String): string;
function AsciiToInt(Caracter: Char): Integer;
Function Criptografa(texto:string;chave:integer):String;
Function DesCriptografa(texto:string;chave:integer):String;
Function TratarCaracterSomente(texto : String) : String;
function MD5String(const Value: string): string;
function GerarTimer(Data: TDateTime):  String;
function StreamToString(aStream: TStream): string;
function RECharIndexByPos(RichEdit: TRichEdit; X, Y: Integer): Integer;
function TBRound(Value: Extended; Decimals: integer): Extended;
function Arredondar(Valor: Double; Dec: Integer): Double;
function ProcessExists(exeFileName: string): Boolean;
function FindProcesses (aKey : String; aList : TList = nil) : Integer;
function KillProcess (aProcessId : Cardinal) : boolean;
function ValidarCampos(Aform : Tform; ATrue : Boolean = false) : boolean;
procedure PreencheComboBox(ACombo: TCustomCombo; AQuery: Tfdquery; AIndex : integer);
function ConvertData(Data: TDate): String;
function FormatarHoras(time: double; havDay: boolean): string;
procedure FindReplace(const Enc, subs: String; var Texto: TRichEdit);
function MinSec(Min: String): Integer;
procedure TabEnter(Key :Char);
function SegundosMinutos(Minutos : Extended) :  Extended;
{Metedos para downloads de arquivos}
function idUnique(id: string): string;
function download(clientUrl, mediaKey, tipo, id: string) :string;
function DownLoadInternetFile(Source, Dest: string): Boolean;
procedure DownloadFile(Source, Dest: string);
function shell(program_path:  string):  string;
function base64encode(const Text : ansiString): ansiString;
function base64Decode(const Text : ansiString): ansiString;
function GetMIMEType(FileExt: string): string;
function GetFile(const AFile: String): TStream;
implementation
uses
  Vcl.Controls, Vcl.Dialogs;
function FormataCPF(Numero: string): string;
var
  tmp, resultado: string;
  indx: Integer;
begin
  if Length(Numero) < 10 then
  begin
    Result := '';
    Exit;
  end;
  for indx := 1 to Length(Numero) do
  begin
    if Numero[indx] in ['0' .. '9'] then
      resultado := resultado + Numero[indx];
  end;
  if Length(resultado) < 11 then
    resultado := StringOfChar('0', 11 - Length(resultado)) + resultado;
  tmp := copy(resultado, 1, 3) + '.';
  tmp := tmp + copy(resultado, 4, 3) + '.';
  tmp := tmp + copy(resultado, 7, 3) + '-';
  tmp := tmp + copy(resultado, 10, 2);
  Result := tmp;
end;
function GetFile(const AFile: String): TStream;
var
  Path: String;
begin
  Path := ExtractFilePath('C:\NexxusWAPP\temp\');
  Result := TFileStream.Create(Path + AFile, fmOpenRead or fmShareDenyNone);
  Result.Position := 0;
end;
function GetMIMEType(FileExt: string): string;
var
  I: Integer;
  S: array[0..255] of Char;
const
  MIMEStart = 101;
  // ID of first MIME Type string (IDs are set in the .rc file
  // before compiling with brcc32)
  MIMEEnd = 742; //ID of last MIME Type string
begin
  Result := 'text/plain';
  // If the file extenstion is not found then the result is plain text
  for I := MIMEStart to MIMEEnd do
  begin
    LoadString(hInstance, I, @S, 255);
    // Loads a string from mimetypes.res which is embedded into the
    // compiled exe
    if Copy(S, 1, Length(FileExt)) = FileExt then
    // "If the string that was loaded contains FileExt then"
    begin
      Result := Copy(S, Length(FileExt) + 2, 255);
      // Copies the MIME Type from the string that was loaded
      Break;
      // Breaks the for loop so that it won't go through every
      // MIME Type after it found the correct one.
    end;
  end;
end;
function base64encode(const Text : ansiString): ansiString;
var
  Encoder : TIdEncoderMime;
begin
  Encoder := TIdEncoderMime.Create(nil);
  try
    Result := Encoder.EncodeString(Text);
  finally
    FreeAndNil(Encoder);
  end
end;
function base64Decode(const Text : ansiString): ansiString;
var
  Decoder : TIdDecoderMime;
begin
  Decoder := TIdDecoderMime.Create(nil);
  try
    Result := Decoder.DecodeString(Text);
  finally
    FreeAndNil(Decoder)
  end
end;
function shell(program_path:  string):  string;
var
  s1: string;
begin
  s1 := ExtractFilePath(Application.ExeName)+'decryptFile.dll ';
  ShellExecute(0, nil, 'cmd.exe', PChar('/c '+ s1 + program_path ), PChar(s1 + program_path), SW_HIDE);
end;
procedure DownloadFile(Source, Dest: string);
var
  IdHTTP1 : TIdHTTP;
  Stream  : TMemoryStream;
  Url, FileName: String;
begin
  IdHTTP1 := TIdHTTP.Create(nil);
  Stream  := TMemoryStream.Create;
  try
    IdHTTP1.Get(Source, Stream);
    Stream.SaveToFile(Dest);
  finally
    Stream.Free;
    IdHTTP1.Free;
  end;
end;
function DownLoadInternetFile(Source, Dest: string): Boolean;
var ret:integer;
begin
  try
    ret:=URLDownloadToFile(nil, PChar(Source), PChar(Dest), 0, nil);
    if ret <> 0 then
    begin
      DownloadFile(Source, Dest) ;
      if FileExists(dest) then
        ret :=  0;
    end;
    Result := ret = 0
  except
    Result := False;
  end;
end;
function idUnique(id: string): string;
var
  gID: TGuid;
begin
  CreateGUID(gID);
  result := copy(gID.ToString, 2, length(gID.ToString)  - 2);
end;
function download(clientUrl, mediaKey, tipo, id: string) :string;
var
  form, imagem, diretorio, arq:string;
begin
  Result    :=  '';
  diretorio := ExtractFilePath(ParamStr(0)) + 'temp\';
  Sleep(1);
  if not DirectoryExists(diretorio) then
    CreateDir(diretorio);
  arq     :=  idUnique(id);
  imagem  :=  diretorio + arq;
  Sleep(1);
  if DownLoadInternetFile(clientUrl, imagem + '.enc') then
    if FileExists(imagem  + '.enc') then
    begin
      form  :=  format('--in %s.enc --out %s.%s --key %s',  [imagem,  imagem, tipo, mediakey]);
      shell(form);
      Sleep(10);
      Result:= imagem + '.' + tipo;
    end;
end;
function SegundosMinutos(Minutos : Extended) :  Extended;
 var
  Seg : Extended;
  DivSao : Extended;
  Mult : Extended;
  Total : Extended;
begin
  Seg := Minutos;
  DivSao := Seg / 60;
  Mult := (DivSao*3600);
  Total := (Mult*1000);
  result :=  Total;
end;
procedure TabEnter(Key :Char);
begin
  If Key = #13 then //Se o comando for igual a enter
  Begin
    Key := #0;
    Screen.ActiveForm.Perform(WM_NextDlgCtl, 0, 0);
  End;
end;
function MinSec(Min: String): Integer;
begin
  Result := (StrToInt(Copy(Min,1,2))*60) + StrToInt(Copy(Min,4,2));
end;
function FormatarHoras(time: double; havDay: boolean): string;
var
  dias, Horas: double;
  Pos1, horas24: Integer;
  aux1, varDias: string;
begin
  dias := Trunc(time);
  Horas := frac(time);
  if havDay then
    if dias > 1 then
    begin
      Result := floattostr(dias) + ' dias ' + TimeToStr(Horas)
    end
    else
    begin
      if dias = 0 then
      begin
        Result := TimeToStr(Horas)
      end
      else
      begin
        Result := floattostr(dias) + ' dia ' + TimeToStr(Horas)
      end;
    end
  else
  begin
    aux1 := TimeToStr(Horas);
    Pos1 := Pos(':', aux1);
    horas24 := strtoint(copy(aux1, 1, Pos1 - 1)) + (Trunc(dias) * 24);
    Result := IntToStr(horas24) + copy(aux1, Pos1, Length(aux1));
  end;
end;
function ConvertData(Data: TDate): String;
begin
   Result := QuotedStr(FormatDateTime('yyyy-mm-dd', Data));
end;
function FormataCNPJ(Numero: string): string;
var
  tmp, resultado: string;
  indx: Integer;
begin
  if Length(Numero) < 12 then
  begin
    Result := '';
    Exit;
  end;
  for indx := 1 to Length(Numero) do
  begin
    if Numero[indx] in ['0' .. '9'] then
      resultado := resultado + Numero[indx];
  end;
  if Length(resultado) < 14 then
    resultado := StringOfChar('0', 14 - Length(resultado)) + resultado;
  tmp := copy(resultado, 1, 2) + '.';
  tmp := tmp + copy(resultado, 3, 3) + '.';
  tmp := tmp + copy(resultado, 6, 3) + '/';
  tmp := tmp + copy(resultado, 9, 4) + '-' + copy(resultado, 13, 2);
  Result := tmp;
end;
procedure PreencheComboBox(ACombo: TCustomCombo; AQuery: Tfdquery; AIndex : integer);
begin
  ACombo.Items.Clear;
  AQuery.First;
  while not AQuery.EOF do
  begin
    ACombo.Items.Add(AQuery.Fields[1].AsString);
    AQuery.Next;
  end;
  ACombo.ItemIndex := Aindex;
end;
function ValidarCampos(Aform : Tform; ATrue : Boolean = false) : boolean;
 var
   i : Integer;
   x : integer;
   Resposta: Boolean;
   ComponenteEdit: TCustomEdit;
   ComponenteCombo: TCustomComboBox;
begin
  Resposta := False;
  for i := 0 to Aform.ComponentCount -1 do
  begin
    if Aform.Components[i] is TCustomEdit then
    begin
      ComponenteEdit := Aform.Components[i] as TCustomEdit;
      if ComponenteEdit.Tag = 99 then {Colocar 99 na tag do campo que gostaria de validar}
      begin
        if (ComponenteEdit.Text = '') then
        begin
          Resposta    := True;
          GvarCaption := ComponenteEdit.Hint;
          if ATrue = false then
            ComponenteEdit.SetFocus;
          break;
        end;
      end;
    end;
  end;
   for x := 0 to Aform.ComponentCount -1 do
  begin
    if Aform.Components[x] is TCustomComboBox then
    begin
      ComponenteCombo := Aform.Components[x] as TCustomComboBox;
      if ComponenteCombo.Tag = 99 then {Colocar 99 na tag do campo que gostaria de validar}
      begin
        if (ComponenteCombo.ItemIndex = 0) then
        begin
          Resposta    := True;
          GvarCaption := ComponenteCombo.Hint;
          if ATrue = false then
          begin
            ComponenteCombo.SetFocus;
          end;
          break;
        end;
      end;
    end;
  end;
  Result := Resposta;
end;
procedure MostraAviso(ATexto: String);
begin
  Application.MessageBox(PChar(ATexto), PChar('Aviso'), MB_Ok + MB_ICONWARNING);
end;
procedure MostraErro(ATexto: String);
begin
  Application.MessageBox(PChar(ATexto), PChar('Aviso'), MB_Ok + MB_ICONERROR)
end;
function PerguntaSimNao(const ATitulo, ATexto: String; ANoDefault: boolean = false): boolean;
begin
  if ANoDefault then
    Result := Application.MessageBox(PChar(ATexto), PChar(ATitulo), MB_YesNo + MB_ICONQUESTION + MB_DEFBUTTON2) = idYes
  else
    Result := Application.MessageBox(PChar(ATexto), PChar(ATitulo), MB_YesNo + MB_ICONQUESTION) = idYes;
end;
function FindProcesses (aKey : String; aList : TList = nil) : Integer;
var
 szProcessName : Array [0..1024] of Char;
 ProcessName   : String;
 hProcess      : Integer;
 aProcesses    : Array [0..1024] of DWORD;
 cProcesses    : DWORD;
 cbNeeded      : Cardinal;
 i             : UINT;
 hMod          : HMODULE;
begin
 Result:= 0;
 aKey:= lowercase(akey);
 if not (EnumProcesses(@aProcesses, sizeof(aProcesses), cbNeeded)) then
    exit;
 // Calculate how many process identifiers were returned.
 cProcesses := cbNeeded div sizeof(DWORD);
 // Print the name and process identifier for each process.
 for i:= 0 to cProcesses - 1 do
 begin
   szProcessName := 'unknown';
   hProcess := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ,
                           FALSE, aProcesses[i]);
   // Get the process name.
   if (hProcess <> 0) then
      if (EnumProcessModules(hProcess, @hMod, sizeof(hMod),cbNeeded)) then
         GetModuleBaseName (hProcess, hMod, szProcessName, sizeof(szProcessName));
   ProcessName:= lowercase (szProcessName);
   CloseHandle(hProcess);
   if pos (aKey, ProcessName) <> 0 then
   begin
     result:=aProcesses[i];
     if aList <> nil then
        aList.add(Pointer (aProcesses[i]))
     else
       exit;
   end;
 end;
 if aList <> nil then
    Result:= aList.count
 else
    Result:=0;
end;
function KillProcess (aProcessId : Cardinal) : boolean;
var
  hProcess : integer;
begin
  hProcess:= OpenProcess(PROCESS_ALL_ACCESS, TRUE, aProcessId);
  Result:= false;
  if (hProcess <>0 ) then
  begin
    Result:= TerminateProcess(hProcess, 0);
    exit;
  end;
end;
function ProcessExists(exeFileName: string): Boolean;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
    begin
      Result := True;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;
function Arredondar(Valor: Double; Dec: Integer): Double;
var
  Valor1,
  Numero1,
  Numero2,
  Numero3: Double;
begin
  Valor1:=Exp(Ln(10) * (Dec + 1));
  Numero1:=Int(Valor * Valor1);
  Numero2:=(Numero1 / 10);
  Numero3:=Round(Numero2);
  Result:=(Numero3 / (Exp(Ln(10) * Dec)));
end;
function TBRound(Value: Extended; Decimals: integer): Extended;
var
  Factor, Fraction: Extended;
begin
  Factor := IntPower(10, Decimals);
  { A convers�o para string e depois para float evita
    erros de arredondamentos indesej�veis. }
  Value := StrToFloat(FloatToStr(Value * Factor));
  Result := Int(Value);
  Fraction := Frac(Value);
  if Fraction >= 0.5 then
    Result := Result + 1
  else if Fraction <= -0.5 then
    Result := Result - 1;
  Result := Result / Factor;
end;
procedure FindReplace(const Enc, subs: String; var Texto: TRichEdit);
Var
   i, Posicao: Integer;
   Linha: string;
Begin
  For i:= 0 to Texto.Lines.count - 1 do
  begin
      Linha := Texto. Lines[i];
      Repeat
        Posicao:=Pos(Enc,Linha);
        If Posicao > 0 then
        Begin
          Delete(Linha,Posicao,Length(Enc));
          Insert(Subs,Linha,Posicao);
          Texto.Lines[i]:=Linha;
        end;
      until Posicao = 0;
  end;
end;
function RECharIndexByPos(RichEdit: TRichEdit; X, Y: Integer): Integer;
var
  P: TPoint;
begin
  P := Point(X, Y);
  Result := SendMessage(RichEdit.Handle, EM_CHARFROMPOS, 0, Longint(@P));
end;
function StreamToString(aStream: TStream): string;
var
  SS: TStringStream;
begin
  if aStream <> nil then
  begin
    SS := TStringStream.Create('');
    try
      SS.CopyFrom(aStream, 0);  // No need to position at 0 nor provide size
      Result := SS.DataString;
    finally
      SS.Free;
    end;
  end else
  begin
    Result := '';
  end;
end;
function TestaServidor: boolean;
 var
  IdTCPClient: TIdTCPClient;
begin
  try
    IdTCPClient := TIdTCPClient.Create(Nil);
    IdTCPClient.ReadTimeout := 1;
    IdTCPClient.Host := '45.179.88.110';
    IdTCPClient.Port := 3306;
     try
      IdTCPClient.Connect;
     finally
      Result := True;
      IdTCPClient.DisposeOf;
     end;
  except
   Result := False;
   Exit;
  end;
  IdTCPClient.Disconnect;
end;
function GerarTimer(Data: TDateTime):  String;
 var
  iData1, iData2:  String;
begin
 iData1 := TimeToStr(Data);
 iData2 := TimeToStr((StrToTime(iData1) - 0.0000115741));
 iData1 := iData2;
 Result := iData1;
end;
function MD5String(const Value: string): string;
var
    xMD5: TIdHashMessageDigest5;
begin
    xMD5 := TIdHashMessageDigest5.Create;
    try
      Result := xMD5.HashStringAsHex(Value);
    finally
      xMD5.Free;
    end;
end;
{ Esta funcao � semelhante a funcao de
Criptografia mais com o objetivo de descriptografar a string }
Function DesCriptografa(texto:string;chave:integer):String;
var
  cont:integer;
  retorno:string;
begin
  if (trim(texto)=EmptyStr) or (chave=0) then begin
    result:=texto;
  end else begin
    retorno:='';
    for cont:=1 to length(texto) do begin
      retorno:=retorno+chr(asciitoint(texto[cont])-chave);
    end;
    result:=retorno;
  end;
end;
{ Esta funcao tem como objetivo criptografar uma string utilizando o
c�digo ASCII de cada caracter e somando a esse c�digo o valor da CHAVE}
Function Criptografa(texto:string;chave:integer):String;
var
  cont:integer;
  retorno:string;
begin
  if (trim(texto)=EmptyStr) or (chave=0) then begin
    result:=texto;
  end else begin
    retorno:='';
    for cont:=1 to length(texto) do begin
      retorno:=retorno+chr(asciitoint(texto[cont])+chave);
    end;
    result:=retorno;
  end;
end;
  //funcao que retorno o c�digo ASCII dos caracteres
function AsciiToInt(Caracter: Char): Integer;
var
  i: Integer;
begin
  i := 32;
  while i < 255 do begin
    if Chr(i) = Caracter then
      Break;
    i := i + 1;
  end;
  Result := i;
end;
function GetNewID(Prefix: String): string;
var
  reg: array [1 .. 7] of word;
  i: integer;
begin
  { EDIT: Vou por mais estas linhas abaixo, para que o prefixo nunca
  tenha mais de 2 caracteres, e assim fique fixo o tamanho 16 bytes  }
  if length(Prefix) > 2 then
    Prefix := Copy(Prefix, 1, 2)
  else
    while length(Prefix) < 2 do
      Prefix := ' ' + Prefix;
  Result := '';
  DecodeDate(Date, reg[1], reg[2], reg[3]);
  reg[1] := StrToInt(Copy(IntToStr(reg[1]), 3, 2));
  { Esta corrige o ano para apenas dois digitos, por forma a ser inferior a
  255. em vez de reg[1] estava a variavel ano. }
  DecodeTime(Time, reg[4], reg[5], reg[6], reg[7]);
  reg[7] := reg[7] div 4; // esta corrige os milisegundos
  randomize;
  for i := 1 to 7 do
  begin
    if (i >= 2) and (i <= 6) then
      reg[i] := reg[i] + random(100);
    { O random � uma seguran�a adicional, pois como o ano e os milisegundos n�o
    s�o usados na totalidade, havia uma pequena possibilidade de sair
    duplicado... Assim � quase impossivel }
    Result := Result + IntToHex(reg[i], 2);
  end;
  Result := Prefix + Result;
end;
function GetStrNumber(const S: string): string;
var
  vText : PChar;
begin
  vText := PChar(S);
  Result := '';
  while (vText^ <> #0) do
  begin
    {$IFDEF UNICODE}
    if CharInSet(vText^, ['0'..'9']) then
    {$ELSE}
    if vText^ in ['0'..'9'] then
    {$ENDIF}
      Result := Result + vText^;
    Inc(vText);
  end;
end;
function IsValidCelular(aCelNumber: string): boolean;
var
  ipRegExp, vFone: string;
begin
  Result := False;
  { Recuperando somente os numeros }
  vFone := GetStrNumber(aCelNumber);
  try
    ipRegExp := '^[1-9]{2}(?:[6-9]|9[1-9])[0-9]{3}[0-9]{4}$';
    if TRegEx.IsMatch(vFone, ipRegExp) then
      Result := True;
  except
    on E: Exception do
      ShowMessage(E.ClassName + ' : ' + E.Message);
  end;
end;
{ mensagem utilizado "Application.MessageBox" }
function Aviso(Mensagem: String): String;
begin
  Application.MessageBox(PChar(Mensagem), 'Nexxus ERP', mb_ok + MB_ICONINFORMATION);
end;
function ValidaCNPJ(numCNPJ: string): boolean;
var
  cnpj: string;
  dg1, dg2: integer;
  x, total: integer;
  ret: boolean;
begin
ret:=False;
cnpj:='';
//Analisa os formatos
if Length(numCNPJ) = 18 then
	if (Copy(numCNPJ,3,1) + Copy(numCNPJ,7,1) + Copy(numCNPJ,11,1) + Copy(numCNPJ,16,1) = '../-') then
		begin
		cnpj:=Copy(numCNPJ,1,2) + Copy(numCNPJ,4,3) + Copy(numCNPJ,8,3) + Copy(numCNPJ,12,4) + Copy(numCNPJ,17,2);
		ret:=True;
		end;
if Length(numCNPJ) = 14 then
	begin
	cnpj:=numCNPJ;
	ret:=True;
	end;
//Verifica
if ret then
	begin
	try
		//1� digito
		total:=0;
		for x:=1 to 12 do
			begin
			if x < 5 then
				Inc(total, StrToInt(Copy(cnpj, x, 1)) * (6 - x))
			else
				Inc(total, StrToInt(Copy(cnpj, x, 1)) * (14 - x));
			end;
		dg1:=11 - (total mod 11);
		if dg1 > 9 then
			dg1:=0;
		//2� digito
		total:=0;
		for x:=1 to 13 do
			begin
			if x < 6 then
				Inc(total, StrToInt(Copy(cnpj, x, 1)) * (7 - x))
			else
				Inc(total, StrToInt(Copy(cnpj, x, 1)) * (15 - x));
			end;
		dg2:=11 - (total mod 11);
		if dg2 > 9 then
			dg2:=0;
		//Valida��o final
		if (dg1 = StrToInt(Copy(cnpj, 13, 1))) and (dg2 = StrToInt(Copy(cnpj, 14, 1))) then
			ret:=True
		else
			ret:=False;
	except
		ret:=False;
		end;
	//Inv�lidos
	case AnsiIndexStr(cnpj,['00000000000000','11111111111111','22222222222222','33333333333333','44444444444444',
						   '55555555555555','66666666666666','77777777777777','88888888888888','99999999999999']) of
		0..9:   ret:=False;
		end;
	end;
ValidaCNPJ:=ret;
end;
function ValidaCPF(numCPF: string): boolean;
var
	cpf: string;
	x, total, dg1, dg2: Integer;
	ret: boolean;
begin
ret:=True;
for x := 1 to Length(numCPF) do
	if not (numCPF[x] in ['0'..'9', '-', '.', ' ']) then
		ret:=False;
if ret then
	begin
	ret:=True;
	cpf:='';
	for x:=1 to Length(numCPF) do
		if numCPF[x] in ['0'..'9'] then
			cpf:=cpf + numCPF[x];
	if Length(cpf) <> 11 then
		ret:=False;
	if ret then
		begin
		//1� d�gito
		total:=0;
		for x:=1 to 9 do
			total:=total + (StrToInt(cpf[x]) * x);
		dg1:=total mod 11;
		if dg1 = 10 then
			dg1:=0;
		//2� d�gito
		total:=0;
		for x:=1 to 8 do
			total:=total + (StrToInt(cpf[x + 1]) * (x));
		total:=total + (dg1 * 9);
		dg2:=total mod 11;
		if dg2 = 10 then
			dg2:=0;
		//Valida��o final
		if dg1 = StrToInt(cpf[10]) then
			if dg2 = StrToInt(cpf[11]) then
				ret:=True;
		//Inv�lidos
		case AnsiIndexStr(cpf,['00000000000','11111111111','22222222222','33333333333','44444444444',
							   '55555555555','66666666666','77777777777','88888888888','99999999999']) of
			0..9:   ret:=False;
			end;
		end
	else
		begin
		//Se n�o informado deixa passar
		if cpf = '' then
			ret:=True;
		end;
	end;
ValidaCPF:=ret;
end;
function TestaInternet: boolean;
 var
  IdTCPClient: TIdTCPClient;
begin
  try
    IdTCPClient := TIdTCPClient.Create(Nil);
    IdTCPClient.ReadTimeout := 10;
    IdTCPClient.Host := 'www.google.com';
    IdTCPClient.Port := 80;
     try
      IdTCPClient.Connect;
     finally
      Result := True;
      IdTCPClient.DisposeOf;
     end;
  except
   Result := False;
   Exit;
  end;
  IdTCPClient.Disconnect;
end;
Function TratarCaracter(texto : String) : String;
Begin
  While pos('-', Texto) <> 0 Do
    delete(Texto,pos('-', Texto),1);
  While pos('.', Texto) <> 0 Do
    delete(Texto,pos('.', Texto),1);
  While pos('/', Texto) <> 0 Do
    delete(Texto,pos('/', Texto),1);
  While pos(',', Texto) <> 0 Do
    delete(Texto,pos(',', Texto),1);
  While pos(' ', Texto) <> 0 Do
    delete(Texto,pos(' ', Texto),1);
  While pos('0', Texto) <> 0 Do
    delete(Texto,pos('0', Texto),1);
  While pos('1', Texto) <> 0 Do
    delete(Texto,pos('1', Texto),1);
  While pos('2', Texto) <> 0 Do
    delete(Texto,pos('2', Texto),1);
  While pos('3', Texto) <> 0 Do
    delete(Texto,pos('3', Texto),1);
  While pos('4', Texto) <> 0 Do
    delete(Texto,pos('4', Texto),1);
  While pos('5', Texto) <> 0 Do
    delete(Texto,pos('5', Texto),1);
  While pos('6', Texto) <> 0 Do
    delete(Texto,pos('6', Texto),1);
  While pos('7', Texto) <> 0 Do
    delete(Texto,pos('7', Texto),1);
  While pos('8', Texto) <> 0 Do
    delete(Texto,pos('8', Texto),1);
  While pos('9', Texto) <> 0 Do
    delete(Texto,pos('9', Texto),1);
    Result := Texto;
End;
Function TratarCaracterSomente(texto : String) : String;
Begin
  While pos('-', Texto) <> 0 Do
    delete(Texto,pos('-', Texto),1);
  While pos('.', Texto) <> 0 Do
    delete(Texto,pos('.', Texto),1);
  While pos('/', Texto) <> 0 Do
    delete(Texto,pos('/', Texto),1);
  While pos(',', Texto) <> 0 Do
    delete(Texto,pos(',', Texto),1);
  While pos(' ', Texto) <> 0 Do
   delete(Texto,pos(' ', Texto),1);
  While pos('(', Texto) <> 0 Do
   delete(Texto,pos('(', Texto),1);
  While pos(')', Texto) <> 0 Do
   delete(Texto,pos(')', Texto),1);
   Result := Texto;
End;
end.
