"
" Syntax highlighting for CPP source files
"

"
" Storage Classes
"

syn keyword cppStorageClass inline mutable virtual
syn keyword cppStructure    class struct
syn keyword cppStructure    typename template namespace

hi link cppStorageClass StorageClass
hi link cppStructure    StorageClass

"
" Syntax highlighting for NT source files
"

"
" Stardard Win32 Types
"

" macros for C types
syn keyword ntcppWinType BYTE CHAR UCHAR SHORT USHORT
syn keyword ntcppWinType INT UINT WORD LONG ULONG DWORD
syn keyword ntcppWinType WCHAR LPCSTR LPCWSTR LPSTR LPWSTR
syn keyword ntcppWinType PCSTR PCWSTR PSTR PWSTR
syn keyword ntcppWinType VOID LPVOID LONG_PTR PVOID PPVOID BOOL

" COM OLE types
syn keyword ntcppWinType HRESULT BSTR VARIANT SAFEARRAY IUnknown IDispatch

" UI handles
syn keyword ntcppWinType HWND HICON HCURSOR HBITMAP HGDIOBJ HDC HFONT
syn keyword ntcppWinType LPARAM WPARAM

" object handles
syn keyword ntcppWinType HANDLE HGLOBAL HINSTANCE HMODULE HCHARSET

hi link ntcppWinType Type

"
" Standard Win32 Macros
"

syn match ntcppMacro "\<STDMETHOD\(IMP\)\=_\=\>"
syn match ntcppMacro "\<IFACEMETHOD\(IMP\)\=_\=\>"

syn keyword ntcppMacro HRESULT_FROM_WIN32 WINAPI SUCCEEDED FAILED
syn keyword ntcppMacro ARRAYSIZE ASSERT CCHMAX
syn keyword ntcppMacro __declspec __uuid

hi link ntcppMacro Macro

"
" Standard Win32 Constants
"

syn match ntcppConstant "\<\(S\|E\)_\w\+\>"

syn keyword ntcppConstant TRUE FALSE
syn keyword ntcppConstant S_OK S_FALSE

hi link ntcppConstant Constant

"
" ATL
"

" Types
syn match ntcppAtlType  "\<CCom\i\+\>"
hi link ntcppAtlType Type

" Macros
syn match ntcppAtlMacro "\<BEGIN_\i\+_MAP\>"
syn match ntcppAtlMacro "\<END_\i\+_MAP\>"
syn match ntcppAtlMacro "<\i\+_ENTRY\>"
syn match ntcppAtlMacro "\<COM\(LITE\)\?_INTERFACE_[A-Z_0-9]*"
syn match ntcppAtlMacro "\<DECLARE_[A-Z_0-9]\+"
syn match ntcppAtlMacro "\<[A-Z_]\+_UNKNOWN"
hi link ntcppAtlMacro Macro

"
" Common Functions
"

syn match ntcppFunction "\<Chk[A-Za-z]*\>"
hi link ntcppFunction Function

"
" Artificial Function Parameter Modifiers
"

syn keyword ntcppSAL __override __checkReturn __callback __nullterminated
syn match   ntcppSAL "\<__\(deref_\(opt_\)\?\)\?\(in\(_z\)\?\|out\|inout\)\(_ecount\|_bcount\)\?\(_full\|_part\)\?\(_opt\)\?\>"

" TODO: Come up with a good color for this
hi link ntcppSAL StorageClass

"
" Generic overrides
"

syn keyword Function sizeof
syn keyword Type     interface
syn keyword Todo     BUGBUG

