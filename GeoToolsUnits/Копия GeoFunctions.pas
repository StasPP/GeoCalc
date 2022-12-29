unit GeoFunctions;

//// Шевчук С. 2016

interface

uses GeoClasses, GeoMath, Math;

  function FindConvertData(Datum : TDatum; FindName: string):integer;

  function FindEllipsoid(FindName: string):integer;
  function AddEllipsoid(Ellipsoid: TEllipsoid):integer;
  function CreateEllipsoid(Name, Caption : String; a, alpha : Double):integer;

  function AddDatum(Datum: TDatum):integer;
  function FindDatum(FindName: string):integer;
  function FindDatumByCaption(FindName: string):integer;
  function CreateDatum(Name, Caption, EllipsoidName : String): integer;

  procedure AddToConvList(Data:TConvertData);

  procedure AddConversionProperties(DatumNumber: integer; ConvertDatumName: String; dx, dy, dz, wx, wy, wz, ms : double);
  procedure AddProjection(DatumNumber: integer; ProjectionName: String);

  procedure Geo1ToGeo2(B1, L1, H1 : double; InputSKNumber, OutputSKNumber :Integer; var B2, L2, H2 : double);
  procedure Geo1ForceToGeo2(B1, L1, H1 : double; InputSKNumber, OutputSKNumber :Integer; var B2, L2, H2 : double);

  procedure GeoToECEF(DatumN: Integer; B, L, H: double; var OutputX, OutputY, OutputZ : double);
  procedure ECEFToGeo(DatumN: Integer; X, Y, Z: double; var OutputB, OutputL, OutputH : double);

  procedure GeoToGaussKruger(B1, L1, H1 : double; var Outputx, Outputy: double; var Zone: integer; AutoZone: boolean);
  procedure GaussKrugerToGeo(x, y: double; var OutputB, OutputL : double);

  procedure GeoToUTM(DatumN: Integer; B, L: double; South, West: Boolean; var OutputNorthing, OutputEasting: double; var Zone: integer; AutoZone: boolean);
  procedure UTMToGeo(DatumN: Integer; Northing, Easting: double; South, West: Boolean; var OutputB, OutputL: double);


  {function GetGeoidDeltaH(x,y :Double; Geoid:TGeoid): Double;
  function GetGeoidalH(x, y, Hell :Double; Geoid:TGeoid);
  function GetEllipsoidalH(x, y, Hgeo :Double; Geoid:TGeoid);  }

  var EllipsoidList: array of TEllipsoid;
      DatumList: array of TDatum;
      TransformationList : array of TConvertData;

implementation


function AddEllipsoid(EllipSoid:TEllipsoid):integer;
var I: Integer;
begin
  I:= Length(EllipsoidList);
  SetLength(EllipsoidList, I+1);
  EllipsoidList[I] := Ellipsoid;
  AddEllipsoid := I;
end;

function AddDatum(Datum:TDatum):integer;
var I: Integer;
begin
  I:= Length(DatumList);
  SetLength(DatumList, I+1);
  DatumList[I] := Datum;
  AddDatum := I;
end;

function CreateEllipsoid(Name, Caption : String; a, alpha : Double):integer;
var I: Integer;
    NewEllipsoid:TEllipsoid;
begin
  I :=FindEllipsoid(name);
  if I=-1 then
  Begin
    NewEllipsoid.name := name;
    NewEllipsoid.Caption := Caption;
    NewEllipsoid.a:= a;
    NewEllipsoid.alpha:= alpha;
    CreateEllipsoid := AddEllipsoid(NewEllipsoid);
  End
    Else
    Begin
      EllipsoidList[I].Caption := Caption;
      EllipsoidList[I].a:= a;
      EllipsoidList[I].alpha:= alpha;
      CreateEllipsoid := I;
    End;
end;

function FindConvertData(Datum : TDatum; FindName: string):integer;
var I :integer;
begin
  FindConvertData := -1;
  for I:= 0 to Length(Datum.ConvertData)-1 do
    if Datum.ConvertData[i].ConvertDatumName = FindName then
      begin
         FindConvertData := i;
         break;
      end;
end;

function FindDatum(FindName: string):integer;
var I :integer;
begin
  FindDatum:= -1;
  for I:= 0 to Length(DatumList)-1 do
    if DatumList[i].name = FindName then
      begin
         FindDatum:= i;
         break;
      end;
end;

