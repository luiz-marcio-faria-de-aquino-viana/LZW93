
{ CopyRight (C) 1993, TML Software Inc. All Right Reserved. }

program LZW93;

uses Crt;

const
  FirstCode = $0100;
  LastCode  = $ffff;

type
  TypeKey     = byte;
  TypeCode    = word;
  TypePointer = ^TypeElement;
  TypeElement =
    record
      NextList      : TypePointer;    { Pointer to the First Element
                                        in the Next List.            }
      KeyOfElement  : TypeKey;
      CodeOfElement : TypeCode;
      NextElement   : TypePointer;    { Pointer to the Next Element in
                                        The current List.            }
    end; { End TypeElement }

{ Structure Element
 -------------------

  TypeElement

        +-+---+---+-+
        | |   |   | |
        +-+---+---+-+
         |  |   |  |
         |  |   |  +------------------ NextElement
         |  |   +------------- CodeOfElement
         |  +----------- KeyOfElement
         +-------- NextList

}

{  List Example
  --------------

    PointerToFirst
    -------------+
                 |  +-+--+-+  +-+--+-+  +-+--+-+  +-+--+-+
                 +--|*|  |*|--|*|  |*|--|*|  |*|--|*|  |*|--+
                    +-+--+-+  +-+--+-+  +-+--+-+  +-+--+-+  |
                     |         |         |         |        |
                     |         |         |        Nil      Nil
                     |         |         |
                     |         |        +-+--+-+  +-+--+-+
                     |         |        |*|  |*|--|*|  |*|--+
                     |         |        +-+--+-+  +-+--+-+  |
                     |         |         |         |        |
                     |         |        Nil       Nil      Nil
                     |         |
                     |        +-+--+-+  +-+--+-+
                     |        |*|  |*|--|*|  |*|--+
                     |        +-+--+-+  +-+--+-+  |
                     |         |         |        |
                     |        Nil        |       Nil
                     |                   |
                     |                  +-+--+-+
                     |                  |*|  |*|--+
                     |                  +-+--+-+  |
                     |                   |        |
                     |                  Nil      Nil
                     |
                    +-+--+-+  +-+--+-+  +-+--+-+
                    |*|  |*|--|*|  |*|--|*|  |*|--+
                    +-+--+-+  +-+--+-+  +-+--+-+  |
                     |         |         |        |
                    Nil       Nil       Nil      Nil
}

var
{ Declaration of Global Variables }
  SourceFileName : string;              { Name of Source File }
  TargetFileName : string;              { Name of Targeet File }
  SourceFilePointer : file of TypeKey;  { Pointer to Buffer of Source File
                                          This is a TypeKey Buffer        }
  TargetFilePointer : file of TypeCode; { Pointer to Buffer of Target File
                                          This is a TypeCode Buffer       }

procedure BeginNewList(var PointerToPrevious : TypePointer; KeyToElement : TypeKey;
                       CodeToElement : TypeCode);
{ Begin a New List with an New Inserted Element }
var
  PointerToNewElement : TypePointer;
begin
  New(PointerToNewElement);
  with PointerToNewElement^ do
    begin
      NextList      := Nil;
      KeyOfElement  := KeyToElement;
      CodeOfElement := CodeToElement;
      NextElement   := Nil;
    end;
  PointerToPrevious := PointerToNewElement;
end; { End BeginNewList }

procedure InsertNewElement(var PointerToPrevious : TypePointer; KeyToElement : TypeKey;
                           CodeToElement : TypeCode);
{ Insert a New Element on the Top of the List }
var
  PointerToNewElement : TypePointer;
begin
  New(PointerToNewElement);
  with PointerToNewElement^ do
    begin
      NextList      := Nil;
      KeyOfElement  := KeyToElement;
      CodeOfElement := CodeToElement;
      NextElement   := PointerToPrevious;
    end;
  PointerToPrevious := PointerToNewElement;
end; { End InsertNewElement }

procedure UserStartedInformation;
{ Write Started Information on the Screen }
begin
  Writeln;
  Writeln('               LZW93  Vr1.10 - 06/08/93              ');
  Writeln('CopyRight (C) 1993, TML Software. All Right Reserved.');
  Writeln;
  Write('Compressing file... ');
