" log.vim — clean escaped ANSI sequences like \^[[1;33m ... \^[[0m

if exists("b:current_syntax")
  finish
endif
syn clear

" Match and conceal escaped ANSI sequences literally appearing as \^[[...m
syntax match logAnsiEscape /\\\^\[\[[0-9;]*m/ conceal
syntax match logAnsiReset  /\\\^\[\[0*m/ conceal

" Also match real ANSI sequences if they ever appear
syntax match logAnsiEscapeReal /\v(\x1b\[|\e\[)[0-9;]*m/ conceal
syntax match logAnsiResetReal  /\v(\x1b\[|\e\[)0*m/ conceal

" Colorized sections (gray + yellow)
syntax match logColorGray /\\\^\[\[\(0;30\|1;30\|30\|90\)m/ conceal nextgroup=logGrayText
syntax match logGrayText /[^\\]\+/ contained contains=logAnsiEscape,logAnsiEscapeReal
hi def link logGrayText Comment

syntax match logColorYellow /\\\^\[\[\(0;33\|1;33\|33\|93\)m/ conceal nextgroup=logYellowText
syntax match logYellowText /[^\\]\+/ contained contains=logAnsiEscape,logAnsiEscapeReal
hi def link logYellowText WarningMsg

" Keep basic markers
syntax match logPrefix /^\s*\[log\]/ containedin=ALL
syntax match logFlutter /^\s*flutter:/ containedin=ALL
syntax match logFBP /\[FBP\]/ containedin=ALL
syntax match logErrorMarker /\[ERROR\]/ containedin=ALL
syntax match logInfoMarker /Info:/ containedin=ALL

hi def link logPrefix PreProc
hi def link logFlutter Special
hi def link logFBP Constant
hi def link logErrorMarker ErrorMsg
hi def link logInfoMarker Identifier

let b:current_syntax = "log"