function FindDatumByCaption(FindName: string):integer;
var I :integer;
begin
  FindDatumByCaption:= -1;
  for I:= 0 to Length(DatumList)-1 do
    if DatumList[i].Caption = FindName then
      begin
         FindDatumByCaption:= i;
         break;
      end;
end;

function FindEllipsoid(FindName: string):integer;
var I :integer;
begin
  FindEllipsoid:= -1;

  for I:= 0 to Length(EllipsoidList)-1 do
    if EllipsoidList[i].name = FindName then
      begin
         FindEllipsoid:= i;
         break;
      end;
end;

procedure GeoToECEF(DatumN: Integer; B, L, H: double; var OutputX, OutputY, OutputZ : double);
var N, e2, a : Double;
    _Datum: TDatum;

 procedure GetConsts;
 var al : Double;
 begin
   a := _Datum.Ellipsoid.a;
   al := _Datum.Ellipsoid.alpha;

   e2  := 2 * al - al*al;
 end;

begin
  try
   _Datum :=  DatumList[DatumN];
  except
    OutputX := 0;
    OutputY := 0;
    OutputZ := 0;
    exit;
  end;

  GetConsts;
  
  B := B * pi / 180;
  L := L * pi / 180;

  N := a/sqrt(1-e2*sin(B)*sin(B));

  OutputX := (N+H)*cos(B)*cos(L);
  OutputY := (N+H)*cos(B)*sin(L);
  OutputZ := ((1-e2)*N+H)*sin(B);
end;

procedure AddToConvList(Data:TConvertData);
var i, j, j2 :integer;
begin

  /// Forward  number in list
  j := -1;
  for i := 0 to length(TransformationList)-1 do
    if TransformationList[i].InputDatumName = Data.InputDatumName then
      if TransformationList[i].ConvertDatumName = Data.ConvertDatumName then
      begin
          j:= i;
          break;
      end;

  /// Reverse  number in list
  j2 :=-1;
  for i := 0 to length(TransformationList)-1 do
    if TransformationList[i].InputDatumName = Data.ConvertDatumName then
      if TransformationList[i].ConvertDatumName = Data.InputDatumName then
      begin
          j2:= i;
          break;
      end;

  if j=-1 then
  begin
     j := length(TransformationList);
     Setlength(TransformationList, j+1);
  end;

  if j2=-1 then
  begin
     j2 := length(TransformationList);
     Setlength(TransformationList, j2+1);
  end;


  //// FWD
  TransformationList[j] := Data;

  /// REW
  TransformationList[j2] := Data;
  with TransformationList[j2] do
  begin
    InputDatumName := TransformationList[j].ConvertDatumName;
    ConvertDatumName := TransformationList[j].InputDatumName;

    dx := - dx;
    dy := - dy;
    dz := - dz;

    wx := - wx;
    wy := - wy;
    wz := - wz;

    ms := -ms;
  end;

end;

procedure ECEFToGeo(DatumN: Integer; X, Y, Z: double; var OutputB, OutputL, OutputH : double);
var La, e2, a, D, r, p, c, s1, s2, _d, b : Double;
    _Datum: TDatum;

 procedure GetConsts;
 var al : Double;
 begin
   a := _Datum.Ellipsoid.a;
   al := _Datum.Ellipsoid.alpha;

   e2  := 2 * al - al*al;
 end;

begin
  try
   _Datum :=  DatumList[DatumN];
  except
    OutputB := 0;
    OutputL := 0;
    OutputH := 0;
    exit;
  end;

  GetConsts;

  D := sqrt(sqr(X)+sqr(Y));
  if D = 0 then
  begin
     OutputB := 0.5*pi*Z/abs(Z);
     OutputL := 0;
     OutputH := Z * Sin(OutputB) - a * sqrt(1-e2*sin(OutputB)*sin(OutputB));
  end
   else
   begin
     La := abs(arcsin(Y/D));

     if (Y < 0) and (X > 0) then OutputL := 2*pi - La;
     if (Y < 0) and (X < 0) then OutputL := pi + La;
     if (Y > 0) and (X < 0) then OutputL := pi - La;
     if (Y > 0) and (X > 0) then OutputL := La;
     if (Y = 0) and (X < 0) then OutputL := 0;
     if (Y = 0) and (X > 0) then OutputL := pi;
   end;

   if Z = 0 then
   begin
      OutputB := 0;
      OutputH := D - a;
   end
    else
    begin
       r := sqrt(sqr(X)+sqr(Y)+sqr(Z));
       c := arcsin(Z/r);
       p := (e2 * a) / (2 * r);

       s1 := 0;

       repeat
         b:= c + s1;
         s2 := p*sin(2*b) / sqrt(1-e2*sin(b)*sin(b)) ;
         s2 := arcsin( s2 );
         _d := abs(s2 - s1);
         s1 := s2;
       until _d < 0.0001/ro;
        OutputB := b;
        OutputH := D*cos(B) + Z*sin(B) - a*sqrt(1-e2*sin(B)*sin(B));
    end;
    OutputB := OutputB / pi *180;
    OutputL := OutputL / pi *180;

