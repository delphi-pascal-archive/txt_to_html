unit TTHUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Spin, ExtDlgs, ShellAPI, JPEG, ClipBRD,
  Grids, RichEdit;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    ColorDialog1: TColorDialog;
    ImageDialog1: TOpenPictureDialog;
    Memo1: TMemo;
    Memo2: TRichEdit;
    OpenDialog1: TOpenDialog;
    P: TPanel;
    GroupBox1: TGroupBox;
    SizeLB: TListBox;
    TypeLB: TListBox;
    GroupBox2: TGroupBox;
    Sample: TPanel;
    FontLB: TListBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    BoldItalic: TLabel;
    Label8: TLabel;
    LoadImgBtn: TButton;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    ClearImgBtn: TButton;
    GroupBox4: TGroupBox;
    Label4: TLabel;
    P1: TPanel;
    Label3: TLabel;
    WidthLabel: TLabel;
    Carrying1: TRadioButton;
    Carrying2: TRadioButton;
    WidthEdit: TSpinEdit;
    Alignleft: TRadioButton;
    Aligncenter: TRadioButton;
    Alignright: TRadioButton;
    GroupBox5: TGroupBox;
    f1: TLabel;
    Frame: TCheckBox;
    FrameEdit: TSpinEdit;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    SaveDialog1: TSaveDialog;
    SaveMemo: TMemo;
    S: TSplitter;
    TabSheet2: TTabSheet;
    GroupBox6: TGroupBox;
    B1: TBevel;
    B2: TBevel;
    TbGrid: TStringGrid;
    TbMemo: TMemo;
    Label5: TLabel;
    Label6: TLabel;
    TbCols: TSpinEdit;
    TbRows: TSpinEdit;
    Button1: TButton;
    GroupBox7: TGroupBox;
    Shape3: TShape;
    TbFrame: TCheckBox;
    Label7: TLabel;
    Button7: TButton;
    TbWidth: TSpinEdit;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    TbHeight: TSpinEdit;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Shape4: TShape;
    TbText: TMemo;
    Button8: TButton;
    P2: TPanel;
    B3: TBevel;
    Label15: TLabel;
    Shape5: TShape;
    cell: TLabel;
    Label18: TLabel;
    Label16: TLabel;
    TbAlign: TComboBox;
    TabSheet3: TTabSheet;
    P3: TPanel;
    Editor: TRichEdit;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Tags: TRichEdit;
    Col: TLabel;
    LChar: TLabel;
    Label17: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Carrying2Click(Sender: TObject);
    procedure Carrying1Click(Sender: TObject);
    procedure FontLBClick(Sender: TObject);
    procedure SizeLBClick(Sender: TObject);
    procedure TypeLBClick(Sender: TObject);
    procedure Shape1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure LoadImgBtnClick(Sender: TObject);
    procedure ClearImgBtnClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FrameClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure TbGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TbMemoChange(Sender: TObject);
    procedure Shape3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape4MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button7Click(Sender: TObject);
    procedure Shape5MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure EditorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditorKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditorSelectionChange(Sender: TObject);
    procedure Button11Click(Sender: TObject);

  private
    { Private declarations }
  CharPos:TPoint;
  LastTag, EndTag, MT, CT1:String;
  TbCol, TbRow, MT1, PLUS:Integer;
  Table, CellColor:TStrings;
  Changes, TG2, TG1, SPACE:Boolean;
  function GetFontTag(var Standart:Boolean; Audit:Boolean):String;
  function GetColor(Color:TColor):String;
  function GetTableTag:String;
  function GetText(SimpleText:String):String;
  function GetFrameOrAlign(FrOrAl:Boolean):String;
  procedure LoadWeb(TX:String);
  function GetTag(Tag:String):String;
  procedure InsertTag(Tag:String);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses AboutUnit;
const
 a='<html>'+#13+'<head>'+#13+'<title> Мой WEB документ </title>'+#13+'<Meta name="Author" content="Coder">'+#13+
 '<Meta name="Description" content="">'+#13'</head>';
 b='</body>'+#13+'</html>';// HTML шаблон
                                                           // типы тегов (не все)
 THTML:array[1..36] of ShortString=('a','font','div','pre','table','td','tr',
 'p','b','i','tt','u','s','small','big','sup','sub','map','script',
 'style','center','h','nobr','q','ul','ol','html','title','head','body','h1',
 'h2','h3','h4','h5','h6');

