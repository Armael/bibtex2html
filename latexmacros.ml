(*
 * bibtex2html - A BibTeX to HTML translator
 * Copyright (C) 1997 Jean-Christophe FILLIATRE
 * 
 * This software is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License version 2, as published by the Free Software Foundation.
 * 
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * 
 * See the GNU General Public License version 2 for more details
 * (enclosed in the file GPL).
 *)

(* $Id: latexmacros.ml,v 1.28 2000-01-14 18:35:40 marche Exp $ *)

(* This code is Copyright (C) 1997  Xavier Leroy. *)

(* output *)

let out_channel = ref stdout
let print_s s = output_string !out_channel s
let print_c c = output_char !out_channel c

type action =
    Print of string
  | Print_arg
  | Skip_arg
  | Raw_arg of (string -> unit)
  | Recursive of string  (* phrase LaTeX � analyser r�cursivement *)

let cmdtable = (Hashtbl.create 19 : (string, action list) Hashtbl.t)

let def name action =
  Hashtbl.add cmdtable name action

let find_macro name =
  try
    Hashtbl.find cmdtable name
  with Not_found ->
    prerr_string "Unknown macro: "; prerr_endline name; [];;

(* General LaTeX macros *)

(* sectioning *)
def "\\part"
    [Print "<H0>"; Print_arg; Print "</H0>\n"];
def "\\chapter"
    [Print "<H1>"; Print_arg; Print "</H1>\n"];
def "\\chapter*"
    [Print "<H1>"; Print_arg; Print "</H1>\n"];
def "\\section"
    [Print "<H2>"; Print_arg; Print "</H2>\n"];
def "\\section*"
    [Print "<H2>"; Print_arg; Print "</H2>\n"];
def "\\subsection"
    [Print "<H3>"; Print_arg; Print "</H3>\n"];
def "\\subsection*"
    [Print "<H3>"; Print_arg; Print "</H3>\n"];
def "\\subsubsection"
    [Print "<H4>"; Print_arg; Print "</H4>\n"];
def "\\subsubsection*"
    [Print "<H4>"; Print_arg; Print "</H4>\n"];
def "\\paragraph"
    [Print "<H5>"; Print_arg; Print "</H5>\n"];

(* text formatting *)
def "\\begin{alltt}" [Print "<pre>"];
def "\\end{alltt}" [Print "</pre>"];
def "\\texttt" [Print "<tt>" ; Print_arg ; Print "</tt>"];
def "\\textit" [Print "<i>" ; Print_arg ; Print "</i>"];
def "\\textsl" [Print "<i>" ; Print_arg ; Print "</i>"];
def "\\textem" [Print "<em>" ; Print_arg ; Print "</em>"];
def "\\textrm" [Print_arg];
def "\\mathcal" [Print_arg];
def "\\textbf" [Print "<b>" ; Print_arg ; Print "</b>"];
def "\\emph" [Print "<em>" ; Print_arg ; Print "</em>"];
def "\\mbox" [Print_arg];
def "\\footnotesize" [];

(* environments *)
def "\\begin{itemize}" [Print "<p><ul>"];
def "\\end{itemize}" [Print "</ul>"];
def "\\begin{enumerate}" [Print "<p><ol>"];
def "\\end{enumerate}" [Print "</ol>"];
def "\\begin{description}" [Print "<p><dl>"];
def "\\end{description}" [Print "</dl>"];
def "\\begin{center}" [Print "<blockquote>"];
def "\\end{center}" [Print "</blockquote>"];
def "\\begin{htmlonly}" [];
def "\\end{htmlonly}" [];
def "\\begin{flushleft}" [Print "<blockquote>"];
def "\\end{flushleft}" [Print "</blockquote>"];

