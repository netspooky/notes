1. This is my minimal PS1 for Bash
```
PS1="\\[\\e]0;\\u@\\h: \\w\\a\\]\\[\\e[38;5;123m\\]\\t\\[\\e[0m\\] \\[\\e[38;5;219m\\]\\w \\[\\e[0m\\]\\n▶ "
```

2. This is the more full PS1 with time and the directory.
```
PS1="\\[\\e[38;5;141m\\][\\[\\e[m\\]\\[\\e[38;5;219m\\]\\u\\[\\e[m\\]\\[\\e[38;5;226m\\]@\\[\\e[m\\]\\[\\e[38;5;86m\\]\\h\\[\\e[m\\]\\[\\e[38;5;141m\\]]-[\\[\\e[m\\]\\[\\e[38;5;159m\\]\\t\\[\\e[m\\]\\[\\e[38;5;141m\\]]-[\\[\\e[m\\]\\[\\e[38;5;226m\\]\\w\\[\\e[m\\]\\[\\e[38;5;141m\\]]\\[\\e[m\\]\\n\\\\$ \\[$(tput sgr0)\\]"
```

3. A ZSH prompt that looks similar to 2
```
PROMPT="%{$reset_color%}%{$fg[cyan]%}%D{%Y-%m-%d %I:%M:%S}%b%{$reset_color%} %{$fg[magenta]%}%~%{$reset_color%}
$fg[yellow]%}～%{$reset_color%}"
```