{$R *.dfm}
function TForm1.GetFontTag(var Standart: Boolean; Audit:Boolean): String;
var Tag,TagType:String;
begin
     Standart:=true;         LastTag:='';
     if (FontLB.Items[FontLB.ItemIndex]<>'Times New Roman')or
     (SizeLB.ItemIndex<>2)then begin Tag:='<font>'; Standart:=false; end;
     if (Alignleft.Checked=false)or(TypeLB.ItemIndex<>0)
     then Standart:=false;

 if FontLB.Items[FontLB.ItemIndex]<>'Times New Roman' then begin// имя шрифта
 Insert(' face="'+FontLB.Items[FontLB.ItemIndex]+'"',Tag,Length(Tag));
 LastTag:='</font>'; end;

      if SizeLB.ItemIndex<>2 then begin// размер шрифта
      Insert(' size="'+Copy(SizeLB.Items[SizeLB.ItemIndex],1,1)+'"',Tag,Length(Tag));
      LastTag:='</font>'; end;

 case TypeLB.ItemIndex of
 1:begin TagType:='<I>'; LastTag:=LastTag+'</I>'; end;
 2:begin TagType:='<B>'; LastTag:=LastTag+'</B>'; end;
 3:begin TagType:='<B><I>'; LastTag:=LastTag+'</I></B>'; end; end;

      if Alignleft.Checked=false then begin
      if Aligncenter.Checked=true then  TagType:='<div align="center">'+TagType;
      if Alignright.Checked=true then TagType:='<div align="right">'+TagType;
      LastTag:=LastTag+'</div>'; end;

 Tag:=TagType+Tag;// соединяем тег шрифта и выравнивания
 if Audit=false then EndTag:=LastTag+#13+EndTag; Result:=Tag;
end;

function TForm1.GetTableTag: String;
var Beg,En:String;
begin
 Beg:='<table width="'+WidthEdit.Text+'"><tr><td>';
 En:='</td></tr></table>';
 if (Frame.Checked=true) then
 Insert(' border="'+FrameEdit.Text+'"',Beg,7);

            if Aligncenter.Checked=true then begin
            Insert('<p align="center">',Beg,1);
            Insert('</p>',En,Length(En)+1); end;
 if Alignright.Checked=true then begin
 Insert('<p align="right">',Beg,1);
 Insert('</p>',En,Length(En)+1); end;

 Result:=Beg;
 EndTag:=En+#13+EndTag
end;

function TForm1.GetText(SimpleText: String): String;
var i,Ent:integer; sa:string;
begin
          sa:=SimpleText;
 for i:=1 to Length(SimpleText) do begin
          Ent:=Pos(Char(LongInt(13)),sa);
 if Ent=0 then break;
 Delete(sa,Ent,2);
 Insert('<br>',sa,Ent);
 end;     Result:=sa;
end;

function TForm1.GetColor(Color: TColor): String;
var R,G,B:String;
begin
 FmtStr(R, '%s%.8x', [HexDisplayPrefix,Color]);
 Delete(R,1,3);      B:=Copy(R,1,2);
 G:=Copy(R,3,2);     R:=Copy(R,5,2);
 Result:='#'+R+G+B;
end;