end;


procedure GaussKrugerToGeo(x, y: double; var OutputB, OutputL: double);

  function XToB(X,Y:double):Double ;
  var
    No : Integer ;
    Bi, Bo, Zo, Ba, Bb, Bc, Db : Double ;
  begin
    No := trunc(Y / 1000000);
    Bi := X / 6367558.4968;

    Bo := Bi + sin(Bi * 2) * (0.00252588685 - 0.0000149186 * power(sin(Bi) , 2) + 0.00000011904 * power(sin(Bi) , 4));

    Zo := (Y - (10 * No + 5) * 100000.0) / (6378245.0 * cos(Bo));

    Ba := Zo * Zo * (0.01672 - 0.0063 * power(sin(Bo) , 2) + 0.01188 * power(sin(Bo) , 4) - 0.00328 * power(sin(Bo) , 6));
    Bb := Zo * Zo * (0.042858 - 0.025318 * power(sin(Bo) , 2) + 0.014346 * power(sin(Bo) , 4) - 0.001264 * power(sin(Bo) , 6) - Ba);
    Bc := Zo * Zo * (0.10500614 - 0.04559916 * power(sin(Bo) , 2) + 0.00228901 * power(sin(Bo) , 4)
        - 0.00002987 * power(sin(Bo) , 6) - Bb);

    dB := Zo * Zo * sin(Bo * 2) * (0.251684631 - 0.003369263 * power(sin(Bo) , 2) + 0.000011276 * power(sin(Bo) , 4) - Bc);

    XToB := (Bo - dB) * 180 / Pi;
  end ;

  function YToL(X,Y:double):Double ;
   var No : Integer ;
       Bi, Bo, Zo, La, Lb, Lc, Ld, dL : Double ;
  begin
    No := trunc(Y / 1000000);
    Bi := X / 6367558.4968;
    Bo := Bi + sin(Bi * 2) * (0.00252588685 - 0.0000149186 * power(sin(Bi) , 2) + 0.00000011904 * power(sin(Bi) , 4));
    Zo := (Y - (10 * No + 5) * 100000.0) / (6378245.0 * cos(Bo));
    La := Zo * Zo * (0.0038 + 0.0524 * power(sin(Bo) , 2) + 0.0482 * power(sin(Bo) , 4) + 0.0032 * power(sin(Bo) , 6));
    Lb := Zo * Zo * (0.01225 + 0.09477 * power(sin(Bo) , 2) + 0.03282 * power(sin(Bo) , 4) - 0.00034 * power(sin(Bo) , 6) - La);
    Lc := Zo * Zo * (0.0420025 + 0.1487407 * power(sin(Bo) , 2) + 0.005942 * power(sin(Bo) , 4)
         - 0.000015 * power(sin(Bo) , 6) - Lb);
    Ld := Zo * Zo * (0.16778975 + 0.16273586 * power(sin(Bo) , 2) - 0.0005249 * power(sin(Bo) , 4)
         - 0.00000846 * power(sin(Bo) , 6) - Lc);
    dL := Zo * (1 - 0.0033467108 * power(sin(Bo) , 2) - 0.0000056002 * power(sin(Bo) , 4) - 0.0000000187 * power(sin(Bo) , 6) - Ld);
    YToL := (6 * (No - 0.5) / 57.29577951 + dL) * 180 / Pi;
  end;

begin
  OutputB := XToB(x,y);
  OutputL := YToL(x,y);
end;