(* special characters *)
def "\\ " [Print " "];
def "\\\n" [Print " "];
def "\\{" [Print "{"];
def "\\}" [Print "}"];
def "\\l" [Print "l"];
def "\\oe" [Print "oe"];       (* Il n'y a pas de oe li�s en HTML *)
def "\\o" [Print "&oslash;"];
def "\\O" [Print "&Oslash;"];
def "\\ae" [Print "&aelig;"];
def "\\AE" [Print "&AElig;"];
def "\\aa" [Print "&aring;"];
def "\\AA" [Print "&Aring;"];
def "\\&" [Print "&amp;"];
def "\\%" [Print "%"];
def "\\_" [Print "_"];
def "\\copyright" [Print "(c)"];
def "\\th" [Print "&thorn;"];
def "\\TH" [Print "&THORN;"];
def "\\dh" [Print "&eth;"];
def "\\DH" [Print "&ETH;"];
def "\\ss" [Print "&szlig;"];
def "\\'" [Raw_arg(function "e" -> print_c '�'
                          | "E" -> print_c '�'
			  | "a" -> print_c '�'
			  | "A" -> print_c '�'
			  | "o" -> print_c '�'
			  | "O" -> print_c '�'
			  | "i" -> print_c '�'
                          | "\\i" -> print_c '�'
			  | "I" -> print_c '�'
			  | "u" -> print_c '�'
			  | "U" -> print_c '�'
			  | ""  -> print_c '\''
                          | s   -> print_s s)];
def "\\`" [Raw_arg(function "e" -> print_c '�'
                          | "E" -> print_c '�'
                          | "a" -> print_c '�'
                          | "A" -> print_c '�'
			  | "o" -> print_c '�'
			  | "O" -> print_c '�'
			  | "i" -> print_c '�'
                          | "\\i" -> print_c '�'
			  | "I" -> print_c '�'
                          | "u" -> print_c '�'
                          | "U" -> print_c '�'
			  | ""  -> print_c '`'
                          | s   -> print_s s)];
def "\\~" [Raw_arg(function "n" -> print_c '�'
		          | ""  -> print_c '~'
                          | s   -> print_s s)];
def "\\c" [Raw_arg(function "c" -> print_c '�'
                          | s   -> print_s s)];
def "\\u" [Raw_arg(function s   -> print_s s)];
def "\\^" [Raw_arg(function "a" -> print_c '�'
                          | "A" -> print_c '�'
                          | "e" -> print_c '�'
                          | "E" -> print_c '�'
                          | "i" -> print_c '�'
                          | "\\i" -> print_c '�'
                          | "I" -> print_c '�'
                          | "o" -> print_c '�'
                          | "O" -> print_c '�'
                          | "u" -> print_c '�'
                          | "U" -> print_c '�'
			  | ""  -> print_c '^'
                          | s   -> print_s s)];
def "\\\"" [Raw_arg(function "e" -> print_c '�'
                          | "E" -> print_c '�'
                          | "a" -> print_c '�'
                          | "A" -> print_c '�'
                          | "\\i" -> print_c '�'
                          | "i" -> print_c '�'
                          | "I" -> print_c '�'
                          | "o" -> print_c '�'
                          | "O" -> print_c '�'
                          | "u" -> print_c '�'
                          | "U" -> print_c '�'
                          | s   -> print_s s)];

(* math macros *)
def "\\leq" [Print "&lt;="];
def "\\log" [Print "log"];
def "\\geq" [Print "&gt;="];
def "\\neq" [Print "&lt;&gt;"];
def "\\circ" [Print "o"];
def "\\sim" [Print "~"];
def "\\(" [Print "<I>"];
def "\\)" [Print "</I>"];
def "\\mapsto" [Print "<tt>|-&gt;</tt>"];

(* misc. macros *)
def "\\/" [];
def "\\-" [];
def "\\smallskip" [];
def "\\medskip" [];
def "\\bigskip" [];
def "\\hskip" [];
def "\\markboth" [Skip_arg; Skip_arg];
def "\\dots" [Print "..."];
def "\\ldots" [Print "..."];
def "\\cdots" [Print "..."];
def "\\newpage" [];
def "\\hbox" [Print_arg];
def "\\noindent" [];
def "\\label" [Print "<A name=\""; Print_arg; Print "\"></A>"];
def "\\ref" [Print "<A href=\"#"; Print_arg; Print "\">(ref)</A>"];
def "\\index" [Skip_arg];
def "\\\\" [Print "<br>"];
def "\\," [];
def "\\symbol" 
  [Raw_arg (function s -> 
	      try let n = int_of_string s in print_c (Char.chr n) 
	      with _ -> ())];
			   

(* Bibliography *)
def "\\begin{thebibliography}" [Print "<H2>References</H2>\n<dl>\n"; Skip_arg];
def "\\end{thebibliography}" [Print "</dl>"];
def "\\bibitem" [Raw_arg (function r ->
  print_s "<dt><A name=\""; print_s r; print_s "\">[";
  print_s r; print_s "]</A>\n";
  print_s "<dd>")];

(* greek letters *)
List.iter (fun symbol -> def ("\\" ^ symbol) [Print ("<I>" ^ symbol ^ "</I>")])
  ["alpha";"beta";"gamma";"delta";"epsilon";"varepsilon";"zeta";"eta";
   "theta";"vartheta";"iota";"kappa";"lambda";"mu";"nu";"xi";"pi";"varpi";
   "rho";"varrho";"sigma";"varsigma";"tau";"upsilon";"phi";"varphi";
   "chi";"psi";"omega";"Gamma";"Delta";"Theta";"Lambda";"Xi";"Pi";
   "Sigma";"Upsilon";"Phi";"Psi";"Omega"];

()

let is_german_style = function
  | "gerabbrv" | "geralpha" | "gerapali" | "gerplain" | "gerunsrt" -> true
  | _ -> false

let init_style_macros st =
  if is_german_style st then begin
    Printf.printf "OK============\n";
    List.iter (fun (m,s) -> def m [ Print s; Print_arg ])
      [ "\\btxetalshort", "et al" ;
	"\\btxeditorshort", "Hrsg";
	"\\Btxeditorshort", "Hrsg";
	"\\btxeditorsshort", "Hrsg";
	"\\Btxeditorsshort", "Hrsg";
	"\\btxvolumeshort", "Bd";
	"\\Btxvolumeshort", "Bd";
	"\\btxnumbershort", "Nr";
	"\\Btxnumbershort", "Nr";
	"\\btxeditionshort", "Aufl";
	"\\Btxeditionshort", "Aufl";
	"\\btxchaptershort", "Kap";
	"\\Btxchaptershort", "Kap";
	"\\btxpageshort", "S";
	"\\Btxpageshort", "S";
	"\\btxpagesshort", "S";
	"\\Btxpagesshort", "S";
	"\\btxtechrepshort", "Techn. Ber";
	"\\Btxtechrepshort", "Techn. Ber";
	"\\btxmonjanshort", "Jan";
	"\\btxmonfebshort", "Feb";
	"\\btxmonaprshort", "Apr";
	"\\btxmonaugshort", "Aug";
	"\\btxmonsepshort", "Sep";
	"\\btxmonoctshort", "Okt";
	"\\btxmonnovshort", "Nov";
	"\\btxmondecshort", "Dez";
      ];
    List.iter (fun (m,s) -> def m [ Skip_arg; Print s])
      [ "\\btxetallong", "et alii";
	"\\btxandshort", "und"; 
	"\\btxandlong", "und";
	"\\btxinlong", "in:"; 
	"\\btxinshort", "in:";
	"\\btxofseriesshort", "d. Reihe";
	"\\btxinseriesshort", "in"; 
	"\\btxofserieslong", "der Reihe";
	"\\btxinserieslong", "in";
	"\\btxeditorlong", "Herausgeber";
	"\\Btxeditorlong", "Herausgeber";
	"\\btxeditorslong", "Herausgeber";
	"\\Btxeditorslong", "Herausgeber";
	"\\btxvolumelong", "Band";
	"\\Btxvolumelong", "Band";
	"\\btxnumberlong", "Nummer";
	"\\Btxnumberlong", "Nummer";
	"\\btxeditionlong", "Auflage";
	"\\Btxeditionlong", "Auflage";
	"\\btxchapterlong", "Kapitel";
	"\\Btxchapterlong", "Kapitel";
	"\\btxpagelong", "Seite";
	"\\Btxpagelong", "Seite";
	"\\btxpageslong", "Seiten";
	"\\Btxpageslong", "Seiten";
	"\\btxmastthesis", "Diplomarbeit";
	"\\btxphdthesis", "Doktorarbeit";
	"\\btxtechreplong", "Technischer Bericht";
	"\\Btxtechreplong", "Technischer Bericht";
	"\\btxmonjanlong", "Januar";
	"\\btxmonfeblong", "Februar";
	"\\btxmonmarlong", "M�rz";
	"\\btxmonaprlong", "April";
	"\\btxmonmaylong", "Mai";
	"\\btxmonjunlong", "Juni";
	"\\btxmonjullong", "Juli";
	"\\btxmonauglong", "August";
	"\\btxmonseplong", "September";
	"\\btxmonoctlong", "Oktober";
	"\\btxmonnovlong", "November";
	"\\btxmondeclong", "Dezember";
	"\\btxmonmarshort", "M�rz";
	"\\btxmonmayshort", "Mai";
	"\\btxmonjunshort", "Juni";
	"\\btxmonjulshort", "Juli";
	"\\Btxinlong", "In:";
	"\\Btxinshort", "In:";
      ]
  end

