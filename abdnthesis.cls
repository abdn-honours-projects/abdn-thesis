%% abdnthesis Class for LaTeX2e.

%% Original version
%% 8th March 2001, Tim Norman <tnorman@csd.abdn.ac.uk>
%%
%% Latest update 2013-08-11
%%

%% Guidelines for using this class are included in the bundled example.

%% Notes:
%%
%% o Pages are numbered in arabic numerals starting with the title page,
%%   but the page number is not shown on the title page.
%%
%% o The preface normally consists of the following sections in the
%%   following order
%%   (a) Title Page
%%   (b) Declaration
%%   (c) Abstract
%%   (d) Acknowledgements
%%   (e) Table of contents, list of tables and list of figures
%%
%% o One and a half spacing is the default.


\def \fileversion{2.3}
\def \filedate{2013/08/11}

\newcommand \@doctor{Doctor of Philosophy}
\newcommand \@masterphil{Master of Philosophy}
\newcommand \@mastersci{Master of Science}
\newcommand \@bachelor{Bachelor of Science}
\newcommand \@degree@string{\@doctor}

% This is used to specify the department/school of the student
\def\school#1{\gdef\@school{#1}}

% Declare and initialise boolean indicating whether or not the title
% should fit into the window used Bachelor and Master degree
% bindings.
\newif\iftitleboxp
\titleboxpfalse
% Some BSc and MSc theses are structured in two parts: the report and the 
% code. Not relevant for PhD/MPhil.
\def\partof#1#2{\gdef\@thepart{#1}\gdef\@numofparts{#2}}

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{abdnthesis}[\filedate\space\fileversion\space ABDN Thesis Class]

\RequirePackage{ifpdf}
% Used to set line spacing given options of single, double or 1.5 (default)
\RequirePackage{setspace}
\newif\ifsinglesp@
\newif\ifdoublesp@
\doublesp@false

\DeclareOption{singlespace}{\singlesp@true}
\DeclareOption{doublespace}{\doublesp@true}
\DeclareOption{bsc}{%
    \renewcommand\@degree@string{\@bachelor}
    \titleboxptrue}
\DeclareOption{BSc}{%
    \renewcommand\@degree@string{\@bachelor}
    \titleboxptrue}
\DeclareOption{msc}{%
    \renewcommand\@degree@string{\@mastersci}
    \titleboxptrue}
\DeclareOption{MSc}{%
    \renewcommand\@degree@string{\@mastersci}
    \titleboxptrue}
\DeclareOption{mphil}{%
    \renewcommand\@degree@string{\@masterphil}}
\DeclareOption{MPhil}{%
    \renewcommand\@degree@string{\@masterphil}}
\DeclareOption{phd}{%
    \renewcommand\@degree@string{\@doctor}}
\DeclareOption{PhD}{%
    \renewcommand\@degree@string{\@doctor}}