procedure GeoToGaussKruger(B1, L1, H1 : double; var Outputx, Outputy: double; var Zone: integer; AutoZone: boolean);

  procedure GetZone (L :Double);
  begin
    if AutoZone then
      Zone := trunc (6 + L) div  6;
  end;

  function BToX(B, L, H: DOUBLE ) : double ;
  var No : Integer ;
      Lo, Bo, Xa,Xb,Xc,Xd : double ;
  begin
     No := Zone;
     Lo := (L - (3 + 6 * (No - 1))) / 57.29577951;
     Bo := B * Pi / 180;
     Xa := pow(Lo , 2) * (109500.0 - 574700.0 * pow(sin(Bo) , 2) + 863700.0 * pow(sin(Bo) , 4) - 398600.0 * pow(sin(Bo) , 6));
     Xb := pow(Lo , 2) * (278194.0 - 830174.0 * pow(sin(Bo) , 2) + 572434.0 * pow(sin(Bo) , 4) - 16010.0 * pow(sin(Bo) , 6) + Xa);
     Xc := pow(Lo , 2) * (672483.4 - 811219.9 * pow(sin(Bo) , 2) + 5420.0 * pow(sin(Bo) , 4) - 10.6 * pow(sin(Bo) , 6) + Xb);
     Xd := pow(Lo , 2) * (1594561.25 + 5336.535 * pow(sin(Bo) , 2) + 26.79 * pow(sin(Bo) , 4) + 0.149 * pow(sin(Bo) , 6) + Xc);
     BToX := 6367558.4968 * Bo - sin(Bo * 2) * (16002.89 + 66.9607 * pow(sin(Bo) , 2) + 0.3515 * pow(sin(Bo) , 4) - Xd);
  end;

  function LToY( B,  L, H: double ): double ;
  var No : Integer;
      Lo, Bo, Ya, Yb, Yc : double ;
  begin
   No := Zone;

   Lo := (L - (3 + 6 * (No - 1))) / 57.29577951;
   Bo := B * Pi / 180;
   Ya := pow(Lo , 2) * (79690.0 - 866190.0 * pow(sin(Bo) , 2) + 1730360.0 * pow(sin(Bo) , 4) - 945460.0 * pow(sin(Bo) , 6));
   Yb := pow(Lo , 2) * (270806.0 - 1523417.0 * pow(sin(Bo) , 2) + 1327645.0 * pow(sin(Bo) , 4) - 21701.0 * pow(sin(Bo) , 6) + Ya);
   Yc := pow(Lo , 2) * (1070204.16 - 2136826.66 * pow(sin(Bo) , 2) + 17.98 * pow(sin(Bo) , 4) - 11.99 * pow(sin(Bo) , 6) + Yb);
   LToY := (5 + 10 * No) * 100000.0 + Lo * cos(Bo) *(6378245 + 21346.1415 * pow(sin(Bo) , 2)
           + 107.159 *pow(sin(Bo) , 4) + 0.5977 * pow(sin(Bo) , 6) + Yc);
  end ;

begin
  GetZone(L1);
  Outputx := BToX(B1, L1, H1);
  Outputy := LToY(B1, L1, H1);
end;

procedure GeoToUTM(DatumN: Integer; B, L: double; South, West: Boolean; var OutputNorthing, OutputEasting: double; var Zone: integer; AutoZone: boolean);
var   Linit, k0, FN, FE, e_2, e2, nu, fi, lambda, A, C, T, M0, M, fi0, Lo, lambda0, ZoneW : Double;
      _Datum : TDatum;
      _a, _al: Double;

 procedure CheckHemisphere;
 begin
  if B < 0 then
      South := true;

  if South then
    if B < 0 then
      B := -B;

  if L < 0 then
      West := true;


  if West then
   if L > 0 then
      L := -L;


 end;

 procedure GetConsts;
 begin
   FE := 500000;
   k0 := 0.9996;

   FN :=0;
   if South then
     FN := 10000000;

   fi0 := 0;
   Linit := 180;
   ZoneW := 6;

   _a := _Datum.Ellipsoid.a;
   _al := _Datum.Ellipsoid.alpha;

   e2  := 2 * _al - _al*_al;
   e_2 := e2 / (1 - e2);
 end;

 function GetZone :integer;
 begin
   Result := trunc((L + Linit + ZoneW)/ZoneW);
 end;

 function GetM(_fi:double) :Double;
 begin
   Result := _a*( (1-e2/4 - 3*e2*e2/64 - 5*e2*e2*e2/256  {- ...})*_fi
                - (3*e2/8 + 3*e2*e2/32 +45*e2*e2*e2/1024 {+ ...})*sin(2*_fi)
                + (15*e2*e2/256 + 45*e2*e2*e2/1024 {+ ...})*sin(4*_fi)
                - (35*e2*e2*e2/3072 {+ ...})*sin(6*_fi) {+ ...});
 end;

