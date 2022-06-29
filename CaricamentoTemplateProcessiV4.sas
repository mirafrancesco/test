

* Caricamento Template Processi;
libname temp xlsx "C:\Ratio\CatenaProcessi_CSTGEST_2022-06-22.xlsx";

data contesti; set temp.contesti; run; * Chiave di aggiornamento è il contesto stesso;
data catene; set temp.catene; run;* Chiave di aggiornamento è contesto catena;
data processi; set temp.processi; run;* Chiave di aggiornamento è contesto processo;
data input; set temp.input; run;* Chiave di aggiornamento è contesto catena;
data output; set temp.output; run;* Chiave di aggiornamento è contesto catena;
data parametri; set temp.parametri; run;* Chiave di aggiornamento è contesto set;
data profili; set temp.profili; run;* Chiave di aggiornamento è contesto profilo;
data scenari; set temp.scenari; run;* Chiave di aggiornamento è contesto scenario;


data work.ORCH_CONTESTI;
   attrib
      c_Contesto    length=$32   label="Contesto"
   ;
   set contesti;
   c_Contesto=Contesto;
   keep c_: ;
run;

data work.ORCH_PROFILI;
   attrib
      c_Contesto    length=$32   label="Contesto"
      c_Profilo     length=$32   label="Profilo"
      c_Ruolo       length=$32   label="Ruolo"
   ;
   set profili;
   c_Contesto=Contesto;
   c_Profilo=Profilo;
   c_Ruolo=Ruolo;
   keep c_: ;
run;

data work.ORCH_PROCESSI;
   attrib
      c_Contesto    length=$32   label="Contesto"
      c_Processo    length=$32   label="Processo"
      x_Processo    length=$256  label="Nome Processo"
      x_Shell       length=$256  label="Script Shell Processo"
      n_Peso        length=8     label="Peso processo"
   ;
   set processi;
   c_Contesto=Contesto;
   c_Processo=Processo;
   x_Processo=Nome;
   x_Shell=Shell;
   n_Peso=Peso;
   keep c_: x_: n_: ;
run;

data work.ORCH_CATENE;
   attrib
      c_Contesto        length=$32   label="Contesto"
      c_Catena          length=$32   label="Catena"
      c_Fase            length=$32   label="Fase"
      c_Processo        length=$32   label="Processo"
      f_PntVerifica     length=$1    label="Flag S/N Punto di Verifica"
      f_PntConsistenza  length=$1    label="Flag S/N Punto di Consistenza"
      f_Esclusivo       length=$1    label="Flag S/N Processo Esclusivo"
   ;
   set Catene;
   c_Contesto=Contesto;
   c_Catena=Catena;
   c_Fase=Fase;
   c_Processo=Processo;
   f_PntVerifica=upcase(Verifica);
   f_PntConsistenza=upcase(Consistenza);
   f_Esclusivo=upcase(Esclusivo);
   if f_PntVerifica='X' then f_PntVerifica='S'; if f_PntVerifica ne 'S' then f_PntVerifica='N';
   if f_PntConsistenza='X' then f_PntConsistenza='S'; if f_PntConsistenza ne 'S' then f_PntConsistenza='N';
   if f_Esclusivo='X' then f_Esclusivo='S'; if f_Esclusivo ne 'S' then f_Esclusivo='N';
   keep c_: f_: ;
run;

data work.ORCH_SCENARI;
   attrib
      c_Contesto    length=$32   label="Contesto"
      c_Scenario    length=$32   label="Scenario"
      n_Ordine      length=8     label="N. ordine"
   ;
   set Scenari;
   c_Contesto=Contesto;
   c_Scenario=Scenario;
   n_Ordine=1;
   keep c_: n_: ;
run;

data work.ORCH_INPUT;
   attrib
      c_Contesto        length=$32   label="Contesto"
      c_Catena          length=$32   label="Catena"
      c_Fase            length=$32   label="Fase"
      c_Processo        length=$32   label="Processo"
      x_Input           length=$256  label="Input"
      c_TipoInput       length=$32   label="Tipo Input"
   ;
   set Input;
   c_Contesto=Contesto;
   c_Catena=Catena;
   c_Fase=Fase;
   c_Processo=Processo;
   x_Input=Input;
   c_TipoInput=Tipo;
   keep c_: x_: ;
run;

