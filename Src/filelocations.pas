unit FileLocations;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  PtrFileObject = ^FileObject;
  FileObject = record
    Name      : String;
    Location  : String;
    Counter   : Integer;  // Needed for the most recent used list.
    FileDate  : TDateTime;
  end;
  AllFileObjects = array of  FileObject;

implementation

end.