Begin
  try
    _Datum :=  DatumList[DatumN];
  except
    OutputNorthing := 0;
    OutputEasting := 0;
    exit;
  end;

  CheckHemisphere;

  GetConsts;

  if AutoZone then
    Zone := GetZone;

  Lo := Zone*ZoneW - ( Linit + ZoneW/2 );

  fi := B * pi / 180;
  lambda := L * pi / 180;
  lambda0 := Lo * pi / 180;

  nu := _a / Sqrt( 1 - e2*sqr(sin(fi)) );
  T :=  sqr(tan(fi));
  C :=  e2*Sqr(cos(fi))/(1 - e2);
  A := (lambda - lambda0)*cos(fi);
  //M0 := GetM(fi0);    !!! M(0) = 0
  M0 := 0;
  M :=  GetM(fi);

  /// Easting
  OutputEasting := Zone * 1000000 + FE + k0 * nu *
             ( A + (1 - T + C)*Pow(A,3)/6 +
             (5 - 18*T + T*T + 72*C - 58*e_2)* Pow(A, 5)/120 ) ;

  OutputNorthing :=  FN + k0 * (M - M0 + nu*tan(fi)* (A*A/2
              + (5 - T + 9*C + 4*C*C)*Pow(A,4)/24
              + (61 - 58*T + T*T + 600*C - 330*e_2)*Pow(A,6)/720));


  if South then
  Begin
     //// Here: WESTING!!!!
     OutputEasting := Zone * 1000000 + FE - k0 * nu *
             ( A + (1 - T + C)*Pow(A,3)/6 +
             (5 - 18*T + T*T + 72*C - 58*e_2)* Pow(A, 5)/120 ) ;

     ///// Here: SOUTHING !!!
     OutputNorthing :=  FN - k0 * (M - M0 + nu*tan(fi)* (A*A/2
              + (5 - T + 9*C + 4*C*C)*Pow(A,4)/24
              + (61 - 58*T + T*T + 600*C - 330*e_2)*Pow(A,6)/720));

  End;
End;

procedure UTMToGeo(DatumN: Integer; Northing, Easting: double; South, West: Boolean; var OutputB, OutputL: double);
var   Linit, k0, FN, FE, e_2, e2, e1, nu1, ro1, fi, fi1, lambda, T1, C1, D, fi0, Lo,
      lambda0, ZoneW, M0, M1, mu1 : Double;
      _Datum : TDatum;
      _a, _al: Double;
      zone : integer;

 procedure GetConsts;
 begin
   FE := 500000;
   k0 := 0.9996;

   FN :=0;
   if South then
     FN := 10000000;

   fi0 := 0;
   Linit := 180;
   ZoneW := 6;

   _a := _Datum.Ellipsoid.a;
   _al := _Datum.Ellipsoid.alpha;

   e2  := 2 * _al - _al*_al;
   e_2 := e2 / (1 - e2);

   e1 := ( 1 - sqrt(1-e2)) / (1 + sqrt(1 - e2));
 end;

 function GetZone :integer;
 begin
   Result := trunc(Easting / 1000000);
 end;

 function GetM(_fi:double) :Double;
 begin
   Result := _a*( (1-e2/4 - 3*e2*e2/64 - 5*e2*e2*e2/256  {- ...})*_fi
                - (3*e2/8 + 3*e2*e2/32 +45*e2*e2*e2/1024 {+ ...})*sin(2*_fi)
                + (15*e2*e2/256 + 45*e2*e2*e2/1024 {+ ...})*sin(4*_fi)
                - (35*e2*e2*e2/3072 {+ ...})*sin(6*_fi) {+ ...});
 end;