data work.ORCH_OUTPUT;
   attrib
      c_Contesto        length=$32   label="Contesto"
      c_Catena          length=$32   label="Catena"
      c_Fase            length=$32   label="Fase"
      c_Processo        length=$32   label="Processo"
      x_Output          length=$256  label="Output"
      c_TipoOutput      length=$32   label="Tipo Output"
   ;
   set Output;
   c_Contesto=Contesto;
   c_Catena=Catena;
   c_Fase=Fase;
   c_Processo=Processo;
   x_Output=Output;
   c_TipoOutput=Tipo;
   keep c_: x_: ;
run;

data work.ORCH_PARAMETRI;
   attrib
      c_Contesto        length=$32   label="Contesto"
      c_SetParametri    length=$32   label="Set Parametri"
      c_Run             length=$32   label="Run"
      c_Scenario        length=$32   label="Scenario"
      c_Chiave          length=$32   label="Chiave"
      x_Chiave          length=$80   label="Desc. Chiave"
      c_Type            length=$32   label="Tipo dati"
      c_Dominio         length=$256  label="Dominio"
      x_Valore          length=$256  label="Valore"
      f_Business        length=$1    label="Flag S/N Utente Business"
   ;
   set Parametri;
   c_Contesto=Contesto;
   c_SetParametri=Set;
   c_Run=Run;
   c_Scenario=Scenario;
   c_Chiave=Chiave;
   x_Chiave=label;
   c_Type=Tipo;
   c_Dominio=Dominio;
   x_Valore=Valore;
   if c_Scenario="Tutti" then c_Scenario=" Tutti";
   if c_Dominio="0,2" then c_Dominio="0,1,2";
   if c_Dominio="1,3" then c_Dominio="1,2,3";
   if Business="P" then f_Business="S"; else f_Business="N";
   keep c_: x_: f_: ;
   *c_Run="Gest1";
   *c_Run="Gest2";
run;




* inserimento con Controlli;


%MACRO UPDATE( DSIN=work.ORCH_PARAMETRI, TBOUT=Orch.ORCH_PARAMETRI, WHR=%STR(and a.c_SetParametri=b.c_SetParametri) );

   * Controllo chiavi missing;
   data ds1;
      set &DSIN;
      array _c c_: ;
      tieni=0;
      do over _c; if _c ne ' ' then tieni=1; end;
      if tieni=0 then delete;
      drop tieni;
   run;

   * Controllo esistenza chiave contesto;
   proc sql noprint;
      create table ds2 as select *
      from ds1
      where c_Contesto in (select c_contesto from work.ORCH_CONTESTI)
      %IF %INDEX(&WHR, Catena) %THEN %DO;
      and c_Catena in (select c_Catena from work.ORCH_CATENE)
      %END;
      ;
   quit;

   * Eliminazione record da inserire nel DB;
   proc sql;
      delete from &TBOUT a
      where exists(select 1 from ds2 b where a.c_Contesto=b.c_Contesto &WHR);
   quit;

   * Inserimento record nel DB;
   proc sql;
      insert into &TBOUT
      select * from  ds2;
   quit;

%MEND UPDATE;


%UPDATE( DSIN=work.ORCH_CONTESTI , TBOUT=Orch.ORCH_CONTESTI , WHR= );
%UPDATE( DSIN=work.ORCH_CATENE   , TBOUT=Orch.ORCH_CATENE   , WHR=%STR(and a.c_Catena=b.c_Catena) );
%UPDATE( DSIN=work.ORCH_PROCESSI , TBOUT=Orch.ORCH_PROCESSI , WHR=%STR(and a.c_Processo=b.c_Processo) );
%UPDATE( DSIN=work.ORCH_INPUT    , TBOUT=Orch.ORCH_INPUT    , WHR=%STR(and a.c_Catena=b.c_Catena and a.c_processo=b.c_processo and a.x_input=b.x_input) );
%UPDATE( DSIN=work.ORCH_OUTPUT   , TBOUT=Orch.ORCH_OUTPUT   , WHR=%STR(and a.c_Catena=b.c_Catena and a.c_processo=b.c_processo and a.x_output=b.x_output) );
%UPDATE( DSIN=work.ORCH_PARAMETRI, TBOUT=Orch.ORCH_PARAMETRI, WHR=%STR(and a.c_SetParametri=b.c_SetParametri and a.c_Run=b.c_Run and a.c_Scenario=b.c_Scenario and a.c_Chiave=b.c_Chiave) );
%UPDATE( DSIN=work.ORCH_PROFILI  , TBOUT=Orch.ORCH_PROFILI  , WHR=%STR(and a.c_Profilo=b.c_Profilo) );
%UPDATE( DSIN=work.ORCH_SCENARI  , TBOUT=Orch.ORCH_SCENARI  , WHR=%STR(and a.c_Scenario=b.c_Scenario) );

