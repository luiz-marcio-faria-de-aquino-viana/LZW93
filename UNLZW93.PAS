
program UnLZW93;

const
  FirstCode = $0100;
  LastCode  = $ffff;

type
  TypeKey     = byte;
  TypeCode    = word;
  TypePointer = ^TypeElement;
  TypeElement =
    record
      NextElement   : TypePointer;
      PrefixElement : TypePointer;
      KeyOfElement  : TypeKey;
      CodeOfElement : TypeCode;
    end;

var
  SourceFileName : string;
  TargetFileName : string;
  SourceFilePointer : file of TypeCode;
  TargetFilePointer : file of TypeKey;

procedure InsertNewElement(var PointerToPrevious, PointerToPrefix : TypePointer;
                           KeyToElement : TypeKey; CodeToElement : TypeCode);
var
  PointerToNew : TypePointer;
begin
  New(PointerToNew);
  with PointerToNew^ do
    begin
      NextElement   := PointerToPrevious;
      PrefixElement := PointerToPrefix;
      KeyOfElement  := KeyToElement;
      CodeOfElement := CodeToElement;
    end;
  PointerToPrevious := PointerToNew;
end;

function SearchElement(PointerToPrevious : TypePointer; CodeToElement : TypeCode) : TypePointer;
var
  StopSearch : boolean;
begin
  StopSearch := False;
  repeat
    if PointerToPrevious = Nil then
      StopSearch := True
    else
      if PointerToPrevious^.CodeOfElement = CodeToElement then
        StopSearch := True
      else
        PointerToPrevious := PointerToPrevious^.NextElement;
  until StopSearch;
  SearchElement := PointerToPrevious;
end;

function SearchFirstElement(PointerToElement : TypePointer) : TypePointer;
begin
  while not(PointerToElement^.PrefixElement = Nil) do
    PointerToElement := PointerToElement^.PrefixElement;
  SearchFirstElement := PointerToElement;
end;

procedure UserStartedInformation;
begin
  Writeln;
  Writeln('              UnLZW93  Vr1.10 - 06/16/93             ');
  Writeln('CopyRight (C) 1993, TML Software. All Right Reserved.');
  Writeln;
  Write('Descompressing file... ');
end;

procedure UserFinishedInformation;
begin
  Writeln('Ok!');
end;

procedure GetNamesOfFiles;
begin
  SourceFileName := ParamStr(1);
  TargetFileName := ParamStr(2);
end;

procedure OpenFiles;
begin
  Assign(SourceFilePointer, SourceFileName);
  Reset(SourceFilePointer);
  Assign(TargetFilePointer, TargetFileName);
  Rewrite(TargetFilePointer);
end;

procedure CloseFiles;
begin
  close(SourceFilePointer);
  close(TargetFilePointer);
end;

procedure WriteStringInFile(ElementToSave : TypePointer);
var
  NextToSave : TypePointer;
  PointerToElement : TypePointer;
begin
  NextToSave := Nil;
  repeat
    PointerToElement := ElementToSave;
    while not(PointerToElement^.PrefixElement = NextToSave) do
      PointerToElement := PointerToElement^.PrefixElement;
    Write(TargetFilePointer, PointerToElement^.KeyOfElement);
    NextToSave := PointerToElement;
  until NextToSave = ElementToSave;
end;

procedure MainProcedure;
var
  PointerToFirst : TypePointer;
  PointerToPrefix : TypePointer;
  PointerToFirstKey : TypePointer;
  PointerToElement : TypePointer;
  PointerNull : TypePointer;
  NextCode : TypeCode;
  DataCode : TypeCode;
  DataKey : TypeKey;
begin
  PointerNull := Nil;
  PointerToFirst := Nil;
  PointerToPrefix := Nil;
  NextCode := FirstCode;
  if not Eof(SourceFilePointer) then
    begin
      Read(SourceFilePointer, DataCode);
      DataKey := Lo(DataCode);
      InsertNewElement(PointerToFirst, PointerNull, DataKey, DataCode);
      Write(TargetFilePointer, DataKey);
      PointerToPrefix := PointerToFirst;
      while not Eof(SourceFilePointer) do
        begin
          Read(SourceFilePointer, DataCode);
          DataKey := Lo(DataCode);
          PointerToElement := SearchElement(PointerToFirst, DataCode);
          if PointerToElement = Nil then
            if DataCode < FirstCode then
              begin
                Write(TargetFilePointer, DataKey);
                InsertNewElement(PointerToFirst, PointerToPrefix, DataKey, NextCode);
                Inc(NextCode);
                InsertNewElement(PointerToFirst, PointerNull, DataKey, DataCode);
                PointerToPrefix := PointerToFirst;
              end
            else
              begin
                PointerToFirstKey := SearchFirstElement(PointerToPrefix);
                InsertNewElement(PointerToFirst, PointerToPrefix, PointerToFirstKey^.KeyOfElement, NextCode);
                PointerToPrefix := PointerToFirst;
                WriteStringInFile(PointerToPrefix);
                Inc(NextCode);
              end
          else
            begin
              WriteStringInFile(PointerToElement);
              PointerToFirstKey := SearchFirstElement(PointerToElement);
              InsertNewElement(PointerToFirst, PointerToPrefix, PointerToFirstKey^.KeyOfElement, NextCode);
              PointerToPrefix := pointerToElement;
              Inc(NextCode);
            end;
        end;
    end;
end;

begin
  GetNamesOfFiles;
  OpenFiles;
  UserStartedInformation;
  MainProcedure;
  UserFinishedInformation;
  CloseFiles;
end.
