; $Id: ;

core = 6.x

; Contrib projects

projects[] = devel
projects[shorturl][subdir] = "contrib"
projects[shorturl][version] = 1.x-dev
projects[shorturl][patch][] = "http://drupal.org/files/issues/shorturl_stats_and_schema.patch"
projects[shorten][subdir] = "contrib"
projects[shorten][version] = 1.5
projects[tldrestrict][subdir] = "contrib"
projects[tldrestrict][version] = 1.x-dev

projects[admin_menu][subdir] = "contrib"
projects[admin_menu][version] = 3.0-alpha4
projects[adminrole][subdir] = "contrib"
projects[adminrole][version] = 1.2

projects[] = install_profile_api


; Themes
 ==== 
projects[blueprint][destination] = sites
projects[blueprint][version] = 2.x-dev
