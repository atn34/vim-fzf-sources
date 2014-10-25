if exists('g:loaded_fzf_sources') || &compatible
  finish
else
  let g:loaded_fzf_sources = 1
endif

function! TagCommand()
  return substitute('awk _!/^!/ { print \$1 }_ ', '_', "'", 'g')
              \ . join(tagfiles() + ['/dev/null'], ' ')
endfunction

command! FZFTags call fzf#run({
\   'source'     : TagCommand(),
\   'sink'       : 'tag',
\   'tmux_height': '40%',
\ })

" List of marks
function! MarkList()
  redir => marks
  silent marks
  redir END
  return split(marks, '\n')[1:]
endfunction

function! MarkOpen(m)
  execute 'normal! `'. matchstr(a:m, '^ \zs.')
endfunction

command! FZFMarks call fzf#run({
\   'source'     : MarkList(),
\   'sink'       : function('MarkOpen'),
\   'tmux_height': '40%',
\ })

" List of buffers
function! BufList()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! BufOpen(e)
  execute 'buffer '. matchstr(a:e, '^[ 0-9]*')
endfunction

command! FZFBuffers call fzf#run({
\   'source'     : reverse(BufList()),
\   'sink'       : function('BufOpen'),
\   'tmux_height': '40%',
\ })

command! FZFFiles call fzf#run({
\   'source'     : 'ag -l -g ""',
\   'sink'       : 'edit',
\   'options'    : '-m',
\   'tmux_height': '40%',
\ })

command! FZFMru call fzf#run({
\   'source'     : v:oldfiles,
\   'sink'       : 'edit',
\   'options'    : '-m',
\   'tmux_height': '40%',
\ })

command! FZFGitFiles call fzf#run({
\   'source'     : 'git ls-files',
\   'sink'       : 'edit',
\   'options'    : '-m',
\   'tmux_height': '40%',
\ })

command! FZFCd call fzf#run({
\   'source'     : 'find * -path "*/.*" -type d -prune -o -type d',
\   'sink'       : 'cd',
\   'tmux_height': '40%',
\ })


" vim:set ft=vim et sw=2:
