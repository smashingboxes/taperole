#!/usr/bin/env bats

@test "Check that we have Install-Recommends set to false" {
    grep 'APT::Install-Recommends "false";' /etc/apt/apt.conf.d/10general
}

@test "Check that we have Install-Suggests set to false" {
    grep 'APT::Install-Suggests "false";' /etc/apt/apt.conf.d/10general
}

@test "Check that we have Update-Package-Lists set to 1" {
    grep 'APT::Periodic::Update-Package-Lists "1";' /etc/apt/apt.conf.d/10periodic
}

@test "Check that we have Download-Upgradeable-Packages set to 1" {
    grep 'APT::Periodic::Download-Upgradeable-Packages "1";' /etc/apt/apt.conf.d/10periodic
}

@test "Check that we have python-apt installed" {
    dpkg -s python-apt
}

@test "Check that we have sudo installed" {
    dpkg -s sudo
}

@test "Check that we have rpcbind installed" {
    run dpkg -s rpcbind
    [ $status -ne 0 ]
}

#@test "Check that we have do not have a testuser" {
#    run id -u "testuser"
#    [ $status -ne 0 ]
#}
