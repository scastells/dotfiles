# Alias de Alias
alias editdotfiles='subl ~/.dotfiles'
alias editaliases='vim ~/.dotfiles/fish/aliases.fish'
alias cataliases='cat ~/.dotfiles/fish/aliases.fish'
alias reloadaliases='source ~/.dotfiles/fish/aliases.fish'

# Git
alias gc='git commit'
alias ga='git commit --amend'
alias gca='git add -A; git commit --amend'
alias gd='git diff --color'
alias gl='git log --graph --pretty=format:"%Cred%h%Creset %C(yellow)%d%Creset %an: %s - %Creset %Cgreen(%cr, %cd)%Creset" --abbrev-commit --date=iso'
alias gs='git status -sb'
alias gf='git fetch --all -p'
alias gp='git push'
alias gpl='git pull'
alias gmm='git merge master'
alias gpum='git pull upstream master'
alias gfp='git push -f'

# Server
alias edithosts='sudo vim /etc/hosts'

# Php
alias phprepl='psysh'
alias fpm56='/usr/local/Cellar/php56/5.6.14/sbin/php56-fpm'

function showphp56fpm
    set_color FF0
    php -v;
    set_color purple
    fpm56 status
    set_color normal
end

function use56
    brew link php56 > /dev/null;
    killall php-fpm
    sudo rm /usr/sbin/php-fpm
    sudo ln -s /usr/local/Cellar/php56/5.6.14/sbin/php-fpm /usr/sbin/php-fpm
    fpm56 start > /dev/null;
    showphp56fpm
end

function startserve
    mysql.server start
    use56
    sudo nginx
    sudo nginx -s reload
end

function phpserve
    sudo php -S 0.0.0.0:$argv
end
alias phpunit='./vendor/bin/phpunit --colors'
alias pf='./vendor/bin/phpunit --filter'
alias behat='./vendor/bin/behat'
alias bf='./vendor/bin/behat --tags=~skip -p'
alias bfp='./vendor/bin/behat --tags=~skip --format=progress -vvv -p'

function enable-xdebug
    sudo mv /usr/local/etc/php/5.6/conf.d/ext-xdebug.ini.bak /usr/local/etc/php/5.6/conf.d/ext-xdebug.ini
end
function disable-xdebug
    sudo mv /usr/local/etc/php/5.6/conf.d/ext-xdebug.ini /usr/local/etc/php/5.6/conf.d/ext-xdebug.ini.bak
end
function ci
    disable-xdebug
    composer install $argv
    enable-xdebug
end

# Ip's
alias privateip='ipconfig getifaddr en0'
alias publicip="curl -s checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*\$//'"

function port_owner
    lsof -n -i4TCP:$argv | grep LISTEN
end

# MySQL
function delete_mysql_db_starting_by
    mysql -uroot -N -B -e "SELECT CONCAT('DROP DATABASE ', SCHEMA_NAME, ';') AS QUERY FROM `information_schema`.`SCHEMATA` WHERE SCHEMA_NAME LIKE '$argv%';" | while read -l line
        mysql -uroot -e "$line"
    end
end

# Utils
alias twitter='rainbowstream'
alias reveal='open .'
alias count_files_recursive='find . -type f -print | wc -l'
alias watch_number_of_files='watch -n1 "find . -type f -print | wc -l"'
alias size_of_the_current_directory='du -ch | grep total'
alias get_last_executed_command='echo $history[1]'
alias fuck!='sudo $history[1]'
alias stt='subl .'
alias normalize_perissions='chmod 775'
alias copy_ssh_key='xclip -sel clip < ~/.ssh/id_rsa.pub'
function uuid_to_db
    set uuid (echo $argv | tr '[:lower:]' '[:upper:]' | sed 's/\-//g')
    echo -n $uuid | pbcopy
    echo $uuid
end
function uuid_db
    set uuid (uuidgen | sed 's/\-//g')
    echo -n $uuid | pbcopy
    echo $uuid
end
function uuid_code
    set uuid (uuidgen | tr '[:upper:]' '[:lower:]')
    echo -n $uuid | pbcopy
    echo $uuid
end

# AWS
function s
    ec2s $argv | percol --prompt='CONNECT TO>' | read -l target
    set ip (echo $target | awk '{print $2}')
    ssh -l $MY_SSH_AKAMON_USERNAME $ip
end