\DeclareOption{twocolumn}{%
    \ClassError{abdnthesis}{Option `twocolumn' not supported}{}}

% Options: we can only print on A4 paper, so disable all other sizes
\DeclareOption{a5paper}{\OptionNotUsed}
\DeclareOption{letterpaper}{\OptionNotUsed}
\DeclareOption{legalpaper}{\OptionNotUsed}
\DeclareOption{executivepaper}{\OptionNotUsed}
\DeclareOption{draft}{\OptionNotUsed}
\DeclareOption{final}{\OptionNotUsed}
\DeclareOption{notitlepage}{\OptionNotUsed}

% Computer Modern for everything option.
\newif\ifcmallp@
\cmallp@false
\DeclareOption{cmall}{\cmallp@true}

% Computer Modern maths font option.
% If you want to use Computer Modern as the maths font, use this option.
\newif\ifcmmathp@
\cmmathp@false
\DeclareOption{cmmath}{\cmmathp@true}

% Parts option
\newif\ifpartsp@
\partsp@false
\DeclareOption{parts}{\partsp@true}

\ProcessOptions

% For some bizarre reason UoA specifies the use of 12pt font and doublespacing. 
% Given all other typesetting requirements, this looks terrible, so 11pt and 1.5 
% spacing is used as default here (nobody has complained yet!). The betterlayout
% option previously defined has been deprecated. 
\PassOptionsToClass{a4paper,11pt,onecolumn,oneside}{book}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions
\LoadClass{book}

% Graphicsx with support for pdflatex
\ifpdf%
        \RequirePackage[pdftex]{graphicx}
\else%
        \RequirePackage[dvips]{graphicx}
\fi%

%% Disallow page breaks at hyphens (this will give some underfull vboxs,
%% so an alternative is to use \brokenpenalty=100 and manually search
%% for and fix such page breaks)
\brokenpenalty=10000

%% Set up line spacing
\AtBeginDocument{%
\ifdoublesp@%
  \doublespacing%
\else\ifsinglesp@%
  \singlespacing%
\else%
  \onehalfspacing%
\fi%
\fi
}

%% Page size and margins.
\setlength \paperheight {297mm}%  842pt almost exactly.
\setlength \paperwidth  {210mm}%  595pt plus a very small fraction.
%\setlength \hoffset {-60\p@}
%\setlength \voffset {-60\p@}
\setlength \marginparwidth {30\p@}
\setlength \textwidth {150mm}
\setlength \textheight {245mm}
\setlength \topmargin {-30pt}
\setlength \oddsidemargin {10mm}
\setlength \evensidemargin {10mm}

% Some other fixes to lengths 
\setlength \parindent{2em}
\setlength \parskip  {\z@ \@plus 1\p@}
\setlength \headsep  {16\p@}
\ifcase \@ptsize
    \setlength \footskip{28\p@}
\or
    \setlength \footskip{29\p@}
\or
    \setlength \footskip{30\p@}
\fi
\setlength \partopsep {\z@}
\tolerance 1200
\vfuzz 2pt
\hfuzz 2pt
\flushbottom
\renewcommand \footnoterule {%
    \kern -3\p@%
    \hrule%
    \kern 2.6\p@%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set up mandatory and optional author variables with the * version
% being mandatory.

% Do the branching between * and normal version
\newcommand{\DeclareAuthorVariable}{%
  \@ifstar{\ting@DeclareAuthorVariable{\ting@mandatory@var}}
          {\ting@DeclareAuthorVariable{\ting@optional@var}}%
}

% The main command; the internal version of \foo is \ting@foo
% The macro \ting@foo is initialized to give an error or an info
% message when used, so if the user doesn't provide a value for a
% mandatory variable, we'll catch the issue. I also need to be able to
% branch according to whether a vaiable has been given a value or not.
\newcommand{\ting@DeclareAuthorVariable}[2]{%
  \@namedef{ting@#2}{#1{#2}}%
  \@namedef{#2}##1{\@namedef{ting@#2}{##1}\@namedef{ting@#2@defined}{}}%
}
\newcommand{\@ifauthorvariable}[3]{\@ifundefined{ting@#1@defined}{#3}{#2}}

% The error and info messages
\newcommand{\ting@mandatory@var}[1]{%
  \ClassError{ting}
    {Missing value for mandatory variable
     \expandafter\string\csname#1\endcsname}
    {You have to provide a value with
     \expandafter\string\csname#1\endcsname{...}}%
}
\newcommand{\ting@optional@var}[1]{%
  \ClassInfo{ting}
    {Missing value for optional variable
     \expandafter\string\csname#1\endcsname}%
}

%%% Define the optional qualifications variable
\DeclareAuthorVariable{qualifications}

% Some may prefer Computer Modern; use the cmall option for this
\ifcmallp@\else%
    % Use the cmmath option for times for text and Computer Modern for
    % all maths
    \ifcmmathp@% 
        \renewcommand\rmdefault{ptm}
    \else%
    % Otherwise the default: Switch to Times font for text AND math,
    % but keep Computer Modern for mathcal,
    % as Times mathcal is UGLY
        \RequirePackage{mathptmx}
        \SetMathAlphabet{\mathcal}{normal}{OMS}{cmsy}{m}{n}
        \SetMathAlphabet{\mathcal}{bold}{OMS}{cmsy}{b}{n}
    \fi%
\fi%

%% This is a major update in style for the 2011/04/01 revision. 
%% Thanks to Daniele Masato for this suggestion.
\RequirePackage{fancyhdr}
\setlength{\headheight}{14pt}
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\sectionmark}[1]{\markright{\thesection.\ #1}}
\renewcommand{\chaptermark}[1]{\markboth{\thechapter.\ #1}{\thechapter.\ #1}}
\lhead{\textsc{\rightmark}}
\rhead{\thepage}

%% Again, thanks for Daniele Masato for this:
% Pretty captions (affects captions in subfig package as well, unless
% new options are specified for subfig)
\RequirePackage[font=small,bf, justification=centerlast, margin=\parindent]{caption}

% Standard math packages
\RequirePackage{amsmath}
\RequirePackage{amsfonts}
\RequirePackage{amssymb}

\renewcommand \tableofcontents{%
    \if@twocolumn%
        \@restonecoltrue \onecolumn%
    \else%
        \@restonecolfalse%
    \fi%
    \chapter*{%
        \contentsname%
        \@mkboth{\contentsname}{\contentsname}%
    }%
    \@starttoc{toc}%
    \if@restonecol%
        \twocolumn%
    \fi%
}
\renewcommand \listoffigures{%
    \if@twocolumn%
        \@restonecoltrue \onecolumn%
    \else%
        \@restonecolfalse%
    \fi%
    \chapter*{%
        \listfigurename%
        \@mkboth{\listfigurename}{\listfigurename}%
    }%
    \@starttoc{lof}%
    \if@restonecol%
        \twocolumn%
    \fi%
}
\renewcommand \listoftables{%
    \if@twocolumn%
        \@restonecoltrue \onecolumn%
    \else%
        \@restonecolfalse%
    \fi%
    \chapter*{%
        \listtablename%
        \@mkboth{\listtablename}{\listtablename}%
    }%
    \@starttoc{lot}%
    \if@restonecol%
        \twocolumn%
    \fi%
}
\renewenvironment{thebibliography}[1]{%
    \chapter*{%
        \bibname%
        \@mkboth{\bibname}{\bibname}%
    }%
    \list{\@biblabel{\arabic{enumiv}}}%
         {\settowidth \labelwidth{\@biblabel{#1}}%
          \leftmargin \labelwidth%
          \advance \leftmargin \labelsep%
          \if@openbib%
              \advance \leftmargin \bibindent%
              \itemindent -\bibindent%
              \listparindent \itemindent%
              \parsep \z@%
          \fi%
          \usecounter{enumiv}%
          \let \p@enumiv \@empty%
          \renewcommand \theenumiv{\arabic{enumiv}}%
         }%
    \if@openbib%
        \renewcommand \newblock{\par}%
    \else%
        \renewcommand \newblock{\hskip .11em \@plus.33em \@minus.07em}%
    \fi%
    \sloppy%
    \clubpenalty 4000%
    \widowpenalty 4000%
    \sfcode`\.=\@m%
}{%
    \def \@noitemerr{\@latex@warning{Empty `thebibliography' environment}}%
    \endlist%
}
\renewenvironment{theindex}{%
    \if@twocolumn%
        \@restonecolfalse%
    \else%
        \@restonecoltrue%
    \fi%
    \columnseprule \z@%
    \columnsep 35\p@%
    \twocolumn[\@makeschapterhead{\indexname}]%
    \@mkboth{\indexname}{\indexname}%
    \thispagestyle{plain}%
    \small%
    \parindent \z@%
    \parskip \z@ \@plus .3\p@%
    \relax%
%%%
%%%  It appears that there is an error in the definition of \@idxitem
%%%  which causes horrid looking indexes.  Redefine the miscreant
%%%  so as to insert the missing \par.  NB.  Cannot use
%%%  |\renewcommand| since this appears not to work on outer block,
%%%  even if |\global| is used.
%%%
    \gdef \@idxitem{\par \hangindent 40\p@}
    \let \item \@idxitem%
}{%
    \if@restonecol%
        \onecolumn%
    \else%
        \clearpage%
    \fi%
}
\renewcommand \maketitle{%
    \setcounter{page}{1}%
    \thispagestyle{empty}%
    \@maketitle%
    \setcounter{footnote}{0}%
    \let \thanks = \relax%
    \gdef \@address{}%
    \gdef \@thanks{}%
    \gdef \@author{}%
    \gdef \@title{}%
    \let \maketitle = \relax%
}

%% This produces the title page.
\newcommand \@maketitle{%
    \newpage%
    \null%
%% Format the title and author so that it fits within the UoA       
%% front cover window.
    \iftitleboxp%
    \vspace*{8em}%
    \begin{center}%
      \begin{minipage}{9cm}
        \begin{center}%
          {\huge \bfseries \@title}%
        \end{center}%
      \end{minipage}\\[2em]%
      {\Large \itshape \@author}\\%
    \end{center}%
%% Otherwise make it look nice! 
    \else%
    \vspace*{5em}%
    \begin{center}%
        {\huge \bfseries \@title}\\[5em]%
        {\Large \itshape \@author}\\[2em]%
        \@ifauthorvariable{qualifications}
            {\small \upshape \ting@qualifications}
            {}
    \end{center}%
    \fi%
    \vfill%
    \begin{center}%
    A dissertation submitted in partial fulfilment \\
    of the requirements for the degree of \\
    \textbf{\@degree@string} \\
    of the \\
    \textbf{University of Aberdeen}.\\[2em]
    \includegraphics[width=2cm]{abdnshield}
    \end{center}%
    \vspace{4em}%
    \begin{center}%
    \@school
    \end{center}%
    \vspace{2em}%
    \begin{center}%
    \@date%
    \end{center}%
}

\renewcommand \chapter{%
    \if@openright%
        \cleardoublepage%
    \else%
        \clearpage%
    \fi
    \thispagestyle{empty}%
    \global \@topnum \z@%
    \@afterindentfalse%
    \secdef \@chapter \@schapter%
}

\def \@makechapterhead#1{%
    \vspace*{40\p@}%
    {\parindent \z@%
     \raggedright%
     \reset@font%
     \ifnum \c@secnumdepth >\m@ne%
         \if@mainmatter%
             \Large \bfseries \@chapapp{} \thechapter%
     \par%
             \vskip 20\p@%
         \fi%
     \fi%
     \huge \bfseries #1%
     \par%
     \nobreak%
     \vskip 40\p@%
    }%
}

\def \@makeschapterhead#1{%
    \vspace*{50\p@}%
    {\parindent \z@%
     \raggedright%
     \reset@font%
     \huge \bfseries #1%
     \par%
     \nobreak%
     \vskip 40\p@%
    }%
}

\renewcommand \section{\@startsection {section}{1}{\z@}%
                                      {-1ex \@plus -.4ex \@minus -.2ex}%
                                      {.6ex \@plus .1ex}%
                                      {\reset@font \Large \bfseries}}

\renewcommand \subsection{\@startsection{subsection}{2}{\z@}%
                                        {-.7ex\@plus -.3ex \@minus -.2ex}%
                                        {.4ex \@plus .1ex}%
                                        {\reset@font \large \bfseries}}

\renewcommand \subsubsection{\@startsection{subsubsection}{3}{\z@}%
                                        {-.5ex\@plus -.2ex \@minus -.2ex}%
                                        {.3ex \@plus .1ex}%
                                        {\reset@font \large}}

\renewcommand \paragraph{\@startsection{paragraph}{4}{\z@}%
                                       {.5ex \@plus .1ex \@minus .2ex}%
                                       {-.2em}%
                                       {\reset@font \normalsize \bfseries}}

\renewcommand \subparagraph{\@startsection{subparagraph}{5}{\parindent}%
                                          {-.3ex \@plus .1ex \@minus .2ex}%
                                          {-.2em}%
                                          {\reset@font \normalsize \bfseries}}

\setcounter{secnumdepth}{2}

\newcommand \@abstract{Abstract}
\newenvironment{abstract}{%
    \chapter*{\@abstract}%
    \@mkboth{\@abstract}{\@abstract}%
}{%
}

\newcommand \@acknowledgements{Acknowledgements}
\newenvironment{acknowledgements}{%
    \chapter*{\@acknowledgements}%
    \@mkboth{\@acknowledgements}{\@acknowledgements}%
}{%
}

%% This produces the standard declaration.
\newcommand \makedeclaration{%
    \chapter*{Declaration}%
    
    No portion of the work contained in this document has been
    submitted in support of an application for a degree or
    qualification of this or any other university or other institution
    of learning.  All verbatim extracts have been distinguished by
    quotation marks, and all sources of information have been
    specifically acknowledged.

    \vskip 40\p@%
    
    \noindent Signed:

    \vskip 40\p@%

    \noindent Date: \@date%
}
\endinput