procedure TForm1.FormShow(Sender: TObject);
var i:integer;
begin
 FontLB.Items:=Screen.Fonts;
 for i:=0 to FontLB.Items.Count do begin
 if FontLB.Items[i]='Times New Roman' then begin
 FontLB.ItemIndex:=i; break; end;
 end;
 SizeLB.ItemIndex:=2;     TypeLB.ItemIndex:=0;
 WidthEdit.Text:='600';
 FrameEdit.Text:='2';
 TbCols.Text:='3';
 TbWidth.Text:='150';
 TbRows.Text:='4';         PLUS:=0;
 TbHeight.Text:='80';      TbAlign.ItemIndex:=1;
 LoadWeb(a+#13+#13+b);     TG1:=false;
end;

procedure TForm1.Carrying2Click(Sender: TObject);
begin
 if Carrying2.Checked=true then begin
 Memo1.ScrollBars:=ssVertical;
 WidthEdit.Enabled:=false; WidthLabel.Enabled:=false; end;
end;

procedure TForm1.Carrying1Click(Sender: TObject);
begin
 if Carrying1.Checked=true then begin
 Memo1.ScrollBars:=ssBoth;
 WidthEdit.Enabled:=true; WidthLabel.Enabled:=true; end;
end;

procedure TForm1.FontLBClick(Sender: TObject);
begin
 Sample.Font.Name:=FontLB.Items[FontLB.ItemIndex];
end;

procedure TForm1.SizeLBClick(Sender: TObject);
begin
 if SizeLB.ItemIndex=0 then Sample.Font.Size:=8
 else Sample.Font.Size:=StrToInt(Copy(SizeLB.Items[
 SizeLB.ItemIndex],3,2));
end;

procedure TForm1.TypeLBClick(Sender: TObject);
begin
 case TypeLB.ItemIndex of
    0:Sample.Font.Style:=TypeLB.Font.Style;
    1:Sample.Font.Style:=[fsItalic];
    2:Sample.Font.Style:=[fsBold];
    3:Sample.Font.Style:=BoldItalic.Font.Style;
 end;
end;

procedure TForm1.Shape1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if ColorDialog1.Execute=false then exit;
 Shape1.Brush.Color:=ColorDialog1.Color;
 Sample.Font.Color:=ColorDialog1.Color;
end;

procedure TForm1.Shape2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if ColorDialog1.Execute=false then exit;
 Shape2.Brush.Color:=ColorDialog1.Color;
 Sample.Color:=ColorDialog1.Color;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin              OpenDialog1.FilterIndex:=1;
 if OpenDialog1.Execute=false then exit;
 Memo1.Lines.Clear;
 Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
end;

procedure TForm1.Button3Click(Sender: TObject);
var BodyTag:string; Standart:Boolean; i:integer;
begin
 BodyTag:='<body text="'+GetColor(Shape1.Brush.Color)+
 '" bgcolor="'+GetColor(Shape2.Brush.Color)+'">';// тег BODY
        if (ClearImgBtn.Enabled=true)and(Image1.Visible=true) then
                Insert(' background="'+ImageDialog1.FileName+'"',BodyTag,Length(BodyTag));
                EndTag:='</body>'+#13+'</html>';// последние теги

 with Memo2.Lines do begin
 Clear; Add(a); Add(BodyTag); GetFontTag(Standart,true);
        if Carrying1.Checked=true then Add(GetTableTag); // таблица
        if Standart=false then Add(GetFontTag(Standart,false));// шрифт
 for i:=0 to memo1.Lines.Count-1 do begin
 if Carrying1.Checked=true then
 memo2.Lines.Add(memo1.Lines[i]+'<br>')
 else memo2.Lines.Add(memo1.Lines[i]); end;
 //        if Standart=false then Add(LastTag);
 Add(EndTag); // Add(b);
 end;
end;

procedure TForm1.LoadImgBtnClick(Sender: TObject);
begin
 ImageDialog1.InitialDir:=ExtractFileName(Application.ExeName);
 if ImageDialog1.Execute=false then exit;
 Image1.Visible:=true; ClearImgBtn.Enabled:=true;
 Image1.Picture.LoadFromFile(ImageDialog1.FileName);
end;

procedure TForm1.ClearImgBtnClick(Sender: TObject);
begin
 Image1.Visible:=false; ClearImgBtn.Enabled:=false;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
 if SaveDialog1.Execute=false then exit;
 SaveMemo.Lines.Clear; SaveMemo.Lines:=Memo2.Lines;
 SaveMemo.Lines.SaveToFile(SaveDialog1.FileName+'.html');
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
 SaveMemo.Lines.Clear; SaveMemo.Lines:=Memo2.Lines;
 SaveMemo.Lines.SaveToFile(ExtractFilePath(Application.ExeName)+'Temporary.html');
 ShellExecute(0,'open',PAnsiChar(ExtractFilePath(Application.ExeName)+'Temporary.html'),
 nil,nil,SW_SHOWNORMAL);
end;

procedure TForm1.FrameClick(Sender: TObject);
begin
 if Frame.Checked=true then begin
 f1.Enabled:=true; FrameEdit.Enabled:=true; end
 else begin
 f1.Enabled:=false;
 FrameEdit.Enabled:=false;  end;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
 Form2.ShowModal;
end;

procedure TForm1.TbGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState); var R:integer;
begin
 if (gdFocused in State) then begin
 Changes:=false;      TbMemo.Visible:=false;
 TbMemo.Left:=Rect.Left+TbGrid.Left+2;
 TbMemo.Top:=Rect.Top+TbGrid.Top+2;
                 if TbMemo.ScrollBars=ssBoth then R:=18
                 else R:=1;
 TbMemo.Width:=Tbgrid.ColWidths[ACol]+R;
 TbMemo.Height:=Tbgrid.RowHeights[ARow]+R;
 TbCol:=ACol;      TbRow:=ARow;

 TbMemo.Lines.Clear;      TbText.Lines.Clear;
 TbMemo.Lines.Strings[0]:=Table.Strings[TbRow+(TbCol*TbGrid.RowCount)];
 TbText.Lines.Strings[0]:=Table.Strings[TbRow+(TbCol*TbGrid.RowCount)];
 TbMemo.Color:=StringToColor(CellColor.Strings[TbRow+(TbCol*TbGrid.RowCount)]);
 Shape3.Brush.Color:=StringToColor(CellColor.Strings[TbRow+(TbCol*TbGrid.RowCount)]);
 cell.Caption:=IntToStr(ACol)+' : '+IntToStr(ARow);
 TbMemo.Visible:=true;      Changes:=true;
