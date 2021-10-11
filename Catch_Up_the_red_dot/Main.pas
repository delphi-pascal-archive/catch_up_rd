unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Menus;

type
  TFAnim = class(TForm)
    PBFrame : TPaintBox;
    Timer1 : TTimer;
    CBxFollowCursor : TCheckBox;
    Panel1 : TPanel;
    CBxFreeze: TCheckBox;
    PopupMenu1: TPopupMenu;
    ShowCupInfos: TMenuItem;
    ShowMCPInfos: TMenuItem;
    ShowGTCInfos: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure PBFramePaint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure CBxFollowCursorClick(Sender: TObject);
    procedure CBxFreezeClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FAnim: TFAnim;

implementation

{$R *.dfm}

uses math, CatchMe;

{ FONCTIONS UTILES ------------------------------------------------------------------------------- }

{>> Permet de verifier si une position TPoint est dans une zone TRect }
function PointInRect(const P : TPoint; const R : TRect) : boolean;
begin
  result := ((P.X >= R.Left) and (P.X <= R.Right)) and ((P.Y >= R.Top) and (P.Y <= R.Bottom));
end;

{>> Crée une couleur grise par rapport a une valeur unique }
function OneByteColor(const B : integer) : integer;
var BC : byte;
begin
  if B > 255 then BC := 255 else
  if B < 0   then BC := 0   else
     BC := B;
  result :=  (BC shl 16) + (BC shl 8) + BC;
end;



{ VARIABLES GLOBALES ----------------------------------------------------------------------------- }

const
    {>> Combien vous en voulez ? }
    COBJCount = 10; { 5..15 (max 1000 attention aux performances)}

var
    {>> Position de la souris ou du point rouge }
    MCP : Tpoint;

    {>> Tableau des CatchUpObj }
    CUP : array[0..COBJCount-1] of TCatchUpObj;

    {>> Interval de vitesse }
    SpeedMax : single = 0.28;
    SpeedMin : single = 0.18;

    {>> Temps en millisecondes ecoulé depuis l'entrée dans OnTimer jusqu'a la fin du dessin }
    PerfCount : integer = 0;


{ INITIALISATIONS -------------------------------------------------------------------------------- }

procedure TFAnim.FormCreate(Sender: TObject);
var i : integer;
    sp: single;
