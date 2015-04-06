if exists('g:loaded_fzf_sources') || &compatible
  finish
else
  let g:loaded_fzf_sources = 1
endif

function! TagCommand()
  return 'awk ''!/^!/ { print $1 }'' ' . join(tagfiles() + ['/dev/null'], ' ')
endfunction

command! FZFTags call fzf#run({
\   'options'    : '-x',
\   'sink'       : 'tag',
\   'source'     : TagCommand(),
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
\   'options'    : '-x',
\   'sink'       : function('MarkOpen'),
\   'source'     : MarkList(),
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
\   'options'    : '-x',
\   'sink'       : function('BufOpen'),
\   'source'     : reverse(BufList()),
\   'tmux_height': '40%',
\ })

command! FZFFiles call fzf#run({
\   'options'    : '-m -x',
\   'sink'       : 'edit',
\   'source'     : 'ag -l -g ""',
\   'tmux_height': '40%',
\ })

command! FZFMru call fzf#run({
\   'options'    : '-m --no-sort -x',
\   'sink'       : 'edit',
\   'source'     : filter(copy(v:oldfiles), 'v:val !~# "^fugitive:///\\|fugitiveblame$"'),
\   'tmux_height': '40%',
\ })

command! FZFGitFiles call fzf#run({
\   'options'    : '-m -x',
\   'sink'       : 'edit',
\   'source'     : 'git ls-files',
\   'tmux_height': '40%',
\ })

command! FZFCd call fzf#run({
\   'options'    : '-x',
\   'sink'       : 'cd',
\   'source'     : 'find * -path "*/.*" -type d -prune -o -type d',
\   'tmux_height': '40%',
\ })


" vim:set ft=vim et sw=2:
