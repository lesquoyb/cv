\ProvidesClass{twentysecondcv}
\LoadClass{article}
\NeedsTeXFormat{LaTeX2e}

%----------------------------------------------------------------------------------------
%	 REQUIRED PACKAGES
%----------------------------------------------------------------------------------------

\RequirePackage[sfdefault]{ClearSans}
\RequirePackage[T1]{fontenc}
\RequirePackage{tikz}
\RequirePackage{xcolor}
\RequirePackage[absolute,overlay]{textpos}
\RequirePackage{ragged2e}
\RequirePackage{etoolbox}
\RequirePackage{ifmtarg}
\RequirePackage{ifthen}
\RequirePackage{pgffor}
\RequirePackage{marvosym}
\RequirePackage{parskip}
\RequirePackage{intcalc}
\RequirePackage{fontawesome5}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

%----------------------------------------------------------------------------------------
%	 COLOURS
%----------------------------------------------------------------------------------------

\definecolor{white}{RGB}{255,255,255}
\definecolor{gray}{HTML}{4D4D4D}
\definecolor{sidecolor}{HTML}{E7E7E7}
\definecolor{mainblue}{HTML}{08C5D1}
\definecolor{secondblue}{HTML}{0E5484}
\definecolor{maingray}{HTML}{B9B9B9}

%----------------------------------------------------------------------------------------
%	 MISC CONFIGURATIONS
%----------------------------------------------------------------------------------------

\renewcommand{\bfseries}{\color{gray}} % Make \textbf produce coloured text instead

\pagestyle{empty} % Disable headers and footers

\setlength{\parindent}{0pt} % Disable paragraph indentation



%---------------------------------------------------------------------------------------
%    SCORE DEFINITION
%---------------------------------------------------------------------------------------

\usetikzlibrary{shapes.geometric, calc}