Begin
  try
    _Datum :=  DatumList[DatumN];
  except
    OutputB := 0;
    OutputL := 0;
    exit;
  end;

  GetConsts;

  Zone := GetZone;

  Lo := Zone*ZoneW - ( Linit + ZoneW/2 );

  lambda0 := Lo * pi / 180;

  M0 := 0;

  if South then
    M1 := M0 - (Northing - FN) / k0
      else
        M1 := M0 + (Northing - FN) / k0;

  mu1 := M1 / (_a*(1 - e2/4 - 3*e2*e2/64 - 5*e2*e2*e2/256 {- ...}));

  fi1 :=  mu1 + (3*e1/2 - 27*e1*e1*e1/32 {+ ...} )*sin(2*mu1)
          + (21*e1*e1/16 - 55*e1*e1*e1*e1/32 {+ ...} )*sin(4*mu1)
          + (151*e1*e1*e1/96 {+ ...} )*sin(6*mu1)
          + (1097*e1*e1*e1*e1/512 {+ ...} )*sin(8*mu1);

  nu1 := _a / Sqrt( 1 - e2*sqr(sin(fi1)) );
  ro1 := _a* (1 - e2) / Pow((1 - e2*sqr(sin(fi1))),1.5);

  T1 :=  sqr(tan(fi1));
  C1 :=  e_2*Sqr(cos(fi1));

  if South then
     D := -( Easting - (FE + Zone*1000000) )/(nu1*k0)
       else  
          D := ( Easting - (FE + Zone*1000000) )/(nu1*k0);


  fi := fi1 - (nu1*tan(fi1)/ro1)*(D*D/2 - (5 + 3*T1 + 10*C1 - 4*C1*C1 - 9*e_2)*Pow(D,4)/24
        + (61 + 90*T1 - 298*C1 + 45*T1*T1 - 252*e_2 - 3*C1*C1)*Pow(D,6)/720);

  lambda := lambda0 + ( D - (1 + 2*T1 +C1)*Pow(D,3)/6 + (5 - 2*C1 +28*T1 - 3*C1*C1 +8*e_2
            + 24*T1*T1)*Pow(D,5)/120 )/cos(fi1);

  OutputB := fi / pi *180 ;
  OutputL := lambda / pi *180 ;

//  if South then
//    if OutputL > 0 then
//       OutputL :=  -OutputL;

  if South then
    if OutputB > 0 then
       OutputB :=  -OutputB;

End;

function CreateDatum(Name, Caption, EllipsoidName : String):integer;
var I, j: Integer;
    GeoSk : TDatum;
begin
  CreateDatum := -1;
  
  j := FindEllipsoid(EllipsoidName);
  if j=-1 then exit;

  GeoSk.name := name;
  GeoSk.Caption := Caption;
  GeoSk.ellipsoid := EllipsoidList[j];
  SetLength(GeoSk.ConvertData, 0);
  SetLength(GeoSk.Projections, 0);

  I :=FindDatum(GeoSk.name);
  if i=-1 then
    i:= AddDatum(GeoSK)
  else
    DatumList[i]:=GeoSK;

  CreateDatum := I;
end;

procedure AddConversionProperties(DatumNumber: integer; ConvertDatumName: String; dx, dy, dz, wx, wy, wz, ms : double);
var i: Integer;
    GeoSk:TDatum;
begin
  try
    GeoSk := DatumList[DatumNumber];
  except
    exit;
  end;

  i := FindConvertData(GeoSk, ConvertDatumName);
  if i=-1 then
  begin
    i := Length(GeoSk.ConvertData);
    SetLength(GeoSk.ConvertData, i+1);
  end;

  GeoSk.ConvertData[i].InputDatumName := GeoSk.Name;
  GeoSk.ConvertData[i].ConvertDatumName := ConvertDatumName;
  GeoSk.ConvertData[i].dx := dx;
  GeoSk.ConvertData[i].dy := dy;
  GeoSk.ConvertData[i].dz := dz;
  GeoSk.ConvertData[i].wx := wx;
  GeoSk.ConvertData[i].wy := wy;
  GeoSk.ConvertData[i].wz := wz;
  GeoSk.ConvertData[i].ms := ms;

  AddToConvList(GeoSk.ConvertData[i]);

  DatumList[DatumNumber]:= GeoSk;
end;

procedure AddProjection(DatumNumber: integer; ProjectionName: String);
var i: Integer;
    GeoSk:TDatum;
    AlreadyHas: Boolean;
begin
  try
    GeoSk := DatumList[DatumNumber];
  except
    exit;
  end;

  AlreadyHas := false;
  for i := 0 to Length(GeoSk.Projections)-1 do
    if GeoSk.Projections[i] = ProjectionName then
       AlreadyHas := true;

  if not AlreadyHas then
  begin
    i := Length(GeoSk.Projections);
    SetLength(GeoSk.Projections, i+1);
    GeoSk.Projections[i] := ProjectionName;
  end;

  DatumList[DatumNumber]:= GeoSk;
end;


procedure Geo1ToGeo2(B1, L1, H1 : double; InputSKNumber, OutputSKNumber :Integer; var B2, L2, H2 : double);

