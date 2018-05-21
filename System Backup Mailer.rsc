######################################################################
###Identity: System Backup Mailer
###Author: Tahasanul Abraham
###Created: Oct 16 2016
###Last Edited: Jan 5 2018
###Compatible Versions: ROS 6.x
###Tested on: ROS 6.2 - 6.42
######################################################################


### Local variable initialization ### 
:local userman "yes"
:local dude "yes"
:local adminmail1 "xyz@xyz.com"
:local adminmail2 "xyz@xyz.com"
:local adminmail3 "xyz@xyz.com"


### Working Script ###
:log warning "Mikrotik Router Backup JOB Started . . ."
:local backupfile mt_config_backup
:local usermanagerfile usm_export_backup
:local dudefile dude_backup
:local sub1 ([/system identity get name])
:local sub2 ([/system clock get time])
:local sub3 ([/system clock get date])

# MAIL SMTP DYNAMIC Config Section, Make sure to change these values to match your's / Jz
:local webmailid "xyz@xyz.com"
:local webmailuser "xyz@xyz.com"
:local fromuser "xyz@xyz.com"
:local webmailpwd "mail-password"
:local webmailport "465"
:local webmailsmtp
:set webmailsmtp [:resolve "smtp address"];


# Setting gmail options in tool email as well, useful when u dont have configured toosl email option
/tool e-mail set address=$webmailsmtp port=$webmailport start-tls=tls-only from=$webmailid user=$webmailuser password=$webmailpwd
 
:log warning "$sub1 : Creating new up to date backup files . . . "
 
# Start creating Backup files backup and export both
/system backup save name=$backupfile
:if ($userman = "yes") do={
/tool user-manager database save name=$usermanagerfile;
}
:if ($dude = "yes") do={
/dude export-db backup-file=$dudefile
}
 
:log warning "$sub1 : Backup JOB process pausing for 30s so it can complete creating backup. Usually for Slow systems ..."
:delay 10s
 
:log warning "Backup JOB is now sending Backup File via Email using WEBMAIL SMTP . . ."
 
# Start Sending email files, make sure you ahve configured tools email section before this. or else it will fail

:if ($userman = "yes" and $dude = "yes") do={
:if ($adminmail1 != "") do={
/tool e-mail send server=$webmailsmtp port=$webmailport start-tls=tls-only user=$webmailuser password=$webmailpwd from=$fromuser to=$adminmail1 subject="$sub1 Configuration BACKUP Files" file=mt_config_backup.backup,usm_export_backup.umb,dude_backup body="$sub1 system configurations backed up on $sub3 at $sub2"}
:if ($adminmail2 != "") do={
/tool e-mail send server=$webmailsmtp port=$webmailport start-tls=tls-only user=$webmailuser password=$webmailpwd from=$fromuser to=$adminmail2 subject="$sub1 Configuration BACKUP Files" file=mt_config_backup.backup,usm_export_backup.umb,dude_backup body="$sub1 system configurations backed up on $sub3 at $sub2"}
:if ($adminmail3 != "") do={
/tool e-mail send server=$webmailsmtp port=$webmailport start-tls=tls-only user=$webmailuser password=$webmailpwd from=$fromuser to=$adminmail3 subject="$sub1 Configuration BACKUP Files" file=mt_config_backup.backup,usm_export_backup.umb,dude_backup body="$sub1 system configurations backed up on $sub3 at $sub2"}
}
:if ($userman = "yes" and $dude = "no") do={
:if ($adminmail1 != "") do={
/tool e-mail send server=$webmailsmtp port=$webmailport start-tls=tls-only user=$webmailuser password=$webmailpwd from=$fromuser to=$adminmail1 subject="$sub1 Configuration BACKUP Files" file=mt_config_backup.backup,usm_export_backup.umb body="$sub1 system configurations backed up on $sub3 at $sub2"}
:if ($adminmail2 != "") do={
/tool e-mail send server=$webmailsmtp port=$webmailport start-tls=tls-only user=$webmailuser password=$webmailpwd from=$fromuser to=$adminmail2 subject="$sub1 Configuration BACKUP Files" file=mt_config_backup.backup,usm_export_backup.umb body="$sub1 system configurations backed up on $sub3 at $sub2"}
:if ($adminmail3 != "") do={
/tool e-mail send server=$webmailsmtp port=$webmailport start-tls=tls-only user=$webmailuser password=$webmailpwd from=$fromuser to=$adminmail3 subject="$sub1 Configuration BACKUP Files" file=mt_config_backup.backup,usm_export_backup.umb body="$sub1 system configurations backed up on $sub3 at $sub2"}
}
:if ($userman = "no" and $dude = "no") do={
:if ($adminmail1 != "") do={
/tool e-mail send server=$webmailsmtp port=$webmailport start-tls=tls-only user=$webmailuser password=$webmailpwd from=$fromuser to=$adminmail1 subject="$sub1 Configuration BACKUP Files" file=mt_config_backup.backup body="$sub1 system configurations backed up on $sub3 at $sub2"}
:if ($adminmail2 != "") do={
/tool e-mail send server=$webmailsmtp port=$webmailport start-tls=tls-only user=$webmailuser password=$webmailpwd from=$fromuser to=$adminmail2 subject="$sub1 Configuration BACKUP Files" file=mt_config_backup.backup body="$sub1 system configurations backed up on $sub3 at $sub2"}
:if ($adminmail3 != "") do={
/tool e-mail send server=$webmailsmtp port=$webmailport start-tls=tls-only user=$webmailuser password=$webmailpwd from=$fromuser to=$adminmail3 subject="$sub1 Configuration BACKUP Files" file=mt_config_backup.backup body="$sub1 system configurations backed up on $sub3 at $sub2"}
}
 
:log warning "$sub1 : BACKUP JOB: Sleeping for 60 seconds so email can be delivered, "
:delay 20s
 
# REMOVE Old backup files to save space.

/file remove $backupfile
:if ($userman = "yes") do={
/file remove $usermanagerfile
}
:if ($dude = "yes") do={
/file remove $dudefile
}
 
# Print Log for done
:log warning "$sub1 : Backup JOB: Process Finished & Backup File Removed. All Done. You should verify your inbox for confirmation."
 
# Script END