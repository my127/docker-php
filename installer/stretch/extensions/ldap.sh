#!/bin/bash

function install_ldap()
{
    if ! has_extension ldap; then
        compile_ldap
    fi
    docker-php-ext-enable ldap
}

function compile_ldap()
{
    _ldap_deps_build

    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/
    docker-php-ext-install ldap

    _ldap_clean
}

function _ldap_deps_build()
{
    install libldap2-dev
}

function _ldap_clean()
{
    remove libldap2-dev
}