// Вспомогательные значения для преобразования эллипсоидов

  var
  InputSK, OutputSK :TDatum;

  /// 1-я СК
  a_1 : Double;   // Полуось и сжатие  СК 1
  al_1 : Double;
  e2_1 : Double;  // Квадрат эксцентриситета эллипсоида 1й СК

  /// 2-я СК
  a_2 : Double;   // Полуось и сжатие  СК 2
  al_2 : Double;
  e2_2 : Double;  // Квадрат эксцентриситета эллипсоида 2й СК

  /// Среднее/разности
  a : Double;
  e2 : Double;
  da : Double;
  de2 : Double;

  // Линейные элементы трансформирования, м
  dx: Double;
  dy: Double;
  dz: Double;

  // Угловые элементы трансформирования, в секундах
  wx: Double;
  wy: Double;
  wz: Double ;

  // Дифференциальное различие масштабов
  ms : Double;

  ConvertDataN : integer;
  Reverse : boolean;

  B2_0, L2_0, H2_0: Double; /// первая итеррация

  procedure GetAllConsts;
  begin
    a_1 := InputSK.ellipsoid.a;
    a_2 := OutputSK.ellipsoid.a;

    al_1 := InputSK.ellipsoid.alpha;
    al_2 := OutputSK.ellipsoid.alpha;

    e2_1 := 2 * al_1 - al_1*al_1;
    e2_2 := 2 * al_2 - al_2*al_2;

    a := (a_1 + a_2) / 2 ;
    e2 := (e2_1 + e2_2) / 2;

    da := a_1 - a_2  ;
    de2 := e2_1 - e2_2;

    if Reverse = false then
    begin
      dx := OutputSK.ConvertData[ConvertDataN].dx;
      dy := OutputSK.ConvertData[ConvertDataN].dy;
      dz := OutputSK.ConvertData[ConvertDataN].dz;

      wx := OutputSK.ConvertData[ConvertDataN].wx;
      wy := OutputSK.ConvertData[ConvertDataN].wy;
      wz := OutputSK.ConvertData[ConvertDataN].wz;

      ms := OutputSK.ConvertData[ConvertDataN].ms;
    end
      else
       Begin
         dx := - InputSK.ConvertData[ConvertDataN].dx;
         dy := - InputSK.ConvertData[ConvertDataN].dy;
         dz := - InputSK.ConvertData[ConvertDataN].dz;

         wx := - InputSK.ConvertData[ConvertDataN].wx;
         wy := - InputSK.ConvertData[ConvertDataN].wy;
         wz := - InputSK.ConvertData[ConvertDataN].wz;

         ms := - InputSK.ConvertData[ConvertDataN].ms;
       end;
  end;

  function dB(Bd, Ld, H: Double) : Double;
  var B, L, M, N : Double;
  begin
    B := Bd * Pi / 180 ;
    L := Ld * Pi / 180 ;
    M := a * (1 - e2) / Pow( (1 - e2 * Sin(B) * Sin(B)), 1.5);
    N := a * Pow((1 - e2 * Sin(B) * Sin(B)), -0.5) ;

    dB := ro / (M + H) * (N / a * e2 * Sin(B) * Cos(B) * da
          + (N * N/ (a * a) + 1) * N * Sin(B) * Cos(B) * de2 / 2
          - (dx * Cos(L) + dy * Sin(L)) * Sin(B) + dz * Cos(B))
          - wx * Sin(L) * (1 + e2 * Cos(2 * B))
          + wy * Cos(L) * (1 + e2 * Cos(2 * B))
          - ro * ms * e2 * Sin(B) * Cos(B) ;
  end;

  function dL(Bd, Ld, H: Double) : Double;
  var B, L, N : Double;
  begin
    B := Bd * Pi / 180;
    L := Ld * Pi / 180;
    N := a * Pow((1 - e2 * Sin(B) * Sin (B)), -0.5);
    dL := ro / ((N + H) * Cos(B)) * (-dx * Sin(L) + dy * Cos(L))
		      + Tan(B) * (1 - e2) * (wx * Cos(L) + wy * Sin(L)) - wz;
  end;

  function dH(Bd, Ld, H :Double) : Double;
  var B, L, N : Double ;
  Begin
    B := Bd * Pi / 180 ;
    L := Ld * Pi / 180 ;
    N := a * Pow((1 - e2 * Sin(B) * Sin(B) ), -0.5) ;
    dH := -a / N * da + N * Sin(B) * Sin(B) * de2 / 2 
			    + (dx * Cos(L) + dy * Sin(L)) * Cos(B) + dz * Sin(B)
			    - N * e2 * Sin(B) * Cos(B) * (wx / ro * Sin(L) - wy / ro * Cos(L))
			    + (a * a / N + H) * ms;
  End;