// Form1.Caption:=IntToStr(ARow+(ACol*TbGrid.RowCount));
 end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var i:integer;
begin
 if (TbCols.Text<='0')or(TbRows.Text<='0')or(TbWidth.Text<='0')or(TbHeight.Text<='0') then begin
 Application.MessageBox('Пожалуйста, введите допустимые значения','Внимание',MB_ICONASTERISK+MB_OK);
 exit; end;// неверные данные

 cell.Caption:='';
 TbMemo.Visible:=false;
             Table.Clear; CellColor.Clear;
             for i:=1 to StrToInt(TbCols.Text)*StrToInt(TbRows.Text) do begin
             Table.Add('');// подготавливаем хранилише текста ячеек
             CellColor.Add('clWhite');{а это для цвета ячеек} end;
 for i:=0 to TbGrid.ColCount-1 do
 TbGrid.Cols[i].Clear;// отчишаем TbGrid
             if StrToInt(TbHeight.Text)<35 then
             TbMemo.ScrollBars:=ssNone  // допустимость на скрол
             else TbMemo.ScrollBars:=ssBoth;
 TbGrid.ColCount:=StrToInt(TbRows.Text);
 TbGrid.RowCount:=StrToInt(TbCols.Text);
 TbGrid.DefaultColWidth:=StrToInt(TbWidth.Text);
 TbGrid.DefaultRowHeight:=StrToInt(TbHeight.Text);
 Button7.Enabled:=true;     Button8.Enabled:=true;
 TbGrid.Visible:=true;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 Table:=TStringList.Create;
 CellColor:=TStringList.Create;
end;

procedure TForm1.TbMemoChange(Sender: TObject);
var s:string[5];
begin
 if Changes=true then begin
 Table.Strings[TbRow+(TbCol*TbGrid.RowCount)]:=TbMemo.Text;
 TbText.Lines:=TbMemo.Lines;
 s:=Table.Strings[TbRow+(TbCol*TbGrid.RowCount)];
 if Length(s)<>0 then
  TbGrid.Cells[TbCol,TbRow]:=s+'...';
 end;
end;

procedure TForm1.Shape3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if TbMemo.Visible=false then exit;
 if ColorDialog1.Execute=false then exit;
 Shape3.Brush.Color:=ColorDialog1.Color;
 CellColor.Strings[TbRow+(TbCol*TbGrid.RowCount)]:=ColorToString(ColorDialog1.Color);
 TbMemo.Color:=ColorDialog1.Color;
end;

procedure TForm1.Shape4MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if ColorDialog1.Execute=false then exit;
 Shape4.Brush.Color:=ColorDialog1.Color;
end;

function TForm1.GetFrameOrAlign(FrOrAl: Boolean): String;
begin
 if FrOrAl=true then begin// если проверка не согласие рамки
 if TbFrame.Checked=true then Result:=' border="2"'
 else Result:=''; end
           else begin// выравнивание текста
           case TbAlign.ItemIndex of
           0:Result:='';
           1:Result:=' align="center"';
           2:Result:=' align="right"';
           end;
           end;
end;

