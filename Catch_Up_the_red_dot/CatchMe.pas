unit CatchMe;

interface

uses Windows, SysUtils, Classes;



{ TFLOATPOINT ------------------------------------------------------------------------------------ }

type
    {>> Comme le type TPoint mais pour les Flottants
        Single offre un bon compromis taille/precision et permet d'eviter les bugs
        de comparaison qu'on obtient avec le type Real et Double... }
    TFloatPoint = record
       X,Y : single;
    end;

function FloatPoint(X,Y : single) : TFloatPoint;



{ TCATCHUPOBJ ------------------------------------------------------------------------------------ }

type
    {>> Je serais le premier a dire, Berk! le bon vieil objet TurboPascal ^^
        mais il faut avouer que dans certains cas il est un bon compromis entre
        le type Record et la classe TObject, meme si on aurait pus faire autrement.
        pour un test ... c'est pas encore trés grave car je vais bientot le transformer
        en classe sur la base d'une TList ... a suivre donc... }
    TCatchUpObj = object
       { position de l'objet }
       Pos   : TPoint;
       { velocitée de l'objet }
       Vel   : TFloatPoint;
       { couleur de l'objet }
       Color : integer;

       { permet de deplacer l'objet vers la coordonnée Pnt ou X,Y }
       procedure CatchUp(const Pnt : TPoint); overload;
       procedure CatchUp(const X,Y : integer); overload;

       { permet de savoir si la position Pnt ou X,Y a été atteinte }
       function IsCaught(const Pnt : TPoint) : boolean; overload;
       function IsCaught(const X,Y : integer) : boolean; overload;
    end;




implementation



{ TFLOATPOINT ------------------------------------------------------------------------------------ }

function FloatPoint(X,Y : single) : TFloatPoint;
begin
  result.X := X;
  result.Y := Y;
end;



{ TCATCHUPOBJ ------------------------------------------------------------------------------------ }

procedure TCatchUpObj.CatchUp(const Pnt : TPoint);
begin
  CatchUp(Pnt.X,Pnt.Y);
end;

procedure TCatchUpObj.CatchUp(const X,Y : integer);
var DX,DY : integer;
begin
  {>> Calcul du decalage de position en X }
  DX := round(Vel.X*(X - Pos.X));
  { si DX est egal a 0 on place la position sur X sinon on applique le decalage }
  if DX = 0 then Pos.X := X else Pos.X := Pos.X + DX;

  {>> Meme principe pour Y }
  DY := round(Vel.Y*(Y - Pos.Y));
  if DY = 0 then Pos.Y := Y else Pos.Y := Pos.Y + DY;
end;

function TCatchUpObj.IsCaught(const Pnt : TPoint) : boolean;
begin
  result := IsCaught(Pnt.X,Pnt.Y);
end;

function TCatchUpObj.IsCaught(const X,Y : integer) : boolean;
begin
  {>> Test sur la simple egalitée de la position et de X,Y }
  result := (Pos.X = X) and (Pos.Y = Y);
end;



end.