begin
  try
    InputSK :=  DatumList[InputSKNumber];
    OutputSK := DatumList[OutputSKNumber];
  except
    B2 := 0;
    L2 := 0;
    H2 := 0;
    exit;
  end;

  Reverse := false;
  ConvertDataN := FindConvertData(OutputSK, InputSK.Name);

  If ConvertDataN = -1 then
  begin
     Reverse := true;
     ConvertDataN := FindConvertData(InputSK, OutputSK.Name);
  end;

  If ConvertDataN = -1 then
  begin
    B2 := 0;
    L2 := 0;
    H2 := 0;
    exit;
  end;

  GetAllConsts;

  B2_0 := dB(B1,L1,H1)/3600;
  L2_0 := dL(B1,L1,H1)/3600;
  H2_0 := dH(B1,L1,H1);

  B2 := dB(B1 - B2_0,L1 - L2_0,H1 - H2_0)/3600;
  L2 := dL(B1 - B2_0,L1 - L2_0,H1 - H2_0)/3600;
  H2 := dH(B1 - B2_0,L1 - L2_0,H1 - H2_0);

  B2 := B1 - (B2_0 + B2)/2;
  L2 := L1 - (L2_0 + L2)/2;
  H2 := H1 - (H2_0 + H2)/2;

end;

procedure Geo1ForceToGeo2(B1, L1, H1 : double; InputSKNumber, OutputSKNumber :Integer; var B2, L2, H2 : double);
var GeoSteps, GeoDatums:array of integer;
    InputName, OutputName, CurrentName :string;
    i :integer;
    CanProcess : boolean;


  function AlreadyInSteps (SearchingN: integer) : boolean;
  var j : integer;
  begin
     Result := false;
     For j := 0 to length(GeoSteps)-1 do
       if (GeoSteps[j] = SearchingN)
          or((TransformationList[GeoSteps[j]].InputDatumName = TransformationList[SearchingN].InputDatumName)and
           (TransformationList[GeoSteps[j]].ConvertDatumName = TransformationList[SearchingN].ConvertDatumName))
          or((TransformationList[GeoSteps[j]].InputDatumName = TransformationList[SearchingN].ConvertDatumName)and
           (TransformationList[GeoSteps[j]].ConvertDatumName = TransformationList[SearchingN].InputDatumName)) then
         begin
           Result := true;
           Break;
         end;
  end;


  function SearchResult(current_v, result_v: Integer):boolean;
  var j: integer;
      curr_sc, res_sc :integer;
      res: boolean;
  begin
     Result := false;

     For j := 0 to length(TransformationList)-1 do
     begin
        curr_sc := FindDatum(TransformationList[j].InputDatumName);  /// № входного датума для текущего эелемета массива трансформаций
        res_sc :=  FindDatum(TransformationList[j].ConvertDatumName);  /// № итогового датума для текущего эелемета массива трансформаций

        if (curr_sc = -1) or (res_sc = -1) then
          continue;

        if AlreadyInSteps(j) then
          continue;

        if curr_sc = current_v then
        begin
           SetLength(GeoSteps,length(GeoSteps)+1);        // APPEND
           GeoSteps[length(GeoSteps)-1] := j;             //
           if res_sc <> result_v then
           begin
             if SearchResult(curr_sc,result_v) = false then
             begin
                 SetLength(GeoSteps,length(GeoSteps)-1);  /// POP
             end
           end
             else
              begin
                Result := true;
                break;
              end;
        end;
     end;

  end;
begin
  try
    InputName := DatumList[InputSKNumber].Name;
    OutputName := DatumList[OutputSKNumber].Name;
  except
    exit
  end;

  SetLength(GeoSteps,0);

  CanProcess := SearchResult(InputSKNumber, OutputSKNumber);

  if CanProcess then
  begin
    SetLength(GeoDatums,length(GeoSteps)+1);
    GeoDatums[0] := InputSKNumber;

    for i := 0 to length(GeoSteps)-1 do                //// Возвращаю номера датумов из списка конвертаций
      GeoDatums[i+1] := FindDatum( TransformationList[GeoSteps[i]].ConvertDatumName);


    for i := 1 to length(GeoDatums)-1 do
    begin
       Geo1ToGeo2(B1, L1, H1, GeoDatums[i-1], GeoDatums[i], B2, L2, H2);
       B1 := B2;
       L1 := L2;
       H1 := H2;
    end;
  end;

end;

end.
