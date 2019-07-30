wrogel
мониторинг событий в небольших логах по греп-листам и уведомления почтой

Поиск ошибок\событий в логах dwl=(/var/log/../xxx.log) на серверах (/root/wrogel/list_lc.txt)
по event-grep листам (/root/wrogel/job/eventN.txt)
и уведомления почтой (/root/wrogel/job/list_mailN.txt) при нахождении таковых

где N - номер события


Установка
1. Скопировать все содержимое в /root/wrogel/
2. apt-get update && apt-get install perl && apt-get install mutt
нужна рускоязычная ось и локаль
получить ключи: ssh-keygen && cat /root/.ssh/id_rsa.pub закинуть на каждый сервер (/root/wrogel/list_lc.txt)  в /root/.ssh/autorized_keys

не забываем в /etc/ssh/sshd_config:
RSAAuthentication yes
PubkeyAuthentication yes

3. Настроить mutt



Настойка
1. Внести список серверов в столбец list_lc.txt (можно ip). Дб настроен вход по ключам без запроса, т.е. предварительно зайти от root и подтвердить.
2. Создать event-лист, пример /job/event1.txt и указать грепы в столбец.
3. Указать элетронные ящики в столбец для уведомлений, пример /job/list_mail1.txt. 
4. nano /root/wrogel/wrogel.sh
#ВВЕСТИ ПУТЬ К ИСКОМОМУ ЛОГУ:
dwl=/var/log/XXXXXXXXXXX/XXXXXX.log
5. chmod +rx /root/wrogel/setup.sh && /root/wrogel/setup.sh


запуск 
/root/rutoll/finderman/fm.sh 1 "Некорректная работа ПО"
, где
1-ID события
2-Тема уведомления в почте

рекомендуется по крону:
*/5 * * * * /root/rutoll/finderman/fm.sh 1 "Некорректная работа ПО"

