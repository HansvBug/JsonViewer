unit ResourceStrings;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

resourcestring
  // Form captions
  rsFormMain      = 'Json Viewer';
  rsFormConfigure = 'Options';  // Instellingen

  //
  rsError = 'Error.';                // 'Fout.'
  rsErrorMessage = 'Error message:'; // 'Foutmelding:'
  rsWarning      = 'Warning.';       // 'Waarschuwing.';


  // Form main

  rsFormatjsonText     = 'Format the Json text.';    // Formateer de Json tekst.
  rsSaveJsontext       = 'Save the Json text.' ;     // Sla de Json tekst op.
  rsClearTrvAndMemo    = 'Clear treeview and memo.'; // 'Maak treeview en memo leeg.'
  rsCloseProgram       = 'Close the program.';       // 'Sluit het programma.'
  rsOpenFileDlgTitle   = 'Open a Json file';         // 'Open een Json bestand'

  rsFile               = 'File: ';                   // 'Bestand: '
  rsNotFound           = ' was not found.';          // ' is niet gevonden.'
  rsMessage            = 'Message:';                 // 'Melding:'
  rsSaveAsJsonFile     = 'Save as Json file.';       // 'Opslaan als Json bestand.'
  rsSaving             = 'Saving...';                // 'Bezig met opslaan...'
  rsReady              = 'Ready.';                   // 'Gereed.'
  rsFileDoesNotExists  = 'The file does not exist.'; // 'Het bestand bestaat niet.'
  rsRemoveFileFromList = 'Remove the file from the menu list?';          //'Het bestand uit de menulijst halen?'
  rsOverwritetext      = 'Do you want to overwrite the existing text?';  // 'Wilt u de bestaande tekst overschrijven?'

  // Form configure
  rsActivateLogging  = 'Activate the log functionality.';                       // 'Activeer de log functionaliteit.'
  rsAppendLogFile    = 'Append existing log file.';                             // 'Vul het bestaande logbestand aan.'
  rsShowHelpText     = 'Show help text when the mouse moves over a component.'; // 'Toon hulpteksen als de muis over een component beweegt.'
  rsHighLightTrvNode = 'Highlight treeview node under mouse pointer.';          // 'Oplichten treeview node onder de muis aanwijzer.'

  // ApplicationEnvironment
  rsMissingFolderWriteRights = 'You do not have write permissions in the folder.'; // 'U heeft geen schrijfrechten in de map.'
  rsCreateSettngsFileFaild   = 'Creating the settings file failed.';               // 'Het maken van het settings bestand is mislukt.'


  // JsonFormatter
  rsBussyFormatingJson = 'Opening and formatting the Jsonfile...';              // 'Bezig met het openen en formateren van de Jsonfile...'
  rsFormatJsonFailed   = 'Formatting the json file failed.';                    // 'Het formateren van het json bestand is mislukt.'

  // Logging
  rsLogInfoAbortLogging   = 'INFORMATION | After 10 attempts, saving to the log file was aborted.';   // 'INFORMATIE | Na 10 pogingen is het opslaan in het logbestand afgebroken.'
  rsLogProgram            = ' Program: ';                                                             // ' Programma: '
  rsLogVersion            = ' Version: ';                                                             // ' Versie   : '
  rsLogDate               = ' Date   : ';                                                             // ' Datum    : '
  rsLogErrStartLogging    = 'ERROR | Unexpected error occurred when starting the logging procedure.'; // 'FOUT      | Onverwachte fout opgetreden bij de opstart van de logging procedure.'
  rsLogProgram_1          = ' Program ';                                                              // ' Programma '
  rsLogIsSaved            = ' is closed';                                                             // ' is afgesloten'
  rsLogInformation        = ' : INFORMATION | ';                                                      // ' : INFORMATIE   | '
  rsLogWarning            = ' : WARNING     | ';                                                      // ' : WAARSCHUWING | '
  rsLogDebug              = ' : DEBUG       | ';                                                      // ' : DEBUG        | '
  rsLogError              = ' : ERROR       | ';                                                      // ' : FOUT         | '



  // SettingsManager
  rsIsReady            = ' is ready.';                                //' is gereed.'
  rsHasFailed          = ' has failed.';                              //' is mislukt.'
  rsGetScreenPos       = 'Ophalen schermpositie van : ';              //'Ophalen schermpositie van : '
  rsStoreScreenPos     = 'Save screen position of : ';                //'Opslaan schermpositie van : '
  rsStoreMruError      = 'Error saving recently opened files list.';  //'Fout bij het opslaan van de recent geopende bestanden lijst.'
  rsGetMruError        = 'Error reading recently opened files list.'; //'Fout bij het ophalen van de recent geopende bestanden lijst.'

implementation

end.