procedure TForm1.Button7Click(Sender: TObject);
var i,y:integer; Talg:string;
begin
 Memo2.Lines.Clear;               Talg:=GetFrameOrAlign(false);
 Memo2.Lines.Add(a+#13+'<body text="'+GetColor(Shape5.Brush.Color)+'">'+#13+
 '<table bgcolor="'+GetColor(Shape4.Brush.Color)+'"'+GetFrameOrAlign(true)+'>');
     for i:=0 to StrToInt(TbCols.Text)-1 do begin
     Memo2.Lines.Add(' <tr height="'+TbHeight.Text+'"'+Talg+'>');// вставить строчку
         for y:=0 to TbGrid.ColCount-1 do
         Memo2.Lines.Add('  <td width="'+TbWidth.Text+'" bgcolor="'+
         GetColor(StringToColor(CellColor.Strings[y*TbGrid.RowCount+i]))+
         '">'+GetText(Table.Strings[y*TbGrid.RowCount+i])+'</td>');
     Memo2.Lines.Add(' </tr>');// закрыть строчку
     end;
 Memo2.Lines.Add('</table>'+#13+b);
 Form1.Button4Click(Memo2);
end;

procedure TForm1.Shape5MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if ColorDialog1.Execute=false then exit;
 Shape5.Brush.Color:=ColorDialog1.Color;
 TbMemo.Font.Color:=ColorDialog1.Color;
end;

function TForm1.GetTag(Tag: String): String;
var
   I,W1,W2,C1,C2:integer;
   B,P,K:Boolean;
begin
 Tags.SelAttributes.Color:=$009F5000;
 Tags.Lines[0]:=Tag;
 if Pos(' ',Tag)<>0 then begin// if
 W1:=Pos(' ',Tag);
 C1:=1;
 B:=false;
 P:=false;
 K:=false;
     for I:=Pos(' ',Tag) to Length(Tag) do begin
     if (Tag[I]='"')and(K=false) then begin C1:=I; K:=true; Continue; end;
     if (Tag[I]='"')and(K=true) then begin
         C2:=I+1;
         Tags.SelStart:=C1-1;
         Tags.SelLength:=C2-C1;
         Tags.SelAttributes.Color:=$008000FF;
         K:=false;
         Continue;
     end;
     if (Tag[I]=' ')and(K=false) then begin P:=true; Continue; end;
     if (Tag[I]<>' ')and(B=false)and(P=true) then begin W1:=I; B:=true; end;
     if Tag[I]='=' then begin
        W2:=I;
        Tags.SelStart:=W1-1;
        Tags.SelLength:=W2-W1;
        Tags.SelAttributes.Color:=$000060BF;
        B:=false;
        P:=false;
     end;
     end;
 end;// if
 Tags.SelStart:=0;
 Tags.SelLength:=Length(Tags.Lines[0]);
 Tags.CutToClipboard;
end;


procedure TForm1.LoadWeb(TX: String);
var Y,T1:integer; LINE:String; P:pointer;
begin
      P:=@LINE;
      LINE:=TX+'<';
      for Y:=1 to Length(String(P^)) do begin // for
      T1:=Pos('<',String(P^));
      Clipboard.SetTextBuf(PChar(Copy(String(P^),1,T1-1)));
      Editor.SelAttributes.Color:=clBlack;
      Editor.PasteFromClipboard;
         if (T1=0)or(Pos('>',String(P^))=0) then break;
      GetTag(PChar(Copy(String(P^),T1,(Pos('>',String(P^))-T1)+1)));
      Editor.PasteFromClipboard;
      Delete(LINE,1,Pos('>',LINE));
      end; // for
end;

procedure TForm1.Button9Click(Sender: TObject);
var F:TStrings;
begin
 OpenDialog1.FilterIndex:=2;
 if OpenDialog1.Execute=false then exit;
          F:=TStringList.Create;
          F.LoadFromFile(OpenDialog1.FileName);
          Editor.Clear;          Editor.SetFocus;          LoadWeb(F.Text);
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
 Editor.Clear; LoadWeb(a+#13+#13+b);
 Editor.SetFocus; Editor.SelStart:=130;
end;

procedure TForm1.InsertTag(Tag: String);
var
   I:integer;
   T:String;
begin
 for I:=2 to Length(Tag) do begin
 if ((Tag[I]=' ')or(Tag[I]='>'))and(Length(T)<>0) then Break;
 T:=T+Tag[I];
 end;
   T:=AnsiLowerCase(T);
   for I:=1 to 36 do begin
   if T=THTML[I] then begin
   Clipboard.SetTextBuf(PChar('</'+THTML[I]+'>'));
   Editor.PasteFromClipboard;
   Editor.SelStart:=Editor.SelStart-(Length(THTML[I])+3);
   Exit;
   end; end;
end;
{       $009F5000; синий (теги)
        $000060BF; ораньжевый (параметры тега)
        $008000FF; малиновый (кавычки)       }
procedure TForm1.EditorKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
    a:pchar;
    Stroka:string;
begin
 TG2:=false;
 SPACE:=false;
 Stroka:=Editor.Lines[CharPos.Y-1];
    if (Length(Editor.Lines[CharPos.Y-1])=0)or(Stroka[CharPos.X-1]='>')or(Stroka[CharPos.X]='<') then
    if (CT1<>Col.Caption) then
    Editor.SelAttributes.Color:=clBlack; // печатать простой текст
 getmem(a,30);
 GetKeyboardLayoutName(a);
    if key=32 then SPACE:=true;          // нажат пробел

    if key=187 then begin                // равно
    if (TG1=true)and(Editor.SelAttributes.Color<>$008000FF)and(CT1=Col.Caption) then
    Editor.SelAttributes.Color:=$009F5000;
    end;
 if a='00000409' then                    // если английский ввод
 begin

    if (ssShift in Shift) then begin      // если зажат "SHIFT"
      if (key=222)and(CT1=Col.Caption) then Editor.SelAttributes.Color:=$008000FF;// кавычки
      if(key=188)then begin               // символ " < "
      Editor.SelAttributes.Color:=$009F5000;
      MT1:=StrToInt(LChar.Caption);       // регистрируем начало тега
      TG1:=true;                          // после, начинаем сложение слова в теге
      CT1:=Col.Caption;
      end;
      if(key=190)then begin               // символ " > "
      Editor.SelAttributes.Color:=$009F5000;
      TG2:=true;
      end;
    end;
 end;
 freemem(a);
end;

procedure TForm1.EditorKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (SPACE=true)and(Editor.SelAttributes.Color=$009F5000) then Editor.SelAttributes.Color:=$000060BF;
    if (TG1=true)and(CT1=Col.Caption) then begin  // В переменную MT с нажатеми клавиш получаем слово
    MT:=Copy(Editor.Lines[StrToInt(Col.Caption)-1],MT1,Length(Editor.Lines[StrToInt(Col.Caption)-1])-(MT1-1));
    PLUS:=PLUS+1;
       if ((Length(MT)=0)or(MT=Char(LongInt(13))))and(PLUS>2) then begin // если стерли наш тег,
       TG1:=false;                             // отключить сложение слова
       MT:='';
       PLUS:=0;
       Editor.SelAttributes.Color:=clBlack;
       end;
//    Form1.Caption:=MT+'  MT1-'+IntToStr(MT1)+'  Length-'+IntToStr(Length(Editor.Lines[StrToInt(Col.Caption)-1]));
       if SPACE=true then Editor.SelAttributes.Color:=$000060BF; // если нажат пробел, придать
    end;                                                         // аттрибутам ораньжевый цвет
 if TG2=true then begin// если тег закрыт, отключить возможности окраски
  InsertTag(MT);       // вставка закрывающего тега
  Editor.SelAttributes.Color:=clBlack;
  MT:='';
  TG1:=false;
  PLUS:=0;
 end;
end;

procedure TForm1.EditorSelectionChange(Sender: TObject);
begin
  CharPos.Y := SendMessage(Editor.Handle, EM_EXLINEFROMCHAR, 0,
    Editor.SelStart);
  CharPos.X := (Editor.SelStart -
    SendMessage(Editor.Handle, EM_LINEINDEX, CharPos.Y, 0));
  Inc(CharPos.Y);
  Inc(CharPos.X);
  Col.Caption:=IntToStr(CharPos.Y);
  LChar.Caption:=IntToStr(CharPos.X);
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
 if SaveDialog1.Execute=false then exit;
 SaveMemo.Lines.Clear; SaveMemo.Lines:=Editor.Lines;
 SaveMemo.Lines.SaveToFile(SaveDialog1.FileName+'.html');
end;

end.
