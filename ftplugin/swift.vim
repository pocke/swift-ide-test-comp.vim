scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim



setlocal omnifunc=swift_ide_test_comp#complete



let &cpo = s:save_cpo
unlet s:save_cpo
