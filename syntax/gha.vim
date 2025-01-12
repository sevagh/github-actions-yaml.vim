" Vim syntax file
" Language:   GitHub Actions YAML
" Maintainer: yasuhiroki <yasuhiroki.duck@gmail.com>
" License:    MIT Copyright (c) 2019 yasuhiroki

let s:save_cpo = &cpo
set cpo&vim

let s:gha_keywords_key = '\%(^\|\s\)\@<=\zs\%('.join(gha#GetKeywords(), '\|').'\)\ze\%(\s*:\|$\)'
let s:gha_keywords_conditional_key = '\%(^\|\s\)\@<=\zs\%('.join(gha#GetKeywordsConditional(), '\|').'\)\ze\%(\s*:\|$\)'
let s:gha_keywords_step_key = '\%([0-9A-Za-z_-]\)\@<!\%('.join(gha#GetKeywordsStep(), '\|').'\)\ze\%(\s*:\|$\)'

syn region GhaDollarSyntax matchgroup=PreProc start="${{" end="}}" containedin=yamlPlainScalar

exe 'syn match GhaKeywords /'.s:gha_keywords_key.'/ contained nextgroup=yamlKeyValueDelimiter containedin=yamlBlockMappingKey'
exe 'syn match GhaKeywordsConditional /'.s:gha_keywords_conditional_key.'/ contained nextgroup=yamlKeyValueDelimiter containedin=yamlBlockMappingKey'
exe 'syn match GhaKeywordsStep /'.s:gha_keywords_step_key.'/ contained nextgroup=yamlKeyValueDelimiter containedin=yamlBlockMappingKey'

" https://docs.github.com/en/actions/learn-github-actions/contexts
syn match GhaKeywordsDollarSyntax /\%(\.\)\@<!\<\%(github\|env\|job\|steps\|runner\|secrets\|strategy\|matrix\|inputs\)\>/ contained containedin=GhaDollarSyntax

" https://docs.github.com/en/actions/learn-github-actions/expressions
syn cluster GhaLiterals contains=GhaNull,GhaBoolean,GhaNumber,GhaString
syn keyword GhaNull null contained containedin=GhaDollarSyntax
syn keyword GhaBoolean true false contained containedin=GhaDollarSyntax
" NOTE: The "Number" definition in dollar syntax is equal to JSON's one, so
" this syntax pattern is imported from "$VIMRUNTIME/syntax/json.vim" with
" small fixes.
syn match GhaNumber /\<-\=\<\%(0\|[1-9]\d*\)\%(\.\d\+\)\=\%([eE][-+]\=\d\+\)\=\>/ contained containedin=GhaDollarSyntax
syn region GhaString start=/'/ skip=/''/ end=/'/ contained containedin=GhaDollarSyntax

syn match GhaOperator /\%(||\|&&\|==\|!=\|>=\|>\|<=\|<\|!\)/ contained containedin=GhaDollarSyntax
exe 'syn region GhaFunction matchgroup=GhaKeywordsFunction start=/\<\%(' . join(gha#GetKeywordsFunction(), '\|') . '\)\ze(/ end=/\ze)/ contained containedin=GhaDollarSyntax contains=@GhaLiterals,GhaOperator,GhaKeywordsDollarSyntax'

hi def link GhaKeywords Keyword
hi def link GhaKeywordsConditional Conditional
hi def link GhaKeywordsStep Define
hi def link GhaKeywordsParameter Keyword
hi def link GhaKeywordsDollarSyntax Keyword
hi def link GhaNull Keyword
hi def link GhaBoolean Boolean
hi def link GhaNumber Number
hi def link GhaString String
hi def link GhaOperator Operator
hi def link GhaKeywordsFunction Function

" borrowed from:
" https://vi.stackexchange.com/a/38085

syntax match equalsdoublequote "\v\=\"\$\{\{.{-}\}\}\"" containedin=ALL
highlight equalsdoublequote ctermfg=57

syntax match doublebraces "\v\$\{\{.{-}\}\}" containedin=ALL
highlight doublebraces ctermfg=17

syntax match braces "\v\$\{[0-9A-Za-z_.]{-}\}" containedin=ALL
highlight braces ctermfg=22

syntax match parens "\v\$\([^\(\)]+\)" containedin=ALL
highlight parens ctermfg=96

syntax match equalsdoublequoteparens "\v\=\"\$\([^\(\)]+\)\"" containedin=ALL
highlight equalsdoublequoteparens ctermfg=197

syntax match doublebraceparens "\v\=\"\$\{\{.{-}\}\}.*\$\([^\(\)]+\)\"" containedin=ALL
highlight doublebraceparens ctermfg=202

" syntax match multiexpanse "\v\=\"\$\{[^\"]+\}" containedin=ALL
" highlight multiexpanse ctermfg=202

" ... in script block
syntax match shDerefSimple "\${{.*}}" nextgroup=@shNoZSList

let &cpo = s:save_cpo
