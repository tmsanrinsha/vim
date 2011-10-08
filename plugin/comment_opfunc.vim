" 元のファイル
" Commenting with opfunc - Vim Tips Wiki
" (http://vim.wikia.com/wiki/Commenting_with_opfunc)
" Hack #205: 複数行をコメントアウトする
" (http://vim-users.jp/2011/03/hack205/)

" 改変してc, css, htmlの囲むコメントにも対応させた。
" ただし、一行単位。

" Comment or uncomment lines from mark a to mark b.
function! CommentMark(docomment, a, b)
  if !exists('b:comment_start')
    let b:comment_start = CommentStrStart() . ' '
    let b:comment_end = ' ' . CommentStrEnd()
  endif
  if a:docomment
    exe "normal! '" . a:a . "_\<C-V>'" . a:b . 'I' . b:comment_start
    exe "normal! '" . a:a . "\<C-V>'" . a:b . '$A' . b:comment_end
  else
    exe "'".a:a.",'".a:b . 's/^\(\s*\)' . escape(b:comment_start,'/*') .'\(.*\)' . escape(b:comment_end,'/*') . '$/\1\2/e'
  endif
endfunction

" Comment lines in marks set by g@ operator.
function! DoCommentOp(type)
  call CommentMark(1, '[', ']')
endfunction

" Uncomment lines in marks set by g@ operator.
function! UnCommentOp(type)
  call CommentMark(0, '[', ']')
endfunction

" Return string used to comment line for current filetype.
function! CommentStrStart()
  if &ft == 'cpp' || &ft == 'java' || &ft == 'javascript' || &ft == 'php'
    return '//'
  elseif &ft == 'vim'
    return '"'
  elseif &ft == 'python' || &ft == 'perl' || &ft == 'sh' || &ft == 'R' || &ft == 'ruby'
    return '#'
  elseif &ft == 'lisp'
    return ';'
  elseif &ft == 'c' || &ft == 'css'
    return '/*'
  elseif &ft == 'html'
    return '<!--'
  endif
  return ''
endfunction

function! CommentStrEnd()
  if &ft == 'c' || &ft == 'css'
    return '*/'
  elseif &ft == 'html'
    return '-->'
  endif
  return ''
endfunction

nnoremap <Leader>c <Esc>:set opfunc=DoCommentOp<CR>g@
nnoremap <Leader>C <Esc>:set opfunc=UnCommentOp<CR>g@
vnoremap <Leader>c <Esc>:call CommentMark(1,'<','>')<CR>
vnoremap <Leader>C <Esc>:call CommentMark(0,'<','>')<CR>