begin
  {>> Dois-je presenter cette ligne ? on sais a quoi elle sert maintenant ... }
  FAnim.DoubleBuffered := true;

  {>> Idem }
  Randomize;

  {>> Init des CatchUpObj ... }
  for i := 0 to COBJCount-1 do begin
      { position de depart au milieu par defaut }
      CUP[i].Pos   := Point( PBFrame.Width div 2, PBFrame.Height div 2 );
      { calcul de la vitesse par rapport a l'ordre dans le tableau }
      sp           := SpeedMin + ((SpeedMax-SpeedMin)/COBJCount)*(COBJCount-i);
      CUP[i].Vel   := FloatPoint(sp,sp);
      { un petit effet de couleur par rapport a l'ordre dans le tableau
        en ajoutant une petite nuance orangée }
      CUP[i].Color := OneByteColor(round(200/High(Cup)*i))+$001225;
  end;

  {>> Init de MCP }
  MCP := point( PBFrame.Width div 2, PBFrame.Height div 2 );
end;



{ DESSINS ---------------------------------------------------------------------------------------- }

procedure TFAnim.PBFramePaint(Sender: TObject);
var i : integer;
    m : integer;
    G : integer;
    T : string;
begin
  with PBFrame.Canvas do begin
       {>> Effacement de la zone de dessin }
       Brush.Style := bsSolid;
       Brush.Color := clWhite;
       FillRect(PBFrame.ClientRect);

       {>> Dessin des lignes }
       { CUP[0] est notre point de depart pour MoveTo }
       Pen.Color := CUP[0].Color;
       MoveTo(CUP[0].Pos.X,CUP[0].Pos.Y);
       { Ensuite les autres servent pour LineTo }
       for i := 1 to COBJCount-1 do begin
           { la couleur de la ligne correspond a la couleur du point }
           Pen.Color := Cup[i].Color;
           { a quand un TCanvas avec des fonctions qui prennent en charge les TPoint ? }
           LineTo(CUP[i].Pos.X, CUP[i].Pos.Y);
       end;

       {>> Dessin des points }
       for i := COBJCount-1 downto 0 do
           with CUP[i] do begin
                { on recupere la couleur }
                Pen.Color   := Color;
                Brush.Color := Color;
                { on ajuste la taille du points a son ordre dans le tableau }
                m := min(2*((COBJCount-i)+1),12);
                { on dessine une simple ellipse }
                Ellipse(Pos.X-m,Pos.Y-m,Pos.X+m,Pos.Y+m);
           end;

       {>> Dessin du point rouge, si on ne suis pas la souris }
       if not CBxFollowCursor.Checked then begin
          Pen.Color   := clRed;
          Brush.Color := clRed;
          { c'est un rectangle en fait de coordonées MCP }
          Rectangle(MCP.X-2,MCP.Y-2,MCP.X+2,MCP.Y+2);
       end;

       {>> Affichage des infos }
       Brush.Style := bsClear;

       {>> Affichage de la position de MCP }
       if ShowMCPInfos.Checked then begin
          font.Color  := clBlue;
          T := format('MCP: %d x %d',[MCP.X,MCP.Y]);
          TextOut( PBFrame.Width-TextWidth(T)-8, PBFrame.Height-22, T );
       end;

       {>> Affichage des positions des CatchUpObj par rapport a MCP }
       if ShowCUPInfos.Checked then
       for i := 0 to COBJCount-1 do begin
           {>> Si il est attrapé, on affiche le texte en vert }
           if CUP[i].IsCaught(MCP) then
              font.Color := clGreen
           { sinon en noir }
           else
              font.Color := clBlack;

           T := format('[%d] %d x %d',[i, MCP.X-CUP[i].Pos.X, MCP.Y-CUP[i].Pos.Y]);
           TextOut( 5, PBFrame.Height-((COBJCount+1)*14)+(14*i), T );
       end;

       {>> Affichage des performances }
       if ShowGTCInfos.Checked then begin
          font.Color  := clGray;
          { on calcul le temps pris }
          G := GetTickCount-PerfCount;
          { on formatte le tout }
                    { Estimation FPS | interval du timer | temps de la routine | nombre d'objet}
          T := format( 'FPS : %.2f (%.3d ms | %.3d ms | %d CatchUpObj)',
                       [1000/(Timer1.Interval+G), Timer1.Interval, G, COBJCount]);
          TextOut( 5, 5, T );
       end;
  end;
end;



{ TIMER ------------------------------------------------------------------------------------------ }

procedure TFAnim.Timer1Timer(Sender: TObject);
var i : integer;
begin
  PerfCount := GetTickCount;

  {>> Suivre le curseur de la souris }
  if CBxFollowCursor.Checked then begin
     { on recupere la position de la souris }
     MCP := point( Mouse.CursorPos.X-ClientOrigin.X,Mouse.CursorPos.Y-ClientOrigin.Y);
     { si on est pas dans la zone de dessin on mets MCP au millieu }
     if not PointInRect(MCP, PBFrame.ClientRect) then
        MCP := point( PBFrame.width div 2, PBFrame.height div 2);

  {>> Suivre le point rouge }
  end else begin
      {>> Si on as attraper le point rouge }
      if CUP[0].IsCaught(MCP) then
         { c'est pour RandomRange qu'on utilise Math ?! hé bé ... }
         MCP := point(RandomRange(15,ClientWidth-15) , RandomRange(15,ClientHeight-15) );
  end;

  {>> On rattrape les position grace a la methode CatchUp des TCatchUpObj }
  { le premier rattrape MCP }
  CUP[0].CatchUp(MCP);
  { les autres rattrape celui qui les precedes }
  for i := 1 to COBJCount do
      CUP[i].CatchUp(CUP[i-1].Pos);

  {>> On rafraichis l'affichage, d'ou le reglage du timer pour obtenir
    un FPS de 12..22 (80..45ms) }
  PBFrame.Refresh;
end;



{ CHECKBOX 'suivre la souris' -------------------------------------------------------------------- }

procedure TFAnim.CBxFollowCursorClick(Sender: TObject);
begin
  {>> Tout simplement on change le titre de l'application selon l'etat }
  { celui de la fiche }
  if CBxFollowCursor.Checked then
     FAnim.Caption := 'Catch up the Mouse!'
  else
     FAnim.Caption := 'Catch up the red dot!';

  { celui de l'application }
  Application.Title := FAnim.Caption;
end;



{ CHECKBOX 'Freeze' ------------------------------------------------------------------------------ }

procedure TFAnim.CBxFreezeClick(Sender: TObject);
begin
  {>> Devinez ... }
  Timer1.Enabled := not CBxFreeze.Checked;
end;

end.
