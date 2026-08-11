PKGNAME="sh.siava.pixelxpert"
PKGPATH="/system/priv-app/PixelXpert/PixelXpert.apk"
LSPDDBPATH="/data/adb/lspd/config/modules_config.db" 
MAGISKDBPATH="/data/adb/magisk.db" 
MODDIR=${0%/*} 
 
prepareSQL(){ 
	chmod +x $MODDIR/sqlite3
	SQLITEPATH="$MODDIR/sqlite3" 
} 

getPkgUID(){
	RESULT=$(pm list packages -U --user 0 2>/dev/null | grep -F "package:$1 " | awk -F 'uid:' '{ print $2 }' | cut -d ' ' -f 1 | cut -d ',' -f 1)
	[ -n "$RESULT" ] && { echo "$RESULT"; return; }

	RESULT=$(cmd package list packages -U --user 0 2>/dev/null | grep -F "package:$1 " | awk -F 'uid:' '{ print $2 }' | cut -d ' ' -f 1 | cut -d ',' -f 1)
	[ -n "$RESULT" ] && { echo "$RESULT"; return; }

	RESULT=$(dumpsys package "$1" 2>/dev/null | grep -m 1 -oE 'userId=[0-9]+' | cut -d '=' -f 2)
	[ -n "$RESULT" ] && { echo "$RESULT"; }
}
 
# runSQL "database path" "command" - then you can use $SQLRESULT to read the outcome 
runSQL(){ 
	SQLRESULT=$($SQLITEPATH $DBPATH "$CMD") 
} 
 
#grant silent root access to given UID 
grantRootUID(){ 
	DBPATH=$MAGISKDBPATH 
	 
	#new record - older magisk compatibility 
	CMD="insert into policies (uid, package_name, policy, until, logging, notification) values ($1, '$2', 2, 0, 1, 0);" && runSQL 
	#new record 
	CMD="insert into policies (uid, policy, until, logging, notification) values ($1, 2, 0, 1, 0);" && runSQL 
	#previously present record 
	CMD="update policies set policy = 2, until = 0, logging = 1, notification = 0 where uid = $1;" && runSQL 
} 
 
 
#grant root access to given package name 
grantRootPkg(){ 
	echo "- 	Granting root access to $1..." 
	UID=$(getPkgUID "$1")

	if [ -z "$UID" ]; then
		echo "- 	UID not available for $1 yet"
		return 1
	fi
 
	grantRootUID $UID $1 
	return 0
} 
 
#grant root access to required apps 
grantRootApps(){ 
	TRIES=0
	while [ $TRIES -lt 60 ]; do
		if grantRootPkg "$PKGNAME"; then
			return 0
		fi
		TRIES=$((TRIES + 1))
		sleep 2
	done

	echo "- 	Failed to grant root access to $PKGNAME after waiting"
	return 1
}

prepareSQL 
 
grantRootApps
