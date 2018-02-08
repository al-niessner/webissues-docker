#!/bin/bash
set -euo pipefail

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASS' 'example'
# (will allow for "$XYZ_DB_PASS_FILE" to fill in the value of
#  "$XYZ_DB_PASS" from a file, especially for Docker's secrets feature)
file_env() {
	local var="$1"
	local fileVar="${var}_FILE"
	local def="${2:-}"
	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
		exit 1
	fi
	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(< "${!fileVar}")"
	fi
	export "$var"="$val"
	unset "$fileVar"
}

if  [ "$1" == php-fpm ]; then
	if ! [ -e ${CHK_INSTALL} ]; then
		echo >&2 "APP not found in $PWD (${CHK_INSTALL}) - copying now..."
		if [ "$(ls -A)" ]; then
			echo >&2 "WARNING: $PWD is not empty - press Ctrl+C now if this is an error!"
			( set -x; ls -A; sleep 10 )
		fi
		tar cf - --one-file-system -C /usr/src/app . | tar xf -
		echo >&2 "Complete! APP has been successfully copied to $PWD"
		if [ ! -e .htaccess ]; then
			# NOTE: The "Indexes" option is disabled in the php:apache base image
			cat > .htaccess <<-'EOF'
				# BEGIN APP
				<IfModule mod_rewrite.c>
				RewriteEngine On
				RewriteBase /
				RewriteRule ^index\.php$ - [L]
				RewriteCond %{REQUEST_FILENAME} !-f
				RewriteCond %{REQUEST_FILENAME} !-d
				RewriteRule . /index.php [L]
				</IfModule>
				# END APP
			EOF
			chown www-data:www-data .htaccess
		fi
	fi

	# allow any of these "Authentication Unique Keys and Salts." to be specified via
	# environment variables with a "APP_" prefix (ie, "APP_AUTH_KEY")
	uniqueEnvs=(
		AUTH_KEY
		SECURE_AUTH_KEY
		LOGGED_IN_KEY
		NONCE_KEY
		AUTH_SALT
		SECURE_AUTH_SALT
		LOGGED_IN_SALT
		NONCE_SALT
	)
	envs=(
		APP_DB_HOST
		APP_DB_USER
		APP_DB_PASS
		APP_DB_NAME
		"${uniqueEnvs[@]/#/APP_}"
		APP_DEBUG
	)
	#haveConfig=
	#for e in "${envs[@]}"; do
	#	file_env "$e"
	#	if [ -z "$haveConfig" ] && [ -n "${!e}" ]; then
	#		haveConfig=1
	#	fi
	#done

	# now that we're definitely done writing configuration, let's clear out the relevant envrionment variables (so that stray "phpinfo()" calls don't leak secrets from our code)
	for e in "${envs[@]}"; do
		unset "$e"
	done
fi

exec "$@"

