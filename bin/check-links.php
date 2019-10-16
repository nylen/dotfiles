#!/usr/bin/env php
<?php

ini_set( 'error_log', '' );
ini_set( 'display_errors', true );
ini_set( 'display_startup_errors', true );
error_reporting( E_ALL );

$options = [
	'add_slashes' => false,
	'auth'        => null,
	'no_verify'   => false,
];

function fail( $message ) {
	$trace = debug_backtrace( 2 );
	$line  = $trace[0]['line'];
	if ( isset( $trace[1] ) ) {
		$fn = ' in ' . $trace[1]['function'] . '()';
	} else {
		$fn = '';
	}
	error_log( '' );
	error_log( "$message (:$line$fn)" );
	exit( 1 );
}

function do_head_request( $url ) {
	global $options;

	$ch = curl_init();
	curl_setopt( $ch, CURLOPT_URL, $url );
	curl_setopt( $ch, CURLOPT_NOBODY, true );
	curl_setopt( $ch, CURLOPT_RETURNTRANSFER, true );
	curl_setopt( $ch, CURLOPT_HEADER, true );

	if ( $options['no_verify'] ) {
		curl_setopt( $ch, CURLOPT_SSL_VERIFYPEER, false );
	}

	if ( $options['auth'] ) {
		curl_setopt( $ch, CURLOPT_HTTPAUTH, CURLAUTH_BASIC );
		curl_setopt( $ch, CURLOPT_USERPWD, $options['auth'] );
	}

	$response = curl_exec( $ch );
	$error = curl_error( $ch );
	if ( $error ) {
		fail( "Request error: $error" );
	}
	curl_close( $ch );

	if ( preg_match( '#^HTTP/[^ ]+ (\d+) (.*)\r?\n#', $response, $matches ) ) {
		$status = intval( $matches[1] );
		$text   = trim( $matches[2] );
	} else {
		$response = json_encode( $response, JSON_UNESCAPED_SLASHES );
		fail( "$url: Invalid response: $response" );
	}

	if (
		( $status >= 200 && $status < 300 ) ||
		( $status >= 400 && $status < 600 )
	) {
		return [
			'status' => $status,
			'text'   => $text,
		];
	} else if ( $status >= 300 && $status < 400 ) {
		foreach ( explode( "\r\n", $response ) as $line ) {
			if ( preg_match( '#^Location:\s*(\S+.*)$#i', $line, $matches ) ) {
				$location = $matches[1];
				$parts = parse_url( $url );
				if ( substr( $location, 0, 2 ) === '//' ) {
					$location = "$parts[scheme]:$location";
				} elseif ( substr( $location, 0, 1 ) === '/' ) {
					$prefix = "$parts[scheme]://$parts[host]";
					if ( ! empty( $parts['port'] ) ) {
						$prefix .= ":$parts[port]";
					}
					$location = $prefix . $location;
				}
				return [
					'status'   => $status,
					'text'     => $text,
					'location' => $location,
				];
			}
		}
		fail(
			"$url: HTTP $status $text, but Location header not found: $response"
		);
	} else {
		fail( "$url: HTTP $status $text" );
	}
}

$urls_to_check = [];
$urls_checked = [];

function format_url_for_echo( $url ) {
	$scheme = parse_url( $url, PHP_URL_SCHEME );
	if ( $scheme === 'http' ) {
		return ' ' . $url;
	}
	return $url;
}

function check_url( $url ) {
	global $urls_to_check, $urls_checked, $options;

	if ( isset( $urls_checked[ $url ] ) ) {
		echo "already checked: $url\n";
		return;
	}

	if (
		$options['add_slashes'] &&
		! preg_match( '#(\.[a-zA-Z0-9]{2,5}|/)(\?|$)#', $url )
	) {
		$urls_to_check[] = preg_replace( '#(\?|$)#', '/$1', $url, 1 );
	}

	$redirections = [];

	$url_echo = format_url_for_echo( $url );
	echo "URL:   $url_echo\n";

	do {
		$result = do_head_request( $url );
		$status = $result['status'];
		$text   = $result['text'];

		if ( $status === 200 ) {
			echo "$status $text\n";
			$redirections[] = 200;

		} else if ( $status >= 300 && $status < 400 ) {
			$url = $result['location'];
			$redirections[] = [ $status, $url ];
			$url_echo = format_url_for_echo( $url );
			echo "$status -> $url_echo\n";

		} else {
			echo "$status $text\n";
			fail( "Response error: $status $text" );
		}

	} while ( $status >= 300 && $status < 400 );

	$urls_checked[ $url ] = $redirections;
}

function starts_with( $str, $prefix ) {
	return ( substr( $str, 0, strlen( $prefix ) ) === $prefix );
}

function strip_prefix( $str, $prefix ) {
	if ( starts_with( $str, $prefix ) ) {
		return substr( $str, strlen( $prefix ) );
	}
	return $str;
}

for ( $i = 1; $i < $argc; $i++ ) {
	$arg = $argv[ $i ];

	if ( starts_with( $arg, '-' ) ) {
		// Option argument.
		if ( $arg === '-n' || $arg === '--no-verify' ) {
			$options['no_verify'] = true;
		} else if ( $arg === '-a' || $arg === '--auth' ) {
			$options['auth'] = $argv[ ++$i ];
		} else if ( starts_with( $arg, '--auth=' ) ) {
			$options['auth'] = strip_prefix( $arg, '--auth=' );
		} else if ( starts_with( $arg, '-a' ) ) {
			$options['auth'] = strip_prefix( $arg, '-a' );
		} else if ( $arg === '-s' || $arg === '--add-slashes' ) {
			$options['add_slashes'] = true;
		} else {
			fail( "Unrecognized argument: $arg" );
		}

	} else {
		// Not an option argument.
		$urls_to_check[] = $arg;
	}
}

if ( count( $urls_to_check ) === 0 ) {
	error_log( 'Reading URLs from standard input...' );
	while ( $line = fgets( STDIN ) ) {
		if ( $line ) {
			$urls_to_check[] = trim( $line );
		}
	}
}

echo "\n";
while ( count( $urls_to_check ) > 0 ) {
	check_url( array_shift( $urls_to_check ) );
	echo "\n";
}