\newcommand\score[2]{%
  \pgfmathsetmacro\pgfxa{#1 + 1}%
  \tikzstyle{scorestars}=[star, star points=5, star point ratio=2.25, draw, inner sep=0.15em, anchor=outer point 3]%
  \begin{tikzpicture}[baseline]
    \foreach \i in {1, ..., #2} {
      \pgfmathparse{\i<=#1 ? "yellow" : "gray"}
      \edef\starcolor{\pgfmathresult}
      \draw (\i*1em, 0) node[name=star\i, scorestars, fill=\starcolor]  {};
    }
    \pgfmathparse{#1>int(#1) ? int(#1+1) : 0}
    \let\partstar=\pgfmathresult
    \ifnum\partstar>0
      \pgfmathsetmacro\starpart{#1-(int(#1)}
      \path [clip] ($(star\partstar.outer point 3)!(star\partstar.outer point 2)!(star\partstar.outer point 4)$) rectangle 
      ($(star\partstar.outer point 2 |- star\partstar.outer point 1)!\starpart!(star\partstar.outer point 1 -| star\partstar.outer point 5)$);
      \fill (\partstar*1em, 0) node[scorestars, fill=yellow]  {};
    \fi
  \end{tikzpicture}%
}



%----------------------------------------------------------------------------------------
%	 SIDEBAR DEFINITIONS
%----------------------------------------------------------------------------------------

\setlength{\TPHorizModule}{1cm} % Left margin
\setlength{\TPVertModule}{1cm} % Top margin

\newlength\imagewidth
\newlength\imagescale
\pgfmathsetlength{\imagewidth}{5cm}
\pgfmathsetlength{\imagescale}{\imagewidth/600}

\newlength{\TotalSectionLength} % Define a new length to hold the remaining line width after the section title is printed
\newlength{\SectionTitleLength} % Define a new length to hold the width of the section title
\newcommand{\profilesection}[1]{%
	\setlength\TotalSectionLength{\linewidth}% Set the total line width
	\settowidth{\SectionTitleLength}{\huge #1 }% Calculate the width of the section title
	\addtolength\TotalSectionLength{-\SectionTitleLength}% Subtract the section title width from the total width
	\addtolength\TotalSectionLength{-2.22221pt}% Modifier to remove overfull box warning
	\vspace{8pt}% Whitespace before the section title
	{\color{black!80} \huge #1 \rule[0.15\baselineskip]{\TotalSectionLength}{1pt}}% Print the title and auto-width rule
}
\newcommand{\profilesubsection}[1]{%
	\setlength\TotalSectionLength{\linewidth}% Set the total line width
	\settowidth{\SectionTitleLength}{\Large #1}% Calculate the width of the section title
	\addtolength\TotalSectionLength{-\SectionTitleLength}% Subtract the section title width from the total width
	%\addtolength\TotalSectionLength{-2.22221pt}% Modifier to remove overfull box warning
	\vspace{8pt}% Whitespace before the section title
	{\color{black!80} \Large #1 \rule[0.15\baselineskip]{\TotalSectionLength}{1pt}}% Print the title and auto-width rule
}
% Define custom commands for CV info
\newcommand{\cvdate}[1]{\renewcommand{\cvdate}{#1}}
\newcommand{\cvmail}[1]{\renewcommand{\cvmail}{#1}}
\newcommand{\cvnumberphone}[1]{\renewcommand{\cvnumberphone}{#1}}
\newcommand{\cvaddress}[1]{\renewcommand{\cvaddress}{#1}}
\newcommand{\cvsite}[1]{\renewcommand{\cvsite}{#1}}
\newcommand{\aboutme}[1]{\renewcommand{\aboutme}{#1}}
\newcommand{\profilepic}[1]{\renewcommand{\profilepic}{#1}}
\newcommand{\cvname}[1]{\renewcommand{\cvname}{#1}}
\newcommand{\cvjobtitle}[1]{\renewcommand{\cvjobtitle}{#1}}
\newcommand{\cvtitle}[1]{\renewcommand{\cvtitle}{#1}}
\newcommand{\cvprofiletitle}[1]{\renewcommand{\cvprofiletitle}{#1}}

% Command for printing the contact information icons
\newcommand*\icon[1]{\tikz[baseline=(char.base)]{\node[shape=circle,draw,inner sep=1pt, fill=mainblue,mainblue,text=white] (char) {#1};}}

% Command for printing skill progress bars
\newcommand\skills[1]{ 
	\renewcommand{\skills}{
		\begin{tikzpicture}
			\foreach [count=\i] \x/\y in {#1}{
				\draw[fill=maingray,maingray] (0,\i) rectangle (6,\i+0.4);
				\draw[fill=white,mainblue](0,\i) rectangle (\y,\i+0.4);
				\node [above right] at (0,\i+0.4) {\x};
			}
		\end{tikzpicture}
	}
}

% Command for printing skills text
\newcommand\skillstext[1]{ 
	\renewcommand{\skillstext}{
		\begin{flushleft}
			\foreach [count=\i] \x/\y in {#1}{ 
				\x$ \star $\y
			}
		\end{flushleft}
	}
}

% Command for printing language section

%%TODO: refaire ça pour gérer avec un foreach
\newcommand\languages[1]{ 
	\renewcommand{\languages}{

		%\ifthenelse{\equal{#1}{}}{}{
			%\begin{flushleft}

			\profilesection{Langues}
			\begin{tabular}{lp{1.5cm}c}
#1
%				\foreach \x/\y in {#1}{
%					\x & \y \\
%				}
%

			\end{tabular}
			%\end{flushleft}
		%}
	}
}






% Command for printing score levels
\newcommand\scores[1]{ 
	\renewcommand{\scores}{

		\begin{flushleft}
			\foreach [count=\i] \x/\y/\z in {#1}{
				\x			
				\hfill	
				\score{\y}{5}
				\hfill
				\z 		
			}
		\end{flushleft}
			
	}
}


%----------------------------------------------------------------------------------------
%	 SIDEBAR LAYOUT
%----------------------------------------------------------------------------------------

\newcommand{\makeprofile}{
	
	\begin{tikzpicture}[remember picture,overlay]
   		\node [rectangle, fill=sidecolor, anchor=north, minimum width=9.5cm, minimum height=\paperheight+1cm] (box) at (-5cm,0.5cm){};
	\end{tikzpicture}

	%------------------------------------------------

	\begin{textblock}{6.5}(0.5, 0.2)
			
		
		% Print Title if not empty	
		\ifthenelse{\equal{\cvprofiletitle}{}}{}{
			\begin{center}
				\Huge{\cvprofiletitle}
			\end{center}
				
		}
		
		
		
		%------------------------------------------------
		
		\ifthenelse{\equal{\profilepic}{}}{}{
			\begin{center}
				\begin{tikzpicture}[x=\imagescale,y=-\imagescale]
					\clip (600/2, 600/2) circle (600/2);
					\node[anchor=north west, inner sep=0pt, outer sep=0pt] at (0,0) {\includegraphics[width=\imagewidth]{\profilepic}};
				\end{tikzpicture}
			\end{center}
		}

		%------------------------------------------------

		{\Huge\color{mainblue}\cvname}

		%------------------------------------------------

		{\Large\color{black!80}\cvjobtitle}

		%------------------------------------------------

		\renewcommand{\arraystretch}{1.6}
		\begin{tabular}{p{0.5cm} @{\hskip 0.5cm}p{5cm}}
			\ifthenelse{\equal{\cvdate}{}}{}{\textsc{\Large\faBirthdayCake} & \cvdate\\}
			\ifthenelse{\equal{\cvaddress}{}}{}{\textsc{\Large\faEnvelope[regular]} & \cvaddress\\}
			\ifthenelse{\equal{\cvnumberphone}{}}{}{\textsc{\Large\faPhone*} & \cvnumberphone\\}
			\ifthenelse{\equal{\cvsite}{}}{}{\textsc{\Large\faGlobeAsia} & \href{\cvsite}{\cvsite}\\}
			\ifthenelse{\equal{\cvmail}{}}{}{\textsc{\large\faAt} & \href{mailto:\cvmail}{\cvmail}}
		\end{tabular}

		%------------------------------------------------
		
		\ifthenelse{\equal{\aboutme}{}}{}{
			\profilesection{À propos de moi}
			\begin{justify}
				\aboutme
			\end{justify}
		}

		%------------------------------------------------

		\profilesection{Compétences}

		\skills
		%\skillstext
		\languages
		\scriptsize
		%(*)[The skill scale is from 0 (Fundamental Awareness) to 6 (Expert).]
			
		%------------------------------------------------
			
	\end{textblock}
}

% TITLE
%----------------------------------------------------------------------------------------
%	 COLOURED SECTION TITLE BOX
%----------------------------------------------------------------------------------------

% Command to create the rounded boxes around the first three letters of section titles
\newcommand*\round[2]{%
	\tikz[baseline=(char.base)]\node[anchor=north west, draw,rectangle, rounded corners, inner sep=1.6pt, minimum size=5.5mm, text height=4mm, fill=#2,#2,text=white](char){#1};%
}

\newcounter{colorCounter}
\newcommand{\sectioncolor}[1]{%
	{%
		\round{#1}{
			secondblue
%			\ifcase\intcalcMod{\value{colorCounter}}{2}%
%			secondblue\or%
%			mainblue\fi%
		}%
	}%
	\stepcounter{colorCounter}%
}

\renewcommand{\section}[1]{
	{%
		\color{gray}%
		\Large\sectioncolor{#1}%
	}
}

\renewcommand{\subsection}[1]{
	\par\vspace{.5\parskip}{%
		\large\color{gray} #1%
	}
	\par\vspace{.25\parskip}%
}

\renewcommand{\cvtitle}[1]{
	\begin{center}
		\Huge{#1}
	\end{center}
}

%----------------------------------------------------------------------------------------
%	 LONG LIST ENVIRONMENT
%----------------------------------------------------------------------------------------

\setlength{\tabcolsep}{0pt}

% New environment for the long list
\newenvironment{twenty}{%
	\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}ll}
}{%
	\end{tabular*}
}

\newcommand{\twentyitem}[4]{%
	#1&\parbox[t]{0.83\textwidth}{%
		\textbf{#2}%
		\hfill%
		{\footnotesize#3}%
		\ifthenelse{\equal{#4}{}}
		{}
		{
			\\#4\vspace{\parsep}%
		}
	}\\
}

%----------------------------------------------------------------------------------------
%	 SMALL LIST ENVIRONMENT
%----------------------------------------------------------------------------------------

\setlength{\tabcolsep}{0pt}

% New environment for the small list
\newenvironment{twentyshort}{%
	\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}ll}
}{%
	\end{tabular*}
}

\newcommand{\twentyitemshort}[2]{%
	#1&\parbox[t]{0.83\textwidth}{%
		\textbf{#2}%
	}\\
}

%----------------------------------------------------------------------------------------
%	 MARGINS AND LINKS
%----------------------------------------------------------------------------------------

\RequirePackage[left=7.6cm,top=-0.3cm,right=1cm,bottom=0cm,nohead,nofoot]{geometry}

\RequirePackage{hyperref}