end; { End UserScreenInterface }

procedure UserFinishedInformation;
{ Write Finished Information About Compresion on the Screen }
begin
  Writeln('Ok!');
end; { End UserFinishedInformation }

function SearchElement(PointerToElement : TypePointer; KeyToSearch : TypeKey) : TypePointer;
{ Search Element on the List }
var
  StopSearch : boolean;
begin
  StopSearch := False;
  repeat
    if PointerToElement = Nil then
      StopSearch := True
    else
      if PointerToElement^.KeyOfElement = KeyToSearch then
        StopSearch := True
      else
        PointerToElement := PointerToElement^.NextElement;
  until StopSearch;
  SearchElement := PointerToElement;
end; { End SearchElement }

procedure GetNamesOfFiles;
{ Get Names of Files in Command Line and
  Verify If these Files Exist.           }
begin
  SourceFileName := ParamStr(1);
  TargetFileName := ParamStr(2);
end;

procedure OpenFiles;
{ Open Files for Use }
begin
  Assign(SourceFilePointer, SourceFileName);
  Reset(SourceFilePointer);
  Assign(TargetFilePointer, TargetFileName);
  Rewrite(TargetFilePointer);
end; { End OpenFiles }

procedure CloseFiles;
{ Close Files in Use }
begin
  Close(SourceFilePointer);
  Close(TargetFilePointer);
end; { End CloseFiles }

function ConversionKeyToCode(Key : TypeKey) : TypeCode;
{ Conversion TypeKey To TypeCode }
begin
  ConversionKeyToCode := word(Key);
end; { End ConversionKeyToCode }

procedure MainProcedure;
{ Main Procedure of this Program }
var
  PointerToFirst : TypePointer;      { Pointer to First Element on the List }
  PointerToElement : TypePointer;
  PointerToNext : TypePointer;
  DataKey : TypeKey;
  DataCode : TypeCode;
  NextCode : TypeCode;
begin
  PointerToFirst := Nil;
  NextCode := FirstCode;

  if not Eof(SourceFilePointer) then
    { If Source File have an Element }
    begin
      Read(SourceFilePointer, DataKey);          { Read the First Element }
      DataCode := ConversionKeyToCode(DataKey);

      repeat
        PointerToElement := SearchElement(PointerToFirst, DataKey);
        if PointerToElement = Nil then
          { If Element Read isn't in the List }
          begin
            InsertNewElement(PointerToFirst, DataKey, DataCode);
            PointerToElement := PointerToFirst;  { Pointer To New Element }
          end;
        PointerToNext := PointerToElement;
        while not Eof(SourceFilePointer) and not(PointerToNext = Nil) do
          begin
            Read(SourceFilePointer, DataKey);      { Read the Next Element }
            DataCode := ConversionKeyToCode(DataKey);

            PointerToNext := PointerToElement^.NextList;
            if PointerToNext = Nil then
              { If This Element not have a SubList ...}
              BeginNewList(PointerToElement^.NextList, DataKey, NextCode)
              { Start a SubList There }
            else
            { If This Element have a SubList ...}
            begin
                PointerToNext := SearchElement(PointerToElement^.NextList, DataKey);
                if PointerToNext = Nil then
                  { If Read Element isn't in the List ...}
                  InsertNewElement(PointerToElement^.NextList, DataKey, NextCode)
                  { Insert There in List }
                else
                  { If Read Element is in the List ...}
                  PointerToElement := PointerToNext;
                  { Get Your Pointer }
              end;
          end;
        Write(TargetFilePointer, PointerToElement^.CodeOfElement);
        Inc(NextCode);
      until Eof(SourceFilePointer);

      if PointerToNext = Nil then
        Write(TargetFilePointer, DataCode);
    end;
end; { End MainProcedure }

{ Main Program }
begin
  GetNamesOfFiles;
  OpenFiles;
  UserStartedInformation;
  MainProcedure;
  UserFinishedInformation;
  CloseFiles;
end.
